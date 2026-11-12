"""Regression review of converter fixes; bytecode disabled, all writes in kernel."""
import sys
sys.dont_write_bytecode=True
import importlib.util, pathlib, struct, zlib, tempfile, subprocess, json, hashlib
from unittest.mock import patch
path = pathlib.Path(__file__).resolve().parent.parent/'converter/compile_fixed.py'
spec=importlib.util.spec_from_file_location('reviewed_converter',path)
c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)
src={'schema':'ayatsuri-fixed-static-input-v1','coordinate_system':'ayatsuri-native-metres','source_units':'metres','geometry_scale':1,'source_mode':'baked-static','parts':[{'positions':[[0,0,0],[1,0,0],[0,1,0]],'normals':[[0,0,1]]*3,'triangles':[[0,1,2]],'materialId':'m','materialSidedness':'single'}],'materialTrace':[{'id':'m','scaledLinear':[.5,.25,1]}]}
print('source_sha256',hashlib.sha256(path.read_bytes()).hexdigest())
for key in ('schema','coordinate_system','source_units','geometry_scale','source_mode'):
 bad=src.copy();bad.pop(key)
 try:c.compile_report(bad)
 except ValueError:pass
 else:raise AssertionError('missing marker accepted '+key)
print('PASS: all five source contract markers required')
blob,stats=c.compile_report(src);mut=bytearray(blob)
_,*f=c.HEADER.unpack_from(blob);bo=f[10]
for axis in range(3):struct.pack_into('<h',mut,bo+96+axis*16,32767)
struct.pack_into('<I',mut,60,0);struct.pack_into('<I',mut,60,zlib.crc32(mut))
try:c.decode(mut)
except ValueError as e:assert str(e)=='encoded normal length'
else:raise AssertionError('nonunit normal accepted')
print('PASS: CRC-valid nonunit normal rejected')
with tempfile.TemporaryDirectory(dir=pathlib.Path(__file__).resolve().parent) as td:
 d=pathlib.Path(td); inp=d/'input.json';out=d/'result.ayfq';inp.write_text(json.dumps(src));side=d/'result.ayfq.json';side.write_text('existing sidecar')
 r=subprocess.run(['python3',str(path),str(inp),str(out)],capture_output=True,text=True)
 assert r.returncode!=0 and not out.exists() and side.read_text()=='existing sidecar'
 try:c.write_pair_new(out,blob,stats)
 except FileExistsError:pass
 else:raise AssertionError('existing sidecar accepted')
 assert not out.exists() and side.read_text()=='existing sidecar'
 side.unlink()
 with patch.object(c.os,'write',side_effect=OSError('injected write failure')):
  try:c.write_pair_new(out,blob,stats)
  except OSError:pass
  else:raise AssertionError('write failure ignored')
 assert not out.exists() and not side.exists()
 c.write_pair_new(out,blob,stats);assert out.read_bytes()==blob and json.loads(side.read_text())==stats
print('PASS: CLI existing-sidecar rejection, API existing-sidecar cleanup, injected write-failure cleanup, successful pair write')
