#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
{
  date -u +'%Y-%m-%dT%H:%M:%SZ'
  uname -a
  gcc --version | head -1
  echo 'Strict floating-point: no-fast-math default is explicitly enforced with -fno-fast-math; contraction off; standard excess precision.'
  echo 'gcc -std=c11 -O2 -fno-tree-vectorize -fno-tree-slp-vectorize -fno-lto -ffp-contract=off -fexcess-precision=standard -fno-fast-math bench_kernel.c -lm -o bench-kernel'
} > benchmark-binding.txt
gcc -std=c11 -O2 -fno-tree-vectorize -fno-tree-slp-vectorize -fno-lto -ffp-contract=off -fexcess-precision=standard -fno-fast-math bench_kernel.c -lm -o bench-kernel
sha256sum bench_kernel.c fixed_kernel.h reference.h run_benchmark.sh bench-kernel >> benchmark-binding.txt
./bench-kernel > benchmark-samples.csv 2> benchmark-preflight.txt
python3 - <<'PY' | tee benchmark-summary.txt
import csv,statistics
rows=list(csv.DictReader(open('benchmark-samples.csv')))
print('width double_ns fixed_prepared_ns fixed_mixed_ns prepared_speedup mixed_speedup')
for width in (1,2,4,8):
 d={name:statistics.median(float(r['ns_per_pixel']) for r in rows if int(r['width'])==width and r['variant']==name) for name in ('double','fixed_prepared','fixed_mixed')}
 print(width,*(f'{d[n]:.3f}' for n in d),f"{d['double']/d['fixed_prepared']:.3f}",f"{d['double']/d['fixed_mixed']:.3f}")
PY
