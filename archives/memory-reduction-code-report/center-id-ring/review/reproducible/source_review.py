from pathlib import Path
import re,json,hashlib
B=Path('fox-v3-indexed-floor-world');R=Path('fox-v3-center-id-ring');P=Path('private-build/product/main/ui/kasane');C=Path('code')
names=['aa_guard','aa_charge','aa_bind','aa_target','aa_geometry','sc_mask','sc_shade_final']
def extract(s,name):
 m=re.search(r'^static [^\n]*?\b'+name+r'\(',s,re.M);assert m,name
 op=s.index('{',m.end());i=op+1;d=1
 while d:d+=(s[i]=='{')-(s[i]=='}');i+=1
 return s[m.start():i]+'\n'
def normalize(s):
 s=s.replace('ksn_bounded_ring_workspace','ksn_aa_workspace')
 for n in names:s=re.sub(r'\bring_'+n+r'\b',n,s)
 return s
helpers=(R/C/'ksn_bounded_ring_helpers.inc').read_text()
for n in names:
 source=(B/P/('ksn_boundary_aa_impl.inc' if n.startswith('aa_') else 'ksn_scene_composition_impl.inc')).read_text()
 assert normalize(extract(helpers,'ring_'+n))==extract(source,n),n
unchanged=[]
for p in (B/P).glob('*'):
 if p.is_file() and p.name!='ksn_mesh_depth.c':
  assert p.read_bytes()==(R/P/p.name).read_bytes(),p.name;unchanged.append(p.name)
for n in ['ksn_bounded_hdr.h','ksn_bounded_hdr_impl.inc','ksn_bounded_hdr_center.inc']:
 assert (B/C/n).read_bytes()==(R/C/n).read_bytes();unchanged.append(n)
assert (R/P/'ksn_mesh_depth.c').read_text()==(B/P/'ksn_mesh_depth.c').read_text()+'\n#include "ksn_bounded_ring_impl.inc"\n'
print(json.dumps({'status':'PASS','verbatimSpecializedFunctions':names,'genericFilesByteIdentical':unchanged,'meshDepthChange':'single include appended','sourceHashes':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in (R/C).glob('ksn_bounded_ring*')}},indent=2))
