#!/bin/bash
################################################################################
# Netskope to DLP Migration Script for Jamf
# 
# Purpose: Safely migrate from Netskope to any DLP solution on macOS via Jamf
# 
# Features:
# - Checks if target DLP is already installed (skips if present)
# - Detects and removes Netskope completely (app, dependencies, receipts)
# - Installs target DLP solution
# - Comprehensive health checks
# - Detailed logging for Jamf
# - Non-blocking error handling (continues on errors)
# - Can run with sudo privileges
#
# Exit codes:
#   0 = Success (migration completed or DLP already present)
#   1 = Critical failure (requires manual intervention)
#
# Jamf Parameters:
#   $4 = DLP install policy ID (e.g., 269)
#   $5 = Log verbosity level (DEBUG, INFO, WARN, ERROR) - default INFO
#
################################################################################

set -u  # Treat unset variables as an error
# Note: Not using 'set -e' to allow error recovery

################################################################################
# CONFIGURATION
################################################################################

# Jamf parameters
DLP_POLICY_ID="${4:-269}"
LOG_LEVEL="${5:-INFO}"

# Validate log level
case "$LOG_LEVEL" in
    DEBUG|INFO|WARN|ERROR) ;;
    *) LOG_LEVEL="INFO" ;;
esac

# No local log files - all output goes to stdout/Jamf
LOG_DIR=""
LOG_FILE=""
JAMF_LOG=""

# Detection paths
NETSKOPE_PATHS=(
    "/Applications/Netskope Client.app"
    "/Applications/Remove Netskope Client.app"
    "/Library/Application Support/Netskope"
    "/usr/local/netskope"
    "/Library/LaunchDaemons/com.netskope.*"
    "/Library/LaunchAgents/com.netskope.*"
    "/tmp/nsbranding"
    "/Library/Extensions/NetskopeClient.system"
    "/Library/Extensions/NetskopeClientExt.system"
)

# System preferences and configuration files
NETSKOPE_PREFERENCES=(
    "/Library/Preferences/com.netskope.*"
    "/Library/Managed Preferences/com.netskope.*"
)

# User-specific paths (will check for all users)
NETSKOPE_USER_PATHS=(
    "Library/Preferences/com.netskope.*"
    "Library/Application Support/Netskope"
    "Library/Caches/com.netskope.*"
    "Library/Saved Application State/com.netskope.*"
    "Library/Logs/Netskope"
)

# DLP paths - CUSTOMIZE THESE FOR YOUR DLP SOLUTION
DLP_PATHS=(
    "/Applications/YourDLP.app"
    "/Library/Application Support/YourDLP"
)

# Package identifiers for receipt checking
NETSKOPE_PKGS=("netskope" "com.netskope" "stagent")
DLP_PKGS=("yourdlp" "com.yourdlp")

# Timing configurations
MAX_WAIT_REMOVAL=60      # Max seconds to wait for removal completion
MAX_WAIT_INSTALL=90      # Max seconds to wait for install completion
CHECK_INTERVAL=3         # Seconds between status checks

# Error tracking
declare -a ERRORS=()
declare -a WARNINGS=()
declare -a INFO_MESSAGES=()

################################################################################
# LOGGING FUNCTIONS
################################################################################

# Get timestamp
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get log level priority (compatible with bash 3.2)
get_log_priority() {
    local level="$1"
    case "$level" in
        DEBUG) echo 0 ;;
        INFO)  echo 1 ;;
        WARN)  echo 2 ;;
        ERROR) echo 3 ;;
        *)     echo 1 ;;
    esac
}

# Set current priority based on LOG_LEVEL
CURRENT_PRIORITY=$(get_log_priority "$LOG_LEVEL")

# Main logging function
log_message() {
    local level="$1"
    shift
    local message="$*"
    local priority=$(get_log_priority "$level")
    
    # Check if we should log this level
    if [[ $priority -ge $CURRENT_PRIORITY ]]; then
        local log_line="[$(timestamp)] [$level] $message"
        # Send all output to stdout (Jamf will capture it)
        echo "$log_line"
    fi
}

