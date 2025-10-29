# Changelog

All notable changes to the Netskope to DLP Migration Script are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2025-10-29

### 🎉 Major Release: Open Source & Universal DLP Support

This release transforms the script from a vendor-specific tool to a universal, open-source DLP migration solution available for everyone.

### Changed

**Breaking Changes:**
- Renamed script: `migrate_to_minecast.sh` → `migrate_to_dlp.sh`
- Replaced vendor-specific references with generic DLP terminology
- Updated configuration variables:
  - `MINECAST_POLICY_ID` → `DLP_POLICY_ID`
  - `MINECAST_PATHS` → `DLP_PATHS`
  - `MINECAST_PKGS` → `DLP_PKGS`
- Updated function names:
  - `is_minecast_present()` → `is_dlp_present()`
  - `install_minecast()` → `install_dlp()`
  - `install_minecast_via_jamf()` → `install_dlp_via_jamf()`
- All log messages now use "DLP" terminology
- Enhanced arrays to support multiple DLP vendors (Code42, Mimecast, Forcepoint)

### Added

- **MIT License** for open-source distribution
- **Comprehensive README** with:
  - Clear installation instructions
  - Configuration examples
  - Detailed troubleshooting guide
  - Contributing guidelines
  - Usage examples with screenshots
- **Multi-vendor support** out of the box
- **Customization documentation** for any DLP solution
- **.gitignore** file for cleaner repository
- **Professional documentation** ready for GitHub

### Removed

- Vendor-specific branding and references
- Internal deployment scripts:
  - `install.sh`
  - `jamfuninstall.sh`
  - `nsclientconfig.sh`
- Workspace configuration files

---

## [1.1.0] - 2024

### Enhanced Netskope Cleanup

#### Added

**System Preferences & Configuration**
- System-level preferences cleanup: `/Library/Preferences/com.netskope.*`
- Managed preferences removal: `/Library/Managed Preferences/com.netskope.*`
- Temporary branding cleanup: `/tmp/nsbranding/`

**User-Specific Cleanup (All Users)**
- User preferences: `~/Library/Preferences/com.netskope.*`
- Application support data: `~/Library/Application Support/Netskope`
- Cache files: `~/Library/Caches/com.netskope.*`
- Saved application state: `~/Library/Saved Application State/com.netskope.*`
- User logs: `~/Library/Logs/Netskope`

**Kernel Extensions (KEXTs)**
- Detection using `kextstat`
- Active kext unloading with `kextunload`
- File removal from `/Library/Extensions/` and `/System/Library/Extensions/`
- Kext cache rebuilding
- Reboot requirement warnings

**System Extensions**
- Detection using `systemextensionsctl`
- Extension bundle removal from `/Library/SystemExtensions/`
- Network extension identification
- Manual removal guidance via System Preferences

**Network Configuration Cleanup**
- VPN configuration detection via `scutil --nc list`
- Proxy settings management:
  - Web proxy (HTTP)
  - Secure web proxy (HTTPS)
  - PAC (Proxy Auto-Config) files
- DNS resolver cleanup: `/etc/resolver/netskope` and `/etc/resolver/netskopecloud`

**Enhanced Process Handling**
- Added `NetskopeClient` to process termination list
- Improved process detection logic

#### Technical Details

**New Functions:**
- `unload_netskope_kexts()` - Handles kernel extension cleanup
- `remove_netskope_system_extensions()` - Manages system extensions
- `clear_netskope_network_configs()` - Cleans network settings

---

## [1.0.0] - 2024

### Initial Release

#### Added

**Core Functionality**
- Netskope to Minecast migration automation
- Comprehensive Netskope removal:
  - Application removal
  - Process termination
  - Launch daemon/agent cleanup
  - Package receipt removal
- Minecast installation via Jamf policy
- Health check functionality
- Non-blocking error handling

**Logging System**
- Comprehensive logging for Jamf
- Configurable verbosity levels: `DEBUG`, `INFO`, `WARN`, `ERROR`
- Detailed error tracking and reporting
- Summary report generation

**Jamf Integration**
- Parameter-based configuration
- Policy ID support
- Pre-migration status checking
- Post-migration verification

**Smart Features**
- Skip installation if already migrated
- Automatic retry logic
- Comprehensive error recovery
- System state validation

---

## Migration Guide: v1.x to v2.0

### For Existing Users

If you're upgrading from version 1.x, here's what you need to know:

#### Required Changes

1. **Script Name**
   - Old: `migrate_to_minecast.sh`
   - New: `migrate_to_dlp.sh`
   - **Action:** Update Jamf policy to reference new script name

2. **Customization**
   - **Action:** Update `DLP_PATHS` and `DLP_PKGS` arrays if using a DLP other than Code42, Mimecast, or Forcepoint

#### No Changes Required

- **Parameter 4:** Still represents the installation policy ID
- **Parameter 5:** Still represents log verbosity level
- **Logging:** Format and levels remain the same
- **Core Functionality:** Same reliable migration process

#### Benefits of Upgrading

- ✅ Open source - community contributions welcome
- ✅ Multi-vendor support built-in
- ✅ Better documentation
- ✅ Active maintenance and updates
- ✅ Issue tracking on GitHub

---

## Support & Contributions

### Getting Help

- **Issues:** [GitHub Issues](https://github.com/caputoDavide93/netskope-to-dlp-migration/issues)
- **Discussions:** [GitHub Discussions](https://github.com/caputoDavide93/netskope-to-dlp-migration/discussions)
- **Documentation:** [README.md](README.md)

### Contributing

Contributions are welcome! See [README.md](README.md#contributing) for guidelines.

---

## Roadmap

### Planned Features

- [ ] Pre-flight system compatibility check
- [ ] Rollback capability
- [ ] Support for additional DLP vendors
- [ ] GUI for configuration
- [ ] Automated testing suite
- [ ] Integration with other MDM solutions

### Under Consideration

- Self-service deployment option
- Slack/Teams notifications
- Custom reporting dashboard
- Multi-language support

---

**Maintained by:** [Davide Caputo](https://github.com/caputoDavide93)  
**Repository:** [netskope-to-dlp-migration](https://github.com/caputoDavide93/netskope-to-dlp-migration)
