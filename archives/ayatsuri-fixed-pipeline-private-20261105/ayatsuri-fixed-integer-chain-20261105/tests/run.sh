#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
O=../ayatsuri-fixed-integer-output-20261105
S=../fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot
I=../ayatsuri-fixed-integer-light-20261105/actual-input.bin
for opt in 0 2; do
 cc -O$opt -std=c11 -ffp-contract=off -fexcess-precision=standard -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer -I$O/code -I$O/private code/chain.c tests/test_chain.c $O/code/integer_output.c $O/code/block_cache.c $O/private/adapter.c -lm -o private/test-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/test-O$opt "$S" "$I" private/pixels-O$opt.csv > private/results-O$opt.txt
done
cmp private/pixels-O0.csv private/pixels-O2.csv
cmp private/results-O0.txt private/results-O2.txt
cc -O2 -std=c11 -c code/chain.c -o private/chain.o
nm -u private/chain.o > private/chain-undefined.txt
