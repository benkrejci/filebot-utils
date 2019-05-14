#!/usr/bin/env bash
umask 002

# input
SOURCE="${BASH_SOURCE[0]}"
SCRIPT_NAME="$(basename "$SOURCE")"
SCRIPT_DIR="$( cd "$( dirname "$SOURCE" )" && pwd )"

ARG_ID="$1"
ARG_NAME="$2"
ARG_PATH="$3"

# configuration
CONFIG_OUTPUT="/mnt/media"
CONFIG_LOGDIR="$CONFIG_OUTPUT/.log"

# logging
add_date() {
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      echo "$(date) [$1] $line"
    fi
  done
}
exec 3>&1 4>&2
exec 1> >(add_date LOG >>$CONFIG_LOGDIR/$SCRIPT_NAME.log)
exec 2> >(add_date ERROR >>$CONFIG_LOGDIR/$SCRIPT_NAME.log)

echo "deluge args:"
echo "  \$ARG_ID = \"$ARG_ID\""
echo "  \$ARG_NAME = \"$ARG_NAME\""
echo "  \$ARG_PATH = \"$ARG_PATH\""

$SCRIPT_DIR/process-media.sh "$ARG_PATH" "$ARG_NAME"
