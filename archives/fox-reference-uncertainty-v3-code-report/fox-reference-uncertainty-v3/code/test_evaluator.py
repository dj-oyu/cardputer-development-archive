import unittest,json,pathlib,sys
import numpy as np
import evaluator as E

class TestReferenceStability(unittest.TestCase):
 def delta(self,values):return np.array(values,dtype=float).reshape(8,1,1)/255
 def refs(self,values):
  a=np.full((8,1,1,3),.25);return a,a+np.array(values).reshape(8,1,1,1)/255
 def test_fixed_t_quantile(self):
  from scipy.stats import t
  self.assertAlmostEqual(E.T_CRIT,t.ppf(.975,7),places=13)
 def test_bright_dark_inactive(self):
  for val,name in [(3,'bright'),(-3,'dark'),(0,'inactive'),(2,'inactive'),(-2,'inactive')]:
   c=E.classify_deltas(self.delta([val]*8));self.assertTrue(c[name].item());self.assertFalse(c['uncertain'].item())
 def test_consensus_and_interval_are_both_required(self):
  c=E.classify_deltas(self.delta([3]*7+[2]));self.assertGreater(c['lower'].item(),E.T);self.assertTrue(c['uncertain'].item())
  c=E.classify_deltas(self.delta([3]*7+[9]));self.assertLess(c['lower'].item(),E.T);self.assertTrue(c['uncertain'].item())
 def test_inactive_boundary_interval_crossing_is_uncertain(self):
  c=E.classify_deltas(self.delta([2]*7+[0]));self.assertTrue(np.all(self.delta([2]*7+[0])<=E.T));self.assertTrue(c['uncertain'].item())
 def test_stable_inactive_keeps_candidate_false_positive(self):
  a,b=self.refs([0]*8);fg=np.ones((1,1),bool);c0=np.full((1,1,3),.25);c1=c0+3/255
  s,m=E.evaluate_response(a,b,fg,c0,c1);r=s['candidateScores']['stableSubset'];self.assertEqual(s['counts']['inactive'],1);self.assertEqual(r['brightening']['IoU'],0);self.assertEqual(r['brightening']['union'],1);self.assertEqual(r['directionAgreementPercent'],0)
 def test_all_uncertain_is_not_success(self):
  a,b=self.refs([3]*7+[9]);s,m=E.evaluate_response(a,b,np.ones((1,1),bool),a[0],b[0]);self.assertEqual(s['conditionScope'],'UNRESOLVED_UNCERTAIN_REMAINDER');self.assertIsNone(s['candidateScores']['stableSubset']['metrics']);self.assertEqual(s['candidateScores']['uncertainSubsetDescriptiveNotAcceptance']['pixels'],1)
 def test_empty_union_not_pass(self):
  a,b=self.refs([0]*8);s,m=E.evaluate_response(a,b,np.ones((1,1),bool),a[0],b[0]);r=s['candidateScores']['stableSubset'];self.assertIsNone(r['brightening']['IoU']);self.assertEqual(r['brightening']['valueStatus'],'N/A_NOT_PASS');self.assertIsNone(r['responseMagnitudeAgreementPercent'])
 def test_empty_foreground_not_pass(self):
  a,b=self.refs([3]*8);s,m=E.evaluate_response(a,b,np.zeros((1,1),bool),a[0],b[0]);self.assertEqual(s['conditionScope'],'NO_FOREGROUND');self.assertIsNone(s['stableCoverageFraction']);self.assertIsNone(s['candidateScores']['stableSubset']['metrics'])
 def test_mask_does_not_depend_on_candidate(self):
  a,b=self.refs([3]*8);fg=np.ones((1,1),bool);s,m=E.evaluate_response(a,b,fg,a[0],b[0]);t,n=E.evaluate_response(a,b,fg,np.zeros((1,1,3)),np.ones((1,1,3)));self.assertTrue(np.array_equal(m['stable'],n['stable']));self.assertEqual(s['counts'],t['counts'])
 def test_color_precision_is_not_color_match(self):
  a=np.zeros((8,1,1,3));s,m=E.evaluate_color(a,np.ones((1,1),bool),np.ones((1,1,3)));self.assertTrue(m['stable'].item());self.assertEqual(s['candidateScores']['stableSubset']['rgbAgreementPercent'],0)
 def test_color_per_channel(self):
  a=np.zeros((8,1,1,3));a[:,0,0,2]=[0,.1]*4;s,m=E.evaluate_color(a,np.ones((1,1),bool));self.assertTrue(m['uncertain'].item());self.assertIsNone(s['candidateScores'])
 def test_reference_only_does_not_claim_quality(self):
  a,b=self.refs([3]*8);s,m=E.evaluate_response(a,b,np.ones((1,1),bool));self.assertEqual(s['qualityScope'],'REFERENCE_ONLY_NO_CANDIDATE');self.assertIsNone(s['candidateScores'])
 def test_incomplete_nonfinite_and_wrong_masks_reject(self):
  a,b=self.refs([3]*8);fg=np.ones((1,1),bool)
  with self.assertRaises(ValueError):E.evaluate_response(a[:7],b[:7],fg)
  bad=a.copy();bad[0,0,0,0]=np.nan
  with self.assertRaises(ValueError):E.evaluate_response(bad,b,fg)
  with self.assertRaises(ValueError):E.evaluate_response(a,b,np.ones((1,1),int))
  with self.assertRaises(ValueError):E.evaluate_response(a,b,fg,a[0],None)
  bad=a.copy();bad[0,0,0,0]=2
  with self.assertRaises(ValueError):E.evaluate_color(bad,fg)
 def test_per_seed_display_order_retained(self):
  # Synthetic nonlinear display values are supplied per seed; mean of encoded values is retained.
  a=np.zeros((8,1,1,3));b=np.repeat(np.array([.1,.2,.3,.4,.5,.6,.7,.8])[:,None,None,None],3,axis=3);s,m=E.evaluate_response(a,b,np.ones((1,1),bool));self.assertAlmostEqual(m['mean'].item(),.45);self.assertNotAlmostEqual(m['mean'].item(),float(np.mean(b**2)))

