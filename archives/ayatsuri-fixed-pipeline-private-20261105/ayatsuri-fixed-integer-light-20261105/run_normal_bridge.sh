#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
for opt in 0 2; do
 gcc -std=c11 -O"$opt" -ffp-contract=off -fexcess-precision=standard -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer test_normal_bridge.c -lm -o "normal-O$opt"
 ASAN_OPTIONS=detect_leaks=0 ./"normal-O$opt" actual-input.bin > "normal-results-O$opt.txt"
done
cmp normal-results-O0.txt normal-results-O2.txt
cat normal-results-O2.txt
