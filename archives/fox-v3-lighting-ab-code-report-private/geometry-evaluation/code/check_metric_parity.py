import importlib.util,pathlib,json,sys,numpy as np
from geometry_certificate import verify,sha
W=pathlib.Path(__file__).resolve().parents[2];R=W/'fox-v3-occlusion-evaluation'
def load(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);sys.modules[name]=m;s.loader.exec_module(m);return m
old=load('old_scorer',W/'fox-v3-ground-transport/scoring/score_candidate.py');new=load('new_scorer',R/'scoring/score_candidate.py');pack=R/'prepared-old-002';new.GEOMETRY=verify(pack,sha(pack/'inputs/geometry-certificate.json'))
ref=old.load_reference(W/'fox-reference-uncertainty-v3');p=W/'fox-v3-ground-transport/le-001/candidate-manifest.json';a=old.load_candidate(p,ref['config']);b=new.load_candidate(p,ref['config']);x,xm=old.score(ref,a);y,ym=new.score(ref,b);assert x==y
assert xm.keys()==ym.keys()
for k in xm:
 for n in xm[k]:assert np.array_equal(xm[k][n],ym[k][n],equal_nan=True),(k,n)
print('Old vs geometry-adapter all10 scoring results and all masks exact; reused frozen images, no rendering.')
