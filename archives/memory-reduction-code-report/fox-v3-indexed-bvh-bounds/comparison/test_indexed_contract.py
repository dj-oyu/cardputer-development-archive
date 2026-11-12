import copy,json,tempfile,unittest
from pathlib import Path
from report_contract import read,compare_reports
from run_fixed40 import C,base_root
class IndexedContractTests(unittest.TestCase):
 def setUp(self):
  self.t=tempfile.TemporaryDirectory();self.p=Path(self.t.name)/'contract.json';self.c=read(C/'REPORT_CONTRACT.json');self.c['status']='FROZEN_REVIEWED_REPORT_CONTRACT';self.save()
  self.old=read(str(base_root('off','diagnostic')/'native-front-baseline')+'.json');self.new=copy.deepcopy(self.old);self.new['visibilitySceneBytes']=69276
 def save(self):self.p.write_text(json.dumps(self.c))
 def compare(self):return compare_reports('.json',self.old,self.new,self.p,'off','native-front-baseline','diagnostic')
 def tearDown(self):self.t.cleanup()
 def test_exact_scene_transition(self):self.compare()
 def test_wrong_scene_size(self):
  self.new['visibilitySceneBytes']+=1
  with self.assertRaises(AssertionError):self.compare()
 def test_counter_changes_fail(self):
  for k in ['visibilityTemporaryBytes','visibilitySceneNodes','visibilityVertices','visibilityTriangles','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportRays','transportNodeVisits','work']:
   old=self.new[k];self.new[k]+=1
   with self.assertRaises(AssertionError):self.compare()
   self.new[k]=old
 def test_forged_expected_delta_fails(self):
  self.c['cases']['diagnostic']['off']['native-front-baseline']['changes']['.json'][0]['candidate']+=1;self.new['visibilitySceneBytes']+=1;self.save()
  with self.assertRaises(AssertionError):self.compare()
 def test_other_field_allowlist_fails(self):
  self.c['cases']['diagnostic']['off']['native-front-baseline']['changes']['.json'][0]['path']=['visibilityNodeVisits'];self.save()
  with self.assertRaises(AssertionError):self.compare()
if __name__=='__main__':unittest.main()
