#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT=${1:-"$ROOT/test-results"}
mkdir -p "$OUT"
for OPT in 0 2; do
  FLAGS="-std=c11 -O$OPT -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -Wall -Wextra -Werror -Wno-misleading-indentation"
  cc $FLAGS -Dco_append=old_co_append -Dco_append_sided=old_co_append_sided -Dco_append_pixel=old_co_append_pixel -Dco_read=old_co_read -Dco_vertex_at=old_co_vertex_at -Dco_pixel_vertex_at=old_co_pixel_vertex_at -Dco_vertex_at_side=old_co_vertex_at_side -Dco_triangle_side=old_co_triangle_side -Dco_triangle_at=old_co_triangle_at -c "$ROOT/tests/legacy/compact_opaque.c" -o "$OUT/legacy-O$OPT.o"
  cc $FLAGS -I "$ROOT/product/main" -I "$ROOT/physical" "$ROOT/tests/test_normal_pair.c" "$OUT/legacy-O$OPT.o" "$ROOT/product/main/ayatsuri/compact_opaque.c" "$ROOT/product/main/ui/kasane/ksn_mesh_depth.c" "$ROOT/product/main/ui/kasane/ksn_procedural.c" "$ROOT/physical/fox_disk_lighting.c" -lm -o "$OUT/test-normal-pair-O$OPT"
  ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 "$OUT/test-normal-pair-O$OPT" > "$OUT/normal-pair-O$OPT.log" 2>&1
  cc $FLAGS -I "$ROOT/product/main" -I "$ROOT/physical" "$ROOT/tests/test_legacy_pixel_renderer.c" "$ROOT/product/main/ayatsuri/compact_opaque.c" "$ROOT/product/main/ui/kasane/ksn_mesh_depth.c" "$ROOT/product/main/ui/kasane/ksn_procedural.c" "$ROOT/physical/fox_disk_lighting.c" -lm -o "$OUT/test-legacy-pixel-O$OPT"
  ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 "$OUT/test-legacy-pixel-O$OPT" > "$OUT/legacy-pixel-O$OPT.log" 2>&1
  cc $FLAGS -I "$ROOT/product/main" -I "$ROOT/physical" -I "$ROOT/visibility" "$ROOT/tests/test_normal_pair_binding.c" "$ROOT/visibility/visibility.c" "$ROOT/visibility/pixel_binding.c" "$ROOT/product/main/ayatsuri/compact_opaque.c" "$ROOT/product/main/ui/kasane/ksn_mesh_depth.c" "$ROOT/product/main/ui/kasane/ksn_procedural.c" "$ROOT/physical/fox_disk_lighting.c" -lm -o "$OUT/test-normal-pair-binding-O$OPT"
  ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 "$OUT/test-normal-pair-binding-O$OPT" > "$OUT/normal-pair-binding-O$OPT.log" 2>&1
done
cat "$OUT"/*.log
