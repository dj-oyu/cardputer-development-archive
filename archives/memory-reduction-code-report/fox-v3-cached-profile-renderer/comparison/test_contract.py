import copy,json,tempfile,unittest
from pathlib import Path
from report_contract import compare_reports,validate_cache
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-aa-phase-overlay'
class ContractTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory();self.p=Path(self.tmp.name)/'contract.json';self.c=json.loads((R/'comparison/REPORT_CONTRACT.json').read_text());self.save()
 def tearDown(self):self.tmp.cleanup()
 def save(self):self.p.write_text(json.dumps(self.c))
 def compare(self,e,a,b,arm='off'):return compare_reports(e,a,b,self.p,arm)
 def row(self,arm='off'):
  old=json.loads((B/f'actual-{arm}-001/native-front-baseline.row.json').read_text());new=copy.deepcopy(old);new['adapterSpanPairs']+=28 if arm=='off' else 29;new['producerUsed'][10]+=28 if arm=='off' else 29;return old,new
 def test_exact(self):self.assertEqual(self.compare('.aa.json',{'a':1},{'a':1}),{})
 def test_unknown_difference(self):
  with self.assertRaises(AssertionError):self.compare('.aa.json',{'a':1},{'a':2})
 def test_added_counter(self):
  with self.assertRaises(AssertionError):self.compare('.aa.json',{'a':1},{'a':1,'counter':2})
 def test_off_row(self):a,b=self.row();self.compare('.row.json',a,b)
 def test_on_row(self):a,b=self.row('on');self.compare('.row.json',a,b,'on')
 def test_other_index(self):
  a,b=self.row();b['producerUsed'][9]+=1
  with self.assertRaises(AssertionError):self.compare('.row.json',a,b)
 def test_wrong_delta(self):
  a,b=self.row();b['producerUsed'][10]+=1
  with self.assertRaises(AssertionError):self.compare('.row.json',a,b)
 def test_cap(self):
  a,b=self.row();a['producerUsed'][10]=1000;b['producerUsed'][10]=1028
  with self.assertRaises(AssertionError):self.compare('.row.json',a,b)
 def test_frozen_required(self):
  self.c['status']='DRAFT_NOT_RUNNABLE';self.save()
  with self.assertRaises(AssertionError):self.compare('.aa.json',{}, {})
 def test_timing(self):self.compare('.background.json',{'backgroundBuildNs':1},{'backgroundBuildNs':2})
 def test_timing_missing(self):
  with self.assertRaises(KeyError):self.compare('.background.json',{}, {})
 def test_negative_timing(self):
  with self.assertRaises(AssertionError):self.compare('.background.json',{'backgroundBuildNs':1},{'backgroundBuildNs':-1})
 def test_changed_timing_schema(self):
  self.c['timing']['.row.json'].append('other');self.save()
  with self.assertRaises(AssertionError):self.compare('.row.json',{}, {})
 def test_all40_exact_declared_rows(self):
  for arm in ['off','on']:
   for f in json.loads((B/f'actual-{arm}-001/COMPLETED.json').read_text())['frames']:
    a=json.loads((B/f'actual-{arm}-001'/(f['name']+'.row.json')).read_text());b=copy.deepcopy(a);b['adapterSpanPairs']+=28 if arm=='off' else 29;b['producerUsed'][10]+=28 if arm=='off' else 29;self.compare('.row.json',a,b,arm)
class CacheTests(unittest.TestCase):
 def setUp(self):self.c={'complete':True,'cacheBytes':3224,'blobBytes':445248,'profileCalls':32400,'hits':100000,'misses':29600,'invalidations':0,'bindIndexEntries':4914,'bindValidatedRecords':4913,'coldPerFrame':True,'selectedVertexLookups':129600,'retainedSnapshotBytesUpper':1584}
 def test_valid(self):self.assertTrue(validate_cache(self.c))
 def test_extra(self):
  self.c['extra']=1
  with self.assertRaises(AssertionError):validate_cache(self.c)
 def test_wrong_sum(self):
  self.c['misses']+=1
  with self.assertRaises(AssertionError):validate_cache(self.c)
 def test_incomplete(self):
  self.c['complete']=False
  with self.assertRaises(AssertionError):validate_cache(self.c)
 def test_wrong_type(self):
  self.c['invalidations']=False
  with self.assertRaises(AssertionError):validate_cache(self.c)
if __name__=='__main__':unittest.main()
