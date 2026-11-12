#!/bin/sh
set -eu
cd "$(dirname "$0")"
python prepare.py > prepare.log
for opt in 0 2; do
 cc -std=c11 -O$opt -g -Wall -Wextra -Wconversion -Werror -fsanitize=address,undefined -fno-omit-frame-pointer sampler.c test.c -o test-O$opt
 ASAN_OPTIONS=detect_leaks=0 ./test-O$opt > test-O$opt.log 2>&1
 cat test-O$opt.log
done