log_debug() { log_message "DEBUG" "$@"; }
log_info() { log_message "INFO" "$@"; INFO_MESSAGES+=("$*"); }
log_warn() { log_message "WARN" "$@"; WARNINGS+=("$*"); }
log_error() { log_message "ERROR" "$@"; ERRORS+=("$*"); }

# Section separator
log_section() {
    local title="$1"
    local separator="=========================================="
    log_info "$separator"
    log_info "$title"
    log_info "$separator"
}

################################################################################
# SYSTEM INFORMATION FUNCTIONS
################################################################################

get_console_user() {
    stat -f %Su /dev/console 2>/dev/null || echo "none"
}

get_os_version() {
    sw_vers -productVersion 2>/dev/null || echo "unknown"
}

get_jamf_version() {
    if command -v jamf >/dev/null 2>&1; then
        jamf -version 2>/dev/null | head -n1 || echo "jamf installed, version unknown"
    else
        echo "jamf not found"
    fi
}

log_system_info() {
    log_section "System Information"
    log_info "macOS Version: $(get_os_version)"
    log_info "Kernel: $(uname -sr)"
    log_info "Console User: $(get_console_user)"
    log_info "Current User: $(whoami)"
    log_info "Jamf: $(get_jamf_version)"
    log_info "Script PID: $$"
    log_info "DLP Policy ID: $DLP_POLICY_ID"
}

################################################################################
# DETECTION FUNCTIONS
################################################################################

# Check if any paths exist
check_paths_exist() {
    local -a paths=("$@")
    local found=0
    
    for path in "${paths[@]}"; do
        # Handle paths with wildcards vs literal paths
        if [[ "$path" == *"*"* ]]; then
            # Expand glob patterns
            local expanded_count=0
            for expanded_path in $path; do
                if [[ -e "$expanded_path" ]]; then
                    log_debug "Found path: $expanded_path"
                    found=1
                    expanded_count=$((expanded_count + 1))
                fi
            done
            # If glob didn't expand (no matches), skip
            [[ $expanded_count -eq 0 ]] && continue
        else
            # Check literal path
            if [[ -e "$path" ]]; then
                log_debug "Found path: $path"
                found=1
            fi
        fi
    done
    
    return $((1 - found))  # Return 0 if found, 1 if not
}

# Check if any package receipts exist
check_receipts_exist() {
    local -a identifiers=("$@")
    local found=0
    
    for identifier in "${identifiers[@]}"; do
        if pkgutil --pkgs | grep -qi "$identifier"; then
            local matching_pkgs
            matching_pkgs=$(pkgutil --pkgs | grep -i "$identifier")
            log_debug "Found package receipt(s) matching '$identifier':"
            echo "$matching_pkgs" | while read -r pkg; do
                [[ -n "$pkg" ]] && log_debug "  - $pkg"
            done
            found=1
        fi
    done
    
    return $((1 - found))
}

# Check if Netskope is present
is_netskope_present() {
    log_debug "Checking for Netskope presence..."
    
    if check_paths_exist "${NETSKOPE_PATHS[@]}"; then
        log_debug "Netskope detected via paths"
        return 0
    fi
    
    if check_receipts_exist "${NETSKOPE_PKGS[@]}"; then
        log_debug "Netskope detected via package receipts"
        return 0
    fi
    
    log_debug "Netskope not detected"
    return 1
}

# Check if DLP is present
is_dlp_present() {
    log_debug "Checking for DLP presence..."
    
    if check_paths_exist "${DLP_PATHS[@]}"; then
        log_debug "DLP detected via paths"
        return 0
    fi
    
    if check_receipts_exist "${DLP_PKGS[@]}"; then
        log_debug "DLP detected via package receipts"
        return 0
    fi
    
    log_debug "DLP not detected"
    return 1
}

################################################################################
# NETSKOPE REMOVAL FUNCTIONS
################################################################################

