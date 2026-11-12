#!/usr/bin/env python3
import hashlib,json,pathlib
root=pathlib.Path(__file__).resolve().parents[1]
old=root.parent/'fox-v3-boundary-rho-affine-evaluation/actual-A2'
h=lambda b:hashlib.sha256(b).hexdigest()
rows=[]
for name in ['product','physical','visibility','transport']:
 for p in sorted((old/name).rglob('*')):
  if not p.is_file():continue
  rel=p.relative_to(old);a=p.read_bytes();b=(root/rel).read_bytes()
  if str(rel)=='product/main/ui/kasane/ksn_mesh_depth.c':
   assert b==a+b'\n/* Separate full-scene camera composition; frozen A2 above remains intact. */\n#include "ksn_scene_composition_impl.inc"\n',(str(rel),b[len(a):])
   mode='EXACT_ORIGINAL_PREFIX_ONLY_NEW_INCLUDE_APPENDED'
  else:assert a==b,str(rel);mode='BYTE_EXACT'
  rows.append({'path':str(rel),'oldSha256':h(a),'newSha256':h(b),'proof':mode})
contract=json.loads((root/'CORE_WORK_CONTRACT.json').read_text())
assert h((root/'CORE_WORK_CONTRACT.json').read_bytes())=='d9b37e3c31691f6b9a0ea654f9b592d86a4e9ba435afc48a08cc12fbee06898b'
assert len(contract['coreCategoryOrder'])==20
source=(root/'product/main/ui/kasane/ksn_scene_composition_impl.inc').read_text()
for name in contract['coreCategoryOrder']:assert '"'+name+'"' in source
out={'status':'PASS','originalFiles':len(rows),'legacyFilesExactExceptAppendOnlyHook':True,'pinnedWorkContract':True,'files':rows}
(root/'tests/source-preservation.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':'PASS','originalFiles':len(rows),'legacyFilesExactExceptAppendOnlyHook':True,'pinnedWorkContract':True}))
