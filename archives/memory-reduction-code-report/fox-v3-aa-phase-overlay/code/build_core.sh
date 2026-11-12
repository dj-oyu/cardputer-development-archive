#!/bin/sh
set -eu
cc -std=c11 -O2 -g -ffp-contract=off -fstack-usage -I fox-v3-aa-phase-overlay/code -I fox-v3-aa-phase-overlay/private-build/product/main -I fox-v3-aa-phase-overlay/private-build/product/main/ui/kasane -I fox-v3-aa-phase-overlay/private-build/physical -c fox-v3-aa-phase-overlay/private-build/product/main/ui/kasane/ksn_mesh_depth.c -o fox-v3-aa-phase-overlay/build-synthetic/core.o
