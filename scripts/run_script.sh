#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"
SCRIPT_FILE_PATH="$3"
PASSWORD="${PASSWORD:-$4}"
SCRIPT_FILE_NAME="$(basename $SCRIPT_FILE_PATH)"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST_IP=$(yq -r '.backend_ip' ${CONFIG_DIR}/data.yaml)

$SCRIPT_ROOT/upload_file.sh "$HOST_IP" "$DP_CONFIG_DIR" "$PASSWORD" "$SCRIPT_FILE_PATH"

$SCRIPT_ROOT/execute.exp "$HOST_IP" "exec ${DP_CONFIG_DIR}/${SCRIPT_FILE_NAME}" "$PASSWORD" 
