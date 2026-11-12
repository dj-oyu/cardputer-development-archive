from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;source=W/'fox-v3-boundary-rho-affine-preflight/RESULT.json';d=json.load(open(source));assert d['status']=='ALL40_GEOMETRY_PREFLIGHT_COMPLETE';out={}
for arm in ['A','B']:
 rows=[r for r in d['rows'] if r['arm']==arm];assert len(rows)==20 and len({r['snapshotFNV'] for r in rows})==20
 lines=['#ifndef AA_PREFLIGHT_GENERATED_H','#define AA_PREFLIGHT_GENERATED_H','#include <stdint.h>','typedef struct {uint64_t snapshot;uint16_t hits[4];} aa_preflight_entry;','static const aa_preflight_entry aa_preflight_rows[20]={']
 for r in rows:lines.append('{UINT64_C(0x'+r['snapshotFNV']+'),{'+','.join(map(str,r['sampleHits']))+'}},')
 lines += ['};','static const uint16_t aa_preflight_targets[20]={'+','.join(str(r['targets']) for r in rows)+'};','_Static_assert(sizeof aa_preflight_rows+sizeof aa_preflight_targets==360,"preflight RO accounting");','static const aa_preflight_entry *aa_preflight_lookup(uint64_t hash){for(unsigned i=0;i<20;i++)if(aa_preflight_rows[i].snapshot==hash)return aa_preflight_rows+i;return 0;}','static int aa_preflight_actual_matches(const aa_preflight_entry*p,const uint64_t hits[4],uint64_t targets){if(!p)return 0;unsigned i=(unsigned)(p-aa_preflight_rows);if(i>=20||targets!=aa_preflight_targets[i])return 0;for(unsigned j=0;j<4;j++)if(hits[j]!=p->hits[j])return 0;return 1;}','#endif']
 p=R/'private'/f'preflight-{arm}.h';p.write_text('\n'.join(lines)+'\n');out[arm]={'headerSHA256':hashlib.sha256(p.read_bytes()).hexdigest(),'rows':rows,'ROBytes':360}
(R/'PREFLIGHT_CONTRACT.json').write_text(json.dumps({'sourceSHA256':hashlib.sha256(source.read_bytes()).hexdigest(),'arms':out,'exactAll20InputPins':d['inputPins'],'admissionCharge64':'20 lookup comparisons, 4 sum, 4 post-comparisons, target comparison and fixed control overhead'},indent=2)+'\n')
