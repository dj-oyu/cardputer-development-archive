#!/usr/bin/env bash
set -euo pipefail
R=$(cd "$(dirname "$0")/.." && pwd)
D=${1:?Pass a fresh output directory}; mkdir "$D"
for opt in O0 O2; do
 FLAGS=(-std=c11 -"$opt" -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fsanitize=address,undefined -fno-omit-frame-pointer)
 for test in test_bounce test_quadrature; do
  cc "${FLAGS[@]}" -I "$R/physical" -I "$R/visibility" -I "$R/transport" "$R/transport/$test.c" "$R/transport/bounce.c" "$R/visibility/visibility.c" "$R/physical/fox_disk_lighting.c" -lm -o "$D/$test-$opt"
  ASAN_OPTIONS=detect_leaks=0 "$D/$test-$opt" > "$D/$test-$opt.log"
 done
 cc "${FLAGS[@]}" -I "$R/visibility" "$R/visibility/test_nearest.c" "$R/visibility/visibility.c" -lm -o "$D/nearest-$opt"
 ASAN_OPTIONS=detect_leaks=0 "$D/nearest-$opt" > "$D/nearest-$opt.log"
 cc "${FLAGS[@]}" -I "$R/product/main" -I "$R/physical" -I "$R/visibility" -I "$R/transport" "$R/code/test_pixel_transport.c" "$R/transport/pixel_transport.c" "$R/transport/bounce.c" "$R/visibility/visibility.c" "$R/visibility/pixel_binding.c" "$R/physical/fox_disk_lighting.c" "$R/product/main/ui/kasane/ksn_mesh_depth.c" "$R/product/main/ui/kasane/ksn_procedural.c" "$R/product/main/ayatsuri/compact_opaque.c" -lm -o "$D/pixel-$opt"
 ASAN_OPTIONS=detect_leaks=0 "$D/pixel-$opt" > "$D/pixel-$opt.log"
done
