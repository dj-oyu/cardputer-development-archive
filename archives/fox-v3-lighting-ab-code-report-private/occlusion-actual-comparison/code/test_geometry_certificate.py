import unittest,tempfile,pathlib,shutil,json,sys
from geometry_certificate import verify,sha,runtime
ROOT=pathlib.Path(__file__).resolve().parents[1];PACK=ROOT/'prepared-old-002';BASE=ROOT.parent/'fox-v3-ground-transport/le-001'
class GeometryPins(unittest.TestCase):
 def test_old_accounting(self):
  c=verify(PACK,sha(PACK/'inputs/geometry-certificate.json'));a=json.loads((BASE/'native-front-baseline.json').read_text());runtime(a,c)
  for k in ['visibilityTriangles','visibilityVertices','snapshotBytes','records','coldBytes','arenaBytes64bit','groundFirstTriangle']:
   b=dict(a);b[k]+=1
   with self.assertRaises(AssertionError,msg=k):runtime(b,c)
 def test_coordinated_rehash_rejected(self):
  with tempfile.TemporaryDirectory() as d:
   r=pathlib.Path(d)/'pack';shutil.copytree(PACK,r);p=r/'inputs/geometry-certificate.json';pin=sha(p);c=json.loads(p.read_text());g=r/'inputs/geometry-source-sided.glb';g.write_bytes(g.read_bytes()+b'changed');c['glbSHA256']=sha(g);c['files']['inputs/geometry-source-sided.glb']=sha(g);p.write_text(json.dumps(c))
   with self.assertRaisesRegex(AssertionError,'external geometry'):verify(r,pin)
 def test_mutated_compile_rejected(self):
  with tempfile.TemporaryDirectory() as d:
   r=pathlib.Path(d)/'pack';shutil.copytree(PACK,r);pin=sha(r/'inputs/geometry-certificate.json');p=r/'compiled/model-baseline/compile.json';p.write_text(p.read_text()+' ')
   with self.assertRaisesRegex(AssertionError,'certificate file'):verify(r,pin)
if __name__=='__main__':unittest.main()
