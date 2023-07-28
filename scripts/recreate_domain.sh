#!/bin/bash -x

SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SITE="$1"
GATEWAY_NUM="$2"
PASSWORD="${PASSWORD:-$3}"

DP_CONFIG_DIR='local:///apic-config'
CONFIG_DIR=${SCRIPT_ROOT}/../config/${SITE}/datapower-${GATEWAY_NUM}
HOST_FQDN=$(yq -r '.fqdn' ${CONFIG_DIR}/data.yaml)
HOST_IP=$(yq -r '.backend_ip' ${CONFIG_DIR}/data.yaml)

cat <<EOF > /tmp/recreate_domain.cfg
	top; configure terminal;
		sw default
		no domain apiconnect
		write memory
		exec local:///apic-config/keygen.cfg
		exec local:///apic-config/apic-config.cfg
	exit
EOF

$SCRIPT_ROOT/upload_file.sh "$HOST_IP" "$DP_CONFIG_DIR" "$PASSWORD" /tmp/recreate_domain.cfg "$CONFIG_DIR"/{keygen.cfg,apic-config.cfg}

$SCRIPT_ROOT/execute.exp "$HOST_IP" "exec ${DP_CONFIG_DIR}/recreate_domain.cfg" "$PASSWORD"
