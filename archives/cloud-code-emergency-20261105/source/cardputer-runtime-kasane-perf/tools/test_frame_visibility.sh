#!/usr/bin/env bash
# Functional characterization only: no device, IO fault or allocation refusal.
set -euo pipefail
cd "$(dirname "$0")/.."
variant=${1:-o2}
out="$PWD/.cache/frame-visibility/$variant"
mkdir -p "$out"
case "$variant" in
  o2) flags='-O2 -g -fstrict-aliasing';;
  asan) flags='-O1 -g -fno-pie -no-pie -fsanitize=address,undefined -fno-sanitize-recover=undefined';;
  *) echo 'usage: test_frame_visibility.sh [o2|asan]' >&2; exit 2;;
esac
CACHE="$out/qjs" OUT="$out/test" CFLAGS="$flags" \
  TEST_SOURCE=tools/test_frame_visibility.c bash tools/build_kasane_test.sh
"$out/test"
