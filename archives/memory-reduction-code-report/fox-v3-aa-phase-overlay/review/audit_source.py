from pathlib import Path
import hashlib,json,re
R=Path(__file__).resolve().parents[1]; B=R.parent/'fox-v3-segmented-model-arena'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
changed=[]
for root in ['code','private-build']:
 for p in (R/root).rglob('*'):
  if p.is_file():
   old=B/p.relative_to(R)
   assert old.is_file(),p
   if sha(p)!=sha(old):changed.append(str(p.relative_to(R)))
assert set(changed)=={'code/ksn_bounded_ring.h','code/ksn_bounded_ring_impl.inc','code/build_core.sh'},changed
assert (B/'code/build_core.sh').read_text().replace('fox-v3-indexed-floor-world','fox-v3-aa-phase-overlay')==(R/'code/build_core.sh').read_text()
old=(B/'code/ksn_bounded_ring_impl.inc').read_text();new=(R/'code/ksn_bounded_ring_impl.inc').read_text()
assert old[old.index('static const uint64_t rrh_limits'):]==new[new.index('static const uint64_t rrh_limits'):]
for fn in ['ksn_bounded_ring_impl.inc','ksn_depth_bands_impl.inc']:
 s=(R/'code'/fn).read_text();start=s.index(' for(unsigned y=0;y<135;y+=8)')
 first=s.index(' for(unsigned y=0;y<135;y+=8)',start+1)
 assert 'center_id' not in s[first:]
 assert 'memcpy(w->delayed_center_hdr,w->reuse.hdr+row*240,sizeof w->delayed_center_hdr)' in s[start:first]
 assert 'ring_sc_mask(binding,w,new_report)' in s[start:first]
 assert 'ring_aa_geometry' in s[first:]
uses={}
for p in (R/'code').glob('*'):
 if p.is_file():
  hits=[i for i,s in enumerate(p.read_text().splitlines(),1) if 'center_id' in s]
  if hits:uses[p.name]=hits
out={'status':'PASS_SOURCE_INVARIANTS_NOT_RENDER_GATE','changedProductionFiles':changed,'orchestrationAndBudgetsByteIdentical':True,'privateBuildByteIdentical':True,'centerIdSites':uses,'sourcePins':{str(p.relative_to(R)):sha(p) for p in (R/'code').iterdir() if p.is_file()}}
(R/'review/SOURCE_REVIEW.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
