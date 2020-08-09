#!/usr/bin/env bash

############### CONFIGURATION ####################

PASSWORD=my-bitwarden-password
OUTPUTFOLDER=/path/to/backup/destination
BW_BINARY=/path/to/bitwarden-cli/bin

############ END OF CONFIGURATION ################

if ! [ -d $OUTPUTFOLDER ]; then
        echo "Output folder doesn't exist." 1>&2
        exit 1
fi

if ! [ -f $BW_BINARY ]; then
        echo "Bitwarden binary cannot be found. Check your settings." 1>&2
        exit 1
fi

if ! $BW_BINARY login --check; then
	exit 1
fi

# Variables used later in script. Not meant to be changed.
SESSIONS=$($BW_BINARY unlock --raw $PASSWORD)
PARENTS=$($BW_BINARY list items --session $SESSIONS --pretty | jq '.[] | select(.attachments)' | grep -o -P '(?<="id": ").*(?=",)' | sed -n -e '/-/{p;n;}')
ATTACHFOLDER=$OUTPUTFOLDER/attachments/
JSONFILE=$OUTPUTFOLDER/vault.json
EXIT=0

$BW_BINARY sync --session $SESSIONS || EXIT=$?
$BW_BINARY export $PASSWORD --format json --session $SESSIONS --output $JSONFILE || EXIT=$?

for P in $PARENTS; do
        ATTACH=$(echo $P $($BW_BINARY get item $P --pretty --session $SESSIONS | jq .attachments | grep -o -P '(?<="id": ").*(?=",)') | awk '{$1=""; print $0}')
        for A in $ATTACH; do
                $BW_BINARY get attachment $A --itemid $P --session $SESSIONS --output $ATTACHFOLDER || EXIT=$?
                sleep 1
        done
done

exit $EXIT
