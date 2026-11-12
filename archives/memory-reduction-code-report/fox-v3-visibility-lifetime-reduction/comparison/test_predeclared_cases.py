"""Validate all 42 declared transformations using baseline reports only. No renderer."""
import copy,json,tempfile,unittest
from pathlib import Path
from report_contract import read,compare_reports,compare_sidecar,REPORTS
from run_fixed40 import B,C,base_root
class PredeclaredTests(unittest.TestCase):
 def test_all42_declared_reports(self):
  c=read(C/'REPORT_CONTRACT.json');c['status']='FROZEN_REVIEWED_REPORT_CONTRACT';count=0
  with tempfile.TemporaryDirectory() as t:
   p=Path(t)/'contract.json';p.write_text(json.dumps(c))
   for mode,arms in c['cases'].items():
    for arm,cases in arms.items():
     for name,case in cases.items():
      for extension in REPORTS:
       old=read(str(base_root(arm,mode)/name)+extension);new=copy.deepcopy(old)
       for rule in case['changes'].get(extension,[]):
        parent=new
        for key in rule['path'][:-1]:parent=parent[key]
        self.assertEqual(parent[rule['path'][-1]],rule['baseline']);parent[rule['path'][-1]]=rule['candidate']
       compare_reports(extension,old,new,p,arm,name,mode)
       bad=copy.deepcopy(new);bad['unannouncedField']=1
       with self.assertRaises(AssertionError):compare_reports(extension,old,bad,p,arm,name,mode)
      assert case['changes']=={}
      if case['sidecar'] is not None:compare_sidecar(case['sidecar'],p,arm,name,mode)
      count+=1
  self.assertEqual(count,42)
if __name__=='__main__':unittest.main()
