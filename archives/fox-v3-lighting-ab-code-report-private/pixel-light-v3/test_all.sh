#!/bin/bash
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
OUT=${1:?fresh output directory}
mkdir "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
cd "$ROOT"
CFLAGS='-O2' sh tests-codec/run.sh > "$OUT/codec.log"
CFLAGS='-O2 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ASAN_OPTIONS=detect_leaks=0 sh tests-codec/run.sh > "$OUT/codec-asan.log"
(cd product && node tools/ayatsuri/model/sided_fixtures.cjs)
for opt in 0 2; do
 flags="-std=c11 -O$opt -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -fexcess-precision=standard"
 cc $flags -I product/main -I physical code/test_pixel_renderer.c product/main/ui/kasane/ksn_mesh_depth.c product/main/ui/kasane/ksn_procedural.c product/main/ayatsuri/compact_opaque.c physical/fox_disk_lighting.c -lm -o "$OUT/render-O$opt"
 ASAN_OPTIONS=detect_leaks=0 "$OUT/render-O$opt" > "$OUT/render-O$opt.log"
 cc $flags -I product/main -I physical code/test_pixel_model_view.c product/main/ayatsuri/ayatsuri_model.c product/main/ayatsuri/ayatsuri_visibility.c product/main/ayatsuri/compact_opaque.c product/main/ui/kasane/ksn_mesh_depth.c product/main/ui/kasane/ksn_procedural.c physical/fox_disk_lighting.c -lm -o "$OUT/model-O$opt"
 ASAN_OPTIONS=detect_leaks=0 "$OUT/model-O$opt" product/.cache/ayatsuri-native/sided-{angled,sorted,legacy64,sided64,backfirst,single32,sided32}.aynm > "$OUT/model-O$opt.log"
done
python -m unittest discover -s scoring -p test_score_candidate.py > "$OUT/scorer.log" 2>&1
