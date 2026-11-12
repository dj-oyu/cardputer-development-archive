"""Read-only baseline/schedule proof; no renderer may execute."""
import unittest
from unittest.mock import patch
from report_contract import read,REPORTS
import run_fixed40 as r
class ScheduleTests(unittest.TestCase):
 def test_baseline_pins(self):
  p=read(r.C/'BASELINE_PINS.json');self.assertEqual(p['actualFrames'],0)
  for path,h in p['pins'].items():self.assertEqual(r.sha(path),h,path)
 def test_fixed42_and_modes(self):
  c=read(r.C/'REPORT_CONTRACT.json');p=read(r.C/'BASELINE_PINS.json');n=0
  self.assertIsNone(c['sidecarExtension']);self.assertEqual(len(REPORTS),9)
  for mode in ('diagnostic','production'):
   self.assertEqual(c['environmentByMode'][mode],{})
   for arm in ('off','on'):
    names=list(c['cases'][mode][arm]);self.assertEqual(names,p['cases'][arm] if mode=='diagnostic' else ['native-front-baseline'])
    self.assertEqual(names[0],'native-front-baseline')
    for name in names:
     case=c['cases'][mode][arm][name];self.assertEqual(case,{'changes':{},'sidecar':None})
     root=r.base_root(arm,mode);cmd=read(str(root/name)+'.command.json')
     self.assertEqual(cmd['environment']['HONE_DEPTH_CAPTURE'],'on' if mode=='diagnostic' else 'off')
     self.assertEqual(cmd['environment']['HONE_FLOOR_WORLD'],arm)
     n+=1
  self.assertEqual(n,42)
 def test_missing_gate_prevents_subprocess(self):
  with patch.object(r,'G',r.C/'NEVER_AUTHORIZED_GATE.json'),patch.object(r.subprocess,'Popen') as process:
   with self.assertRaises(FileNotFoundError):r.run('off','canary')
   process.assert_not_called()
 def test_no_actual_outputs_during_preparation(self):
  # Preparation invariant only; final execution review should not rerun this test.
  for mode in ('actual','production'):
   for arm in ('off','on'):self.assertFalse((r.R/f'{mode}-{arm}-001').exists())
if __name__=='__main__':unittest.main()
