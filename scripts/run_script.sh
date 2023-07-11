#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"
SCRIPT_FILE="$3"
PASSWORD="${PASSWORD:-$4}"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST=$(yq -r '.fqdn' ${CONFIG_DIR}/data.yaml)

$SCRIPT_ROOT/execute.exp "$HOST" "configure terminal; mkdir $DP_CONFIG_DIR; exit" "$PASSWORD"

dp-file-uploader -p "$PASSWORD" "$HOST" "$DP_CONFIG_DIR" "$SCRIPT_FILE"

$SCRIPT_ROOT/execute.exp "$HOST" "exec ${DP_CONFIG_DIR}/${SCRIPT_FILE}" "$PASSWORD" 
