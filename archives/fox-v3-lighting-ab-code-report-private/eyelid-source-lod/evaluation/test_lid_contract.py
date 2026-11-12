from pathlib import Path
import json,sys,tempfile,shutil,unittest,ast
R=Path(__file__).resolve().parent;sys.path.insert(0,str(R/'code'));from geometry_certificate import verify,sha;from codec_audit import audit,fnv
PINS={8:'a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3',9:'4d5ece2a49f9111f8c881d4f0787db8595e8afaaef178839c9bd7a8f4ee5727b'}
class Tests(unittest.TestCase):
 def test_all_pinned(self):
  for s,p in PINS.items():verify(R/f'prepared-lid{s}',p)
 def test_external_sha_reject(self):
  for s in PINS:
   with self.assertRaises(AssertionError):verify(R/f'prepared-lid{s}','0'*64)
 def test_changed_certificate(self):
  for mutate in [lambda c:c['counts'].__setitem__('vertices',c['counts']['vertices']+1),lambda c:c.__setitem__('codecSnapshotBytes',65537),lambda c:c.__setitem__('codecMode',0),lambda c:c.__setitem__('glbSHA256','0'*64)]:
   with tempfile.TemporaryDirectory() as td:
    d=Path(td)/'pack';shutil.copytree(R/'prepared-lid8',d);p=d/'inputs/geometry-certificate.json';c=json.loads(p.read_text());mutate(c);p.write_text(json.dumps(c))
    with self.assertRaises((AssertionError,KeyError)):verify(d,sha(p))
 def test_full_snapshot_and_metadata_reject(self):
  for stage in PINS:
   contract=json.loads((R/f'prepared-lid{stage}/inputs/codec-contract.json').read_text())
   for row in json.loads((R/f'capacity-lid{stage}.json').read_text())['rows']:
    key=row['key'];view,case,*rev=key.split('-');raw=(R/f'probe-lid{stage}/private-snapshots/{key}.snapshot').read_bytes();audit(raw,contract,1,view,case,bool(rev))
   raw=(R/f'probe-lid{stage}/private-snapshots/front-baseline.snapshot').read_bytes()
   for field in ['normalPairMode4Records','normalPairMode5Records','normalPairSavedBytes']:
    for bad in [False,1.0,-1,None]:
     m={'normalPairCodecEnabled':True,'normalPairMode4Records':0,'normalPairMode5Records':contract['counts']['records'],'normalPairSavedBytes':contract['counts']['snapshotBytes']-len(raw),'visibilitySnapshotFingerprint':fnv(raw)};audit(raw,contract,1,'front','baseline',False,m);m[field]=bad
     with self.assertRaises(AssertionError):audit(raw,contract,1,'front','baseline',False,m)
   corrupt=bytearray(raw);corrupt[0]^=1
   with self.assertRaises(AssertionError):audit(corrupt,contract,1,'front','baseline',False)
 def test_cross_candidate_selector_and_contract(self):
  import copy
  raw=(R/'probe-lid8/private-snapshots/front-baseline.snapshot').read_bytes();c=json.loads((R/'prepared-lid8/inputs/codec-contract.json').read_text());other=json.loads((R/'prepared-lid9/inputs/codec-contract.json').read_text())
  with self.assertRaises(AssertionError):audit(raw,other,1,'front','baseline',False)
  for mode in [0,2,False,True,1.0]:
   with self.assertRaises((AssertionError,KeyError)):audit(raw,c,mode,'front','baseline',False)
  for mutate in [lambda x:x['modes']['1'].__setitem__('snapshotBytes',65537),lambda x:x['counts'].__setitem__('snapshotBytes',65536),lambda x:x['oldSnapshots']['front-baseline'].__setitem__('sha256','0'*64),lambda x:x['wireSnapshots']['front-baseline'].__setitem__('sha256','0'*64)]:
   bad=copy.deepcopy(c);mutate(bad)
   with self.assertRaises(AssertionError):audit(raw,bad,1,'front','baseline',False)
 def test_score_ast_exact(self):
  def f(p):return ast.dump(next(x for x in ast.parse(p.read_text()).body if isinstance(x,ast.FunctionDef) and x.name=='score'))
  self.assertEqual(f(R/'scoring/score_candidate.py'),f(R.parent/'fox-v3-normal-pair-evaluation/scoring/score_candidate.py'))
if __name__=='__main__':unittest.main()
