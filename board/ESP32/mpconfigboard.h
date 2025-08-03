// Both of these can be set by mpconfigboard.cmake if a BOARD_VARIANT is
// specified.

#ifndef MICROPY_HW_BOARD_NAME
#define MICROPY_HW_BOARD_NAME "ESP32 module 16MB"
#endif

#ifndef MICROPY_HW_MCU_NAME
#define MICROPY_HW_MCU_NAME "Fracttal IOT"
#endif

#define MICROPY_PY_NETWORK_LAN_SPI_CLOCK_SPEED_MZ 5