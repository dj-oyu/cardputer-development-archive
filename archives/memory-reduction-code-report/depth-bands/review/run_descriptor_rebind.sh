#!/bin/sh
set -eu
R=fox-v3-depth-bands
P=$R/private-build
D=$R/review/build-rebind${SUFFIX:-}
mkdir -p "$D"
for test in test_descriptor_rebind; do
 cc -std=c11 -O2 -g -ffp-contract=off -fexcess-precision=standard ${SANITIZE:-} -ffunction-sections -fdata-sections -I "$R/code" -I "$R/harness" -I "$P/product/main" -I "$P/product/main/ui/kasane" -I "$P/physical" "$R/review/$test.c" "$P/product/main/ui/kasane/ksn_mesh_depth.c" "$P/product/main/ayatsuri/compact_opaque.c" "$P/physical/fox_disk_lighting.c" -Wl,--gc-sections -lm -o "$D/$test"
 "$D/$test" > "$D/$test.log"
 cat "$D/$test.log"
done
