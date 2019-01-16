# BitwardenBackup

Script for backing up Bitwarden vault including attachments


## Summary

This script is a product of me trying to find a solution for backing up the Bitwarden vault including all attachments daily via cron. There's plenty of scripts/programs out there that backup Bitwarden, but very few that also handle attachments.

It currently does not handle versioning/encryption. Borg backup is an excellent tool that can handle both of these things better than I could write in a script.


## Usage, Requirements

This script can be invoked manually, but it's designed to work without issues when called via cron aswell.

Required dependencies:
 * **bw** for accessing your Bitwarden vault. It's Bitwarden's official CLI utility that can be downloaded from https://github.com/bitwarden/cli
 * **jq**, **grep**, **sed** and **awk** for utility output parsing. **jq** may need to be installed seperately. For Debian based distributions it can be installed with 
    
    $ apt install jq
     
  
## Configuration

1. Create the folder where you want your backups to end up.

2. Edit the values of the variables in the configuration section. Do not edit anything under "END OF CONFIGURATION" unless you know exactly what you're doing. 


## License

This software is released under the terms of the MIT License, see file
*LICENSE*.
