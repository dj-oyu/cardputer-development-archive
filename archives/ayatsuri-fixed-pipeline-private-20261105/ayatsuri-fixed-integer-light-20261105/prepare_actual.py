import json,struct,hashlib,pathlib
root=pathlib.Path(__file__).resolve().parent
source=root.parent/'fox-v3-floor-world-reflection/capture/on/native-front-baseline.samples.jsonl'
snapshot=root.parent/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot'
rows=[json.loads(line) for line in source.read_text().splitlines()];hits=[r for r in rows if r['hit']]
with (root/'actual-input.bin').open('wb') as f:
 for r in hits:f.write(struct.pack('<9d',*r['P'],*r['Ns'],*r['rho']))
meta={'hits':len(hits),'position_abs_max':max(abs(x) for r in hits for x in r['P']),'source':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'snapshot':str(snapshot),'snapshot_sha256':hashlib.sha256(snapshot.read_bytes()).hexdigest()}
(root/'actual-provenance.json').write_text(json.dumps(meta,indent=2)+'\n');print(json.dumps(meta))
