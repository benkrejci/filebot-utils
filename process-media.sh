#!/usr/bin/env bash

# input
INPUT_PATH_PREFIX="$1"
INPUT_PATH_SUFFIX="$2" # optional
INPUT_LABEL="${3:-N/A}" # optional (e.g. Movie, Series, Anime, etc.)

INPUT_PATH="$INPUT_PATH_PREFIX"
if [ -n "$INPUT_PATH_SUFFIX" ]; then
  INPUT_PATH="$INPUT_PATH/$INPUT_PATH_SUFFIX"
  INPUT_NAME="$INPUT_PATH_SUFFIX"
else
  INPUT_NAME="$(basename "$INPUT_PATH")"
fi

# configuration
CONFIG_OUTPUT="/mnt/media"
CONFIG_LOGDIR="$CONFIG_OUTPUT/.log"
CONFIG_TMP="$CONFIG_OUTPUT/.processing"
CONFIG_EXCLUDES="$CONFIG_OUTPUT/.excludes"
CONFIG_MOVIE_FORMAT="movies/{n} ({y})/{n} ({y}){'.'+lang}"
CONFIG_SERIES_FORMAT="tv/{n}/Season {s.pad(2)}/{n} - {s00e00} - {t}{'.'+lang}"
CONFIG_MUSIC_FORMAT="music/{n}/{album+'/'}{pi.pad(2)+'. '}{artist} - {t}"

echo "PROCESS MEDIA START"
echo "  \$INPUT_PATH = \"$INPUT_PATH\""
echo "  \$INPUT_NAME = \"$INPUT_NAME\""
echo "  \$INPUT_LABEL = \"$INPUT_LABEL\""

# preparation
#TMP_PATH="$CONFIG_TMP/$INPUT_NAME"
#TMP_DIRECTORY="$(dirname "$TMP_PATH")"
#mkdir -p "$TMP_DIRECTORY"
#echo "Copy to tmp file: \"$TMP_PATH\""
#cp -r "$INPUT_PATH" "$TMP_PATH" # cp to intermediary processing dir

# go!
AMC_LOG=$CONFIG_LOGDIR/amc.log
echo "Run amc script (see $AMC_LOG)"
filebot -script fn:amc "$INPUT_PATH" --output "$CONFIG_OUTPUT" --log-file "$AMC_LOG" \
  --action hardlink --conflict skip -non-strict \
  --def subtitles=en unsorted=y music=y artwork=y excludeList="$CONFIG_EXCLUDES" minFileSize=1000000 \
        ut_kind="multi" ut_title="$INPUT_NAME" ut_label="$INPUT_LABEL" \
        movieFormat="$CONFIG_MOVIE_FORMAT" seriesFormat="$CONFIG_SERIES_FORMAT" musicFormat="$CONFIG_MUSIC_FORMAT"

#echo "Removing tmp file"
#rm -r "$TMP_PATH"

echo "PROCESS MEDIA DONE!"
