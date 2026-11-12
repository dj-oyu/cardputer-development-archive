from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent; S=P.parent/'face-mask-prototype';ROOT=P.parent.parent
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert (S/'SHA256SUMS').read_bytes()==(P/'prototype-frozen.sha256').read_bytes()
for line in (P/'prototype-frozen.sha256').read_text().splitlines():
 digest,name=line.split(maxsplit=1);assert h(S/name)==digest,name
r=json.loads((P/'encoding-report.json').read_text())
for name,digest in {**r['inputs'],**r['sources']}.items():assert h(ROOT/name)==digest,name
blob=(P/'r8-unique-span.bin').read_bytes();assert blob==(S/'r8-unique-span.bin').read_bytes() and len(blob)==7963
assert list(blob[:8])==[0,1,2,3,4,5,4,4]
idx=[int.from_bytes(blob[8+i*2:10+i*2],'little') for i in range(769)]
assert idx[0]==0 and idx[-1]==6417
for a,b in zip(idx,idx[1:]):
 assert 0<=a<=b<=6417 and b-a>=2
 start,n=blob[1546+a:1548+a];assert start+n<=64 and n+2==b-a
(P/'compact-data.h').write_text('static const uint8_t face_compact_blob[7963]={'+','.join(map(str,blob))+'};\n_Static_assert(sizeof(face_compact_blob)==7963,"compact blob size");\n')
(P/'bindings.json').write_text(json.dumps({'inherited_input_hashes':r['inputs'],'source_hashes':r['sources'],'frozen_prototype_manifest_sha256':h(P/'prototype-frozen.sha256'),'compact_blob_sha256':h(P/'r8-unique-span.bin'),'table_bytes':7963,'table_layout':{'state_map':8,'little_endian_offsets':1538,'span_payload':6417},'source_bindings':{f:h(S/f) for f in ['sampler.c','sampler.h','test.c','oracle-data.h','README.md']}},indent=2))
print('PASS: frozen prototype, source/candidate hashes, compact layout verified')
