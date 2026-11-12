#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
cc -std=gnu11 -O2 -g -fno-fast-math -fno-associative-math -fno-reciprocal-math -ffp-contract=off -frounding-math -fno-lto -UNDEBUG -Imain -Imain/ui/kasane main/ui/kasane/ksn_mesh_q7_certified.c main/ui/kasane/ksn_mesh_prepared.c main/ui/kasane/ksn_mesh_depth.c main/ui/kasane/ksn_shiki_frame.c main/ayatsuri/compact_opaque.c tools/kasane_contract/q7/flat_span_oracle.c tools/qemu_q7/generated/*.c -lm -o tools/qemu_q7/host-profile
tools/qemu_q7/host-profile > tools/qemu_q7/host.log
