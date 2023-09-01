#!/bin/bash
TEMPLATE_DIR=templates
CONFIG_FILE=config/main.yaml
OUTPUT_DIR=output

CONFIG="$(cat $CONFIG_FILE)"

. ./functions.sh


for node in `seq 0 $(($(echo "$CONFIG" | yq -r '.nodes | length') - 1))`; do
    NODE_CONFIG="$(node_config "$CONFIG" "$node")"
    render_template "$NODE_CONFIG" default-domain.j2 default-domain-node-${node}.cfg
done

for domain in `seq 0 $(($(echo "$CONFIG" | yq -r '.apic_domains | length') - 1))`; do
    DOMAIN_CONFIG="$(domain_config "$CONFIG" "$domain")"
    NODE="$(echo "$DOMAIN_CONFIG" | yq -r .node)"
    DOMAIN_NAME="$(echo "$DOMAIN_CONFIG" | yq -r .name)"
    render_template "$DOMAIN_CONFIG" apic-domain.j2 apic-domain-${NODE}-${DOMAIN_NAME}.cfg
    render_template "$DOMAIN_CONFIG" keygen.j2 apic-domain-keygen-${NODE}-${DOMAIN_NAME}.cfg
done
