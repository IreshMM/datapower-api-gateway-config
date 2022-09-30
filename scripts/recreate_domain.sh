#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST=$(yq -r '.fqdn' ${CONFIG_DIR}/data.yaml)

cat <<EOF > /tmp/recreate_domain.cfg
	top; configure terminal;
		sw default
		no domain apiconnect
		write memory
		exec local:///apic-config/keygen.cfg
		exec local:///apic-config/apic-config.cfg
	exit
EOF

$SCRIPT_ROOT/execute.sh "$HOST" "configure terminal; mkdir $DP_CONFIG_DIR; exit"

dp-file-uploader "$HOST" "$DP_CONFIG_DIR" /tmp/recreate_domain.cfg
dp-file-uploader "$HOST" "$DP_CONFIG_DIR" "${CONFIG_DIR}/keygen.cfg"
dp-file-uploader "$HOST" "$DP_CONFIG_DIR" "${CONFIG_DIR}/apic-config.cfg"

$SCRIPT_ROOT/execute.sh "$HOST" "exec ${DP_CONFIG_DIR}/recreate_domain.cfg"