class TestPngBoundaries(unittest.TestCase):
 def test_all_gray_png_boundary_origins(self):
  for start in range(254):
   a=np.full((8,1,1,3),start,np.uint8);b=np.full_like(a,start+2)
   for x,y in [(a,b),(b,a)]:
    st=E.classify_png8(x,y);self.assertTrue(st['inactive'].item());self.assertFalse(st['uncertain'].item())
 def test_png_consensus_ci_and_false_positive(self):
  a=np.full((8,1,1,3),64,np.uint8);b=a.copy();b[:7]+=3;b[7]+=2
  self.assertTrue(E.classify_png8(a,b)['uncertain'].item())
  b[7]=73;self.assertTrue(E.classify_png8(a,b)['uncertain'].item())
  fg=np.ones((1,1),bool);c0=np.zeros((1,1,3));c1=c0+3/255
  s,st=E.evaluate_response_png8(a,a,fg,c0,c1)
  self.assertEqual(s['candidateScores']['stableSubset']['brightening']['IoU'],0)
 def test_constant_correlation_is_undefined(self):
  for width in [15,51,100]:
   a=np.full((8,1,width,3),128,np.uint8);b=np.full_like(a,131)
   z=np.zeros((1,width,3));s,_=E.evaluate_response_png8(a,b,np.ones((1,width),bool),z,z+np.array([1/31,1/63,1/31]))
   self.assertIsNone(s['candidateScores']['stableSubset']['signedCorrelation'])
 def test_png_rejects_float(self):
  with self.assertRaises(ValueError):E.classify_png8(np.zeros((8,1,1,3)),np.zeros((8,1,1,3)))

if __name__=='__main__':
 suite=unittest.TestSuite([unittest.defaultTestLoader.loadTestsFromTestCase(TestReferenceStability),unittest.defaultTestLoader.loadTestsFromTestCase(TestPngBoundaries)]);r=unittest.TextTestRunner(verbosity=2).run(suite)
 out={'testsRun':r.testsRun,'failures':len(r.failures),'errors':len(r.errors),'success':r.wasSuccessful(),'scope':'synthetic only; no actual reference images/candidate pack available'}
 (pathlib.Path(__file__).resolve().parents[1]/'synthetic-results.json').write_text(json.dumps(out,indent=2));sys.exit(not r.wasSuccessful())
