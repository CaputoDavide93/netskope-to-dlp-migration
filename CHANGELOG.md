# Changelog

All notable changes to the Netskope to DLP Migration Script will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-10-29

### 🎉 Major Release - Open Source & Universal DLP Support

This release transforms the script from a Minecast-specific tool to a universal, open-source DLP migration solution.

### Changed
- **BREAKING**: Renamed script from `migrate_to_minecast.sh` to `migrate_to_dlp.sh`
- **BREAKING**: Replaced all Minecast-specific references with generic DLP terminology
- Updated variable names:
  - `MINECAST_POLICY_ID` → `DLP_POLICY_ID`
  - `MINECAST_PATHS` → `DLP_PATHS`
  - `MINECAST_PKGS` → `DLP_PKGS`
  - `is_minecast_present()` → `is_dlp_present()`
  - `install_minecast()` → `install_dlp()`
  - `install_minecast_via_jamf()` → `install_dlp_via_jamf()`
- Updated all log messages to use "DLP" instead of "Minecast"
- Enhanced `DLP_PATHS` and `DLP_PKGS` to support multiple DLP solutions (Code42, Mimecast, Forcepoint)

### Added
- MIT License for open-source distribution
- Comprehensive GitHub-ready README with:
  - Installation instructions
  - Configuration guide
  - Troubleshooting section
  - Contributing guidelines
  - Usage examples
- Support for multiple DLP vendors out of the box
- Clear documentation on how to customize for any DLP solution

### Removed
- Minecast-specific branding and references
- Proprietary deployment scripts (install.sh, jamfuninstall.sh, nsclientconfig.sh)

## [1.1.0] - 2024 (Previous Internal Version)

### Added - Comprehensive Netskope Cleanup

#### System Preferences & Configuration Files
- System-level preferences: `/Library/Preferences/com.netskope.*`
- Managed preferences: `/Library/Managed Preferences/com.netskope.*`
- Temporary branding: `/tmp/nsbranding/` (where config files are stored)

#### User-Specific Cleanup (All Users)
The script now cleans Netskope files from every user account:
- `~/Library/Preferences/com.netskope.*` - User preferences
- `~/Library/Application Support/Netskope` - User app data
- `~/Library/Caches/com.netskope.*` - Cache files
- `~/Library/Saved Application State/com.netskope.*` - Window state
- `~/Library/Logs/Netskope` - User logs

#### Kernel Extensions (KEXTs)
- Detects loaded Netskope kernel extensions with `kextstat`
- Unloads active kexts with `kextunload`
- Removes kext files from `/Library/Extensions/` and `/System/Library/Extensions/`
- Rebuilds kext cache after removal
- Warns if reboot is required

#### System Extensions
- Detects system extensions with `systemextensionsctl`
- Removes extension bundles from `/Library/SystemExtensions/`
- Identifies network extensions
- Provides guidance for manual removal via System Preferences

#### Network Configuration Cleanup
- **VPN Configurations**: Detects Netskope VPN services via `scutil --nc list`
- **Proxy Settings**: Checks and disables:
  - Web proxy (HTTP)
  - Secure web proxy (HTTPS)
  - PAC (Proxy Auto-Config) files
- **DNS Resolvers**: Removes `/etc/resolver/netskope` and `/etc/resolver/netskopecloud`

#### Enhanced Process Handling
- Added `NetskopeClient` to process kill list
- More comprehensive process detection

### Technical Details

#### New Functions Added:
1. `unload_netskope_kexts()` - Handles kernel extension cleanup
2. `remove_netskope_system_extensions()` - Manages system extensions
3. `clear_netskope_network_configs()` - Cleans network settings

## [1.0.0] - 2024 (Initial Internal Version)

### Added
- Initial script for Netskope to Minecast migration
- Basic Netskope removal functionality:
  - Application removal
  - Process termination
  - Launch daemon/agent cleanup
  - Package receipt removal
- Minecast installation via Jamf policy
- Comprehensive logging system
- Health check functionality
- Non-blocking error handling
- Jamf integration with parameter support
- Pre-migration status checking
- Post-migration verification

### Features
- Smart detection (skips if Minecast already installed)
- Detailed logging for Jamf
- Configurable log verbosity levels (DEBUG, INFO, WARN, ERROR)
- Policy-based installation using Jamf policy IDs
- Comprehensive error tracking and reporting

---

## Migration Guide from v1.x to v2.0

If you're upgrading from version 1.x, here are the key changes:

1. **Script Name**: Update your Jamf policies to use `migrate_to_dlp.sh` instead of `migrate_to_minecast.sh`
2. **Parameter 4**: Still represents the installation policy ID, but now supports any DLP solution
3. **Customization**: Update `DLP_PATHS` and `DLP_PKGS` arrays if you're not using Code42, Mimecast, or Forcepoint
4. **Logging**: No changes to log format or levels
5. **Functionality**: Core functionality remains the same, just more flexible

## Support

For issues, questions, or contributions, please visit:
- GitHub Issues: https://github.com/caputoDavide93/netskope-to-dlp-migration/issues
- GitHub Discussions: https://github.com/caputoDavide93/netskope-to-dlp-migration/discussions
