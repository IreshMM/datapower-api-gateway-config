render_template() {
    local CONFIG="$1"
    local TEMPLATE_FILE="$2"
    local OUTPUT_FILE="$3"
    echo "$CONFIG" | j2 --format=yaml ${TEMPLATE_DIR}/${TEMPLATE_FILE} > ${OUTPUT_DIR}/${OUTPUT_FILE}
}

node_config() {
    local CONFIG="$1"
    local NODE="$2"
    NODE_CONFIG="$(echo "$CONFIG" | /usr/bin/yq ". as \$root | .common.node *d .nodes[$NODE] | .management_listen=.nics[.management_listen].fqdn")"
    echo "$NODE_CONFIG"
}

domain_config() {
    local CONFIG="$1"
    local DOMAIN="$2"
    DOMAIN_CONFIG="$(echo "$CONFIG" | yq -y ". as \$root | .common.apic_domain + .apic_domains[$DOMAIN] | \
        .frontend_listen=\$root.nodes[.node].nics[.frontend_listen].fqdn | \
        .backend_listen=\$root.nodes[.node].nics[.backend_listen].fqdn | \
        .management_listen=\$root.nodes[.node].nics[.management_listen].fqdn | \
        .fqdn=\$root.nodes[.node].fqdn")"
    echo "$DOMAIN_CONFIG"
}
