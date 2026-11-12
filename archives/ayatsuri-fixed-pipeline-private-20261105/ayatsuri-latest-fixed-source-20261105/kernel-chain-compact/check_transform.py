"""Check the only changes are storage names/lifetime and output ABI; no graph changes."""
import pathlib,hashlib,json
P=pathlib.Path(__file__).resolve().parent;old=P.parent/'kernel-chain-prototype/chain.c';s=old.read_text();changes=[('#include "chain.h"','#include "compact.h"'),('int kc_rho(','static int compact_rho('),('kc_output*out','aa_result*out'),('kc_output t;memset(&t,0,sizeof t);aa_state a;','aa_result t;memset(&t,0,sizeof t);aa_state a;'),('const kc_slot*v=&in->slots[j];','mc_output material;int32_t world[3],local[2];int16_t unit_normal[3];uint16_t rho[3];uint64_t radiance[3];\n  const kc_slot*v=&in->slots[j];'),('t.world[j]','world'),('t.local[j]','local'),('t.material[j]','material'),('t.normal[j]','unit_normal'),('t.rho[j]','rho'),('t.radiance[j]','radiance'),('kc_rho(','compact_rho('),('&t.final','&t'),('int kc_block(','int kcc_block('),('kc_output temp[8]','aa_result temp[8]')]
counts=[]
for a,b in changes:counts.append(dict(before=a,after=b,replacements=s.count(a)));s=s.replace(a,b)
assert s==(P/'compact.c').read_text()
(P/'storage-transform-proof.json').write_text(json.dumps(dict(frozen_audit_sha256=hashlib.sha256(old.read_bytes()).hexdigest(),compact_sha256=hashlib.sha256(s.encode()).hexdigest(),exact_text_after_declared_storage_substitutions=True,changes=counts),indent=2)+'\n')
