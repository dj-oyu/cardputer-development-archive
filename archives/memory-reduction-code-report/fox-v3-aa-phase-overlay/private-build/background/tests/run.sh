#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
CFLAGS='-std=c11 -ffp-contract=off -Wall -Wextra -Werror -Wno-misleading-indentation -I../product/main -I../physical'
gcc $CFLAGS -O2 tests/test_background.c ../physical/fox_disk_lighting.c ../visibility/visibility.c -lm -o tests/test-o2
./tests/test-o2
gcc $CFLAGS -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer tests/test_background.c ../physical/fox_disk_lighting.c ../visibility/visibility.c -lm -o tests/test-asan
ASAN_OPTIONS=detect_leaks=0 ./tests/test-asan
mkdir -p tests/stack
gcc $CFLAGS -O2 -fstack-usage -c background.c -o tests/stack/background.o
gcc $CFLAGS -O2 -fstack-usage -c ../physical/fox_disk_lighting.c -o tests/stack/physical.o
gcc $CFLAGS -O2 -fstack-usage -c ../visibility/visibility.c -o tests/stack/visibility.o
