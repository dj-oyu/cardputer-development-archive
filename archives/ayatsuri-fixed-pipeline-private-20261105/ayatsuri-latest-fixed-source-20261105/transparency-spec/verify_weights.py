"""Independent closure-weight arithmetic only; no scene/radiance/renderer inputs."""
import json,pathlib,random
P=pathlib.Path(__file__).resolve().parent;rng=random.Random(519);results=[]
for bits in (16,20,24):
 S=1<<bits;codes=[-S,-1,0,1,S//4,S//2,3*S//4,S-1,S,S+1,2*S]+[rng.randint(-S,2*S) for _ in range(10000)]
 for raw in codes:
  principled=min(S,max(0,raw));transparent=S-principled
  assert 0<=principled<=S and 0<=transparent<=S and principled+transparent==S
  # White Transparent color multiplies its weight by exactly one per RGB channel.
  white_transparent=[transparent]*3
  assert all(x==transparent for x in white_transparent)
 # Exact fractional witness from Math.016/017/018/019, outside strip.
 b=S//128;strip=0;raw= max(strip,S-min(S,50*b));assert raw==39*S//64
 for b in (0,1,S//128,S//50-1,S//50,S//50+1,S):
  outside=S-min(S,50*b);assert 0<=outside<=S
 results.append({'fractional_witness_code':39*S//64,'fractional_witness_real':'39/64','bits':bits,'explicit_and_random_raw_codes':len(codes),'sum_codes':S,'min_max_and_complement':'PASS','scope':'top-level incoming weight one; not source float32 branch or scene transport parity'})
(P/'weight-results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(results,indent=2))
