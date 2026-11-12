#!/bin/sh
set -eu
cd "$(dirname "$0")"
CC=${CC:-cc}
FLAGS='-std=c11 -O2 -Wall -Wextra -Wpedantic -Werror'
$CC $FLAGS -fPIC -shared fox_disk_lighting.c -lm -o libfox_disk_lighting.so
$CC $FLAGS fox_disk_lighting.c test_disk_lighting.c -lm -o test_disk_lighting
./test_disk_lighting > synthetic-report.json
cat synthetic-report.json
python3 test_convergence.py > convergence-summary.txt
cat convergence-summary.txt
$CC $FLAGS -fstack-usage -c fox_disk_lighting.c -o fox_disk_lighting.o
size fox_disk_lighting.o > object-size.txt
