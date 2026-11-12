#!/usr/bin/env python3
"""Construct PRIVATE exact cube4 blob and exhaustively check the C decoder."""
import ctypes, hashlib, json, pathlib, re, struct, subprocess, time
import measure_lossless as m
ROOT=pathlib.Path(__file__).resolve().parent
SRC=pathlib.Path('fox-v3-profile-integration-feasibility/build-private/agx_lut.inc')
s=SRC.read_bytes();lut=list(map(int,re.findall(r'\d+',s.decode().split('{',1)[1].split('}',1)[0])))
data=bytearray();offsets=[0];blockmeta=[]
for ids,sh in m.blocks(('cube',4)):
 records=[]
 for c in range(3):
  v=[lut[i*3+c] for i in ids];record=m.encode(m.options(v,sh,True));data+=record;records.append((record,v))
 offsets.append(len(data));blockmeta.append((ids,sh,records))
head=struct.pack('<8sHHIIIII',b'AGXL4R01',65,4,4913,32+4*4914+len(data),32,19688,0)
blob=head+struct.pack('<4914I',*offsets)+data
private=ROOT/'private';private.mkdir(exist_ok=True);(private/'agx_cube4_rice.bin').write_bytes(blob)
subprocess.run(['cc','-Os','-shared','-fPIC',str(ROOT/'block_decoder.c'),'-o',str(ROOT/'block_decoder.so')],check=True)
lib=ctypes.CDLL(str(ROOT/'block_decoder.so'));ptr=ctypes.POINTER(ctypes.c_uint8);u16=ctypes.POINTER(ctypes.c_uint16)
lib.lossless_decode_channel.argtypes=[ptr,ctypes.c_size_t,ctypes.c_uint,ctypes.c_uint,ctypes.c_uint,u16];lib.lossless_decode_channel.restype=ctypes.c_size_t
lib.lossless_fetch.argtypes=[ptr,ctypes.c_size_t,ctypes.c_uint32,u16];lib.lossless_fetch.restype=ctypes.c_int
for ids,sh,records in blockmeta:
 for r,v in records:
  buf=(ctypes.c_uint8*len(r)).from_buffer_copy(r);out=(ctypes.c_uint16*64)();used=lib.lossless_decode_channel(buf,len(r),*sh,out)
  assert used==len(r) and list(out)[:len(v)]==v
buf=(ctypes.c_uint8*len(blob)).from_buffer_copy(blob);out=(ctypes.c_uint16*3)();t=time.perf_counter()
for i in range(65**3):
 assert lib.lossless_fetch(buf,len(blob),i,out)==1 and list(out)==lut[i*3:i*3+3],i
elapsed=time.perf_counter()-t
# Public fetch output must remain unchanged for every tested rejected blob.
tests=[]
def reject(name,b,vertex=0):
 arr=(ctypes.c_uint8*len(b)).from_buffer_copy(b);o=(ctypes.c_uint16*3)(123,456,789)
 assert lib.lossless_fetch(arr,len(b),vertex,o)==0 and list(o)==[123,456,789],name
 tests.append(name)
for n in (0,31,19687,len(blob)-1):reject('truncated_'+str(n),blob[:n])
reject('vertex_oob',blob,274625)
for at,val in ((0,0),(8,64),(10,8),(12,0),(16,0),(20,0),(24,0),(28,1),(32,1),(19688,4),(19689,17)):
 b=bytearray(blob);b[at]=val;reject('bad_field_'+str(at),b)
b=bytearray(blob);struct.pack_into('<I',b,36,0);reject('empty_block',b)
b=bytearray(blob);struct.pack_into('<I',b,36,len(data)+1);reject('offset_past_end',b)
# Replace first block with syntactically selected Rice stream whose all-zero
# unary prefix runs past the selected record; bounded by selected block end.
b=bytearray(blob);b[19688:19688+offsets[1]]=bytes(offsets[1]);b[19688]=5;reject('unterminated_unary',b)
r=dict(input_sha256=hashlib.sha256(s).hexdigest(),blob_sha256=hashlib.sha256(blob).hexdigest(),blob_bytes=len(blob),channel_values_verified=823875,vertices_verified=274625,uint16_values_verified_by_fetch=823875,host_fetch_exhaustive_seconds=elapsed,rejection_tests=tests,private_blob_path=str(private/'agx_cube4_rice.bin'))
(ROOT/'c_verification.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