# Stop Netskope processes
stop_netskope_processes() {
    log_info "Stopping Netskope processes..."
    
    local processes=("Netskope" "stagent" "stAgentSvc" "stAgentUI" "NetskopeClient")
    local stopped=0
    
    for proc in "${processes[@]}"; do
        if pgrep -f "$proc" >/dev/null 2>&1; then
            log_debug "Found running process: $proc"
            if pkill -9 -f "$proc" 2>/dev/null; then
                log_debug "Killed process: $proc"
                stopped=1
            else
                log_warn "Failed to kill process: $proc (may not have permissions or already stopped)"
            fi
        fi
    done
    
    if [[ $stopped -eq 1 ]]; then
        log_info "Stopped Netskope processes"
        sleep 2  # Give processes time to fully terminate
    else
        log_debug "No Netskope processes found running"
    fi
}

# Unload and remove kernel extensions
unload_netskope_kexts() {
    log_info "Checking for Netskope kernel extensions..."
    
    local kexts_found=0
    
    # Check for loaded kexts
    local loaded_kexts
    loaded_kexts=$(kextstat | grep -i netskope || true)
    
    if [[ -n "$loaded_kexts" ]]; then
        log_info "Found loaded Netskope kernel extensions:"
        echo "$loaded_kexts" | while read -r line; do
            [[ -n "$line" ]] && log_debug "  $line"
        done
        
        # Try to unload each kext
        echo "$loaded_kexts" | awk '{print $6}' | while read -r kext_id; do
            if [[ -n "$kext_id" ]]; then
                log_debug "Unloading kext: $kext_id"
                if kextunload -b "$kext_id" 2>/dev/null; then
                    log_debug "Unloaded kext: $kext_id"
                    kexts_found=1
                else
                    log_warn "Failed to unload kext: $kext_id (may require reboot)"
                fi
            fi
        done
    fi
    
    # Remove kext files from system
    for kext in /Library/Extensions/Netskope*.kext /System/Library/Extensions/Netskope*.kext; do
        if [[ -e "$kext" ]]; then
            log_debug "Removing kext: $kext"
            if rm -rf "$kext" 2>/dev/null; then
                log_debug "Removed kext: $kext"
                kexts_found=1
            else
                log_warn "Failed to remove kext: $kext (may require SIP adjustment)"
            fi
        fi
    done
    
    if [[ $kexts_found -eq 1 ]]; then
        log_info "Kernel extension cleanup completed (reboot may be required)"
        # Rebuild kext cache
        log_debug "Rebuilding kext cache..."
        touch /Library/Extensions/ 2>/dev/null || true
        kextcache -invalidate / 2>/dev/null || log_debug "Could not invalidate kext cache"
    else
        log_debug "No kernel extensions found"
    fi
}

