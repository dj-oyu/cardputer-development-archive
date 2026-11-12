from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-aa-phase-overlay';C=R.parent/'fox-v3-profile-four-block-cache'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for name in ('block_cache.c','block_cache.h','candidate_profile.c'):assert (R/'cache'/name).read_bytes()==(C/'implementation'/name).read_bytes(),name
for p in (B/'code').glob('*'):
 if p.is_file():assert p.read_bytes()==(R/'code'/p.name).read_bytes(),p
old=(B/'harness/row_transport_bridge.c').read_text();new=(R/'harness/row_transport_bridge.c').read_text();assert new.startswith(old)
def function(text,name):
 at=text.index(name+'(');start=text.rfind('\n',0,at)+1;i=text.index('{',at);depth=1;j=i+1
 while depth:
  if text[j]=='{':depth+=1
  if text[j]=='}':depth-=1
  j+=1
 return text[start:j]
new=(R/'code/ksn_cached_profile_impl.inc').read_text();old=(B/'code/ksn_depth_bands_impl.inc').read_text()
for orig,target in [('db_finish_row','cached_finish_row'),('ksn_mesh_pixel_render_depth_bands_experimental','ksn_mesh_pixel_render_cached_depth_bands_private')]:
 a=function(old,orig).replace(orig,target).replace('KsnBandProfile profile','agx_block_cache *profile').replace('rrh_encode(', 'cached_encode(').replace('db_finish_row(', 'cached_finish_row(')
 assert a==function(new,target),target
old=(B/'code/ksn_bounded_ring_impl.inc').read_text();a=function(old,'rrh_encode').replace('rrh_encode(','cached_encode(').replace('KsnBandProfile profile','agx_block_cache *profile').replace('profile(in,v)','agx_cache_profile_eval(profile,in,v)');assert a==function(new,'cached_encode')
result={}
for build,report in [('build-product','PRODUCT_NAMED_STACK.json'),('build-adapter','NAMED_STACK.json')]:
 frames={}
 for p in (R/build).glob('*.su'):
  for line in p.read_text().splitlines():
   loc,amount,kind=line.split('\t');frames[p.stem+':'+loc.rsplit(':',1)[-1]]=int(amount)
 st=json.loads((R/report).read_text());base=json.loads((B/report).read_text())
 for name,c in st['chains'].items():
  assert sum(x['bytes'] for x in c['frames'])==c['bytes']
  assert all(x['bytes']==frames[x['name']] for x in c['frames'])
  if 'profile' not in name and name not in ('bridge_admission','diagnostic_hdr_copy'):
   assert c['bytes']==base['chains'][name]['bytes'],name
 for name in ('center_profile','quarter_profile'):
  chain=[x['name'] for x in st['chains'][name]['frames']]
  assert chain[-3:]==['profile_bridge:agx_cache_profile_eval','block_cache:agx_cache_fetch4','block_cache:header']
 assert st['backgroundPeak']==4080<=st['backgroundCap']==4096
 assert st['rendererPeak']==5008<=st['rendererCap']==8192
 for p,h in st['stackFiles'].items():assert sha(R/build/p)==h
 result[build]={'backgroundPeak':4080,'rendererPeak':5008,'centerProfile':st['chains']['center_profile']['bytes'],'quarterProfile':st['chains']['quarter_profile']['bytes'],'mainStack':st['mainStack'],'allNamedFramesRecomputed':True}
out={'status':'PASS_SOURCE_AND_NAMED_STACK','sourceSpecializationExact':True,'frozenCacheSourceExact':True,'legacyBridgePrefixUnchanged':True,'stack':result,'actualAdmission':{'off':{'base':588,'candidate':616},'on':{'base':616,'candidate':645}},'admissionCap':1024,'exclusions':['libc/libm and ABI runtime','allocator metadata','target-device layout'],'scriptSHA256':sha(Path(__file__))}
(R/'review/SOURCE_STACK.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
