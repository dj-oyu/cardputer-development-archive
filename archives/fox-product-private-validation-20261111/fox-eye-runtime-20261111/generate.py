import json,pathlib,struct
R=pathlib.Path(__file__).resolve().parent;W=R.parent
j=json.load(open(W/'fox-eye-contract-20261111/evaluated-contract.json'));m=json.load(open(W/'fox-eye-fixtures-20261111/mapping.json'));o=json.load(open(R/'oracle.json'))
def ff(x):return float(x).hex()+'f'
def arr(a):return '{'+','.join(arr(x) if isinstance(x,list) else ff(x) for x in a)+'}'
neutral={x['name']:x for x in j['fixtures'][0]['objects']};basis=[];indices=[];deltas=[];hidden=[[],[]]
for x in m['object_mapping']:
 n=neutral[x['name']];basis+=n['vertices_local']
 if x['id'] in (43,44):
  sh=o['shapes'][str(x['id'])];assert sh['Basis']==n['vertices_local']
  for i,(b,e) in enumerate(zip(sh['Basis'],sh['Blink'])):
   if b!=e:indices.append(x['vertex_start']+i);deltas.append([v-u for u,v in zip(b,e)])
 if x['name'].startswith(('Expressive eye contour','Expressive eye white','Outer eye corner')):hidden[0 if x['name'].endswith('-1') else 1].append(x['id'])
assert len(indices)==32
out=['/* Generated immutable source basis and sparse Blink-Basis. */','static const float fox_eye_basis[1322][3]='+arr(basis)+';', 'static const uint16_t fox_eye_delta_index[32]={'+','.join(map(str,indices))+'};','static const float fox_eye_delta[32][3]='+arr(deltas)+';','static const uint8_t fox_eye_hidden_index[2][3]={'+','.join('{'+','.join(map(str,h))+'}' for h in hidden)+'};','static const int8_t fox_runtime_material_mask[12]={'+','.join(str(m['mask_mapping'].get(m['material_mapping'][str(i)],-1)) for i in range(12))+'};']
# Exact source non-eye colors by name, never rely on global/local ID agreement.
nc=json.load(open(W/'fox-eye-contract-20261111/non_eye_base_colors.json'));colors={x['name']:x['linear_rgba'][:3] for x in nc['materials']};out.append('static const float fox_runtime_non_eye_rgb[12][3]='+arr([colors.get(m['material_mapping'][str(i)],[0,0,0]) for i in range(12)])+';')
(R/'eye_geometry.inc').write_text('\n'.join(out)+'\n')
(R/'generation.json').write_text(json.dumps({'source_sha256':j['source_sha256'],'changed_vertices':indices,'hidden_indices':hidden,'cold_geometry_bytes':1322*12+32*12+32*2+6+12,'old_fixture_geometry_bytes':13*1322*12},indent=2))
