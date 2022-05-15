#!/usr/bin/env bash

############### CONFIGURATION ####################

PASSWORD=my-bitwarden-password
OUTPUTFOLDER=/path/to/backup/destination
BW_BINARY=/path/to/bitwarden-cli/bin

############ END OF CONFIGURATION ################

# Check if the output directory exists
if ! [ -d "$OUTPUTFOLDER" ]; then
        echo "Output folder doesn't exist." 1>&2
        exit 1
fi

# Check if the Bitwarden CLI binary exists
if ! [ -f "$BW_BINARY" ]; then
        echo "Bitwarden binary cannot be found. Check your settings." 1>&2
        exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
        echo "The command jq could not be found. Make sure jq is installed before you use this script."
        exit 1
fi

# Check if the user is logged into Bitwarden
if ! "$BW_BINARY" login --check &> /dev/null; then
        echo "You need to login to BitWarden before running this script."
        exit 1
fi

# Variables used later in script. Not meant to be changed.
SESSION=$("$BW_BINARY" unlock --raw "$PASSWORD")
PARENTS=$("$BW_BINARY" list items --session "$SESSION" | jq -r '.[] | select(.attachments) | .id')
JSONFILE="$OUTPUTFOLDER"/vault.json
EXIT=0

# Detect changes to your Bitwarden vault and export passwords to json file
"$BW_BINARY" sync --session "$SESSION" || EXIT=$?
"$BW_BINARY" export "$PASSWORD" --format json --session "$SESSION" --output "$JSONFILE" || EXIT=$?

# Goes through any item that contains attachments and downloads them
for P in $PARENTS; do
        ATTACH=$("$BW_BINARY" get item "$P" --session "$SESSION" | jq -r .attachments[].id)
        PARENTFOLDER=$(echo $P | cut -d - -f 1)
        for A in $ATTACH; do
                ATTACHFOLDER=$(echo $A | cut -c1-8)
                "$BW_BINARY" get attachment "$A" --itemid "$P" --session "$SESSION" --output "$OUTPUTFOLDER"/attachments/"$PARENTFOLDER"/"$ATTACHFOLDER"/ || EXIT=$?
        done
done

# Exits with zero code 0 unless anything went wrong
exit $EXIT