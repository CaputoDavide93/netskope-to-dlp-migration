# Netskope to DLP Migration Script

Bash script for migrating macOS from Netskope to any DLP solution via Jamf Pro.

## Overview

Removes all Netskope components and installs your target DLP solution.

## Requirements

- macOS 10.13 or later
- Jamf Pro
- Root access

## Usage

```bash
sudo ./migrate_to_dlp.sh <jamf_policy_id> <log_level>
```

Example:

```bash
sudo ./migrate_to_dlp.sh 269 INFO
```

## Configuration

Edit these lines in the script for your DLP:

```bash
DLP_PATHS=(
    "/Applications/YourDLP.app"
    "/Library/Application Support/YourDLP"
)

DLP_PKGS=("yourdlp" "com.yourdlp")
```

## What Gets Removed

- Netskope applications
- Launch daemons and agents
- Kernel and system extensions
- Network configurations
- System and user preferences
- Package receipts

## Exit Codes

- 0 = Success
- 1 = Failure

## License

MIT

## Author

Davide Caputo - [@caputoDavide93](https://github.com/caputoDavide93)
