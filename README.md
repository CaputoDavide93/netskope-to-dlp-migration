# Netskope to DLP Migration Script# Netskope to DLP Migration Script# Netskope to DLP Migration Script# Netskope to DLP Migration Script# Netskope to Minecast Migration Script



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[![macOS](https://img.shields.io/badge/macOS-10.13+-brightgreen.svg)](https://www.apple.com/macos/)

[![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-Compatible-blue.svg)](https://www.jamf.com/)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)



A bash script for migrating macOS devices from Netskope to any DLP solution via Jamf Pro.[![macOS](https://img.shields.io/badge/macOS-10.13+-brightgreen.svg)](https://www.apple.com/macos/)



## Features[![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-Compatible-blue.svg)](https://www.jamf.com/)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



- Universal DLP support (Code42, Mimecast, Forcepoint, or any DLP)

- Complete Netskope removal (apps, extensions, configs, user files)

- Automated DLP installation via Jamf policyA bash script for migrating macOS devices from Netskope to any DLP solution via Jamf Pro.[![macOS](https://img.shields.io/badge/macOS-10.13+-brightgreen.svg)](https://www.apple.com/macos/)

- Comprehensive logging and health checks



## Requirements

## Features[![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-Compatible-blue.svg)](https://www.jamf.com/)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)## Overview

- macOS 10.13 or later

- Jamf Pro environment

- Root privileges

- Jamf policy configured for DLP installation- Universal DLP support (Code42, Mimecast, Forcepoint, or any DLP)



## Installation- Complete Netskope removal (apps, extensions, configs, user files)



**1. Clone Repository**- Automated DLP installation via Jamf policyA comprehensive bash script for safely migrating macOS devices from Netskope to any Data Loss Prevention (DLP) solution in Jamf-managed environments.[![macOS](https://img.shields.io/badge/macOS-compatible-brightgreen.svg)](https://www.apple.com/macos/)



```bash- Comprehensive logging and health checks

git clone https://github.com/caputoDavide93/netskope-to-dlp-migration.git

cd netskope-to-dlp-migration

```

## Requirements

**2. Upload to Jamf Pro**

---[![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-ready-blue.svg)](https://www.jamf.com/)This script safely migrates macOS devices from Netskope to Minecast in Jamf-managed environments. It handles the complete removal of Netskope and its dependencies, then installs Minecast via Jamf policy.

- Navigate to **Settings → Computer Management → Scripts**

- Click **New** and upload `migrate_to_dlp.sh`- macOS 10.13+

- Save as "Netskope to DLP Migration"

- Jamf Pro

**3. Create Policy**

- Root privileges

- Create new policy in Jamf Pro

- Add the migration script- Jamf policy configured for DLP installation## 🎯 Overview

- Set Parameter 4: Your DLP policy ID (e.g., 269)

- Set Parameter 5: Log level (INFO or DEBUG)

- Scope to target computers

## Installation

## Configuration



**Jamf Parameters:**

### 1. Clone RepositoryThis tool automates the complete migration process by:A comprehensive bash script for safely migrating macOS devices from Netskope to any Data Loss Prevention (DLP) solution in Jamf-managed environments. This tool handles complete removal of Netskope and its dependencies, then installs your target DLP solution via Jamf policy.## Features

- Parameter 4 = DLP installation policy ID (default: 269)

- Parameter 5 = Log level: DEBUG, INFO, WARN, ERROR (default: INFO)



**Customize for Your DLP:**```bash- Removing all Netskope components (apps, extensions, network configs)



Edit these arrays in the script to match your DLP solution:git clone https://github.com/caputoDavide93/netskope-to-dlp-migration.git



```bashcd netskope-to-dlp-migration- Installing your target DLP solution via Jamf policy

DLP_PATHS=(

    "/Applications/YourDLP.app"```

    "/Library/Application Support/YourDLP"

)- Performing comprehensive health checks



DLP_PKGS=("yourdlp" "com.yourdlp")### 2. Upload to Jamf Pro

```

- Providing detailed logging and error reporting## 🌟 Features- ✅ **Smart Detection**: Skips installation if Minecast is already present

## Usage

1. Go to **Settings → Computer Management → Scripts**

**Via Jamf (Recommended):**

2. Click **New** and upload `migrate_to_dlp.sh`

Deploy the policy to devices with Netskope installed.

3. Save as "Netskope to DLP Migration"

**Manual Testing:**

**Supported DLP Solutions:** Code42, Mimecast, Forcepoint, and easily customizable for others.- ✅ **Complete Removal**: Removes all Netskope components (apps, daemons, receipts)

```bash

sudo ./migrate_to_dlp.sh 269 DEBUG### 3. Create Policy

```



## What It Does

1. Create new policy

1. **Pre-Check** - Detects Netskope and target DLP status

2. **Remove Netskope** - Removes all components:2. Add the script---- ✅ **Universal DLP Support**: Works with any DLP solution (Code42, Mimecast, Forcepoint, etc.)- ✅ **Non-Blocking Errors**: Continues execution even if errors occur

   - Applications and processes

   - Launch daemons and agents3. Set **Parameter 4**: Your DLP policy ID (e.g., `269`)

   - Kernel and system extensions

   - Network configurations (VPN, proxy, DNS)4. Set **Parameter 5**: Log level (`INFO` or `DEBUG`)

   - System and user preferences

   - Package receipts5. Scope to target computers

3. **Install DLP** - Runs Jamf policy to install your DLP

4. **Health Check** - Verifies successful migration## ✨ Features- ✅ **Smart Detection**: Automatically skips installation if target DLP is already present- ✅ **Jamf Logging**: All logs are sent to Jamf (no local log files)

5. **Report** - Provides detailed status and any errors

## Configuration

## Exit Codes



- **0** = Success

- **1** = Failure (manual intervention required)### Jamf Parameters



## Troubleshooting| Feature | Description |- ✅ **Complete Removal**: Removes all Netskope components including:- ✅ **Health Checks**: Comprehensive verification of migration status



**DLP Not Detected:**| Parameter | Description | Default |

- Verify policy ID is correct

- Check DLP_PATHS and DLP_PKGS match your DLP|-----------|-------------|---------||---------|-------------|

- Run with DEBUG log level

| `$4` | DLP installation policy ID | `269` |

**Netskope Remnants Remain:**

| `$5` | Log level (`DEBUG`, `INFO`, `WARN`, `ERROR`) | `INFO` || **Universal DLP Support** | Works with any DLP solution - just configure the paths |  - Applications and system files- ✅ **Policy-Based Installation**: Uses Jamf policy ID for Minecast installation

Some components may require a reboot (KEXTs, system extensions). Run script again after reboot.



**Manual Checks:**

### Customize for Your DLP| **Smart Detection** | Skips installation if target DLP is already present |

```bash

# Check processes

pgrep -if netskope

Edit these arrays in the script to match your DLP solution:| **Complete Removal** | Removes all Netskope components comprehensively |  - Launch daemons and agents

# Check launchd items

ls /Library/Launch{Daemons,Agents}/com.netskope.* 2>/dev/null



# Check system extensions```bash| **Non-Blocking Errors** | Continues execution even if individual steps fail |

systemextensionsctl list | grep -i netskope

```DLP_PATHS=(



## Contributing    "/Applications/YourDLP.app"| **Jamf Integration** | Seamless policy-based installation |  - Kernel extensions (KEXTs)## Jamf Configuration



Contributions welcome! Please fork the repository, create a feature branch, test thoroughly, and submit a pull request.    "/Library/Application Support/YourDLP"



## License)| **Detailed Logging** | All logs sent directly to Jamf for monitoring |



MIT License - see [LICENSE](LICENSE) file for details.



## AuthorDLP_PKGS=("yourdlp" "com.yourdlp")| **Health Checks** | Automatic verification of migration success |  - System extensions



**Davide Caputo**  ```

GitHub: [@caputoDavide93](https://github.com/caputoDavide93)

| **Production Ready** | Battle-tested with enterprise-grade error handling |

## Disclaimer

## Usage

Provided as-is without warranty. Always test in non-production environments first.

  - Network configurations (VPN, proxy, DNS)### Script Parameters

### Via Jamf (Recommended)

---

Deploy the policy to devices with Netskope installed.

  - User-specific files across all accounts

### Manual Testing

## 📋 Prerequisites

```bash

sudo ./migrate_to_dlp.sh 269 DEBUG  - Package receipts- **Parameter 4**: Minecast install policy ID (default: `269`)

```

- macOS 10.13 or later

## What It Does

- Jamf Pro environment- ✅ **Non-Blocking Errors**: Continues execution even if errors occur- **Parameter 5**: Log level - `DEBUG`, `INFO`, `WARN`, `ERROR` (default: `INFO`)

1. **Pre-Check**: Detects Netskope and target DLP status

2. **Remove Netskope**: Removes all components including:- Root/sudo privileges

   - Applications and processes

   - Launch daemons/agents- Jamf policy configured for your DLP installation- ✅ **Jamf Integration**: Seamless integration with Jamf Pro policies

   - Kernel and system extensions

   - Network configs (VPN, proxy, DNS)

   - System and user preferences

   - Package receipts---- ✅ **Comprehensive Logging**: Detailed logs sent directly to Jamf### Setup in Jamf Pro

3. **Install DLP**: Runs Jamf policy to install your DLP

4. **Health Check**: Verifies successful migration

5. **Report**: Provides detailed status and any errors

## 🚀 Quick Start- ✅ **Health Checks**: Automatic verification of migration status

## Exit Codes



| Code | Meaning |

|------|---------|### 1. Clone the Repository- ✅ **Production Ready**: Battle-tested error handling and recovery1. **Upload the Script**

| `0` | Success |

| `1` | Failure (manual intervention required) |



## Troubleshooting```bash   - Navigate to: Settings → Computer Management → Scripts



### DLP Not Detectedgit clone https://github.com/caputoDavide93/netskope-to-dlp-migration.git



- Verify policy ID is correctcd netskope-to-dlp-migration## 📋 Prerequisites   - Click "New"

- Check `DLP_PATHS` and `DLP_PKGS` match your DLP

- Run with `DEBUG` log level```



### Netskope Remnants Remain   - Upload `migrate_to_minecast.sh`



Some components may require a reboot (KEXTs, system extensions). Run script again after reboot.### 2. Upload to Jamf Pro



### Check Manually- macOS 10.13 or later   - Set display name: "Netskope to Minecast Migration"



```bash1. Navigate to: **Settings → Computer Management → Scripts**

# Check processes

pgrep -if netskope2. Click **New**- Jamf Pro management



# Check launchd items3. Upload `migrate_to_dlp.sh`

ls /Library/Launch{Daemons,Agents}/com.netskope.* 2>/dev/null

4. Set display name: `Netskope to DLP Migration`- Root/sudo privileges2. **Configure Policy**

# Check system extensions

systemextensionsctl list | grep -i netskope

```

### 3. Create Jamf Policy- Jamf policy configured for your target DLP installation   - Create a new policy or edit existing

## Contributing



Contributions welcome! Please:

1. Create a new policy   - Add the script

1. Fork the repository

2. Create a feature branch2. Add the migration script

3. Test thoroughly

4. Submit a pull request3. Configure parameters:## 🚀 Installation   - Configure parameters:



## License   - **Parameter 4:** Your DLP policy ID (e.g., `269`)



MIT License - see [LICENSE](LICENSE) file.   - **Parameter 5:** Log level (e.g., `INFO`)     - Parameter 4: `269` (Minecast install policy ID)



## Author4. Set execution frequency: **Once per computer**



**Davide Caputo**  5. Scope to target devices### Quick Start     - Parameter 5: `INFO` (or `DEBUG` for detailed logging)

GitHub: [@caputoDavide93](https://github.com/caputoDavide93)



## Disclaimer

---

Provided as-is without warranty. Test in non-production environments first.



---

## ⚙️ Configuration1. **Clone the repository**3. **Scope**

**Version:** 2.0.0  

**Last Updated:** October 29, 2025


### Jamf Parameters   ```bash   - Target computers that need migration



| Parameter | Description | Default | Options |   git clone https://github.com/caputoDavide93/netskope-to-dlp-migration.git   - Recommended: Use smart groups based on installed software

|-----------|-------------|---------|---------|

| `$4` | DLP installation policy ID | `269` | Any valid Jamf policy ID |   cd netskope-to-dlp-migration

| `$5` | Log verbosity level | `INFO` | `DEBUG`, `INFO`, `WARN`, `ERROR` |

   ```### Example Configuration

### Example Configuration



```bash

# In Jamf Policy:2. **Upload to Jamf Pro**```

Parameter 4: 269

Parameter 5: INFO   - Navigate to: **Settings → Computer Management → Scripts**Script: migrate_to_minecast.sh

```

   - Click **New**Parameter 4: 269

### Customize for Your DLP Solution

   - Upload `migrate_to_dlp.sh`Parameter 5: INFO

Edit the script to match your DLP solution's paths:

   - Set display name: "Netskope to DLP Migration"Execution Frequency: Once per computer

```bash

DLP_PATHS=(```

    "/Applications/YourDLP.app"

    "/Library/Application Support/YourDLP"3. **Configure Jamf Policy**

)

   - Create a new policy or edit existing## What the Script Does

DLP_PKGS=("yourdlp" "com.yourdlp")

```   - Add the migration script



---   - Configure parameters (see below)### 1. Pre-Migration Check



## 📖 Usage   - Set scope to target computers- Detects if Netskope is installed



### Via Jamf Pro (Recommended)- Checks if Minecast is already present



1. Create a smart group for devices with Netskope## ⚙️ Configuration- Exits early if system is already in desired state

2. Create a policy with the migration script

3. Scope to your smart group

4. Deploy

### Jamf Parameters### 2. Netskope Removal

### Manual Testing



```bash

sudo ./migrate_to_dlp.sh 269 DEBUG| Parameter | Description | Default | Example |**Comprehensive cleanup includes:**

```

|-----------|-------------|---------|---------|

---

| **$4** | DLP install policy ID | 269 | Your Jamf policy ID |- **Processes**: Stops all Netskope processes (stagent, stAgentSvc, stAgentUI, etc.)

## 🔍 How It Works

| **$5** | Log verbosity level | INFO | DEBUG, INFO, WARN, ERROR |- **Launch Agents/Daemons**: Unloads and removes all launchd items

### Step 1: Pre-Migration Check

- Detects Netskope installation- **Kernel Extensions**: Unloads and removes kernel extensions (if present)

- Checks if target DLP is already present

- Exits early if already migrated### Example Policy Configuration- **System Extensions**: Identifies and removes system/network extensions



### Step 2: Netskope Removal- **Applications**: 



**Processes & Services**```  - `/Applications/Netskope Client.app`

- Stops all Netskope processes

- Unloads launch daemons and agentsScript: migrate_to_dlp.sh  - `/Applications/Remove Netskope Client.app`



**System Components**Parameter 4: 269- **System Files**:

- Removes applications

- Cleans kernel extensions (KEXTs)Parameter 5: INFO  - `/Library/Application Support/Netskope`

- Removes system extensions

- Deletes support filesExecution Frequency: Once per computer  - `/usr/local/netskope`



**Configuration & Preferences**```  - `/tmp/nsbranding`

- System preferences

- Managed preferences- **System Preferences**:

- User-specific preferences (all users)

### Customizing for Your DLP Solution  - `/Library/Preferences/com.netskope.*`

**Network Settings**

- VPN configurations  - `/Library/Managed Preferences/com.netskope.*`

- Proxy settings

- DNS resolversEdit the `DLP_PATHS` and `DLP_PKGS` arrays in the script to match your DLP solution:- **User-Specific Files** (for all users):



**Cleanup Locations:**  - `~/Library/Preferences/com.netskope.*`

```

/Applications/Netskope Client.app```bash  - `~/Library/Application Support/Netskope`

/Library/Application Support/Netskope

/Library/LaunchDaemons/com.netskope.*DLP_PATHS=(  - `~/Library/Caches/com.netskope.*`

/Library/LaunchAgents/com.netskope.*

/Library/Preferences/com.netskope.*    "/Applications/YourDLP.app"  - `~/Library/Saved Application State/com.netskope.*`

/Library/Extensions/Netskope*.system

/usr/local/netskope    "/Library/Application Support/YourDLP"  - `~/Library/Logs/Netskope`

/tmp/nsbranding

~/Library/Preferences/com.netskope.*)- **Network Configurations**:

~/Library/Application Support/Netskope

~/Library/Caches/com.netskope.*  - VPN configurations

/etc/resolver/netskope*

```DLP_PKGS=("yourdlp" "com.yourdlp")  - Proxy settings (web, secure web, PAC)



### Step 3: DLP Installation```  - DNS resolver configurations

- Executes Jamf policy by ID

- Waits for installation completion- **Package Receipts**: Removes all with `pkgutil --forget`

- Verifies successful installation

## 📖 Usage

### Step 4: Health Check

- Confirms Netskope removal### 3. Minecast Installation

- Verifies DLP installation

- Checks for conflicts### Via Jamf Pro (Recommended)- Runs Jamf policy by ID to install Minecast

- Reports system status

- Waits for installation to complete (max 90 seconds)

### Step 5: Summary Report

- Success/failure status1. Create a smart group targeting devices with Netskope installed- Verifies installation success

- Lists errors and warnings

- Provides recommendations2. Create a policy with the migration script



---3. Scope to your target smart group### 4. Health Check



## 📊 Exit Codes4. Run the policy- Confirms Netskope removal



| Code | Meaning |- Verifies Minecast installation

|------|---------|

| `0` | Success - Migration completed or DLP already installed |### Manual Execution (Testing)- Checks for conflicting processes

| `1` | Critical failure - Manual intervention required |

- Validates system state

---

```bash

## 🛠️ Troubleshooting

sudo ./migrate_to_dlp.sh <policy_id> <log_level>### 5. Summary Report

### Issue: DLP Not Detected After Installation

```- Provides clear success/failure status

**Solution:**

1. Verify the policy ID is correct- Lists all errors and warnings

2. Check `DLP_PATHS` and `DLP_PKGS` match your solution

3. Review Jamf policy logsExample:- Logs execution time and details

4. Run with `DEBUG` level:

   ```bash```bash

   sudo ./migrate_to_dlp.sh 269 DEBUG

   ```sudo ./migrate_to_dlp.sh 269 DEBUG## Exit Codes



### Issue: Netskope Remnants Still Present```



**Solution:**- `0` = Success (migration completed or Minecast already present)



Some components require a reboot:## 🔍 What the Script Does- `1` = Critical failure (manual intervention required)

- System extensions

- Kernel extensions

- Network configurations

### 1. Pre-Migration Check## Log Output

**Manual Check:**

```bash- Detects if Netskope is installed

# Check for running processes

pgrep -if netskope- Checks if target DLP is already presentAll logs are sent to stdout and captured by Jamf. Example:



# Check launchd items- Exits early if system is already in desired state

ls -la /Library/Launch{Daemons,Agents}/com.netskope.* 2>/dev/null

```

# Check system extensions

systemextensionsctl list | grep -i netskope### 2. Netskope Removal[2025-10-29 10:30:45] [INFO] ==========================================

```

[2025-10-29 10:30:45] [INFO] Minecast Migration Script Started

### Issue: Permission Denied

The script performs comprehensive cleanup of all Netskope components:[2025-10-29 10:30:45] [INFO] ==========================================

**Solution:**

[2025-10-29 10:30:45] [INFO] Script version: 1.0

Ensure root privileges:

```bash#### Process Management[2025-10-29 10:30:45] [INFO] Start time: 2025-10-29 10:30:45

sudo ./migrate_to_dlp.sh 269 INFO

```- Stops all Netskope processes (stagent, stAgentSvc, stAgentUI, NetskopeClient)[2025-10-29 10:30:46] [INFO] macOS Version: 14.5



### Issue: Script Hangs During Execution[2025-10-29 10:30:46] [INFO] Minecast Policy ID: 269



**Solution:**#### System Components```

1. Check if Netskope processes are frozen

2. Force kill processes: `sudo pkill -9 -f Netskope`- **Launch Agents/Daemons**: Unloads and removes all launchd items

3. Run script again

- **Kernel Extensions**: Unloads and removes KEXTs (if present)## Monitoring in Jamf

---

- **System Extensions**: Identifies and removes system/network extensions

## 🤝 Contributing

- **Applications**: 1. **View Logs**

Contributions are welcome! Please follow these steps:

  - `/Applications/Netskope Client.app`   - Go to the computer record

1. **Fork** the repository

2. **Create** a feature branch  - `/Applications/Remove Netskope Client.app`   - Click "Policy Logs"

   ```bash

   git checkout -b feature/YourFeature   - Find the migration policy

   ```

3. **Test** thoroughly in a safe environment#### System Files   - Review complete output

4. **Commit** your changes

   ```bash- `/Library/Application Support/Netskope`

   git commit -m 'Add YourFeature'

   ```- `/usr/local/netskope`2. **Check Status**

5. **Push** to your branch

   ```bash- `/tmp/nsbranding`   - Look for `✓ MIGRATION SUCCESSFUL` in logs

   git push origin feature/YourFeature

   ```- `/Library/Extensions/Netskope*.system`   - Verify Minecast appears in installed software

6. **Open** a Pull Request

   - Confirm Netskope is no longer listed

### Contribution Guidelines

#### Preferences & Configuration

- Test in non-production environment first

- Follow existing code style- `/Library/Preferences/com.netskope.*`3. **Troubleshooting**

- Update documentation for new features

- Add entries to CHANGELOG.md- `/Library/Managed Preferences/com.netskope.*`   - If errors occur, check the detailed log output



---   - Script continues even on errors (non-blocking)



## 📝 License#### User-Specific Files (All Users)   - Look for `[ERROR]` and `[WARN]` tags in logs



This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.- `~/Library/Preferences/com.netskope.*`



---- `~/Library/Application Support/Netskope`## Error Handling



## 👤 Author- `~/Library/Caches/com.netskope.*`



**Davide Caputo**- `~/Library/Saved Application State/com.netskope.*`The script is designed to be **resilient**:



- GitHub: [@caputoDavide93](https://github.com/caputoDavide93)- `~/Library/Logs/Netskope`- Errors don't stop execution



---- Each step is logged independently



## 🙏 Acknowledgments#### Network Configurations- Continues with next step even if previous fails



- Jamf community for inspiration and support- VPN configurations- Final summary reports all issues

- macOS system administration best practices

- Open source community- Proxy settings (web, secure web, PAC)



---- DNS resolver configurations (`/etc/resolver/netskope*`)## Smart Features



## ⚠️ Disclaimer



This script is provided **as-is**, without warranty of any kind. Always test in a non-production environment first. The author is not responsible for any data loss or system issues that may occur.#### Package Receipts### Skip If Already Migrated



---- Removes all Netskope package receipts with `pkgutil --forget`If Minecast is installed and Netskope is not present, the script exits immediately:



## 📚 Resources```



- [Jamf Pro Documentation](https://docs.jamf.com/)### 3. DLP Installation[INFO] System is already in desired state (Minecast installed, Netskope removed)

- [macOS Deployment Guide](https://support.apple.com/guide/deployment/welcome/web)

- [Bash Best Practices](https://google.github.io/styleguide/shellguide.html)- Runs Jamf policy by ID to install target DLP[INFO] No migration needed - exiting successfully



---- Waits for installation to complete (max 90 seconds)```



## 🔖 Version- Verifies installation success



**Current Version:** 2.0.0  ### Partial Success Handling

**Last Updated:** October 29, 2025

### 4. Health CheckIf Minecast installs but Netskope remnants remain:

---

- Confirms Netskope removal```

> **Note:** This is an independent open-source tool. It is not affiliated with or endorsed by Netskope, Jamf, or any DLP vendor.

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
