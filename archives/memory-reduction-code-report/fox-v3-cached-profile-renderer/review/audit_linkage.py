"""Independent ELF payload and call-linkage audit. No renderer execution."""
from pathlib import Path
import struct,hashlib,json,re,subprocess
R=Path(__file__).resolve().parents[1];W=R.parent
sha=lambda b:hashlib.sha256(b).hexdigest()
def elf(path):
 data=path.read_bytes();assert data[:6]==b'\x7fELF\x02\x01'
 hdr=struct.unpack_from('<16sHHIQQQIHHHHHH',data);off,sz,n=hdr[6],hdr[11],hdr[12]
 secs=[struct.unpack_from('<IIQQQQIIQQ',data,off+i*sz) for i in range(n)]
 out={}
 for sec in secs:
  if sec[1]!=2:continue
  strings=secs[sec[6]];strings=data[strings[4]:strings[4]+strings[5]]
  for pos in range(sec[4],sec[4]+sec[5],sec[9]):
   name,info,other,ix,val,size=struct.unpack_from('<IBBHQQ',data,pos)
   name=strings[name:strings.index(0,name)].decode()
   if name and ix and ix<len(secs):
    target=secs[ix];at=target[4]+val-target[3]
    out[name]={'address':val,'size':size,'flags':target[2],'data':data[at:at+size]}
 return data,out
base,bs=elf(W/'fox-v3-aa-phase-overlay/build-product/native-render');raw=bs['agx_lut']['data'];assert len(raw)==65**3*3*2
header=(W/'fox-v3-lossless-profile-lut/profile/private/profile_data.h').read_text();blob=bytes(map(int,re.search(r'agx_encoded\[\]\s*=\s*\{(.*?)\}',header,re.S).group(1).replace('\n','').strip().strip(',').split(',')))
results={}
for arm in ('build-product','build-adapter'):
 p=R/arm/'native-render';data,syms=elf(p)
 assert not any('agx_lut' in name for name in syms),'raw symbol linked'
 assert raw not in data,'full raw table linked'
 matches=[(name,s) for name,s in syms.items() if s['data']==blob]
 assert len(matches)==1 and data.count(blob)==1,'compressed payload not singleton'
 name,s=matches[0];assert not s['flags']&1,'compressed payload writable'
 for expected in ('agx_cache_profile_eval','agx_cache_fetch4'):
  assert expected in syms,expected
 dis=subprocess.check_output(['objdump','-d',str(p)],text=True)
 callers={}
 for target in ('row_transport_render_cached_bands','ksn_mesh_pixel_render_cached_depth_bands_private','cached_encode','agx_cache_profile_eval','agx_cache_fetch4'):
  current='';found=[]
  for line in dis.splitlines():
   m=re.match(r'[0-9a-f]+ <([^>]+)>:',line)
   if m:current=m[1]
   if re.search(r'\b(call|jmp)\b',line) and '<'+target+'>' in line:found.append(current)
  assert found,target
  callers[target]=sorted(set(found))
 assert 'main' in callers['row_transport_render_cached_bands']
 assert 'row_transport_render_cached_bands' in callers['ksn_mesh_pixel_render_cached_depth_bands_private']
 assert 'ksn_mesh_pixel_render_cached_depth_bands_private' in callers['cached_encode']
 assert 'cached_encode' in callers['agx_cache_profile_eval']
 assert 'agx_cache_profile_eval' in callers['agx_cache_fetch4']
 results[arm]={'binarySHA256':sha(data),'encodedSymbol':name,'encodedBytes':len(blob),'encodedSHA256':sha(blob),'encodedReadOnly':True,'encodedCopies':1,'rawSymbolAbsent':True,'rawFullPayloadAbsent':True,'directCallers':callers}
out={'status':'PASS_PAYLOAD_AND_LINKAGE','rawComparisonBytes':len(raw),'rawBaselineSHA256':sha(raw),'builds':results,'qualification':'Symbol and direct-call linkage proves available cache path; actual invocation requires runtime counters and fixed40 evidence.'}
(R/'review/LINKAGE.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
