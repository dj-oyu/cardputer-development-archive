from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];p=R/'private/BACKGROUND_INPUTS.json';j=json.load(open(p))
num=lambda x:float(x).hex()
a=lambda xs:'{'+','.join(num(x) for x in xs)+'}'
lines=['/* Pinned authored camera/material inputs and immutable snapshot counts, no model vertices. */','#ifndef FOX_CAMERA_BACKGROUND_INPUT_H','#define FOX_CAMERA_BACKGROUND_INPUT_H','#include <stdint.h>','typedef struct { uint64_t snapshot; unsigned case_index,view_index,reverse,slots,empty_slots,overrides; double camera[9],origin[3],view[3],clip[2],rho[3],le[3],world_rgb[3],world_strength; } fox_bg_fixed_input;','static const fox_bg_fixed_input fox_bg_inputs[20]={']
for r in j['rows']:
 lines += ['{UINT64_C(0x'+r['snapshotFNV']+'),'+','.join(map(str,[r['caseIndex'],r['viewIndex'],int(r['reverse']),r['runtimeSlots'],r['combinedEmptySlots'],r['expectedFinalFloorOverrides']]))+','+','.join([a(r['nativeCameraF32']),a(r['sourceOrigin']),a(r['sourceUnitView']),a([r['near'],r['far']]),a(r['rho']),a(r['le']),a(r['worldRGB']),num(r['worldStrength'])])+'},']
lines+=['};','#define FOX_BG_INPUT_JSON_SHA256 "'+hashlib.sha256(p.read_bytes()).hexdigest()+'"','#endif','']
(R/'private/background_input.h').write_text('\n'.join(lines))
