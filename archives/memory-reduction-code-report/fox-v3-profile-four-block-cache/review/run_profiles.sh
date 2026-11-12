#!/bin/bash
set -eu
cd /workspace/scratch/6d8dcdbcdc54
r=fox-v3-profile-four-block-cache/review
i=fox-v3-profile-four-block-cache/implementation
p=fox-v3-lossless-profile-lut/profile
flags='-O2 -fno-fast-math -ffp-contract=off'
gcc $flags -Dagx_profile_eval=old_eval -c fox-v3-profile-integration-feasibility/build-private/agx_profile.c -o $r/old.o
gcc $flags -DFAST_BITS=0 -c $i/block_cache.c -o $r/cache.o
gcc $flags -I$p/private -c $i/candidate_profile.c -o $r/profile.o
gcc $flags $r/profile_replay.c $r/old.o $r/cache.o $r/profile.o -lm -o $r/replay
$r/replay f32 $p/private/all_inputs.f32le > $r/profile.log
python - <<'PY'
import json,subprocess,hashlib
from pathlib import Path
r=Path('fox-v3-profile-four-block-cache/review')
m=json.load(open('fox-v3-lossless-profile-lut/profile/INPUTS.json'))
for p,h in m['pins'].items(): assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==h,p
with (r/'actual_f64.log').open('w') as out:
 for f in m['frames']: subprocess.run([str(r/'replay'),'f64',f['hdr'],f['expected565']],stdout=out,check=True)
print('All 87 pins and 40 retained f64 frames verified')
PY
cat $r/profile.log
