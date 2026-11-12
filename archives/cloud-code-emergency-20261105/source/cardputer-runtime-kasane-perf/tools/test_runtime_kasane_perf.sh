#!/usr/bin/env bash
# Focused performance regressions. No device, OOM sweep or allocation refusal.
set -euo pipefail
cd "$(dirname "$0")/.."
variant=${1:-o2}
case "$variant" in
  o2) flags='-O2 -g -fstrict-aliasing'; grid_args=();;
  asan) flags='-O1 -g -fno-pie -no-pie -fsanitize=address,undefined -fno-sanitize-recover=undefined';
        grid_args=(--sanitize);;
  *) echo 'usage: test_runtime_kasane_perf.sh [o2|asan]' >&2; exit 2;;
esac
out="$PWD/.cache/runtime-kasane-perf/$variant"
mkdir -p "$out"
python3 tools/test_session_dispatch.py
for name in kasane_schema_set kasane_imucal; do
  CFLAGS="$flags -DKSN_SCHEMA_DIRTY_COUNT" CACHE="$out/qjs" \
    OUT="$out/$name" TEST_SOURCE="tools/test_$name.c" \
    bash tools/build_kasane_test.sh
  "$out/$name"
done
python3 tools/kasane_contract/run_pocket_grid_qjs.py "${grid_args[@]}"
bash tools/test_frame_visibility.sh "$variant"
node --check apps/imucal/imucal.js
git diff --check
echo "RUNTIME_KASANE_PERF $variant PASS (host only; direct-entry hazard remains gated)"
