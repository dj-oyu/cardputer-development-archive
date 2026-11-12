import unittest,json,sys
from pathlib import Path
R=Path(__file__).resolve().parents[1];W=R.parent;sys.path.insert(0,str(W/'fox-v3-normal-pair-capacity'));from prototype import encode,records
from codec_audit import audit
contract=json.loads((R/'inputs/codec-contract.json').read_text());dumps=json.loads((W/'fox-v3-normal-pair-capacity/dump-summary.json').read_text())
class Audit(unittest.TestCase):
 def test_all20_off_on_contract(self):
  for x in dumps['rows']:
   raw=(W/'fox-v3-normal-pair-capacity'/x['file']).read_bytes();audit(raw,contract,0,x['view'],x['case'],x['reverse']);enc,_=encode(raw);enc=bytearray(enc)
   for off,*_ in records(enc,True):enc[off+2]=5
   audit(bytes(enc),contract,1,x['view'],x['case'],x['reverse'])
 def test_wrong_contract_mode_rejected(self):
  x=dumps['rows'][0];raw=(W/'fox-v3-normal-pair-capacity'/x['file']).read_bytes()
  with self.assertRaises(AssertionError):audit(raw,contract,1,x['view'],x['case'],x['reverse'])
 def test_actual_counter_types_rejected(self):
  x=dumps['rows'][0];raw=(W/'fox-v3-normal-pair-capacity'/x['file']).read_bytes();actual={'normalPairCodecEnabled':False,'normalPairMode4Records':51,'normalPairMode5Records':0,'normalPairSavedBytes':0,'visibilitySnapshotFingerprint':x['snapshotFingerprint']}
  audit(raw,contract,0,x['view'],x['case'],x['reverse'],actual)
  for key in ['normalPairMode4Records','normalPairMode5Records','normalPairSavedBytes']:
   for invalid in [float(actual[key]),False,True,-1,None]:
    m=dict(actual);m[key]=invalid
    with self.assertRaisesRegex(AssertionError,'integer required'):audit(raw,contract,0,x['view'],x['case'],x['reverse'],m)
   m=dict(actual);del m[key]
   with self.assertRaisesRegex(AssertionError,'integer required'):audit(raw,contract,0,x['view'],x['case'],x['reverse'],m)
 def test_wrong_scene_byte_rejected(self):
  x=dumps['rows'][0];raw=bytearray((W/'fox-v3-normal-pair-capacity'/x['file']).read_bytes());raw[16]^=1
  with self.assertRaisesRegex(AssertionError,'decoded snapshot'):audit(bytes(raw),contract,0,x['view'],x['case'],x['reverse'])
if __name__=='__main__':unittest.main()
