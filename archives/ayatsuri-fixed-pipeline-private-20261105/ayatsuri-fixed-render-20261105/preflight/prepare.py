from pathlib import Path
import json,re,struct,hashlib
W=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).parent
src=W/'fox-v3-indexed-bvh-bounds/private-build/product/main/ui/kasane/ksn_mesh_depth.c'
s=src.read_text();text=s[s.index('typedef struct {double a,b,c;int sign;bool closed;} gouraud_edge;'):s.index('\nstatic bool strip(')]
(D/'geometry_helpers.inc').write_text('/* Verbatim unchanged geometry helpers from pinned ksn_mesh_depth.c. */\n'+text+'\n')
p=json.loads((W/'ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json').read_text())['parts'];off=[0];entries=b''
for part in p:
 for t,o in zip(part['triangles'],part['origins']):
  sid=int(re.fullmatch(r'node/(\d+)/mesh/\d+/primitive/\d+',o['surface'])[1]);entries+=bytes(t)+struct.pack('<H',sid)
 off.append(off[-1]+len(part['triangles']))
b=struct.pack('<'+'H'*len(off),*off)+entries
old=(W/'fox-v3-floor-direct-reflection-evaluation/actual-002/private/identity.h').read_text();orig=bytes(map(int,re.search(r'=\{([^}]*)\}',old)[1].split(',')));assert b==orig
(D/'identity.bin').write_bytes(b)
(D/'identity_generated.h').write_text('static const unsigned char identity_bytes[] = {'+','.join(map(str,b))+'};\n')
(D/'PREPARATION.json').write_text(json.dumps({'identityBytes':len(b),'identityMatchesPrior':True,'sourceHelperSHA256':hashlib.sha256(src.read_bytes()).hexdigest(),'identitySHA256':hashlib.sha256(b).hexdigest()},indent=2)+'\n')
