#!/bin/sh
set -eu
test "$#" -eq 5 || { echo 'usage: verify.sh <firmware checkout> <idle host delivery> <cheek/chest shadow delivery> <original fox-host-v5.aynm> <new output directory>' >&2; exit 2; }
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
out="$5"
mkdir "$out"
sh "$3/verify.sh" "$1" "$2" "$4" "$out/prior" >"$out/prior.log"
python3 "$here/bake.py" "$out/prior/weak.aynm" "$out" --diagnostic-isolates >"$out/aynm-evidence.jsonl"
for k in tail-forehead tail forehead; do
 for a in -35 35; do
  mkdir -p "$out/$k/$a"
  ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
    "$out/prior/original/host_smoke" "$out/$k.aynm" "$a" "$out/$k/$a" >"$out/$k/$a.tsv" 2>"$out/$k/$a.log"
 done
done
python3 "$here/compare.py" "$out" "$out/prior/weak"
for k in prior/weak tail-forehead tail forehead; do
 for a in -35 35; do printf '%s %s ' "$k" "$a"; grep '^peak' "$out/$k/$a.tsv"; done
done >"$out/host-budgets.txt"
