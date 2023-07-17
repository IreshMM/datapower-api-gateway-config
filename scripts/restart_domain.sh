#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"
PASSWORD="${PASSWORD:-$3}"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST_IP=$(yq -r '.backend_ip' ${CONFIG_DIR}/data.yaml)

cat <<EOF > /tmp/restart_domain.cfg
	top; configure terminal;
		sw default
		restart domain apiconnect
		write memory
	exit
EOF


$SCRIPT_ROOT/upload_file.sh "$HOST_IP" "$DP_CONFIG_DIR" "$PASSWORD" /tmp/restart_domain.cfg

$SCRIPT_ROOT/execute.exp "$HOST_IP" "exec ${DP_CONFIG_DIR}/restart_domain.cfg" $PASSWORD
