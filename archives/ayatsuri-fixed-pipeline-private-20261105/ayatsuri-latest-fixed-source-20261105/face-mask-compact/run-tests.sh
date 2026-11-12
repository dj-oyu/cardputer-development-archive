#!/bin/sh
set -eu
cd "$(dirname "$0")"
python prepare.py > prepare.log
cc --version > compiler.txt
for opt in 0 2; do
 cc -std=c11 -O$opt -g -Wall -Wextra -Wconversion -Werror -fsanitize=address,undefined -fno-omit-frame-pointer -c sampler.c -o sampler-sanitized-O$opt.o
 cc -std=c11 -O$opt -g -Wall -Wextra -Wconversion -Werror -fsanitize=address,undefined -fno-omit-frame-pointer test.c sampler-sanitized-O$opt.o -o test-O$opt
 ASAN_OPTIONS=detect_leaks=0 ./test-O$opt > test-O$opt.log 2>&1
 cat test-O$opt.log
 cc -std=c11 -O$opt -Wall -Wextra -Wconversion -Werror -fstack-usage -c sampler.c -o sampler-host-O$opt.o
 nm -S --size-sort sampler-host-O$opt.o > symbols-O$opt.txt
 nm -u sampler-host-O$opt.o > undefined-O$opt.txt
 size -A sampler-host-O$opt.o > sections-O$opt.txt
done
python inspect-objects.py
