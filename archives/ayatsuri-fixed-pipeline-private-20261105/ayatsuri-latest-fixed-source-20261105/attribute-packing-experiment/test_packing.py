import copy,json,unittest
import compare_packing as p
class Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.ir=json.loads((p.INPUT/'attributes-q20-v2.json').read_text());cls.parts=json.loads((p.HERE/'packing-q20-min_id.json').read_text())['parts']
 def test_content_and_limits(self):
  self.assertEqual(p.signatures(self.ir),p.signatures(self.parts));self.assertEqual(p.metrics(self.parts)['partition_vertices'],1645);self.assertEqual(len(self.parts),99)
 def test_unchanged_uv_side_stream_association(self):
  uv={(x['source_object_id'],i,x['layer']):v for x in self.ir['optional_uv_stream'] for i,v in enumerate(x['values_by_triangle'])}
  def associate(parts):
   return {(part['source_object_id'],t['source_lod_triangle_index'],layer):uv[(part['source_object_id'],t['source_lod_triangle_index'],layer)] for part in parts for t in part['triangles'] for layer in {x['layer'] for x in self.ir['optional_uv_stream'] if x['source_object_id']==part['source_object_id']} if (part['source_object_id'],t['source_lod_triangle_index'],layer) in uv}
  self.assertEqual(associate(self.ir['parts']),associate(self.parts));self.assertEqual(sum(len(x) for x in associate(self.parts).values()),792)
 def test_duplicate_and_mutation_detection(self):
  v=copy.deepcopy(self.parts);v[0]['triangles'].append(copy.deepcopy(v[0]['triangles'][0]))
  with self.assertRaises(AssertionError):p.signatures(v)
  for kind in ('position','normal','material','winding','id'):
   v=copy.deepcopy(self.parts)
   if kind=='position':v[0]['vertices'][0]['world_xyz'][0]+=1
   elif kind=='normal':v[0]['vertices'][0]['normal_world_s32767'][0]+=1
   elif kind=='material':v[0]['material']='wrong'
   elif kind=='winding':v[0]['triangles'][0]['vertices'][0],v[0]['triangles'][0]['vertices'][1]=v[0]['triangles'][0]['vertices'][1],v[0]['triangles'][0]['vertices'][0]
   else:v[0]['triangles'][0]['source_lod_triangle_index']=999999
   self.assertNotEqual(p.signatures(self.ir),p.signatures(v))
 def test_input_pins_unchanged(self):
  for bits,pin in p.PINS.items():self.assertEqual(p.sha(p.INPUT/f'attributes-q{bits}-v2.json'),pin)
if __name__=='__main__':unittest.main()
