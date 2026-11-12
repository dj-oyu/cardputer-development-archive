from pathlib import Path
import hashlib,json,struct
from PIL import Image
P=Path(__file__).resolve().parent; ROOT=P.parent.parent; S=ROOT/'fox-cardputer-2d-face-private'
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
expected={'latest-fox-source-readonly/fox-bubble-bold.blend':'d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a','fox-cardputer-latest-private/fox-cardputer-2k-v2.blend':'384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8','fox-cardputer-2d-face-private/prototype-profile-tables.bin':'b02d4c83cca2bd9c2a26ebd20746b68c181f79c1adad96e9080a6ef35b49a222','fox-cardputer-2d-face-private/prototype-profile-tables.json':'81fc3049843e6a46dc698095bd71fe87444f7271d3a1d28c0a1f09dda9d7812b'}
for f,v in expected.items():assert h(ROOT/f)==v,f
manifest=json.loads((S/'MANIFEST.json').read_text())
# Check all relevant inputs, not unrelated output images or uploads.
inputs=['README.md','fox-2d-brows-mouth-prototype.blend','mask-spec.json','prototype-settings.json','extract_masks.py','make_masks.py','render_prototype.py','make_profile_tables.py','source-projected-strokes.json','source-feature-audit.json','prototype-profile-tables.bin','prototype-profile-tables.json']+[p.name for p in sorted(S.glob('*-mask.png'))]
for f in inputs:assert h(S/f)==manifest[f]['sha256'],f
binary=(S/'prototype-profile-tables.bin').read_bytes(); meta=json.loads((S/'prototype-profile-tables.json').read_text()); raw=[]; offsets=[0]; runs=[]; spans=[]; stats=[]
for i,t in enumerate(meta['tables']):
 im=Image.open(S/t['file']);assert im.mode=='L' and im.size==(128,64); a=list(im.get_flattened_data());raw+=a
 assert t['offset']==i*256 and t['bytes']==256
 assert hashlib.sha256(binary[i*256:(i+1)*256]).hexdigest()==t['sha256']
 nr=0; ns=0; aa=0
 for x in range(128):
  col=[a[y*128+x] for y in range(64)]; lo,hi=binary[i*256+x*2:i*256+x*2+2]
  for y,v in enumerate(col):assert (v>=128)==(lo!=255 and lo<=y<=hi)
  aa+=sum(0<v<255 for v in col)
  nz=[y for y,v in enumerate(col) if v]; start,end=(nz[0],nz[-1]+1) if nz else (0,0)
  spans.extend([start,end-start]+col[start:end]);ns+=2+end-start
  y=0
  while y<64:
   if col[y]==0:y+=1;continue
   e=y+1
   while e<64 and col[e]==col[y]:e+=1
   runs.extend([y,e-y,col[y]]);nr+=1;y=e
  offsets.append(len(runs)//3)
 stats.append({'file':t['file'],'aa_pixels':aa,'rle_runs':nr,'rle_payload_bytes':nr*3,'span_payload_bytes':ns})
assert max(offsets)<65536
rle=struct.pack('<1025H',*offsets)+bytes(runs)
(P/'r8-column-rle.bin').write_bytes(rle)
# Exact span alternative offsets enable one indexed byte read. Encode variable records.
so=[0];sb=[]
for m in range(8):
 for x in range(128):
  col=raw[m*8192+x:m*8192+8192:128]; nz=[y for y,v in enumerate(col) if v]; lo,hi=(nz[0],nz[-1]+1) if nz else (0,0)
  sb.extend([lo,hi-lo]+col[lo:hi]);so.append(len(sb))
assert max(so)<65536
(P/'r8-column-span.bin').write_bytes(struct.pack('<1025H',*so)+bytes(sb))
def decl(name,typ,vals):return 'static const '+typ+' '+name+'[]={'+','.join(map(str,vals))+'};\n'
(P/'data.h').write_text(decl('binary','uint8_t',binary)+decl('off','uint16_t',offsets)+decl('runs','uint8_t',runs)+decl('spanoff','uint16_t',so)+decl('spans','uint8_t',sb))
(P/'oracle-data.h').write_text(decl('raw','uint8_t',raw))
report={'validated_pixels':65536,'raw_bytes':len(raw),'binary_bytes':len(binary),'rle_bytes':len(rle),'rle_index_bytes':2050,'rle_max_runs_per_column':max(b-a for a,b in zip(offsets,offsets[1:])),'span_bytes':2050+len(sb),'span_index_bytes':2050,'masks':stats,'inputs':{str((S/f).relative_to(ROOT)):h(S/f) for f in inputs},'sources':expected}
(P/'encoding-report.json').write_text(json.dumps(report,indent=2));print(json.dumps({k:v for k,v in report.items() if k not in ['inputs','sources']},indent=2))
unique=[];state_map=[]
for m in range(8):
 block=bytes(raw[m*8192:(m+1)*8192])
 if block not in unique:unique.append(block)
 state_map.append(unique.index(block))
us=[0];up=[];ur=[0];rp=[]
for block in unique:
 for x in range(128):
  col=block[x::128];nz=[y for y,v in enumerate(col) if v];lo,hi=(nz[0],nz[-1]+1) if nz else (0,0)
  up.extend([lo,hi-lo]+list(col[lo:hi]));us.append(len(up));y=0
  while y<64:
   if col[y]==0:y+=1;continue
   e=y+1
   while e<64 and col[e]==col[y]:e+=1
   rp.extend([y,e-y,col[y]]);y=e
  ur.append(len(rp)//3)
for kind,idx,payload in [('span',us,up),('rle',ur,rp)]:
 blob=bytes(state_map)+struct.pack('<'+str(len(idx))+'H',*idx)+bytes(payload)
 (P/f'r8-unique-{kind}.bin').write_bytes(blob)
 # Independent byte-level decoder verifies the serialized deduplicated representation.
 ix=struct.unpack('<'+str(len(idx))+'H',blob[8:8+len(idx)*2]);data=blob[8+len(idx)*2:]
 for m in range(8):
  for x in range(128):
   c=blob[m]*128+x
   for y in range(64):
    if kind=='span':
     p=ix[c];lo,n=data[p:p+2];v=data[p+2+y-lo] if lo<=y<lo+n else 0
    else:
     v=0
     for r in range(ix[c],ix[c+1]):
      lo,n,a=data[r*3:r*3+3]
      if lo<=y<lo+n:v=a
    assert v==raw[m*8192+y*128+x]
 report['unique_'+kind]={'bytes':len(blob),'state_map_bytes':8,'offset_bytes':len(idx)*2,'payload_bytes':len(payload),'unique_masks':len(unique),'state_map':state_map,'verified_pixels':65536}
(P/'encoding-report.json').write_text(json.dumps(report,indent=2));print('DEDUP',report['unique_span'],report['unique_rle'])