# Remove network/system extensions
remove_netskope_system_extensions() {
    log_info "Removing Netskope system/network extensions..."
    
    local removed=0
    
    # List and remove system extensions
    local sys_exts
    sys_exts=$(systemextensionsctl list 2>/dev/null | grep -i netskope || true)
    
    if [[ -n "$sys_exts" ]]; then
        log_info "Found Netskope system extensions:"
        echo "$sys_exts" | while read -r line; do
            [[ -n "$line" ]] && log_debug "  $line"
        done
        log_warn "System extensions found - these may require manual removal via System Preferences"
        log_warn "Go to: System Preferences → Privacy & Security → Extensions"
        removed=1
    fi
    
    # Remove extension files
    for ext in /Library/SystemExtensions/*/com.netskope.*.systemextension; do
        if [[ -e "$ext" ]]; then
            log_debug "Found extension: $ext"
            log_warn "System extension found at: $ext (may require reboot to fully remove)"
            removed=1
        fi
    done
    
    if [[ $removed -eq 0 ]]; then
        log_debug "No system extensions found"
    fi
}

# Unload Netskope launch agents/daemons
unload_netskope_launchd() {
    log_info "Unloading Netskope launch agents and daemons..."
    
    local unloaded=0
    
    # System daemons
    for plist in /Library/LaunchDaemons/com.netskope.*.plist; do
        if [[ -f "$plist" ]]; then
            log_debug "Unloading daemon: $plist"
            if launchctl unload "$plist" 2>/dev/null; then
                log_debug "Successfully unloaded: $plist"
                unloaded=1
            else
                log_warn "Failed to unload: $plist (may already be unloaded)"
            fi
        fi
    done
    
    # User agents
    for plist in /Library/LaunchAgents/com.netskope.*.plist; do
        if [[ -f "$plist" ]]; then
            log_debug "Unloading agent: $plist"
            if launchctl unload "$plist" 2>/dev/null; then
                log_debug "Successfully unloaded: $plist"
                unloaded=1
            else
                log_warn "Failed to unload: $plist (may already be unloaded)"
            fi
        fi
    done
    
    if [[ $unloaded -eq 1 ]]; then
        log_info "Unloaded Netskope launchd items"
    else
        log_debug "No Netskope launchd items found to unload"
    fi
}

# Manual cleanup of Netskope files
manual_netskope_cleanup() {
    log_info "Performing manual Netskope cleanup..."
    
    local removed=0
    
    # Remove application bundles
    for path in "/Applications/Netskope Client.app" "/Applications/Remove Netskope Client.app"; do
        if [[ -e "$path" ]]; then
            log_debug "Removing: $path"
            if rm -rf "$path" 2>/dev/null; then
                log_debug "Removed: $path"
                removed=1
            else
                log_error "Failed to remove: $path"
            fi
        fi
    done
    
    # Remove support files
    for path in "/Library/Application Support/Netskope" "/usr/local/netskope" "/tmp/nsbranding"; do
        if [[ -e "$path" ]]; then
            log_debug "Removing: $path"
            if rm -rf "$path" 2>/dev/null; then
                log_debug "Removed: $path"
                removed=1
            else
                log_error "Failed to remove: $path"
            fi
        fi
    done
    
    # Remove launchd plists
    for plist in /Library/LaunchDaemons/com.netskope.*.plist /Library/LaunchAgents/com.netskope.*.plist; do
        if [[ -f "$plist" ]]; then
            log_debug "Removing: $plist"
            if rm -f "$plist" 2>/dev/null; then
                log_debug "Removed: $plist"
                removed=1
            else
                log_error "Failed to remove: $plist"
            fi
        fi
    done
    
    # Remove system preferences
    log_info "Removing Netskope system preferences..."
    for pref in /Library/Preferences/com.netskope.* /Library/Managed\ Preferences/com.netskope.*; do
        if [[ -e "$pref" ]]; then
            log_debug "Removing preference: $pref"
            if rm -rf "$pref" 2>/dev/null; then
                log_debug "Removed: $pref"
                removed=1
            else
                log_warn "Failed to remove preference: $pref"
            fi
        fi
    done
    
    # Remove system extensions
    log_info "Removing Netskope system extensions..."
    for ext in /Library/Extensions/NetskopeClient.system /Library/Extensions/NetskopeClientExt.system; do
        if [[ -e "$ext" ]]; then
            log_debug "Removing system extension: $ext"
            if rm -rf "$ext" 2>/dev/null; then
                log_debug "Removed: $ext"
                removed=1
            else
                log_warn "Failed to remove system extension: $ext"
            fi
        fi
    done
    
    # Clean user-specific files for all users
    log_info "Cleaning Netskope files for all users..."
    for user_home in /Users/*; do
        if [[ -d "$user_home" && ! "$user_home" == "/Users/Shared" && ! "$user_home" == "/Users/Guest" ]]; then
            local username=$(basename "$user_home")
            log_debug "Checking user: $username"
            
            # Remove user preferences
            for pref in "$user_home"/Library/Preferences/com.netskope.*; do
                if [[ -e "$pref" ]]; then
                    log_debug "Removing user preference: $pref"
                    rm -rf "$pref" 2>/dev/null && removed=1 || log_warn "Failed to remove: $pref"
                fi
            done
            
            # Remove user application support
            if [[ -d "$user_home/Library/Application Support/Netskope" ]]; then
                log_debug "Removing user app support: $user_home/Library/Application Support/Netskope"
                rm -rf "$user_home/Library/Application Support/Netskope" 2>/dev/null && removed=1
            fi
            
            # Remove user caches
            for cache in "$user_home"/Library/Caches/com.netskope.*; do
                if [[ -e "$cache" ]]; then
                    log_debug "Removing user cache: $cache"
                    rm -rf "$cache" 2>/dev/null && removed=1
                fi
            done
            
            # Remove saved application state
            for state in "$user_home"/Library/Saved\ Application\ State/com.netskope.*; do
                if [[ -e "$state" ]]; then
                    log_debug "Removing saved state: $state"
                    rm -rf "$state" 2>/dev/null && removed=1
                fi
            done
            
            # Remove user logs
            if [[ -d "$user_home/Library/Logs/Netskope" ]]; then
                log_debug "Removing user logs: $user_home/Library/Logs/Netskope"
                rm -rf "$user_home/Library/Logs/Netskope" 2>/dev/null && removed=1
            fi
        fi
    done
    
    if [[ $removed -eq 1 ]]; then
        log_info "Manual cleanup completed"
    else
        log_debug "No files found for manual cleanup"
    fi
}

# Forget Netskope package receipts
forget_netskope_receipts() {
    log_info "Removing Netskope package receipts..."
    
    local forgotten=0
    
    for identifier in "${NETSKOPE_PKGS[@]}"; do
        local matching_pkgs
        matching_pkgs=$(pkgutil --pkgs | grep -i "$identifier" || true)
        
        if [[ -n "$matching_pkgs" ]]; then
            echo "$matching_pkgs" | while read -r pkg; do
                if [[ -n "$pkg" ]]; then
                    log_debug "Forgetting package: $pkg"
                    if pkgutil --forget "$pkg" 2>/dev/null; then
                        log_debug "Forgot package: $pkg"
                        forgotten=1
                    else
                        log_warn "Failed to forget package: $pkg"
                    fi
                fi
            done
        fi
    done
    
    if [[ $forgotten -eq 1 ]]; then
        log_info "Package receipts removed"
    else
        log_debug "No package receipts found to remove"
    fi
}

# Clear Netskope network configurations
clear_netskope_network_configs() {
    log_info "Clearing Netskope network configurations..."
    
    local cleared=0
    
    # Check for VPN configurations
    log_debug "Checking for Netskope VPN configurations..."
    local vpn_services
    vpn_services=$(scutil --nc list 2>/dev/null | grep -i netskope || true)
    
    if [[ -n "$vpn_services" ]]; then
        log_info "Found Netskope VPN configurations:"
        echo "$vpn_services" | while read -r line; do
            [[ -n "$line" ]] && log_debug "  $line"
        done
        log_warn "VPN configurations found - manual removal may be required"
        log_warn "Check: System Preferences → Network → VPN"
        cleared=1
    fi
    
    # Check for proxy configurations
    log_debug "Checking for Netskope proxy configurations..."
    local network_services
    network_services=$(networksetup -listallnetworkservices 2>/dev/null | grep -v "asterisk" | tail -n +2 || true)
    
    if [[ -n "$network_services" ]]; then
        while IFS= read -r service; do
            if [[ -n "$service" ]]; then
                # Check web proxy
                local web_proxy
                web_proxy=$(networksetup -getwebproxy "$service" 2>/dev/null | grep -i netskope || true)
                if [[ -n "$web_proxy" ]]; then
                    log_info "Found Netskope web proxy on: $service"
                    log_debug "Disabling web proxy on: $service"
                    networksetup -setwebproxystate "$service" off 2>/dev/null || log_warn "Failed to disable web proxy"
                    cleared=1
                fi
                
                # Check secure web proxy
                local secure_proxy
                secure_proxy=$(networksetup -getsecurewebproxy "$service" 2>/dev/null | grep -i netskope || true)
                if [[ -n "$secure_proxy" ]]; then
                    log_info "Found Netskope secure web proxy on: $service"
                    log_debug "Disabling secure web proxy on: $service"
                    networksetup -setsecurewebproxystate "$service" off 2>/dev/null || log_warn "Failed to disable secure web proxy"
                    cleared=1
                fi
                
                # Check PAC file
                local pac_url
                pac_url=$(networksetup -getautoproxyurl "$service" 2>/dev/null | grep -i netskope || true)
                if [[ -n "$pac_url" ]]; then
                    log_info "Found Netskope PAC configuration on: $service"
                    log_debug "Disabling PAC on: $service"
                    networksetup -setautoproxystate "$service" off 2>/dev/null || log_warn "Failed to disable PAC"
                    cleared=1
                fi
            fi
        done <<< "$network_services"
    fi
    
    # Check for DNS modifications
    log_debug "Checking for Netskope DNS configurations..."
    if [[ -f "/etc/resolver/netskope" ]] || [[ -f "/etc/resolver/netskopecloud" ]]; then
        log_info "Found Netskope DNS resolver configurations"
        rm -f /etc/resolver/netskope /etc/resolver/netskopecloud 2>/dev/null && cleared=1
        log_debug "Removed Netskope DNS resolver files"
    fi
    
    if [[ $cleared -eq 1 ]]; then
        log_info "Network configuration cleanup completed"
    else
        log_debug "No Netskope network configurations found"
    fi
}

# Main Netskope removal function
remove_netskope() {
    log_section "Netskope Removal Process"
    
    if ! is_netskope_present; then
        log_info "Netskope is not installed - skipping removal"
        return 0
    fi
    
    log_info "Netskope detected - beginning removal process"
    
    # Step 1: Stop processes
    stop_netskope_processes || log_warn "Process stop had issues, continuing..."
    
    # Step 2: Unload launchd items
    unload_netskope_launchd || log_warn "Launchd unload had issues, continuing..."
    
    # Step 3: Unload kernel extensions
    unload_netskope_kexts || log_warn "Kernel extension unload had issues, continuing..."
    
    # Step 4: Remove system/network extensions
    remove_netskope_system_extensions || log_warn "System extension removal had issues, continuing..."
    
    # Step 5: Manual cleanup (complete removal of all Netskope files)
    manual_netskope_cleanup || log_warn "Manual cleanup had issues, continuing..."
    
    # Step 6: Clear network configurations
    clear_netskope_network_configs || log_warn "Network config cleanup had issues, continuing..."
    
    # Step 7: Forget package receipts
    forget_netskope_receipts || log_warn "Receipt removal had issues, continuing..."
    
    # Step 8: Wait and verify removal
    log_info "Waiting for removal to complete (max ${MAX_WAIT_REMOVAL}s)..."
    local elapsed=0
    while [[ $elapsed -lt $MAX_WAIT_REMOVAL ]]; do
        sleep $CHECK_INTERVAL
        elapsed=$((elapsed + CHECK_INTERVAL))
        
        if ! is_netskope_present; then
            log_info "Netskope successfully removed (verified after ${elapsed}s)"
            return 0
        fi
        
        log_debug "Still detecting Netskope remnants... ($elapsed/$MAX_WAIT_REMOVAL seconds)"
    done
    
    # Final check
    if is_netskope_present; then
        log_error "Netskope remnants still detected after removal attempts"
        log_error "Manual intervention may be required"
        
        # List remaining items
        log_info "Remaining Netskope components:"
        for path in "${NETSKOPE_PATHS[@]}"; do
            for expanded in $path; do
                [[ -e "$expanded" ]] && log_info "  - $expanded"
            done
        done
        
        return 1
    fi
    
    log_info "Netskope removal completed"
    return 0
}

################################################################################
# DLP INSTALLATION FUNCTIONS
################################################################################

# Install DLP via Jamf policy
install_dlp_via_jamf() {
    log_info "Installing DLP via Jamf policy ID: $DLP_POLICY_ID"
    
    if ! command -v jamf >/dev/null 2>&1; then
        log_error "Jamf binary not found"
        return 1
    fi
    
    if [[ -z "$DLP_POLICY_ID" ]]; then
        log_error "No DLP policy ID provided"
        return 1
    fi
    
    # Run Jamf policy by ID
    log_info "Running: jamf policy -id $DLP_POLICY_ID"
    if jamf policy -id "$DLP_POLICY_ID" 2>&1; then
        log_info "Jamf policy execution completed"
        return 0
    else
        local rc=$?
        log_warn "Jamf policy exited with code $rc (continuing to verify installation)"
        return 1
    fi
}

# Main DLP installation function
install_dlp() {
    log_section "DLP Installation Process"
    
    if is_dlp_present; then
        log_info "DLP is already installed - skipping installation"
        return 0
    fi
    
    log_info "DLP not detected - beginning installation"
    
    # Ensure device is properly managed and has latest config profiles
    log_info "Running Jamf recon to update inventory..."
    if jamf recon 2>&1 | grep -q "Successfully"; then
        log_info "Jamf recon completed successfully"
    else
        log_warn "Jamf recon completed with warnings (continuing)"
    fi
    
    log_info "Running Jamf manage to ensure configuration profiles..."
    if jamf manage 2>&1; then
        log_info "Jamf manage completed successfully"
    else
        log_warn "Jamf manage completed with warnings (continuing)"
    fi
    
    # Brief pause to allow config profiles to settle
    sleep 2
    
    # Install via Jamf policy
    local install_success=0
    if install_dlp_via_jamf; then
        install_success=1
    fi
    
    if [[ $install_success -eq 0 ]]; then
        log_error "Jamf policy installation failed"
        log_error "Please verify Jamf policy ID $DLP_POLICY_ID is correct"
        return 1
    fi
    
    # Wait and verify installation
    log_info "Waiting for installation to complete (max ${MAX_WAIT_INSTALL}s)..."
    local elapsed=0
    while [[ $elapsed -lt $MAX_WAIT_INSTALL ]]; do
        sleep $CHECK_INTERVAL
        elapsed=$((elapsed + CHECK_INTERVAL))
        
        if is_dlp_present; then
            log_info "DLP successfully installed (verified after ${elapsed}s)"
            return 0
        fi
        
        log_debug "Waiting for DLP to appear... ($elapsed/$MAX_WAIT_INSTALL seconds)"
    done
    
    # Final check
    if is_dlp_present; then
        log_info "DLP installation completed"
        return 0
    else
        log_error "DLP not detected after installation attempts"
        return 1
    fi
}

################################################################################
# HEALTH CHECK FUNCTIONS
################################################################################

# Perform comprehensive health check
health_check() {
    log_section "System Health Check"
    
    local health_status=0
    
    # Check 1: Verify Netskope is removed
    log_info "Check 1: Verifying Netskope removal..."
    if is_netskope_present; then
        log_error "✗ Netskope still detected on system"
        log_error "  This may cause conflicts with Minecast"
        health_status=1
        
        # List what was found
        for path in "${NETSKOPE_PATHS[@]}"; do
            for expanded in $path; do
                [[ -e "$expanded" ]] && log_error "  Found: $expanded"
            done
        done
    else
        log_info "✓ Netskope successfully removed"
    fi
    
    # Check 2: Verify DLP is installed
    log_info "Check 2: Verifying DLP installation..."
    if is_dlp_present; then
        log_info "✓ DLP is installed"
        
        # Check specific components
        for path in "${DLP_PATHS[@]}"; do
            for expanded in $path; do
                [[ -e "$expanded" ]] && log_debug "  Found: $expanded"
            done
        done
    else
        log_error "✗ DLP not detected"
        health_status=1
    fi
    
    # Check 3: Verify no conflicting processes
    log_info "Check 3: Checking for conflicting processes..."
    local netskope_procs
    netskope_procs=$(pgrep -f -i netskope || true)
    if [[ -n "$netskope_procs" ]]; then
        log_warn "✗ Netskope processes still running:"
        # Convert newline-separated PIDs to comma-separated for ps command
        local pid_list
        pid_list=$(echo "$netskope_procs" | tr '\n' ',' | sed 's/,$//')
        ps -p "$pid_list" -o pid,command 2>/dev/null || log_warn "  Could not retrieve process details"
        health_status=1
    else
        log_info "✓ No Netskope processes running"
    fi
    
    # Check 4: Verify system resources
    log_info "Check 4: System resources..."
    local disk_usage
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    log_info "  Root disk usage: ${disk_usage}%"
    
    if [[ $disk_usage -gt 90 ]]; then
        log_warn "✗ Disk usage is high (${disk_usage}%)"
        health_status=1
    else
        log_info "✓ Disk usage is acceptable"
    fi
    
    # Check 5: Verify launchd items
    log_info "Check 5: Checking launchd configuration..."
    local netskope_launchd
    netskope_launchd=$(find /Library/Launch{Daemons,Agents} -name "*netskope*" 2>/dev/null || true)
    if [[ -n "$netskope_launchd" ]]; then
        log_warn "✗ Netskope launchd items still present:"
        echo "$netskope_launchd" | while read -r item; do
            [[ -n "$item" ]] && log_warn "  $item"
        done
        health_status=1
    else
        log_info "✓ No Netskope launchd items found"
    fi
    
    return $health_status
}

################################################################################
# SUMMARY REPORTING
################################################################################

generate_summary() {
    log_section "Migration Summary"
    
    log_info "Script execution completed at $(timestamp)"
    log_info "Total execution time: $SECONDS seconds"
    
    # Netskope status
    if is_netskope_present; then
        log_warn "Netskope Status: STILL PRESENT (needs manual cleanup)"
    else
        log_info "Netskope Status: Successfully Removed"
    fi
    
    # DLP status
    if is_dlp_present; then
        log_info "DLP Status: Successfully Installed"
    else
        log_error "DLP Status: NOT INSTALLED"
    fi
    
    # Error summary
    if [[ ${#ERRORS[@]} -gt 0 ]]; then
        log_error "Errors encountered (${#ERRORS[@]}):"
        for err in "${ERRORS[@]}"; do
            log_error "  - $err"
        done
    else
        log_info "No errors encountered"
    fi
    
    # Warning summary
    if [[ ${#WARNINGS[@]} -gt 0 ]]; then
        log_warn "Warnings (${#WARNINGS[@]}):"
        for warn in "${WARNINGS[@]}"; do
            log_warn "  - $warn"
        done
    fi
    
    # Final recommendation
    log_section "Final Status"
    if ! is_netskope_present && is_dlp_present; then
        log_info "✓ MIGRATION SUCCESSFUL"
        log_info "  Netskope has been removed"
        log_info "  DLP is installed and ready"
        return 0
    elif is_dlp_present && is_netskope_present; then
        log_warn "⚠ PARTIAL SUCCESS"
        log_warn "  DLP is installed but Netskope remnants remain"
        log_warn "  Manual cleanup recommended"
        return 0  # Still return success since DLP is installed
    elif is_dlp_present; then
        log_info "✓ DLP is installed (Netskope was not present)"
        return 0
    else
        log_error "✗ MIGRATION INCOMPLETE"
        log_error "  DLP installation failed"
        log_error "  Manual intervention required"
        return 1
    fi
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    # Ensure we're running as root
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: This script must be run as root or with sudo"
        exit 1
    fi
    
    log_section "DLP Migration Script Started"
    log_info "Script version: 2.0"
    log_info "Start time: $(timestamp)"
    
    # Log system information
    log_system_info
    
    # Pre-migration check
    log_section "Pre-Migration Status Check"
    local netskope_present=0
    local dlp_present=0
    
    if is_netskope_present; then
        log_info "Netskope: DETECTED (will be removed)"
        netskope_present=1
    else
        log_info "Netskope: Not detected"
    fi
    
    if is_dlp_present; then
        log_info "DLP: ALREADY INSTALLED (will skip installation)"
        dlp_present=1
    else
        log_info "DLP: Not detected (will be installed)"
    fi
    
    # If DLP is already installed and Netskope is not present, we're done
    if [[ $dlp_present -eq 1 && $netskope_present -eq 0 ]]; then
        log_info "System is already in desired state (DLP installed, Netskope removed)"
        log_info "No migration needed - exiting successfully"
        generate_summary
        exit 0
    fi
    
    # Remove Netskope (non-blocking - continue even if it fails)
    if [[ $netskope_present -eq 1 ]]; then
        if ! remove_netskope; then
            log_error "Netskope removal encountered errors, but continuing with DLP installation..."
        fi
    fi
    
    # Install DLP (non-blocking - continue even if it fails)
    if [[ $dlp_present -eq 0 ]]; then
        if ! install_dlp; then
            log_error "DLP installation encountered errors"
        fi
    fi
    
    # Perform health check (non-blocking)
    health_check || log_warn "Health check identified some issues (see above)"
    
    # Generate final summary and determine exit code
    if generate_summary; then
        exit 0
    else
        log_error "Migration completed with errors - manual intervention recommended"
        exit 1
    fi
}

# Execute main function
main "$@"
