import pathlib,re,json
P=pathlib.Path(__file__).resolve().parent;OLD=P.parent/'material-c-prototype';records=[]
pat=re.compile(r'v\[(\d+)\]')
def parse(s,name):
 f=re.search(r'static void '+name+r'\([^\n]+\n(.*?)\n}',s,re.S);assert f
 return [l for l in f.group(1).splitlines() if l.startswith('v[')]
def compact(lines,initial,roots):
 reads=[];writes=[];defined=set(initial)
 for line in lines:
  w=int(re.match(r'v\[(\d+)\]=',line)[1]);rr=[int(x) for x in pat.findall(line.split('=',1)[1])];assert set(rr)<=defined,('undefined',line);assert w not in defined,('logicalmultiplewrite',w);defined.add(w);writes.append(w);reads.append(rr)
 assert set(roots)<=defined
 last={x:-1 for x in initial}
 for t,rr in enumerate(reads):
  for x in rr:last[x]=t
 for x in roots:last[x]=len(lines)
 mapping={x:i for i,x in enumerate(initial)};active=mapping.copy();free=[];nextslot=len(initial);peak=nextslot;out=[];events=[]
 for t,(line,w,rr) in enumerate(zip(lines,writes,reads)):
  for x in list(active):
   if last.get(x,-1)<t:free.append(active.pop(x))
  assert all(x in active for x in rr)
  slot=min(free) if free else nextslot
  if free:free.remove(slot)
  else:nextslot+=1
  assert slot not in active.values();mapping[w]=slot;active[w]=slot;last.setdefault(w,t)
  rewritten=pat.sub(lambda m:'v[%d]'%mapping[int(m[1])],line);inverse={physical:logical for logical,physical in active.items()};assert pat.sub(lambda m:'v[%d]'%inverse[int(m[1])],rewritten)==line;out.append(rewritten);peak=max(peak,len(active));events.append({'logical_output':w,'physical':slot,'reads':rr,'active_slots':len(active)})
 return out,mapping,nextslot,events
for bits in (16,20,24):
 s=(OLD/f'generated-q{bits}.inc').read_text();tables=re.findall(r'static const int64_t lut_(?:left|right)\[257\]\[3\] = (.*);',s);assert len(tables)==2 and tables[0]==tables[1];nums=list(map(int,re.findall(r'-?\d+',tables[0])));assert len(nums)==771 and all(0<=x<=0xffffffff for x in nums)
 result=['#define ROUGHNESS '+re.search(r'#define ROUGHNESS (\d+)',s)[1],'static const uint32_t lut_shared[257][3] = '+tables[0]+';'];ns=[];nc=[]
 for side in ('left','right'):
  uni=parse(s,'uniform_'+side);spa=parse(s,'spatial_'+side)
  colors=list(map(int,re.search(r'color_'+side+r'\[3\]=\{([^}]+)',s)[1].split(',')));mask=int(re.search(r'mask_'+side+r'=(\d+)',s)[1]);roots=colors+[mask]
  spatwrites={int(re.match(r'v\[(\d+)\]',x)[1]) for x in spa};need=sorted({int(y) for x in spa for y in pat.findall(x.split('=',1)[1]) if int(y) not in spatwrites}|(set(roots)-spatwrites))
  u,um,un,ue=compact(uni,[],need);v,vm,vn,ve=compact(spa,need,roots);nc.append(len(need));ns.append(vn)
  result.append('static void uniform_'+side+'(int64_t *cache,const int32_t *u,const int32_t *xz,int *e){(void)xz;int64_t v['+str(un)+'];')
  result+=u;result+=['cache[%d]=v[%d];'%(i,um[k]) for i,k in enumerate(need)];result.append('}')
  result.append('static void spatial_'+side+'(int64_t *v,const int32_t *u,const int32_t *xz,int *e){(void)u;')
  result += [x.replace('lut_'+side,'lut_shared') for x in v];result.append('}')
  result.append('static const unsigned color_'+side+'[3]={'+','.join(str(vm[x]) for x in colors)+'};');result.append('static const unsigned mask_'+side+'='+str(vm[mask])+';')
  records.append({'bits':bits,'side':side,'cache_logical_slots':need,'cache_slots':len(need),'uniform_scratch_slots':un,'spatial_scratch_slots':vn,'uniform_allocation':ue,'spatial_allocation':ve,'checks':'single logical assignment; every RHS defined/live; output slot never aliases a live RHS; roots kept through output; exact statement order unchanged; every rewritten statement inverse-maps byte-for-byte to original','lut_max':max(nums)})
 assert nc[0]==nc[1]
 result.insert(0,'#define NCACHE '+str(max(nc)));result.insert(0,'#define NSLOTS '+str(max(ns)))
 (P/f'generated-q{bits}.inc').write_text('\n'.join(result)+'\n')
(P/'allocation-manifest.json').write_text(json.dumps(records,indent=2)+'\n');print([(r['bits'],r['side'],r['cache_slots'],r['uniform_scratch_slots'],r['spatial_scratch_slots']) for r in records])
