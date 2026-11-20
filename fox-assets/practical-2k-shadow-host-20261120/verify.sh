#!/bin/sh
set -eu
test "$#" -eq 4 || { echo 'usage: verify.sh <firmware checkout> <pinned fox idle host delivery dir> <fox-host-v5.aynm> <new output dir>' >&2; exit 2; }
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
out="$4"
mkdir "$out"
sh "$2/verify.sh" "$1" "$3" "$out/original" >"$out/baseline.log"
python3 "$here/bake.py" "$3" "$out" >"$out/aynm-evidence.jsonl"
mkdir "$out/baseline"
mv "$out/original/left" "$out/baseline/-35"
mv "$out/original/right" "$out/baseline/35"
mv "$out/original/left.tsv" "$out/baseline/-35.tsv"
mv "$out/original/right.tsv" "$out/baseline/35.tsv"
for strength in weak strong; do
 for angle in -35 35; do
  mkdir -p "$out/$strength/$angle"
  ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
  "$out/original/host_smoke" "$out/$strength.aynm" "$angle" "$out/$strength/$angle" >"$out/$strength/$angle.tsv"
 done
done
python3 "$here/compare.py" "$out"
for k in baseline weak strong; do
 for a in -35 35; do printf '%s %s ' "$k" "$a"; grep '^peak' "$out/$k/$a.tsv"; done
done >"$out/host-budgets.txt"
