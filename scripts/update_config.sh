#!/bin/bash

# Guardar la ubicación del script en una variable
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Guardar el path del repositorio en una variable
REPO_PATH=$(realpath "$SCRIPT_DIR/../../..")

# Definir el puerto serial
SERIAL_PORT=""

# Procesar argumentos
while [ $# -gt 0 ]; do
  case "$1" in
    -p | --port)
      SERIAL_PORT="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Asignar valor predeterminado si no se pasó como argumento
if [ -z "$SERIAL_PORT" ]; then
    SERIAL_PORT="/dev/ttyUSB1"
fi

# Copiar los archivos de configuración y datos al ESP32
cd $REPO_PATH/server/src
mpremote connect $SERIAL_PORT rm :config.ini
mpremote connect $SERIAL_PORT cp data/config.ini :config.ini