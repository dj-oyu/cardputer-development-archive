#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT=${1:?Choose a fresh synthetic output directory}
mkdir "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
cd "$ROOT/product"
node tools/ayatsuri/asset/test_import.cjs > "$OUT/import.log"
node tools/ayatsuri/asset/compact_opaque/test_batch.cjs > "$OUT/batch.log"
node tools/ayatsuri/model/test_sidedness.cjs > "$OUT/sided-js.log"
node tools/ayatsuri/model/sided_fixtures.cjs
cc -std=c11 -O2 -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -I main -I "$ROOT/physical" tools/ayatsuri/model/test_sidedness.c "$ROOT/physical/fox_disk_lighting.c" main/ayatsuri/ayatsuri_model.c main/ayatsuri/ayatsuri_visibility.c main/ayatsuri/compact_opaque.c main/ui/kasane/ksn_mesh_depth.c main/ui/kasane/ksn_procedural.c -lm -o "$OUT/test-sided"
ASAN_OPTIONS=detect_leaks=0 "$OUT/test-sided" > "$OUT/sided-asan.log"
