#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
D=capture
for opt in o2 sanitized; do
 flags='-O2'
 if [ "$opt" = sanitized ]; then flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer'; fi
 common="-std=c11 $flags -Wall -Wextra -Werror -ffp-contract=off -fexcess-precision=standard"
 cc $common tests/test_floor_world.c "$D/visibility/visibility.c" "$D/physical/fox_disk_lighting.c" -lm -o tests/floor-world-$opt
 ASAN_OPTIONS=detect_leaks=0 tests/floor-world-$opt
 cc $common -ffunction-sections -fdata-sections -I"$D/product/main" -I"$D/physical" "$D/floor-tests/test_pixel_floor.c" "$D/transport/bounce.c" "$D/visibility/visibility.c" "$D/physical/fox_disk_lighting.c" -Wl,--gc-sections -lm -o tests/pixel-floor-$opt
 ASAN_OPTIONS=detect_leaks=0 tests/pixel-floor-$opt
 for n in test_nearest test_visibility test_bruteforce; do
  extra="$D/visibility/visibility.c"; if [ "$n" = test_visibility ]; then extra=""; fi
  cc $common "$D/visibility/$n.c" $extra -lm -o tests/$n-$opt
  ASAN_OPTIONS=detect_leaks=0 tests/$n-$opt
 done
done
for n in test_bounce test_quadrature test_ground test_ground_quadrature; do
 cc -std=c11 -O2 -Wall -Wextra -Werror -Wno-missing-field-initializers "$D/transport/$n.c" "$D/transport/bounce.c" "$D/visibility/visibility.c" "$D/physical/fox_disk_lighting.c" -lm -o tests/$n
 tests/$n
done
