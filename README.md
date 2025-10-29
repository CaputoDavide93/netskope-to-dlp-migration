# Netskope to DLP Migration Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-10.13+-brightgreen.svg)](https://www.apple.com/macos/)
[![Jamf Pro](https://img.shields.io/badge/Jamf_Pro-Compatible-blue.svg)](https://www.jamf.com/)
[![Shell](https://img.shields.io/badge/Shell-Bash-informational.svg)](https://www.gnu.org/software/bash/)

An automated bash script for migrating macOS devices from Netskope to any DLP (Data Loss Prevention) solution using Jamf Pro. This tool handles complete removal of Netskope components and seamlessly installs your target DLP solution.

## ✨ Features

- 🔄 **Complete Migration** - Removes all Netskope components and installs your DLP
- 🎯 **Universal DLP Support** - Works with Code42, Mimecast, Forcepoint, or any DLP
- 🧹 **Deep Cleanup** - Removes apps, extensions, configs, network settings, and user files
- 📊 **Health Checks** - Verifies successful migration with detailed reporting
- 🔐 **Production Ready** - Non-blocking error handling and comprehensive logging

## 📋 Requirements

- macOS 10.13 or later
- Jamf Pro environment
- Root/sudo privileges
- Jamf policy configured for your DLP installation

## 🚀 Usage

### Basic Usage

```bash
sudo ./migrate_to_dlp.sh <jamf_policy_id> <log_level>
```

### Examples

**Standard migration with INFO logging:**
```bash
sudo ./migrate_to_dlp.sh 269 INFO
```

**Debug mode for troubleshooting:**
```bash
sudo ./migrate_to_dlp.sh 269 DEBUG
```

**Via Jamf Pro (recommended):**
- Create a policy in Jamf Pro
- Set Parameter 4: Your DLP policy ID (e.g., `269`)
- Set Parameter 5: Log level (`INFO` or `DEBUG`)
- Deploy to target devices

## ⚙️ Configuration

### Customize for Your DLP Solution

Edit these arrays in the script to match your DLP:

```bash
DLP_PATHS=(
    "/Applications/YourDLP.app"
    "/Library/Application Support/YourDLP"
)

DLP_PKGS=("yourdlp" "com.yourdlp")
```

### Pre-configured Support

The script includes paths for:
- Code42
- Mimecast  
- Forcepoint

## 🧹 What Gets Removed

- ✅ Netskope applications and processes
- ✅ Launch daemons and agents
- ✅ Kernel extensions (KEXTs)
- ✅ System extensions
- ✅ Network configurations (VPN, proxy, DNS)
- ✅ System and user preferences (all users)
- ✅ Package receipts

## 📤 Exit Codes

| Code | Description |
|------|-------------|
| `0` | Success - Migration completed |
| `1` | Failure - Manual intervention required |

## 🛠️ Troubleshooting

**DLP not detected:**
- Verify the policy ID is correct
- Ensure `DLP_PATHS` and `DLP_PKGS` match your solution
- Run with `DEBUG` log level for detailed output

**Netskope remnants remain:**
- Some components (KEXTs, system extensions) may require a reboot
- Run the script again after restart

**Check manually:**
```bash
# Check for running processes
pgrep -if netskope

# Check launchd items
ls /Library/Launch{Daemons,Agents}/com.netskope.* 2>/dev/null

# Check system extensions
systemextensionsctl list | grep -i netskope
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Davide Caputo**
- GitHub: [@caputoDavide93](https://github.com/caputoDavide93)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ⚠️ Disclaimer

This script is provided as-is, without warranty. Always test in a non-production environment first.
