#!/bin/bash

for i in 1 2 3; do
    j2 apic-config.j2 datapower-${i}/data.yaml > datapower-${i}/apic-config.cfg
    j2 keygen.j2 datapower-${i}/data.yaml > datapower-${i}/keygen.cfg
done
