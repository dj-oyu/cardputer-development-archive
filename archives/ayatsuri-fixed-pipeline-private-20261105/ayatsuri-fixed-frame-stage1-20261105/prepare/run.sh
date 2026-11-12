#!/bin/sh
set -eu
cd "$(dirname "$0")"
[ "$#" = 1 ] || { echo 'usage: ./run.sh NEW_OUTPUT.json' >&2; exit 2; }
cc -std=c11 -O2 -ffp-contract=off -fno-fast-math -fexcess-precision=standard -fPIC -shared reference_init.c -lm -o reference_init.so
PYTHONDONTWRITEBYTECODE=1 python3 test_prepare.py
PYTHONDONTWRITEBYTECODE=1 python3 prepare.py "$1"
