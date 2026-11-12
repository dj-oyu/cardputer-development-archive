#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
for name in test_hidden_failure test_boundary_aa; do
 cc -std=c11 -O2 -Wall -Wextra -Wno-misleading-indentation -ffunction-sections -fdata-sections -Iproduct/main -Iphysical tests/$name.c product/main/ui/kasane/ksn_mesh_depth.c product/main/ayatsuri/compact_opaque.c physical/fox_disk_lighting.c -Wl,--gc-sections -lm -o tests/$name
 tests/$name > tests/$name.json
 cat tests/$name.json
done
