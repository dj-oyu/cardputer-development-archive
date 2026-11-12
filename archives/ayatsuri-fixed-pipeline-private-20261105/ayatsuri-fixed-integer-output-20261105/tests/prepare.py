from pathlib import Path
import math,re,json,hashlib
R=Path(__file__).resolve().parents[1]; W=R.parent
src=W/'fox-v3-lossless-profile-lut/profile/private/profile_data.h'
s=src.read_text(); const={k:float(re.search(r'#define '+k+r' ([^\n]+)',s)[1]) for k in ['AGX_LO','AGX_HI','AGX_LOG_RANGE']}
lo,hi,lr=[const[k] for k in ['AGX_LO','AGX_HI','AGX_LOG_RANGE']]
def f(code):return round(math.log1p(code/524288/lo)/lr*64*65536)
nodes=list(range(257))
for e in range(8,32):nodes += [k*2**(e-8) for k in range(256,513)]
table=[f(x) for x in nodes]
assert all(table[i]<=table[i+1] for i in range(256))
for b in range(24):assert all(table[257+b*257+i]<=table[257+b*257+i+1] for i in range(256))
(R/'private/shaper.h').write_text('#include <stdint.h>\nstatic const uint32_t shape[]={'+','.join(map(str,table))+'};\nstatic const integer_profile profile={'+str(math.floor(hi*524288))+',shape};\n')
# Private source copied only to private directory. Generic decoder/code contains no profile payload.
(R/'private/profile_data.h').write_bytes(src.read_bytes())
files=[src,W/'fox-v3-indexed-bvh-bounds/cache/candidate_profile.c',W/'fox-v3-indexed-bvh-bounds/cache/block_cache.c',W/'fox-v3-indexed-bvh-bounds/harness/profile_bridge.c']
(R/'private/PINS.json').write_text(json.dumps({'sha256':{str(p.relative_to(W)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},'constants':const,'high_code':math.floor(hi*524288),'shape_bytes':len(table)*4},indent=2))
