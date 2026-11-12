#!/bin/sh
set -eu
cd "$(dirname "$0")/../../"
root=fox-v3-lossless-profile-fast-access
build="$root/tests/build"
mkdir -p "$build"
flags='-std=c11 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer'
cc $flags -Dlossless_decode_channel=old_decode_channel -Dlossless_fetch=old_fetch -c fox-v3-lossless-profile-lut/research/block_decoder.c -o "$build/old.o"
for mode in 0 1; do
 cc $flags -DFAST_BITS=$mode "$root/implementation/block_decoder.c" "$root/tests/synthetic.c" "$build/old.o" -o "$build/synthetic-$mode"
 ASAN_OPTIONS=detect_leaks=0 "$build/synthetic-$mode"
done
