#!/bin/sh
set -eu
cd "$(dirname "$0")"
for q in 8 10; do
 cc -std=c11 -O2 -Wall -Wextra -Werror -DSUBPIX=$q -fPIC -shared geometry.c -o geometry$q.so
 cc -std=c11 -O1 -g -Wall -Wextra -Werror -fsanitize=undefined -fno-sanitize-recover=all -DSUBPIX=$q -fPIC -shared geometry.c -o geometry$q-ubsan.so
done
PYTHONDONTWRITEBYTECODE=1 python3 evaluate.py > results.stdout.json
PYTHONDONTWRITEBYTECODE=1 python3 - <<'PY' > sanitizer-results.json
import ctypes,json,evaluate
original=evaluate.lib
# Preserve signatures from the regular ABI, then load separately instrumented libraries.
def checked(q):
 base=original(q);l=ctypes.CDLL(str(evaluate.HERE/f'geometry{q}-ubsan.so'))
 for name in ('project','project_batch','sample','sample_batch'):
  getattr(l,name).argtypes=getattr(base,name).argtypes
 return l
evaluate.lib=checked
print(json.dumps({q:evaluate.synthetic(q) for q in (8,10)},indent=2))
PY
