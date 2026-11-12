import copy,json,tempfile,unittest
from pathlib import Path
from report_contract import compare_reports,compare_sidecar,TIMING,exact,read
class ContractTests(unittest.TestCase):
 def setUp(self):
  self.t=tempfile.TemporaryDirectory();self.p=Path(self.t.name)/'c.json'
  self.c={'status':'FROZEN_REVIEWED_REPORT_CONTRACT','timing':TIMING,'cases':{'diagnostic':{'off':{'front':{'changes':{},'sidecar':{'complete':True}}}}},'sidecarExtension':'.streamed-depth.json','memoryDeclarations':{},'workDeclarations':{},'observerDeclarations':{},'environmentByMode':{}};self.save()
 def tearDown(self):self.t.cleanup()
 def save(self):self.p.write_text(json.dumps(self.c))
 def compare(self,a,b):return compare_reports('.aa.json',a,b,self.p,'off','front','diagnostic')
 def test_exact(self):self.compare({'n':4},{'n':4})
 def test_bool_not_integer(self):
  with self.assertRaises(AssertionError):self.compare({'n':0},{'n':False})
 def test_unknown(self):
  with self.assertRaises(AssertionError):self.compare({'n':4},{'n':5})
 def test_added(self):
  with self.assertRaises(AssertionError):self.compare({}, {'extra':1})
 def test_any_transition_forbidden(self):
  self.c['cases']['diagnostic']['off']['front']['changes']={'.aa.json':[{'path':['n',1],'baseline':2,'candidate':3}]};self.save()
  with self.assertRaises(AssertionError):self.compare({'n':[1,2]},{'n':[1,3]})
  with self.assertRaises(AssertionError):self.compare({'n':[1,2]},{'n':[1,4]})
 def test_frozen(self):
  self.c['status']='DRAFT';self.save()
  with self.assertRaises(AssertionError):self.compare({}, {})
 def test_timing(self):compare_reports('.background.json',{'backgroundBuildNs':1},{'backgroundBuildNs':2},self.p,'off','front','diagnostic')
 def test_negative_timing(self):
  with self.assertRaises(AssertionError):compare_reports('.background.json',{'backgroundBuildNs':1},{'backgroundBuildNs':-1},self.p,'off','front','diagnostic')
 def test_sidecar(self):
  compare_sidecar({'complete':True},self.p,'off','front','diagnostic')
  with self.assertRaises(AssertionError):compare_sidecar({'complete':1},self.p,'off','front','diagnostic')
 def test_duplicate(self):
  self.p.write_text('{"a":1,"a":2}')
  with self.assertRaises(AssertionError):read(self.p)
if __name__=='__main__':unittest.main()
