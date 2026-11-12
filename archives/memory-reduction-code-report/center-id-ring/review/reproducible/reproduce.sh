#!/bin/sh
set -eu
cd /workspace/scratch/6d8dcdbcdc54
D=/tmp/center-id-ring-independent
R=fox-v3-center-id-ring
P=$R/private-build
python "$D/schedule_proof.py" > "$D/SCHEDULE_PROOF.json"
python "$D/source_review.py" > "$D/SOURCE_REVIEW.json"
cc -std=c11 -Wall -Wextra -Werror -I "$R/code" -I "$P/product/main" -I "$P/product/main/ui/kasane" -I "$P/physical" "$D/layout.c" -o "$D/layout"
"$D/layout" > "$D/LAYOUT.json"
for spec in 'test_ring_exact EXACT_ASAN' 'test_ring_negative NEGATIVE_ASAN'; do
 set -- $spec
 cc -std=c11 -O2 -g -ffp-contract=off -fexcess-precision=standard -fsanitize=address,undefined -fno-omit-frame-pointer -ffunction-sections -fdata-sections -I "$R/code" -I "$P/product/main" -I "$P/product/main/ui/kasane" -I "$P/physical" "$R/harness/$1.c" "$P/product/main/ui/kasane/ksn_mesh_depth.c" "$P/product/main/ayatsuri/compact_opaque.c" "$P/physical/fox_disk_lighting.c" -Wl,--gc-sections -lm -o "$D/$1-asan"
 ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 "$D/$1-asan" > "$D/$2.json"
done
