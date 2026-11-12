from pathlib import Path
from classify_pixels import masks
import json,hashlib,numpy as np
RAW=['.snapshot','.f32le','.targets.u8','.hdr.f64le','.u16le']
REPORTS=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json','.depth-stream.json','.cache.json']
TIMING={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
def read(p):return json.loads(Path(p).read_text())
def diff(a,b,path=''):
 if type(a)!=type(b):return [{'path':path,'baseline':a,'candidate':b}]
 if isinstance(a,dict):
  out=[]
  for k in a.keys()|b.keys():
   if k not in a or k not in b:out.append({'path':path+'.'+k,'baseline':a.get(k),'candidate':b.get(k)})
   else:out+=diff(a[k],b[k],path+'.'+k)
  return out
 if isinstance(a,list):
  if len(a)!=len(b):return [{'path':path,'baseline':a,'candidate':b}]
  return sum((diff(x,y,path+f'[{i}]') for i,(x,y) in enumerate(zip(a,b))),[])
 return [] if a==b else [{'path':path,'baseline':a,'candidate':b}]
def metric(a,b):
 d=np.abs(a-b);return {'count':int(d.size),'changed':int((d!=0).sum()),'max_abs':float(d.max()) if d.size else 0.,'mean_abs':float(d.mean()) if d.size else 0.,'rms':float(np.sqrt((d*d).mean())) if d.size else 0.}
def compare(prefix,old,kind,metadata,preflight,input_json_hash):
 prefix,old,preflight=map(Path,[prefix,old,preflight]);m=metadata;result={'kind':kind,'complete':True,'shadowParityClaim':False,'reportDifferences':{}}
 loaded={}
 for ext in REPORTS:
  c=read(str(prefix)+ext);a=read(str(old)+ext);loaded[ext]=c
  if 'complete' in c:assert c['complete'] is True,(ext,'incomplete')
  for name in TIMING.get(ext,[]):a.pop(name);c2=None
  b=dict(c)
  for name in TIMING.get(ext,[]):b.pop(name)
  if ext=='.background.json':assert b['inputJSONSHA256']==input_json_hash;a['inputJSONSHA256']=input_json_hash
  delta=diff(a,b);result['reportDifferences'][ext]=delta
  if kind=='baseline':assert not delta,(ext,delta)
 for ext in RAW:assert Path(str(prefix)+ext).exists()
 if kind=='baseline':
  for ext in RAW:assert Path(str(prefix)+ext).read_bytes()==Path(str(old)+ext).read_bytes(),ext
  result['originalRawBitExact']=True
 for current,pf in [('.snapshot','.snapshot'),('.f32le','.center-depth.f32le'),('.targets.u8','.targets.u8')]:assert Path(str(prefix)+current).read_bytes()==Path(str(preflight)+pf).read_bytes(),('own preflight',current)
 aa=loaded['.aa.json'];floor=loaded['.floor.json'];bg=loaded['.background.json'];world=loaded['.floor-world.json'];row=loaded['.row.json'];depth=loaded['.depth-stream.json'];main=loaded['.json']
 assert aa['sampleHits']==m['quarterHits'] and aa['targets']==m['targets'] and aa['centerShades']+aa['sampleShades']==m['shaders'] and aa['preflightMatch'] is True
 assert floor['shaderCalls']==m['shaders'] and floor['floorHits']==m['floorHits'] and floor['shaderLimit']==m['shaders'] and floor['floorHitLimit']==m['floorHits']
 assert [x['limit'] for x in floor['categories'].values()]==m['floorCategoryLimits'];assert floor['limitTotal']==m['floorWorkLimit'] and floor['usedTotal']<=floor['limitTotal']
 assert [x['reserved'] for x in bg['core']['categories'].values()]==m['sceneCategoryLimits'];assert bg['core']['observedTotal']<=bg['core']['reservedTotal']<=1680000
 for k in ['slots','floor','world','keep']:assert bg['classification'][k]==m['background'][k],('bg',k)
 assert world['enabled'] is True and world['shaderCalls']==m['shaders'] and world['workLimit']==m['floorWorldWorkLimit'] and world['workUsed']<=world['workLimit']
 assert depth['producerWorkIncludingDepth']==sum(row['producerUsed'])+depth['pendingCopyFloats']+depth['captureCopyFloats']<=637599
 # Every category pair retains its explicit observed <= reserved / used <= limit contract.
 def caps(o):
  if isinstance(o,dict):
   if 'used' in o and 'limit' in o:assert o['used']<=o['limit']
   if 'observed' in o and 'reserved' in o:assert o['observed']<=o['reserved']
   for v in o.values():caps(v)
  elif isinstance(o,list):
   for v in o:caps(v)
 for o in loaded.values():caps(o)
 x=np.fromfile(str(old)+'.hdr.f64le',dtype='<f8').reshape(32400,3);y=np.fromfile(str(prefix)+'.hdr.f64le',dtype='<f8').reshape(32400,3);assert np.all(np.isfinite(y)) and np.all(y>=0)
 z0=np.fromfile(str(old)+'.f32le',dtype='<f4');z1=np.fromfile(str(prefix)+'.f32le',dtype='<f4');mask=np.fromfile(str(old)+'.targets.u8',dtype='u1').astype(bool);char=np.isfinite(z0);both=char&np.isfinite(z1)
 result['HDR']={name:metric(x[sel],y[sel]) for name,sel in [('all',np.ones(32400,bool)),('boundary',mask),('character_depth_finite',char),('background_depth_nonfinite',~char)]};eligible=x>=1e-3;result['HDR']['relative_above_1e_3']=metric(np.ones(int(eligible.sum())),y[eligible]/x[eligible]);result['HDR']['abs_error_quantiles']={str(q):float(np.quantile(np.abs(y-x),q)) for q in [.5,.95,.99,1]}
 rgb0=np.fromfile(str(old)+'.u16le',dtype='<u2');rgb1=np.fromfile(str(prefix)+'.u16le',dtype='<u2');assert rgb1.size==32400;unpack=lambda z:np.stack([(z>>11)&31,(z>>5)&63,z&31],axis=1).astype(np.float64)
 regions=masks(preflight.parent/'baseline-front',read(Path(__file__).resolve().parent/'baseline-front.metadata.json'));result['HDR_baseline_composition_regions']={name:metric(x[selection],y[selection]) for name,selection in regions.items()};result['baselineCompositionPixelCounts']={name:int(selection.sum()) for name,selection in regions.items()};result['RGB565']={'changed_pixels':int((rgb0!=rgb1).sum()),'channel_steps':metric(unpack(rgb0),unpack(rgb1))};result['depth']={'coverage_changed_pixels':int((np.isfinite(z0)!=np.isfinite(z1)).sum()),'shared_finite':metric(z0[both].astype(float),z1[both].astype(float))};result['targetMaskChangedPixels']=int((np.fromfile(str(old)+'.targets.u8',dtype='u1')!=np.fromfile(str(prefix)+'.targets.u8',dtype='u1')).sum())
 return result
