from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[1]; B=R.parent/'fox-v3-indexed-transport-input'; rel=Path('private-build/product/main/ayatsuri/ayatsuri_model.c')
a=(B/rel).read_text();b=(R/rel).read_text()
assert a.count('i->arena,i->arena_bytes')==13
assert b.count('i->arena,i->arena_bytes')==1
# Exact old init, disposal, evaluation, setter and geometry bodies must remain.
def body(s,name):
 start=s.index(name+'(');start=s.index('{',start); depth=1;k=start+1
 while depth:
  depth+=(s[k]=='{')-(s[k]=='}');k+=1
 return s[start:k]
unchanged=['ayatsuri_model_instance_init','ayatsuri_model_instance_dispose','ayatsuri_model_instance_evaluate','ayatsuri_model_instance_linear_light','ayatsuri_model_instance_disk_scene','mesh_packet','mesh_project','node_slot_bytes']
for name in unchanged: assert body(a,name)==body(b,name),name
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
out={'status':'PASS_SOURCE_INVARIANTS_NOT_RENDER_GATE','unchangedBodies':unchanged,'oldArenaGuardExpressions':13,'sourcePins':{str(p.relative_to(R)):sha(p) for p in [R/rel,R/rel.with_suffix('.h')]}}
for kind in ['build-product','build-adapter']:
 p=R/kind/'BUILD.json'
 if not p.exists():continue
 m=json.loads(p.read_text());stale=[]
 for name,digest in m['files'].items():
  q=R.parent/name
  if not q.exists() or sha(q)!=digest:stale.append(name)
 out[kind]={'dependencyCount':len(m['files']),'stale':stale,'binaryMatch':sha(R/kind/'native-render')==m['binarySHA256'],'manifestSHA256':sha(p)}
(R/'review/SOURCE_REVIEW.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
