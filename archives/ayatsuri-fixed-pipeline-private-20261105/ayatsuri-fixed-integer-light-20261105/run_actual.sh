#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
python3 prepare_actual.py > actual-preparation.txt
for opt in 0 2; do
 gcc -std=c11 -O"$opt" -ffp-contract=off -fexcess-precision=standard -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer test_actual.c -lm -o "actual-O$opt"
 ASAN_OPTIONS=detect_leaks=0 ./"actual-O$opt" ../fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot actual-input.bin > "actual-results-O$opt.txt"
done
cmp actual-results-O0.txt actual-results-O2.txt
cat actual-results-O2.txt
