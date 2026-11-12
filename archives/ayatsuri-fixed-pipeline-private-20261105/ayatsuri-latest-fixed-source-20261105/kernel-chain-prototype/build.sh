#!/bin/sh
set -eu
cd "$(dirname "$0")"
AA=../../ayatsuri-fixed-frame-stage1-20261105/aa/code
OUT=../../ayatsuri-fixed-integer-output-20261105
SOURCES="chain.c reference.c ../material-c-compact/material.c ../control-prototype/control.c $AA/integer_aa.c $AA/profile_adapter.c $OUT/code/integer_output.c $OUT/code/block_cache.c $OUT/private/adapter.c"
for B in 16 20 24; do
 cc -std=c11 -O2 -DMBITS=$B -shared -fPIC $SOURCES -o chain-q$B.so
 cc -std=c11 -O2 -DMBITS=$B -fstack-usage -c chain.c -o chain-q$B.o
 size -A chain-q$B.o > size-q$B.txt
 objdump -d chain-q$B.o > disassembly-q$B.txt
 for O in 0 2; do
  cc -std=c11 -O$O -DMBITS=$B -fsanitize=address,undefined -fno-sanitize-recover=all test_native.c $SOURCES -o test-q$B-o$O
  ASAN_OPTIONS=detect_leaks=0 ./test-q$B-o$O > test-q$B-o$O.log 2>&1
 done
done
