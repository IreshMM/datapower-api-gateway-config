#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

HOST="$1"
DP_CONFIG_DIR="$2"
PASSWORD="$3"
shift 3
FILE_PATHS="$@"

XML_MGMT_PORT=5550
if [[ "$F_UPLOAD_USE_WEB_MGMT_PORT" == true ]]; then
    XML_MGMT_PORT=9090
    ./execute.exp $HOST "configure terminal; web-mgmt; admin-state disabled; exit; xml-mgmt $HOST $XML_MGMT_PORT; exit" $PASSWORD
fi

$SCRIPT_ROOT/execute.exp "$HOST" "configure terminal; mkdir $DP_CONFIG_DIR; exit" "$PASSWORD"

for file_path in $FILE_PATHS; do
    dp-file-uploader -P "$XML_MGMT_PORT" -p "$PASSWORD" "$HOST" "$DP_CONFIG_DIR" "$file_path"
done

if [[ "$F_UPLOAD_USE_WEB_MGMT_PORT" == true ]]; then
    XML_MGMT_PORT=5550
    ./execute.exp $HOST "configure terminal; xml-mgmt $HOST $XML_MGMT_PORT; web-mgmt; admin-state enabled; exit; exit" $PASSWORD
fi