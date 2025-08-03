SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if [ -z $IDF_PATH ]; then
    source ~/esp-idf/export.sh
fi

$SCRIPT_DIR/build.sh
$SCRIPT_DIR/deploy.sh
$SCRIPT_DIR/monitor.sh