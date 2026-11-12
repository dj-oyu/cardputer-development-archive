#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
O=../ayatsuri-fixed-integer-output-20261105
G=../ayatsuri-fixed-integer-geometry-20261105
for opt in 0 2; do
 cc -O$opt -std=c11 -DSUBPIX=10 -g -fsanitize=address,undefined -fno-omit-frame-pointer code/chain.c code/attributes.c tests/test_synthetic_geometry.c "$G/geometry.c" "$O/code/integer_output.c" "$O/code/block_cache.c" "$O/private/adapter.c" -o private/synthetic-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/synthetic-O$opt > private/synthetic-results-O$opt.txt
done
cmp private/synthetic-results-O0.txt private/synthetic-results-O2.txt
