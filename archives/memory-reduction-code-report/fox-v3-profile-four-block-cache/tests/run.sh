#!/bin/sh
set -eu
cd "$(dirname "$0")/../.."
D=fox-v3-profile-four-block-cache
FLAGS="-std=c11 -Wall -Wextra -Werror -fno-fast-math -ffp-contract=off -DFAST_BITS=0 -I$D/implementation -Ifox-v3-lossless-profile-lut/profile/private"
cc $FLAGS -O2 -fstack-usage "$D/tests/test_contract.c" "$D/implementation/block_cache.c" "$D/implementation/candidate_profile.c" -lm -o "$D/tests/test_contract"
"$D/tests/test_contract"
cc $FLAGS -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer "$D/tests/test_contract.c" "$D/implementation/block_cache.c" "$D/implementation/candidate_profile.c" -lm -o "$D/tests/test_contract_san"
ASAN_OPTIONS=detect_leaks=0 "$D/tests/test_contract_san"
