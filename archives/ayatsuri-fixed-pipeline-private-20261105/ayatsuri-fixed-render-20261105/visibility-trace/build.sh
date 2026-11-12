#!/bin/sh
set -eu
cd /workspace/scratch/6d8dcdbcdc54
D=ayatsuri-fixed-render-20261105/visibility-trace
[ ! -e "$D/trace.so" ]
cc -std=c11 -O2 -g -Wall -Wextra -Werror -Wno-misleading-indentation -fPIC -shared -ffp-contract=off -fexcess-precision=standard -fstack-usage -Ifox-v3-indexed-bvh-bounds/private-build/visibility "$D/trace.c" fox-v3-indexed-bvh-bounds/private-build/visibility/visibility.c -lm -o "$D/trace.so"
