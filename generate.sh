#!/bin/bash
TEMPLATE_DIR=templates

for i in 1; do
    for site in test-site; do
        SITE_CONFIG_DIR=config/${site}
        cat ${SITE_CONFIG_DIR}/datapower-${i}/data.yaml ${SITE_CONFIG_DIR}/common-data.yaml \
            | j2 --format=yaml ${TEMPLATE_DIR}/apic-config.j2  > ${SITE_CONFIG_DIR}/datapower-${i}/apic-config.cfg
        j2 ${TEMPLATE_DIR}/keygen.j2 ${SITE_CONFIG_DIR}/datapower-${i}/data.yaml > ${SITE_CONFIG_DIR}/datapower-${i}/keygen.cfg
    done
done
