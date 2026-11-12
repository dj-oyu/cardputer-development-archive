#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
CC=${CC:-cc}
FLAGS='-std=c11 -O2 -Wall -Wextra -Werror'
$CC $FLAGS test_diagnostic.c visibility/visibility.c physical/fox_disk_lighting.c -lm -o build/test_diagnostic
./build/test_diagnostic
$CC -std=c11 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer test_diagnostic.c visibility/visibility.c physical/fox_disk_lighting.c -lm -o build/test_diagnostic_sanitize
ASAN_OPTIONS=detect_leaks=0 ./build/test_diagnostic_sanitize
for test in test_bounce test_ground; do
 $CC -std=c11 -O2 transport/$test.c transport/bounce.c visibility/visibility.c physical/fox_disk_lighting.c -lm -o build/$test
 ./build/$test
done
