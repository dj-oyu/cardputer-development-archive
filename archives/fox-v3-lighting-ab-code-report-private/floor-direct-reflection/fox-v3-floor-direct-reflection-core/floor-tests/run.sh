#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
for opt in o2 asan; do
 flags='-O2'
 if [ "$opt" = asan ]; then flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer'; fi
 cc -std=c11 $flags -Wall -Wextra -Werror floor-tests/test_floor.c visibility/visibility.c physical/fox_disk_lighting.c -lm -o floor-tests/floor-$opt
 ASAN_OPTIONS=detect_leaks=0 floor-tests/floor-$opt
 cc -std=c11 $flags -Wall -Wextra -Werror -ffunction-sections -fdata-sections -Iproduct/main -Iphysical floor-tests/test_pixel_floor.c transport/bounce.c visibility/visibility.c physical/fox_disk_lighting.c -Wl,--gc-sections -lm -o floor-tests/pixel-floor-$opt
 ASAN_OPTIONS=detect_leaks=0 floor-tests/pixel-floor-$opt
done
for name in test_bounce test_quadrature test_ground test_ground_quadrature; do
 cc -std=c11 -O2 -Wall -Wextra -Werror -Wno-missing-field-initializers transport/$name.c transport/bounce.c visibility/visibility.c physical/fox_disk_lighting.c -lm -o floor-tests/$name
 floor-tests/$name
done
for name in bounce pixel_transport; do
 cc -std=c11 -O2 -Wall -Wextra -Werror -fstack-usage -Iproduct/main -Iphysical -c transport/$name.c -o floor-tests/$name.o
done
