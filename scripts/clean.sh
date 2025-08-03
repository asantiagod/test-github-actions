BOARD=ESP32
BOARD_VARIANT="OTA"

if [ -z $IDF_PATH ]; then
    source ~/esp-idf/export.sh
fi

cd ~/micropython/ports/esp32
make BOARD_DIR=./boards/$BOARD BOARD_VARIANT=$BOARD_VARIANT clean