#!/bin/sh
set -eu
cd /workspace/scratch/6d8dcdbcdc54
cc -std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -Wall -Wextra -Werror -Wno-misleading-indentation -shared -fPIC -I fox-v3-indexed-bvh-bounds/private-build/product/main/ayatsuri -I fox-v3-indexed-bvh-bounds/private-build/product/main/ui/kasane -I ayatsuri-fixed-pipeline-20261105/kernel ayatsuri-fixed-pipeline-20261105/quality/replay/replay.c fox-v3-indexed-bvh-bounds/private-build/product/main/ayatsuri/compact_opaque.c -lm -o ayatsuri-fixed-pipeline-20261105/quality/replay/replay.so
