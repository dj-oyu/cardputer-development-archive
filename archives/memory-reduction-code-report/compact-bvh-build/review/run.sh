#!/bin/sh
set -eu
cd /workspace/scratch/6d8dcdbcdc54
R=fox-v3-compact-bvh-build-review
for opt in O0 O2; do
 for side in old new; do
  src=fox-v3-center-id-ring
  [ "$side" = old ] || src=fox-v3-compact-bvh-build
  cc -std=c11 -$opt -g -ffp-contract=off -fstack-usage -DSOURCE=\"../$src/private-build/visibility/visibility.c\" $R/compare.c -lm -o $R/$side-$opt
  $R/$side-$opt > $R/$side-$opt.bin
 done
 cmp $R/old-$opt.bin $R/new-$opt.bin
 sha256sum $R/old-$opt.bin $R/new-$opt.bin
 done
for side in old new; do
 src=fox-v3-center-id-ring
 [ "$side" = old ] || src=fox-v3-compact-bvh-build
 cc -std=c11 -O2 -g -ffp-contract=off -fsanitize=address,undefined -fno-omit-frame-pointer -DSOURCE=\"../$src/private-build/visibility/visibility.c\" $R/compare.c -lm -o $R/$side-san
 ASAN_OPTIONS=detect_leaks=0 $R/$side-san > $R/$side-san.bin
 done
cmp $R/old-san.bin $R/new-san.bin
sha256sum $R/old-san.bin $R/new-san.bin
