#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
for opt in 0 2; do
 gcc -std=c11 -O"$opt" -ffp-contract=off -fexcess-precision=standard -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer test_integer_light.c -lm -o "test-O$opt"
 ASAN_OPTIONS=detect_leaks=0 ./"test-O$opt" > "results-O$opt.txt"
done
cmp results-O0.txt results-O2.txt
cat results-O2.txt
