import copy,ctypes,json,math,pathlib,tempfile,unittest
import prepare as p
class Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.result=p.audit();cls.scene=cls.result['source_input']
 def test_exact_fidelity_and_determinism(self):
  self.assertEqual(self.result,p.audit());self.assertEqual(self.result['fidelity']['prepared_scene_bit_mismatches'],0)
  prior=json.loads((p.ROOT/'ayatsuri-fixed-integer-geometry-20261105/results.json').read_text())
  for cam in self.result['cameras']:
   r=next(x for x in prior['actual']['experiments'] if x['view']==cam['authored']['name'] and x['position_fraction_bits']==20 and x['screen_fraction_bits']==10)
   self.assertEqual(cam['integer']['m_q20'],r['camera_coeff_codes']);self.assertEqual(cam['integer']['offset_q10'],r['camera_offset_codes'])
 def test_numeric_and_schema_rejection(self):
  edits=[lambda s:s.update(animation=[]),lambda s:s.update(mode='animated'),lambda s:s.update(visibility='all-visible'),lambda s:s['lights'][0].update(shape='RECTANGLE'),lambda s:s['lights'][0].update(no_parent=False),lambda s:s['lights'][0].update(identity_scale=[True,1,1]),lambda s:s['lights'][0].update(rotation_mode='QUATERNION'),lambda s:s['lights'][0].update(position=[9,0,0]),lambda s:s['lights'][0].update(position=[math.nan,0,0]),lambda s:s['lights'][0].update(power=math.inf),lambda s:s['lights'][0].update(power=-1),lambda s:s['lights'][0].update(power=True),lambda s:s['lights'][0].update(color=[1e300,1,1]),lambda s:s['lights'][0].update(diameter=0),lambda s:s.update(world_rgb=[16,16,16],world_strength=16),lambda s:s['lights'][0].update(position=[8,0,0],diameter=16)]
  for edit in edits:
   s=copy.deepcopy(self.scene);edit(s)
   with self.assertRaises(ValueError):p.prepare(s)
 def test_malicious_json(self):
  for x in ('{"x":NaN}','{"x":Infinity}','{"x":1e400}','{"x":1,"x":2}','['*40+'0'+']'*40,'{"x":'+'9'*1000+'}'):
   with self.assertRaises(ValueError):p.loads(x)
  with self.assertRaises(ValueError):p.loads(' '*2097153)
 def test_rounding_domain(self):
  self.assertEqual([p.quant(x,1,-10,10) for x in (-2.5,-1.5,-.5,.5,1.5,2.5)],[-2,-2,0,0,2,2])
  for x in (10.0001,-10.0001,math.nan,math.inf,True):
   with self.assertRaises(ValueError):p.quant(x,1,-10,10)
 def test_atomic_nooverwrite(self):
  with tempfile.TemporaryDirectory(dir=p.HERE) as d:
   target=pathlib.Path(d)/'x.json';p.write_new(target,{'ok':1});before=target.read_bytes()
   with self.assertRaises(FileExistsError):p.write_new(target,{'ok':2})
   self.assertEqual(before,target.read_bytes());self.assertFalse(list(pathlib.Path(d).glob('.prepare-*')))
   link=pathlib.Path(d)/'link';link.symlink_to(target)
   with self.assertRaises(FileExistsError):p.write_new(link,{'ok':3})
   self.assertEqual(before,target.read_bytes())
   with self.assertRaises(ValueError):p.write_new(pathlib.Path(d)/'bad.json',{'n':math.nan})
   self.assertFalse((pathlib.Path(d)/'bad.json').exists())
  with self.assertRaises(ValueError):p.write_new('/tmp/not-authorized-output.json',{})
 def test_rounding_mode_rejected(self):
  lib=ctypes.CDLL('libm.so.6');old=lib.fegetround()
  try:
   self.assertEqual(lib.fesetround(0x400),0)
   with self.assertRaises(ValueError):p.prepare(self.scene)
  finally:lib.fesetround(old)
if __name__=='__main__':unittest.main()
