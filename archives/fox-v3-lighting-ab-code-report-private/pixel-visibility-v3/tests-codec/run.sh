#!/bin/sh
set -eu
cd "$(dirname "$0")"
bin=$(mktemp /tmp/fox-codec.XXXXXX)
trap 'rm -f "$bin"' EXIT HUP INT TERM
${CC:-cc} -std=c11 -Wall -Wextra -Werror -pedantic ${CFLAGS:-} -I../product/main/ayatsuri test_codec.c ../product/main/ayatsuri/compact_opaque.c -lm -o "$bin"
"$bin"
