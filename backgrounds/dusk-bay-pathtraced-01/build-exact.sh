#!/bin/sh
set -eu
cd "$(dirname "$0")"
PIN=fea78dce956a75d027b6fb24f3d89bd345e74f1c
if [ "$#" -gt 1 ]; then echo "usage: $0 [<firmware git checkout or bare repo>]" >&2; exit 2; fi
if [ "$#" -eq 1 ]; then
  VERIFY_TEMP=$(mktemp -d)
  trap 'rm -rf "$VERIFY_TEMP"' EXIT
  git -C "$1" archive -o "$VERIFY_TEMP/source.tar" "$PIN" main/ayatsuri main/ui/kasane
  tar -xf "$VERIFY_TEMP/source.tar" -C "$VERIFY_TEMP"
  M="$VERIFY_TEMP/main"
  EXTRA="$M"
else
  # Current workspace only: materialized from the GitHub-file connector at PIN.
  M=pr135-full/main
  EXTRA=pr135
fi
cc -std=c11 -O2 -g -Wall -Wextra -Werror -ffp-contract=off -fsanitize=address,undefined \
  -fno-omit-frame-pointer -fno-pie -no-pie -I"$EXTRA" -I"$M" render.c \
  "$M/ayatsuri/ayatsuri_model.c" "$M/ayatsuri/ayatsuri_visibility.c" "$M/ayatsuri/compact_opaque.c" \
  "$M/ui/kasane/ksn_shiki_frame.c" "$M/ui/kasane/ksn_mesh_depth.c" -lm -o render-exact
