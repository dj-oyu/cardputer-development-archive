#!/bin/sh
set -eu
R=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
W=$(dirname "$(dirname "$R")")
B="$R/build-sanitize"; mkdir -p "$B"; cd "$B"
FLAGS="-std=c11 -O2 -fno-fast-math -ffp-contract=off -fsanitize=address,undefined -fno-omit-frame-pointer -g"
cc $FLAGS -Dagx_profile_eval=old_profile_eval -c "$W/fox-v3-profile-integration-feasibility/build-private/agx_profile.c" -o old.o
cc $FLAGS -I"$R" -I"$R/private" -c "$R/candidate_profile.c" -o new.o
cc $FLAGS -c "$R/../research/block_decoder.c" -o decoder.o
cc $FLAGS "$R/sanitize_main.c" old.o new.o decoder.o -lm -o compare
# LeakSanitizer cannot run under the managed ptrace environment; ASan/UBSan remain active.
ASAN_OPTIONS=${ASAN_OPTIONS:-detect_leaks=0:halt_on_error=1} UBSAN_OPTIONS=${UBSAN_OPTIONS:-halt_on_error=1} ./compare "$R/private/all_inputs.f32le"
