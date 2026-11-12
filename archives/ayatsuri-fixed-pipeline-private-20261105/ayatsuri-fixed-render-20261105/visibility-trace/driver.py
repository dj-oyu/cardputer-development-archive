from pathlib import Path
import json,hashlib,sys,ctypes,collections,struct
import numpy as np
D=Path(__file__).parent.resolve();W=D.parents[1];P=D.parent/'preflight';M=D.parent/'plan';KINDS=['baseline','q16','q20']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,obj):
 with p.open('x') as f:json.dump(obj,f,indent=2);f.write('\n')
def pins():
 files=[D/p for p in ['trace.c','bounce_pure_extract.h','trace.so','build.sh','driver.py','PLAN.md','ALIGNMENT.json','keys.json']]
 files += [W/'fox-v3-indexed-bvh-bounds/private-build'/p for p in ['visibility/visibility.c','visibility/visibility.h','transport/bounce.c']]
 for k in KINDS:files += [D/f'{k}.aligned-events.f64le',D/f'{k}.aligned-identities.json',M/f'{k}-front.metadata.json']+[P/f'{k}-front{ext}' for ext in ['.events.jsonl','.world-vertices.f64le','.world-triangles.u32le','.targets.u8','.geometry.json']]
 return {str(p.relative_to(W)):sha(p) for p in files}
if sys.argv[1:]==['--prepare']:
 # Validate extraction verbatim against allowed original source, not just another helper hash.
 src=(W/'fox-v3-indexed-bvh-bounds/private-build/transport/bounce.c').read_text();helper=(D/'bounce_pure_extract.h').read_text()
 for name in ['dot','norm','cross','direction']:
  import re
  pattern=r'static (?:double|int|void) '+name+r'\([^\n]*'
  start=re.search(pattern,src).start();brace=src.index('{',start);depth=1;i=brace+1
  while depth:depth+=(src[i]=='{')-(src[i]=='}');i+=1
  assert src[start:i] in helper, name
 allkeys=None;correspondence={};aligned=[]
 for k in KINDS:
  events=list(map(json.loads,(P/f'{k}-front.events.jsonl').read_text().splitlines()));count=collections.Counter();index={}
  for file_index,e in enumerate(events):
   group=(e['phase'],e['x'],e['y']);order=count[group];count[group]+=1;key=group+(order,);assert key not in index;index[key]=(e,file_index)
  assert len(events)==17070 and max(count.values())==8
  keys=sorted(index)
  if allkeys is None:allkeys=keys;write(D/'keys.json',[list(x) for x in keys])
  else:assert keys==allkeys,'Event correspondence mismatch: do not align by file row index'
  assert all(n==1 for (phase,x,y),n in count.items() if phase>0)
  mask=(P/f'{k}-front.targets.u8').read_bytes();rows=[];nums=[]
  for key in keys:
   e,i=index[key];phase,x,y,ordinal=key;last=ordinal==count[key[:3]]-1;target=bool(mask[y*240+x]);disposition='final-quarter' if phase else ('overwritten-center' if not last else ('center-replaced-by-AA' if target else 'retained-center'))
   rows.append({'key':list(key),'originalEventIndex':i,'disposition':disposition,'targetPixel':target,'primitiveInput':{n:e[n] for n in ['recordOffset','node','face','sourceId','back']},'depth':e['depth'],'rho':e['rho']});nums.append(e['P']+e['Ns'])
  with (D/f'{k}.aligned-events.f64le').open('xb') as f:f.write(np.asarray(nums,dtype='<f8').tobytes())
  write(D/f'{k}.aligned-identities.json',rows);correspondence[k]={'events':len(events),'groups':len(count),'dispositions':dict(collections.Counter(r['disposition'] for r in rows)),'perGroupCountsIdentical':True};aligned.append(rows)
 write(D/'ALIGNMENT.json',{'status':'KEY_SETS_AND_PER_PIXEL_EVENT_COUNTS_PROVEN','key':['phase','x','y','per-pixel-update-ordinal'],'directionKey':'append j=0..15','variants':correspondence,'primitiveInputChanges':{KINDS[i]:sum(a['primitiveInput']!=b['primitiveInput'] for a,b in zip(aligned[0],aligned[i])) for i in [1,2]}})
 write(D/'FREEZE.json',{'status':'PREPARED_NOT_EXECUTED','purpose':'new query-aligned classification trace, not retry of aggregate metadata','raysPerVariant':273120,'variants':KINDS,'nodeCapPerVariant':100000000,'triangleCapPerVariant':50000000,'files':pins()});print(sha(D/'FREEZE.json'));sys.exit(0)
