import copy,json,math,pathlib,tempfile,unittest
from fractions import Fraction
import compile_attributes as c
import finalize_ir as f
class Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.source=c.loads(c.SOURCE.read_bytes())
 def test_actual_roundtrip_and_determinism(self):
  for bits in (16,20):
   ir=f.finalize(self.source,bits);stored=c.loads((c.HERE/f'attributes-q{bits}-v2.json').read_bytes());self.assertEqual(c.canonical(ir),c.canonical(stored));count=0;deg=0
   for part in ir['parts']:
    obj=self.source['objects'][part['source_object_id']]
    self.assertLessEqual(len(part['vertices']),32);self.assertLessEqual(len(part['triangles']),64)
    for t in part['triangles']:
     orig=obj['triangles'][t['source_lod_triangle_index']];count+=1;deg+=bool(t['static_degenerate_domains'])
     self.assertEqual([part['vertices'][i]['source_vertex_index'] for i in t['vertices']],orig['vertices'])
     for j,idx in enumerate(t['vertices']):
      v=part['vertices'][idx];i=v['source_vertex_index'];self.assertEqual(v['world_xyz'],c.quant(obj['vertices_world_metres'][i],bits));self.assertEqual(v['local_xyz'],c.quant(obj['vertices_local'][i],bits));self.assertEqual(v['normal_world_s32767'],c.normal(orig['corner_normals_world'][j]));self.assertEqual(v['normal_local_s32767'],c.normal(orig['corner_normals_local'][j]))
   self.assertEqual((count,deg),(1982,36));self.assertFalse(ir['ready_for_AYFQ_v1'])
 def test_scalar_batch_widths_and_exact_rounding(self):
  def oracle(x,scale):
   n=Fraction(x*scale);sign=-1 if n<0 else 1;n=abs(n);q,r=divmod(n.numerator,n.denominator);return sign*(q+(2*r>n.denominator or (2*r==n.denominator and q%2)))
  for bits in(16,20):
   values=[v for o in self.source['objects'] for field in ('vertices_local','vertices_world_metres') for p in o[field] for v in p]
   expected=[oracle(x,1<<bits) for x in values]
   for width in (1,2,4,8):self.assertEqual([round(x*(1<<bits)) for start in range(0,len(values),width) for x in values[start:start+width]],expected)
   for n in(-5,-3,-1,1,3,5):self.assertEqual(c.quant([n/2/(1<<bits)],bits),[oracle(n/2/(1<<bits),1<<bits)])
 def test_invalid_inputs(self):
  edits=[lambda s:s.update(source_sha256='0'*64),lambda s:s['objects'][0]['vertices_local'][0].__setitem__(0,129),lambda s:s['objects'][0]['vertices_world_metres'][0].__setitem__(0,math.nan),lambda s:s['objects'][0]['triangles'][0].update(vertices=[0,0,1]),lambda s:s['objects'][0]['triangles'][0].update(material_slot=99),lambda s:s['objects'][0]['triangles'][0]['corner_normals_world'].__setitem__(0,[0,0,0]),lambda s:s['objects'][0].update(attributes={'unknown':[]})]
  for edit in edits:
   s=copy.deepcopy(self.source);edit(s)
   with self.assertRaises(ValueError):c.compile_ir(s,20)
  with self.assertRaises(ValueError):c.compile_ir(self.source,19)
 def test_new_collapse_rejected(self):
  s=copy.deepcopy(self.source);o=s['objects'][0];ids=o['triangles'][0]['vertices']
  for field in('vertices_local','vertices_world_metres'):
   for i,p in zip(ids,[[0,0,0],[1e-8,0,0],[0,1e-8,0]]):o[field][i]=p
  with self.assertRaises(ValueError):c.compile_ir(s,16)
 def test_malformed_json(self):
  for x in [b'{"a":NaN}',b'{"a":1,"a":2}',b'[1e400]',('['*50+'0'+']'*50).encode()]:
   with self.assertRaises(ValueError):c.loads(x)
 def test_nooverwrite(self):
  p=c.HERE/'temporary-test-nooverwrite.json'
  try:
   c.write_new(p,{'a':1});before=p.read_bytes()
   with self.assertRaises(FileExistsError):c.write_new(p,{'a':2})
   self.assertEqual(before,p.read_bytes())
  finally:p.unlink(missing_ok=True)
if __name__=='__main__':unittest.main()
