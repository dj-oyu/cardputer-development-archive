#!/usr/bin/env python3
"""Serialize authenticated candidate metadata, never derive counts from old hash aliases."""
from pathlib import Path
import json,hashlib,re
R=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).resolve().parent;P=D.parent/'preflight';H=D/'generated-v2';H.mkdir()
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,s):
 with p.open('x') as f:f.write(s)
def jwrite(p,j):write(p,json.dumps(j,indent=2)+'\n')
meta=json.loads((D/'METADATA_RESULT.json').read_text());assert meta['status']=='THREE_FRONT_METADATA_COMPLETE_NO_SHADED_FRAMES';rows=meta['rows'];assert [r['kind'] for r in rows]==['baseline','q16','q20'];assert len(set(r['snapshotFNV'] for r in rows))==3 and all(int(r['snapshotFNV'],16) for r in rows)
assert all(r['targets']==2385 and r['targetPackedFNV']==rows[0]['targetPackedFNV'] and r['sceneCategoryLimits']==rows[0]['sceneCategoryLimits'] for r in rows)
source={'status':'THREE_GENUINE_FRONT_ROWS','metadataResultSHA256':sha(D/'METADATA_RESULT.json'),'metadataFreezeSHA256':meta['freezeSHA256'],'capacity':20,'activeRows':3,'inactiveRows':'zero-initialized; nonzero admitted snapshots cannot match','rows':rows}
jwrite(H/'CANDIDATE_INPUTS.json',source)
# Reuse exact helper APIs and fixed-size accounting, change only initialized row data.
old=R/'fox-v3-floor-direct-reflection-evaluation/actual-002/private'
s=(old/'preflight.h').read_text();start=s.index('static const aa_preflight_entry aa_preflight_rows[20]={');end=s.index('};',start)+2
new='static const aa_preflight_entry aa_preflight_rows[20]={\n'+''.join('{UINT64_C(0x'+r['snapshotFNV']+'),{'+','.join(map(str,r['quarterHits']))+'}},\n' for r in rows)+'};';s=s[:start]+new+s[end:];s=re.sub(r'static const uint16_t aa_preflight_targets\[20\]=\{[^}]+\};','static const uint16_t aa_preflight_targets[20]={2385,2385,2385};',s);write(H/'preflight.h',s)
s=(old/'floor_input.h').read_text();start=s.index('static const floor_input_row floor_input_rows[20]={');end=s.index('};',start)+2;new='static const floor_input_row floor_input_rows[20]={\n'+''.join('{UINT64_C(0x'+r['snapshotFNV']+'),0,UINT64_C('+str(r['shaders'])+'),UINT64_C('+str(r['floorHits'])+')},\n' for r in rows)+'};';write(H/'floor_input.h',s[:start]+new+s[end:])
oldbg=R/'fox-v3-camera-background-evaluation/actual-002/private';s=(oldbg/'background_input.h').read_text();start=s.index('static const fox_bg_fixed_input fox_bg_inputs[20]={');end=s.index('};',start)+2
num=lambda x:float(x).hex();arr=lambda xs:'{'+','.join(map(num,xs))+'}'
new='static const fox_bg_fixed_input fox_bg_inputs[20]={\n'
for r in rows:
 b=r['background'];c=r['sourceCameraFields'];new+='{UINT64_C(0x'+r['snapshotFNV']+'),0,0,0,'+','.join(map(str,[b['slots'],b['emptySlots'],b['overrides']]))+','+','.join([arr(c['nativeCameraF32']),arr(c['sourceOrigin']),arr(c['sourceUnitView']),arr([c['near'],c['far']]),arr(c['rho']),arr(c['le']),arr(c['worldRGB']),num(c['worldStrength'])])+'},\n'
new+='};';s=s[:start]+new+s[end:];s=re.sub(r'#define FOX_BG_INPUT_JSON_SHA256 "[0-9a-f]+"','#define FOX_BG_INPUT_JSON_SHA256 "'+sha(H/'CANDIDATE_INPUTS.json')+'"',s);write(H/'background_input.h',s)
# Nonadmitted oblique/background-only table entries retain the original envelope;
# runtime runner must prohibit those modes. Front combined entry must independently match.
s=(oldbg/'scene_core_input.h').read_text();first=re.search(r'\{([0-9,]+)\}',s);assert list(map(int,first.group(1).split(',')))==rows[0]['sceneCategoryLimits'];assert rows[0]['targetPackedFNV'] in s;write(H/'scene_core_input.h',s)
ledger=[]
for r in rows:
 k=r['kind'];l=json.loads((P/(k+'-front.aa-ledger.json')).read_text());assert l['snapshotFNV']==r['snapshotFNV'] and l['sampleHits']==r['quarterHits'] and l['targets']==r['targets'];assert l['counterDispatchConservativeBound']<=310000
 vals=[]
 for name,c in l['categories'].items():vals.append(310000 if name=='counterGuardDispatches' else c['reserved'])
 assert len(vals)==21 and sum(vals)<=8000000
 write(H/(k+'-front.ledger.txt'),' '.join(map(str,vals))+'\n');ledger.append({'kind':k,'sourceLedgerSHA256':sha(P/(k+'-front.aa-ledger.json')),'derivedGuardNeed':l['counterDispatchConservativeBound'],'derivedRoundedReservation':l['categories']['counterGuardDispatches']['reserved'],'retainedGuardCapacity':310000,'reservedTotal':sum(vals),'ledgerSHA256':sha(H/(k+'-front.ledger.txt'))})
 if k=='baseline':assert (H/(k+'-front.ledger.txt')).read_bytes()==(R/'fox-v3-floor-direct-reflection-evaluation/actual-002/ledger-front.txt').read_bytes()
jwrite(H/'LEDGER_CONTRACT.json',{'status':'DERIVED_GUARDS_WITH_RETAINED_ORIGINAL_CONSERVATIVE_CAPACITY','originalBaselineLedgerByteExact':True,'rows':ledger})
jwrite(H/'MANIFEST.json',{'status':'GENERATED_NOT_BUILT_NOT_RENDERED','activeSnapshotRows':3,'capacity':20,'floorCategoryParityOriginal':True,'sceneCategoryReservationsOriginalExact':True,'files':{p.name:sha(p) for p in H.iterdir() if p.is_file()},'sourceGeneratorSHA256':sha(__file__)})
print('GENERATED_NOT_BUILT_NOT_RENDERED')
