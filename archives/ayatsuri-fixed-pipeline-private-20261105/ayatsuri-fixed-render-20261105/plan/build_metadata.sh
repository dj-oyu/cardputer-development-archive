#!/bin/sh
set -eu
cd /workspace/scratch/6d8dcdbcdc54
cc -std=c11 -O2 -g -ffp-contract=off -fexcess-precision=standard -Wall -Wextra -Werror -Wno-misleading-indentation -Wno-unused-function -fstack-usage -shared -fPIC -I fox-v3-indexed-bvh-bounds/private-build/visibility -I fox-v3-indexed-bvh-bounds/private-build/physical -I fox-v3-indexed-bvh-bounds/private-build/product/main ayatsuri-fixed-render-20261105/plan/metadata.c ayatsuri-fixed-render-20261105/plan/background_metadata.c fox-v3-indexed-bvh-bounds/private-build/visibility/visibility.c fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.c -lm -o ayatsuri-fixed-render-20261105/plan/metadata.so
