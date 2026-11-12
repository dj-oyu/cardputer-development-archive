#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
for opt in 0 2; do
  gcc -std=c11 -Wall -Wextra -Werror -Wno-misleading-indentation -O"$opt" -g -fsanitize=address,undefined -fno-omit-frame-pointer test_kernel.c -lm -o "test-O$opt"
  ASAN_OPTIONS=detect_leaks=0 ./"test-O$opt" 2>&1 | tee "results-O$opt.txt"
done
cmp results-O0.txt results-O2.txt
