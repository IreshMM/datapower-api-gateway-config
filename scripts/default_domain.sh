#!/bin/bash

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

. $SCRIPT_ROOT/../functions.sh

CONFIG_FILE=$SCRIPT_ROOT/../config/main.yaml
OUTPUT_DIR=$SCRIPT_ROOT/../output
CONFIG="$(cat $CONFIG_FILE)"

NODE=$1
PASSWORD="${PASSWORD:-$2}"

NODE_CONFIG="$(node_config "$CONFIG" "$NODE")"
DP_CONFIG_DIR='local:///apic-config'
HOST_FQDN=$(echo "$NODE_CONFIG" | yq -r .fqdn)
HOST_IP=$(echo "$NODE_CONFIG" | yq -r '.nics[0].ip_address')
DOMAIN_CONFIG_FILE="default-domain-node-${NODE}.cfg"

$SCRIPT_ROOT/upload_file.sh "$HOST_IP" "$DP_CONFIG_DIR" "$PASSWORD" "$OUTPUT_DIR"/"$DOMAIN_CONFIG_FILE"

$SCRIPT_ROOT/execute.exp "$HOST_IP" "exec ${DP_CONFIG_DIR}/${DOMAIN_CONFIG_FILE}" "$PASSWORD"
