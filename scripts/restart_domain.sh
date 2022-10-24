#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST=$(yq -r '.fqdn' ${CONFIG_DIR}/data.yaml)

cat <<EOF > /tmp/restart_domain.cfg
	top; configure terminal;
		sw default
		restart domain apiconnect
		write memory
	exit
EOF

$SCRIPT_ROOT/execute.sh "$HOST" "configure terminal; mkdir $DP_CONFIG_DIR; exit"

dp-file-uploader "$HOST" "$DP_CONFIG_DIR" /tmp/restart_domain.cfg

$SCRIPT_ROOT/execute.sh "$HOST" "exec ${DP_CONFIG_DIR}/restart_domain.cfg"
