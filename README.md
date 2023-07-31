# BitwardenBackup

Script for backing up Bitwarden vault including attachments

## Summary

This script is a product of me trying to find a solution for backing up the Bitwarden vault including all attachments daily via cron. There's plenty of scripts/programs out there that backup Bitwarden, but very few that also handle attachments.

It currently does not handle versioning/encryption. Borg backup is an excellent tool that can handle both of these things better than I could write in a script.

Pull requests are highly encouraged!

## Usage, Requirements

This script can be invoked manually, but it's designed to work without issues when called via cron aswell.

Download the latest release from GitHub for a stable and tested version.

Required dependencies:
 * **bw** for accessing your Bitwarden vault. It's Bitwarden's official CLI utility that can be downloaded from [https://github.com/bitwarden/cli](https://bitwarden.com/download/)
 * **jq** for parsing output so the script can find what to backup. If you run a Debian based distributions then it can be installed with  ```sudo apt install jq ```
 
 WARNING! There is no built in check in the script nor in "bw" that checks for existing files and they WILL get overwritten if a file with the same filename that you are downloading already exists.

## Configuration

1. Create the folder where you want your backups to end up.

2. Edit the values of the variables in the configuration section. Do not edit anything under "END OF CONFIGURATION" unless you know exactly what you're doing. An example could be 
```bash
############### CONFIGURATION ####################

PASSWORD=secretpassword123
OUTPUTFOLDER=/mnt/bitwarden
BW_BINARY=/usr/bin/bw

############ END OF CONFIGURATION ################
```

## License

This software is released under the terms of the MIT License, see file
*LICENSE*.
