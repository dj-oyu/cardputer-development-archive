#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
for label in original candidate; do
 D=capture
 if [ "$label" = original ]; then D=../fox-v3-floor-display-combination/capture-001; fi
 P="$(realpath "$D/transport/pixel_transport.c")"
 cc -std=c11 -O2 -Wall -Wextra -Werror -Wno-misleading-indentation -ffunction-sections -fdata-sections -ffp-contract=off -fexcess-precision=standard -DFOX_FLOOR_WORLD_CAPTURE=1 -DPIXEL_SOURCE=\"$P\" -I"$D/product/main" -I"$D/physical" tests/test_off_parity.c "$D/transport/bounce.c" "$D/visibility/visibility.c" "$D/visibility/pixel_binding.c" "$D/physical/fox_disk_lighting.c" "$D/product/main/ui/kasane/ksn_mesh_depth.c" "$D/product/main/ayatsuri/compact_opaque.c" -Wl,--gc-sections -lm -o tests/parity-$label
 tests/parity-$label tests/parity-$label.bin
done
cmp tests/parity-original.bin tests/parity-candidate.bin
sha256sum tests/parity-*.bin

D=capture;P="$(realpath "$D/transport/pixel_transport.c")"
for flags in '-O2' '-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer'; do
 cc -std=c11 $flags -Wall -Wextra -Werror -Wno-misleading-indentation -ffunction-sections -fdata-sections -ffp-contract=off -fexcess-precision=standard -DTEST_WORLD_ON=1 -DFOX_FLOOR_WORLD_CAPTURE=1 -DPIXEL_SOURCE=\"$P\" -I"$D/product/main" -I"$D/physical" tests/test_off_parity.c "$D/transport/bounce.c" "$D/visibility/visibility.c" "$D/visibility/pixel_binding.c" "$D/physical/fox_disk_lighting.c" "$D/product/main/ui/kasane/ksn_mesh_depth.c" "$D/product/main/ayatsuri/compact_opaque.c" -Wl,--gc-sections -lm -o tests/parity-world-on
 ASAN_OPTIONS=detect_leaks=0 tests/parity-world-on tests/parity-world-on.bin
done
