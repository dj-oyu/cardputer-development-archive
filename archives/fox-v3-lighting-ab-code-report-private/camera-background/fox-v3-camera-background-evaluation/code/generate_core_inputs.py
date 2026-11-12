from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;P=W/'fox-v3-camera-background-plan';j=json.load(open(P/'CORE-WORK-DESIGN.json'));keys=j['coreCategoryOrder'];assert len(keys)==20
f=lambda b:__import__('functools').reduce(lambda h,x:((h^x)*1099511628211)&((1<<64)-1),b,14695981039346656037)
lines=['#ifndef FOX_SCENE_CORE_INPUT_H','#define FOX_SCENE_CORE_INPUT_H','#include <stdint.h>','static const uint64_t fox_scene_limits[2][2][20]={']
for view in ['front','oblique']:
 lines.append('{')
 for mode in ['combinedCoreReservedLedger','backgroundOnlyCoreReservedLedger']:
  a=j['views'][view][mode];assert set(a)==set(keys);vals=[a[k] for k in keys];assert sum(vals)<=1680000;lines.append('{'+','.join(str(x) for x in vals)+'},')
 lines.append('},')
lines+=['};','static const uint64_t fox_scene_mask_hash[2]={']
for view in ['front','oblique']:
 p=W/f'fox-v3-boundary-rho-affine-evaluation/actual-A2/on/private-partial/native-{view}-baseline.targets.u8';a=p.read_bytes();assert len(a)==32400 and set(a)<={0,1};b=bytearray(4050)
 for i,v in enumerate(a):b[i>>3]|=v<<(i&7)
 (R/'private'/f'target-{view}.bits').write_bytes(b);lines.append('UINT64_C(0x%016x),'%f(b))
lines+=['};','#endif',''];(R/'private/scene_core_input.h').write_text('\n'.join(lines));print(keys)
