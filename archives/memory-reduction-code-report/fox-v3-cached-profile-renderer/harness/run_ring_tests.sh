#!/bin/sh
set -eu
R=fox-v3-cached-profile-renderer
P=$R/private-build
D=$R/build-synthetic${SUFFIX:-}
mkdir -p "$D"
for test in test_producer test_ring_negative test_ring_exact test_ring_exact_depth test_ring_negative_depth; do
 cc -std=c11 -O2 -g -ffp-contract=off -fexcess-precision=standard -fstack-usage ${SANITIZE:-} -ffunction-sections -fdata-sections -I $R/code -I $P/product/main -I $P/product/main/ui/kasane -I $P/physical $R/harness/$test.c $P/product/main/ui/kasane/ksn_mesh_depth.c $P/product/main/ayatsuri/compact_opaque.c $P/physical/fox_disk_lighting.c -Wl,--gc-sections -lm -o $D/$test
 $D/$test > $D/$test.log
 cat $D/$test.log
done
