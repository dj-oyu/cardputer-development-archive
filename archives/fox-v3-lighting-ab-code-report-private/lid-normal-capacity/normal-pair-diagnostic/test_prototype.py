import unittest,struct,json
from pathlib import Path
from prototype import encode,decode,records,DIAG
R=Path(__file__).resolve().parent;manifest=json.loads((R/'dump-summary.json').read_text());original=(R/manifest['rows'][0]['file']).read_bytes()
class CodecTests(unittest.TestCase):
 def test_all20_exact_and_order(self):
  for row in manifest['rows']:
   raw=(R/row['file']).read_bytes();enc,audit=encode(raw);self.assertEqual(decode(enc),raw);self.assertEqual(enc[:416],raw[:416]);self.assertEqual(sum(x['eligibleRecord'] for x in audit),51)
 def test_one_component_mismatch_whole_record_fallback(self):
  data=bytearray(original);off,rec,nv,nt,stride,raw=records(original)[0];back=struct.unpack_from('<h',data,off+12+50)[0];changed=back+1 if back<32767 else back-1;struct.pack_into('<h',data,off+12+50,changed)
  enc,audit=encode(bytes(data));self.assertFalse(audit[0]['eligibleRecord']);self.assertEqual(audit[0]['eligibleVertices'],nv-1);self.assertEqual(audit[0]['savedBytesAfterAlignment'],0);self.assertEqual(records(enc,True)[0][1],bytes(data[off:off+len(rec)]));self.assertEqual(decode(enc),bytes(data))
 def test_int16_min_does_not_wrap(self):
  data=bytearray(original);off,*_=records(original)[0];struct.pack_into('<h',data,off+12+44,-32768);struct.pack_into('<h',data,off+12+50,-32768);enc,audit=encode(bytes(data));self.assertFalse(audit[0]['eligibleRecord']);self.assertGreater(audit[0]['frontInt16MinimumComponents'],0);self.assertEqual(decode(enc),bytes(data))
 def test_all_record_fallback_preserves_worst_case(self):
  data=bytearray(original)
  for off,rec,nv,nt,stride,raw in records(original):
   back=struct.unpack_from('<h',data,off+12+50)[0];struct.pack_into('<h',data,off+12+50,back+1 if back<32767 else back-1)
  enc,audit=encode(bytes(data));self.assertEqual(enc,bytes(data));self.assertEqual(len(enc),65216);self.assertEqual(sum(x['fallbackRecord'] for x in audit),51);self.assertEqual(decode(enc),bytes(data))
 def test_truncated_empty_length_mode_and_unusedbits(self):
  for cut in [0,415,417,len(original)-1]:
   with self.assertRaises(ValueError):encode(original[:cut])
  for field,value in [(0,0),(1,0),(2,3),(3,1)]:
   data=bytearray(original);data[416+field]=value
   with self.assertRaises(ValueError):encode(bytes(data))
  data=bytearray(original);struct.pack_into('<H',data,416+10,65535)
  with self.assertRaises(ValueError):encode(bytes(data))
  for off,rec,nv,nt,stride,raw in records(original):
   if nt%8:
    data=bytearray(original);data[off+raw-1]|=128
    with self.assertRaises(ValueError):encode(bytes(data))
    break
 def test_nonzero_padding_rejected(self):
  for off,rec,nv,nt,stride,raw in records(original):
   if raw<len(rec):
    data=bytearray(original);data[off+raw]=1
    with self.assertRaises(ValueError):encode(bytes(data))
    return
  self.fail('fixture missing padded record')
 def test_compact_minimum_rejected(self):
  enc,_=encode(original);data=bytearray(enc);struct.pack_into('<h',data,416+12+44,-32768)
  with self.assertRaisesRegex(ValueError,'INT16_MIN'):decode(bytes(data))
if __name__=='__main__':unittest.main()
