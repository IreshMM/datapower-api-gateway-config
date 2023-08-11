#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

HOST="$1"
DP_CONFIG_DIR="$2"
PASSWORD="$3"
shift 3
FILE_PATHS="$@"

# Make sure xml-mgmt is enabled
$SCRIPT_ROOT/execute.exp $HOST "configure terminal; xml-mgmt; admin-state enabled; exit; exit" $PASSWORD

XML_MGMT_PORT=5550
if [[ "$F_UPLOAD_USE_WEB_MGMT_PORT" == true ]]; then
    XML_MGMT_PORT=9090
    $SCRIPT_ROOT/execute.exp $HOST "configure terminal; web-mgmt; admin-state disabled; exit; xml-mgmt; port $XML_MGMT_PORT; exit; exit" $PASSWORD
fi

$SCRIPT_ROOT/execute.exp "$HOST" "configure terminal; mkdir $DP_CONFIG_DIR; exit" "$PASSWORD"

for file_path in $FILE_PATHS; do
    dp-file-uploader -P "$XML_MGMT_PORT" -p "$PASSWORD" "$HOST" "$DP_CONFIG_DIR" "$file_path"
done

if [[ "$F_UPLOAD_USE_WEB_MGMT_PORT" == true ]]; then
    XML_MGMT_PORT=5550
    $SCRIPT_ROOT/execute.exp $HOST "configure terminal; xml-mgmt; port $XML_MGMT_PORT; exit; web-mgmt; admin-state enabled; exit; exit" $PASSWORD
fi
