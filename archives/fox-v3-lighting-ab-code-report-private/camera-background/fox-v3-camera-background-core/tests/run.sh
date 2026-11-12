#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
base='-std=c11 -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fexcess-precision=standard -ffunction-sections -fdata-sections -Iproduct/main -Iphysical'
src='tests/test_scene_composition.c product/main/ui/kasane/ksn_mesh_depth.c product/main/ayatsuri/compact_opaque.c physical/fox_disk_lighting.c'
cc $base -O2 -fstack-usage $src -Wl,--gc-sections -lm -o tests/test_scene_composition
tests/test_scene_composition > tests/fixtures-O2.json
cc $base -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer $src -Wl,--gc-sections -lm -o tests/test_scene_composition_sanitized
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 tests/test_scene_composition_sanitized > tests/fixtures-O1-ASanUBSan.json
cat tests/fixtures-O2.json tests/fixtures-O1-ASanUBSan.json

for name in test_boundary_aa test_hidden_failure; do
 cc $base -O2 tests/$name.c product/main/ui/kasane/ksn_mesh_depth.c product/main/ayatsuri/compact_opaque.c physical/fox_disk_lighting.c -Wl,--gc-sections -lm -o tests/$name
 tests/$name > tests/$name.json
 cat tests/$name.json
done
python3 tests/verify_source.py
