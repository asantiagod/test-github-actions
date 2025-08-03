
# Definir el puerto serial
SERIAL_PORT=""

# Procesar argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
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

minicom -D $SERIAL_PORT

