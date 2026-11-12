from pathlib import Path
import json,hashlib
P=Path(__file__).resolve().parent;ROOT=P.parent.parent;S=ROOT/'fox-v3-camera-background-core'
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ranges={
 'background/background.c':[(69,74),(100,118)],'background/background.h':[(21,28),(41,55),(76,98)],
 'background/REPORT.md':[(1,13),(41,43)],'CORE_REPORT.md':[(1,11),(19,19),(27,31)],
 'CORE_SOURCE_FREEZE.json':[(1,9),(27,35)],
 'product/main/ui/kasane/ksn_scene_composition.h':[(4,18),(50,68)],
 'product/main/ui/kasane/ksn_scene_composition_impl.inc':[(42,59),(66,74),(83,100),(114,139),(142,163)],
 'product/main/ui/kasane/ksn_mesh_depth.c':[(130,153),(181,186)],
 'product/main/ui/kasane/ksn_boundary_aa.h':[(35,52),(57,65)],
 'product/main/ui/kasane/ksn_boundary_aa_impl.inc':[(76,85),(116,122),(158,167)],
 'product/main/ayatsuri/ayatsuri_shade.h':[(45,51)],
 'product/tools/ayatsuri/asset/import_glb.cjs':[(82,83),(125,133),(176,177)],
 'product/tools/ayatsuri/asset/compile_static.cjs':[(24,28)],
 'background/BYTE_PROOF.json':[(1,3)],'background/SOURCE_FREEZE.json':[], 'tests/source-preservation.json':[]}
hashes={f:h(S/f) for f in ranges};checks=[]
for f,key in [('CORE_SOURCE_FREEZE.json','production'),('background/SOURCE_FREEZE.json','productionFiles'),('background/SOURCE_FREEZE.json','evidenceFiles')]:
 for name,digest in json.loads((S/f).read_text())[key].items():
  if name in hashes:assert hashes[name]==digest,name;checks.append({'manifest':f,'path':name,'match':True})
for entry in json.loads((S/'tests/source-preservation.json').read_text())['files']:
 if entry['path'] in hashes:assert hashes[entry['path']]==entry['newSha256'];checks.append({'manifest':'tests/source-preservation.json','path':entry['path'],'match':True})
lines=['# Exact selected source excerpts; read-only audit\n']
for f,rs in ranges.items():
 if not rs:continue
 text=(S/f).read_text().splitlines();lines.append(f'\n## {f}\nSHA256 {hashes[f]}\n')
 for lo,hi in rs:
  lines.extend(f'{i}: {text[i-1]}' for i in range(lo,min(hi,len(text))+1))
(P/'SOURCE_EVIDENCE.md').write_text('\n'.join(lines)+'\n')
current={'latest-fox-source-readonly/fox-bubble-bold.blend':'d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a','fox-cardputer-latest-private/fox-cardputer-2k-v2.blend':'384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8'}
for f,digest in current.items():assert h(ROOT/f)==digest
(P/'source-audit.json').write_text(json.dumps({'root':'fox-v3-camera-background-core','audited_files_sha256':hashes,'manifest_matches':checks,'latest_assets_separate_no_binding_proven':current,'historical_asset_sha':'Not established by inspected source files/manifests','execution':'No existing renderer/importer/background/visibility function executed. Only read-only source/hash audit and independent scalar arithmetic.'},indent=2))
print('PASS:',len(hashes),'audited files;',len(checks),'selected manifest checks; latest source hashes unchanged')
