#!/bin/bash

for i in 1 2 3; do
    cat datapower-${i}/data.yaml common-data.yaml | j2 --format=yaml apic-config.j2  > datapower-${i}/apic-config.cfg
    j2 keygen.j2 datapower-${i}/data.yaml > datapower-${i}/keygen.cfg
done
