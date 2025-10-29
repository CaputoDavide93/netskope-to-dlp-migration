# Netskope to DLP Migration Script# Netskope to Minecast Migration Script



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)## Overview

[![macOS](https://img.shields.io/badge/macOS-compatible-brightgreen.svg)](https://www.apple.com/macos/)

[![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-ready-blue.svg)](https://www.jamf.com/)This script safely migrates macOS devices from Netskope to Minecast in Jamf-managed environments. It handles the complete removal of Netskope and its dependencies, then installs Minecast via Jamf policy.



A comprehensive bash script for safely migrating macOS devices from Netskope to any Data Loss Prevention (DLP) solution in Jamf-managed environments. This tool handles complete removal of Netskope and its dependencies, then installs your target DLP solution via Jamf policy.## Features



## 🌟 Features- ✅ **Smart Detection**: Skips installation if Minecast is already present

- ✅ **Complete Removal**: Removes all Netskope components (apps, daemons, receipts)

- ✅ **Universal DLP Support**: Works with any DLP solution (Code42, Mimecast, Forcepoint, etc.)- ✅ **Non-Blocking Errors**: Continues execution even if errors occur

- ✅ **Smart Detection**: Automatically skips installation if target DLP is already present- ✅ **Jamf Logging**: All logs are sent to Jamf (no local log files)

- ✅ **Complete Removal**: Removes all Netskope components including:- ✅ **Health Checks**: Comprehensive verification of migration status

  - Applications and system files- ✅ **Policy-Based Installation**: Uses Jamf policy ID for Minecast installation

  - Launch daemons and agents

  - Kernel extensions (KEXTs)## Jamf Configuration

  - System extensions

  - Network configurations (VPN, proxy, DNS)### Script Parameters

  - User-specific files across all accounts

  - Package receipts- **Parameter 4**: Minecast install policy ID (default: `269`)

- ✅ **Non-Blocking Errors**: Continues execution even if errors occur- **Parameter 5**: Log level - `DEBUG`, `INFO`, `WARN`, `ERROR` (default: `INFO`)

- ✅ **Jamf Integration**: Seamless integration with Jamf Pro policies

- ✅ **Comprehensive Logging**: Detailed logs sent directly to Jamf### Setup in Jamf Pro

- ✅ **Health Checks**: Automatic verification of migration status

- ✅ **Production Ready**: Battle-tested error handling and recovery1. **Upload the Script**

   - Navigate to: Settings → Computer Management → Scripts

## 📋 Prerequisites   - Click "New"

   - Upload `migrate_to_minecast.sh`

- macOS 10.13 or later   - Set display name: "Netskope to Minecast Migration"

- Jamf Pro management

- Root/sudo privileges2. **Configure Policy**

- Jamf policy configured for your target DLP installation   - Create a new policy or edit existing

   - Add the script

## 🚀 Installation   - Configure parameters:

     - Parameter 4: `269` (Minecast install policy ID)

### Quick Start     - Parameter 5: `INFO` (or `DEBUG` for detailed logging)



1. **Clone the repository**3. **Scope**

   ```bash   - Target computers that need migration

   git clone https://github.com/caputoDavide93/netskope-to-dlp-migration.git   - Recommended: Use smart groups based on installed software

   cd netskope-to-dlp-migration

   ```### Example Configuration



2. **Upload to Jamf Pro**```

   - Navigate to: **Settings → Computer Management → Scripts**Script: migrate_to_minecast.sh

   - Click **New**Parameter 4: 269

   - Upload `migrate_to_dlp.sh`Parameter 5: INFO

   - Set display name: "Netskope to DLP Migration"Execution Frequency: Once per computer

```

3. **Configure Jamf Policy**

   - Create a new policy or edit existing## What the Script Does

   - Add the migration script

   - Configure parameters (see below)### 1. Pre-Migration Check

   - Set scope to target computers- Detects if Netskope is installed

- Checks if Minecast is already present

## ⚙️ Configuration- Exits early if system is already in desired state



### Jamf Parameters### 2. Netskope Removal



| Parameter | Description | Default | Example |**Comprehensive cleanup includes:**

|-----------|-------------|---------|---------|

| **$4** | DLP install policy ID | 269 | Your Jamf policy ID |- **Processes**: Stops all Netskope processes (stagent, stAgentSvc, stAgentUI, etc.)

| **$5** | Log verbosity level | INFO | DEBUG, INFO, WARN, ERROR |- **Launch Agents/Daemons**: Unloads and removes all launchd items

- **Kernel Extensions**: Unloads and removes kernel extensions (if present)

### Example Policy Configuration- **System Extensions**: Identifies and removes system/network extensions

- **Applications**: 

```  - `/Applications/Netskope Client.app`

Script: migrate_to_dlp.sh  - `/Applications/Remove Netskope Client.app`

Parameter 4: 269- **System Files**:

Parameter 5: INFO  - `/Library/Application Support/Netskope`

Execution Frequency: Once per computer  - `/usr/local/netskope`

```  - `/tmp/nsbranding`

- **System Preferences**:

### Customizing for Your DLP Solution  - `/Library/Preferences/com.netskope.*`

  - `/Library/Managed Preferences/com.netskope.*`

Edit the `DLP_PATHS` and `DLP_PKGS` arrays in the script to match your DLP solution:- **User-Specific Files** (for all users):

  - `~/Library/Preferences/com.netskope.*`

```bash  - `~/Library/Application Support/Netskope`

DLP_PATHS=(  - `~/Library/Caches/com.netskope.*`

    "/Applications/YourDLP.app"  - `~/Library/Saved Application State/com.netskope.*`

    "/Library/Application Support/YourDLP"  - `~/Library/Logs/Netskope`

)- **Network Configurations**:

  - VPN configurations

DLP_PKGS=("yourdlp" "com.yourdlp")  - Proxy settings (web, secure web, PAC)

```  - DNS resolver configurations

- **Package Receipts**: Removes all with `pkgutil --forget`

## 📖 Usage

### 3. Minecast Installation

### Via Jamf Pro (Recommended)- Runs Jamf policy by ID to install Minecast

- Waits for installation to complete (max 90 seconds)

1. Create a smart group targeting devices with Netskope installed- Verifies installation success

2. Create a policy with the migration script

3. Scope to your target smart group### 4. Health Check

4. Run the policy- Confirms Netskope removal

- Verifies Minecast installation

### Manual Execution (Testing)- Checks for conflicting processes

- Validates system state

```bash

sudo ./migrate_to_dlp.sh <policy_id> <log_level>### 5. Summary Report

```- Provides clear success/failure status

- Lists all errors and warnings

Example:- Logs execution time and details

```bash

sudo ./migrate_to_dlp.sh 269 DEBUG## Exit Codes

```

- `0` = Success (migration completed or Minecast already present)

## 🔍 What the Script Does- `1` = Critical failure (manual intervention required)



### 1. Pre-Migration Check## Log Output

- Detects if Netskope is installed

- Checks if target DLP is already presentAll logs are sent to stdout and captured by Jamf. Example:

- Exits early if system is already in desired state

```

### 2. Netskope Removal[2025-10-29 10:30:45] [INFO] ==========================================

[2025-10-29 10:30:45] [INFO] Minecast Migration Script Started

The script performs comprehensive cleanup of all Netskope components:[2025-10-29 10:30:45] [INFO] ==========================================

[2025-10-29 10:30:45] [INFO] Script version: 1.0

#### Process Management[2025-10-29 10:30:45] [INFO] Start time: 2025-10-29 10:30:45

- Stops all Netskope processes (stagent, stAgentSvc, stAgentUI, NetskopeClient)[2025-10-29 10:30:46] [INFO] macOS Version: 14.5

[2025-10-29 10:30:46] [INFO] Minecast Policy ID: 269

#### System Components```

- **Launch Agents/Daemons**: Unloads and removes all launchd items

- **Kernel Extensions**: Unloads and removes KEXTs (if present)## Monitoring in Jamf

- **System Extensions**: Identifies and removes system/network extensions

- **Applications**: 1. **View Logs**

  - `/Applications/Netskope Client.app`   - Go to the computer record

  - `/Applications/Remove Netskope Client.app`   - Click "Policy Logs"

   - Find the migration policy

#### System Files   - Review complete output

- `/Library/Application Support/Netskope`

- `/usr/local/netskope`2. **Check Status**

- `/tmp/nsbranding`   - Look for `✓ MIGRATION SUCCESSFUL` in logs

- `/Library/Extensions/Netskope*.system`   - Verify Minecast appears in installed software

   - Confirm Netskope is no longer listed

#### Preferences & Configuration

- `/Library/Preferences/com.netskope.*`3. **Troubleshooting**

- `/Library/Managed Preferences/com.netskope.*`   - If errors occur, check the detailed log output

   - Script continues even on errors (non-blocking)

#### User-Specific Files (All Users)   - Look for `[ERROR]` and `[WARN]` tags in logs

- `~/Library/Preferences/com.netskope.*`

- `~/Library/Application Support/Netskope`## Error Handling

- `~/Library/Caches/com.netskope.*`

- `~/Library/Saved Application State/com.netskope.*`The script is designed to be **resilient**:

- `~/Library/Logs/Netskope`- Errors don't stop execution

- Each step is logged independently

#### Network Configurations- Continues with next step even if previous fails

- VPN configurations- Final summary reports all issues

- Proxy settings (web, secure web, PAC)

- DNS resolver configurations (`/etc/resolver/netskope*`)## Smart Features



#### Package Receipts### Skip If Already Migrated

- Removes all Netskope package receipts with `pkgutil --forget`If Minecast is installed and Netskope is not present, the script exits immediately:

```

### 3. DLP Installation[INFO] System is already in desired state (Minecast installed, Netskope removed)

- Runs Jamf policy by ID to install target DLP[INFO] No migration needed - exiting successfully

- Waits for installation to complete (max 90 seconds)```

- Verifies installation success

### Partial Success Handling

### 4. Health CheckIf Minecast installs but Netskope remnants remain:

- Confirms Netskope removal```

- Verifies DLP installation[WARN] ⚠ PARTIAL SUCCESS

- Checks for conflicting processes[WARN]   Minecast is installed but Netskope remnants remain

- Validates system state[WARN]   Manual cleanup recommended

- Reports disk usage```



### 5. Summary Report## Testing Recommendations

- Provides clear success/failure status

- Lists any errors or warnings encountered1. **Test on a few devices first**

- Recommends next steps if needed   - Create a test smart group

   - Deploy to 2-3 machines

## 📊 Exit Codes   - Verify results before wider rollout



| Code | Description |2. **Use DEBUG logging for testing**

|------|-------------|   - Set Parameter 5 to `DEBUG`

| 0 | Success (migration completed or DLP already present) |   - Review detailed output

| 1 | Critical failure (requires manual intervention) |   - Switch to `INFO` for production



## 🛠️ Troubleshooting3. **Monitor first deployments**

   - Watch Jamf policy logs

### DLP Not Detected After Installation   - Check for common errors

   - Adjust policy settings if needed

1. Verify the policy ID is correct

2. Check that `DLP_PATHS` and `DLP_PKGS` match your DLP solution## Requirements

3. Review Jamf policy logs for installation issues

4. Run with `DEBUG` log level for detailed output- macOS 10.13 or later

- Jamf Pro

### Netskope Remnants Still Present- Script must run as root (default for Jamf policies)

- Minecast install policy must be created (ID: 269)

Some components may require a reboot to fully remove:

- System extensions## Support

- Kernel extensions

- Network configurationsFor issues or questions:

1. Check Jamf policy logs for detailed error messages

Run the script again after reboot, or manually check:2. Verify policy ID 269 exists and works independently

```bash3. Test Netskope removal manually if needed

# Check for processes4. Review health check output for specific failures

pgrep -if netskope

# Check for launchd items
ls -la /Library/Launch{Daemons,Agents}/com.netskope.*

# Check for system extensions
systemextensionsctl list | grep -i netskope
```

### Permission Issues

Ensure the script runs with root privileges:
```bash
sudo ./migrate_to_dlp.sh <policy_id> <log_level>
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Test thoroughly in a safe environment
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Davide Caputo**
- GitHub: [@caputoDavide93](https://github.com/caputoDavide93)

## 🙏 Acknowledgments

- Thanks to the Jamf community for inspiration and support
- Built with best practices from macOS system administration
- Designed for enterprise deployment reliability

## ⚠️ Disclaimer

This script is provided as-is, without warranty. Always test in a non-production environment first. The author is not responsible for any data loss or system issues that may occur from using this script.

## 📚 Additional Resources

- [Jamf Pro Documentation](https://docs.jamf.com/)
- [macOS System Administration Guide](https://support.apple.com/guide/deployment/welcome/web)
- [Bash Scripting Best Practices](https://google.github.io/styleguide/shellguide.html)

---

**Note**: This is an open-source tool designed to help organizations migrate away from Netskope to any DLP solution. It is not affiliated with or endorsed by Netskope, Jamf, or any DLP vendor.