if len(sys.argv)!=3 or sys.argv[1]!='--run':raise SystemExit('--prepare or --run <independently-reviewed FREEZE SHA256>')
assert sys.byteorder=='little' and struct.calcsize('d')==8
freeze=D/'FREEZE.json';assert sha(freeze)==sys.argv[2];frozen=json.loads(freeze.read_text());assert frozen['files']==pins();(D/'RUN-RESERVATION').mkdir()
lib=ctypes.CDLL(str(D/'trace.so'));Q=ctypes.POINTER(ctypes.c_uint64);F=ctypes.POINTER(ctypes.c_double);U=ctypes.POINTER(ctypes.c_uint32);fn=lib.trace_primary;fn.argtypes=[F,ctypes.c_size_t,U,ctypes.c_size_t,F,ctypes.c_size_t,ctypes.c_uint64,ctypes.c_char_p,Q];rows=[]
for i,k in enumerate(KINDS,10):
 assert pins()==frozen['files'];xyz=np.fromfile(P/f'{k}-front.world-vertices.f64le',dtype='<f8');tri=np.fromfile(P/f'{k}-front.world-triangles.u32le',dtype='<u4');ev=np.fromfile(D/f'{k}.aligned-events.f64le',dtype='<f8');assert xyz.size==3501 and tri.size==4698 and ev.size==17070*6
 counters=(ctypes.c_uint64*8)();status=fn(xyz.ctypes.data_as(F),1167,tri.ctypes.data_as(U),1566,ev.ctypes.data_as(F),17070,i,str(D/f'{k}.trace.bin').encode(),counters)
 if status:write(D/f'{k}.FAILED.json',{'status':status,'counters':list(counters),'complete':False});raise SystemExit('Trace failure; no retries')
 c=dict(zip(['rays','nodes','triangles','groundHits','characterHits','misses','events','sceneBytes'],counters));assert c['rays']==273120 and c['events']==17070
 old=json.loads((M/f'{k}-front.metadata.json').read_text())['floorRayCounters'];assert c==old,(k,c,old)
 write(D/f'{k}.counters.json',c);rows.append({'variant':k,'counters':c,'traceSHA256':sha(D/f'{k}.trace.bin')});print(k,c,flush=True)
assert pins()==frozen['files'];dtype=np.dtype([('found','<u4'),('triangle','<u4'),('distance','<f8'),('direction','<f8',(3,))]);assert dtype.itemsize==40
keys=json.loads((D/'keys.json').read_text());base=np.fromfile(D/'baseline.trace.bin',dtype=dtype);summary=[]
for k in KINDS[1:]:
 other=np.fromfile(D/f'{k}.trace.bin',dtype=dtype);assert base.size==other.size==273120;bi=json.loads((D/'baseline.aligned-identities.json').read_text());ci=json.loads((D/f'{k}.aligned-identities.json').read_text())
 def classify(a):return np.where(a['found']==0,0,np.where(a['triangle']>=1564,2,1))
 a,b=classify(base),classify(other);fc=base['found']!=other['found'];cc=a!=b;tc=base['triangle']!=other['triangle'];dc=base['distance']!=other['distance'];direction=np.any(base['direction']!=other['direction'],axis=1);changed=np.flatnonzero(fc|cc|tc);details=[]
 for j in changed:
  e=int(j)//16;key=keys[e]+[int(j)%16];details.append({'queryKey':key,'disposition':ci[e]['disposition'],'baselineInput':bi[e],'candidateInput':ci[e],'baseline':{'class':int(a[j]),'triangle':int(base[j]['triangle']),'distance':float(base[j]['distance']),'direction':base[j]['direction'].tolist()},'candidate':{'class':int(b[j]),'triangle':int(other[j]['triangle']),'distance':float(other[j]['distance']),'direction':other[j]['direction'].tolist()}})
 write(D/f'{k}.divergences.json',details)
 summary.append({'variant':k,'foundChanges':int(fc.sum()),'classificationChanges':int(cc.sum()),'triangleChanges':int(tc.sum()),'distanceChanges':int(dc.sum()),'directionChanges':int(direction.sum()),'groundDelta':int((b==2).sum()-(a==2).sum()),'classificationChangesByDisposition':dict(collections.Counter(ci[int(j)//16]['disposition'] for j in np.flatnonzero(cc))),'triangleChangesByDisposition':dict(collections.Counter(ci[int(j)//16]['disposition'] for j in np.flatnonzero(tc)))})
write(D/'RESULT.json',{'status':'COMPLETE_NEW_QUERY_ALIGNED_TRACE','freezeSHA256':sha(freeze),'rows':rows,'comparisons':summary,'warning':'Primary nearest directions only, no secondary visibility, direct shadow segments or shaded frames'});print(summary)
