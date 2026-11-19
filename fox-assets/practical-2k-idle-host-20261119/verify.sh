#!/bin/sh
# Rebuild against the actual supported runtime; no generated images or binaries are checked in.
set -eu
test "$#" -eq 3 || { printf '%s\n' 'usage: verify.sh <firmware checkout> <fox-host-v5.aynm> <new output dir>' >&2; exit 2; }
RUNTIME=5a3dedcba86f46bf74567fc07c42a85e7bb3e25f
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WORK=$3
MODEL=$2
printf '%s  %s\n' 616033c06602ae3fe7ee8c14536ffba7654aa57bab257c67c19b25c63a584225 "$MODEL" | sha256sum --check
mkdir "$WORK"
mkdir "$WORK/runtime" "$WORK/right" "$WORK/left"
git -C "$1" archive "$RUNTIME" main/ayatsuri main/ui/kasane | tar xf - -C "$WORK/runtime"
M="$WORK/runtime/main"
srcs="$M/ayatsuri"
# Sanitizers enabled by default; only LSan is disabled (available hosts may forbid ptrace).
${CC:-cc} -std=c11 -O2 -g -Wall -Wextra -Werror -ffp-contract=off \
 -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie -no-pie \
 -I"$HERE" -I"$M" "$HERE/fox_idle.c" "$HERE/host_smoke.c" \
 "$srcs/ayatsuri_model.c" "$srcs/ayatsuri_visibility.c" "$srcs/compact_opaque.c" \
 "$M/ui/kasane/ksn_mesh_depth.c" "$M/ui/kasane/ksn_shiki_frame.c" -lm -o "$WORK/host_smoke"
for direction in right left; do
 case "$direction" in right) yaw=35;; left) yaw=-35;; esac
 ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
 "$WORK/host_smoke" "$MODEL" "$yaw" "$WORK/$direction" >"$WORK/$direction.tsv"
 cat "$WORK/$direction.tsv"
done
