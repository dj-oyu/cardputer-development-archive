#!/bin/sh
set -eu
cd "$(dirname "$0")"
flags='-std=c11 -O2 -g -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fexcess-precision=standard'
cc $flags test_independent.c ../private-build/visibility/visibility.c ../private-build/physical/fox_disk_lighting.c -lm -o independent
./independent
cc $flags -fsanitize=address,undefined -fno-omit-frame-pointer test_independent.c ../private-build/visibility/visibility.c ../private-build/physical/fox_disk_lighting.c -lm -o independent-san
ASAN_OPTIONS=detect_leaks=0 ./independent-san
