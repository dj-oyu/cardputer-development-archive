#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
O=../ayatsuri-fixed-integer-output-20261105
S=../fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot
I=../ayatsuri-fixed-integer-light-20261105/actual-input.bin
for opt in 0 2; do
 cc -O$opt -DRAW_NORMAL -std=c11 -ffp-contract=off -fexcess-precision=standard -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer -I$O/code -I$O/private code/chain.c code/chain_raw.c tests/test_chain.c $O/code/integer_output.c $O/code/block_cache.c $O/private/adapter.c -lm -o private/raw-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/raw-O$opt "$S" "$I" private/raw-pixels-O$opt.csv > private/raw-results-O$opt.txt
done
cmp private/raw-pixels-O0.csv private/raw-pixels-O2.csv
cmp private/raw-results-O0.txt private/raw-results-O2.txt
