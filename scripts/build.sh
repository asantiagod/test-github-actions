#!/bin/bash

BOARD="ESP32"
BOARD_VARIANT="OTA"
MANIFEST_FILE="manifest.py"
# FIRMWARE_FILE="firmware.bin"
FIRMWARE_FILE="micropython.bin"

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
ESP_IDF_DIR=~/esp-idf 
MICROPYTHON_DIR=~/micropython/ports/esp32
BIN_PATH="$SCRIPT_DIR/../../bin"
SRC_DIR="$SCRIPT_DIR/../../src"
MANIFEST_PATH="$SRC_DIR/$MANIFEST_FILE"

if [ -z $IDF_PATH ]; then
    source $ESP_IDF_DIR/export.sh
fi

cd $MICROPYTHON_DIR

if [ ! -d "$MICROPYTHON_DIR/boards/$BOARD" ]; then
    cp -r $SRC_DIR/boards/$BOARD ./boards
fi

make BOARD_DIR="$MICROPYTHON_DIR/boards/$BOARD" BOARD_VARIANT=$BOARD_VARIANT FROZEN_MANIFEST="$MANIFEST_PATH"

# Create binary directory if it does not exist
if [ ! -d $BIN_PATH ]; then
    mkdir $BIN_PATH
fi

cp build-$BOARD-$BOARD_VARIANT/$FIRMWARE_FILE $BIN_PATH
SHA256=$(sha256sum build-$BOARD-$BOARD_VARIANT/$FIRMWARE_FILE | awk '{print $1}')
FILE_LENGTH=$(stat -c %s build-$BOARD-$BOARD_VARIANT/$FIRMWARE_FILE)
printf '{
    "firmware": "%s",
    "sha": "%s",
    "length": %s
}' $FIRMWARE_FILE $SHA256 $FILE_LENGTH > $BIN_PATH/ota.json

cat $BIN_PATH/ota.json
