#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
DEPS="$ROOT/deps"
OUT=${1:-"$ROOT/root-pose"}
CC=${CC:-cc}
EXTRA=()
if [[ ${HONE_SANITIZE:-0} == 1 ]]; then EXTRA=(-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer); else EXTRA=(-O2); fi
"$CC" -std=c11 "${EXTRA[@]}" -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fexcess-precision=standard \
 -I "$DEPS/product/main" -I "$DEPS/physical" -I "$DEPS/visibility" -I "$DEPS/transport" -I "$DEPS/code" \
 "$ROOT/code/root_pose.c" "$DEPS/transport/bounce.c" "$DEPS/transport/pixel_transport.c" \
 "$DEPS/visibility/visibility.c" "$DEPS/visibility/pixel_binding.c" "$DEPS/physical/fox_disk_lighting.c" \
 "$DEPS/product/main/ayatsuri/ayatsuri_model.c" "$DEPS/product/main/ayatsuri/ayatsuri_visibility.c" \
 "$DEPS/product/main/ayatsuri/compact_opaque.c" "$DEPS/product/main/ui/kasane/ksn_mesh_depth.c" \
 "$DEPS/product/main/ui/kasane/ksn_procedural.c" -lm -o "$OUT"
