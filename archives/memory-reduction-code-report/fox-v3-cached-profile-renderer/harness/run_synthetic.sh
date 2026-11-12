#!/bin/sh
set -eu
R=fox-v3-cached-profile-renderer
P=$R/private-build
cc -std=c11 -O2 -g -ffp-contract=off -fstack-usage ${SANITIZE:-} -ffunction-sections -fdata-sections -I $R/code -I $P/product/main -I $P/product/main/ui/kasane -I $P/physical $R/harness/test_producer.c $P/product/main/ui/kasane/ksn_mesh_depth.c $P/product/main/ayatsuri/compact_opaque.c $P/physical/fox_disk_lighting.c -Wl,--gc-sections -lm -o $R/build-synthetic/test-producer
$R/build-synthetic/test-producer
