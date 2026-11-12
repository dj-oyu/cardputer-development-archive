import json,pathlib,hashlib
P=pathlib.Path(__file__).resolve().parent
src=P.parent/'attribute-prototype/attributes-q20-v2.json';j=json.loads(src.read_text())
# Material binding is exact material identity; no nearest-source-face transfer.
fixtures=[]
for p in j['parts']:
 if 'eye white' not in p['material']:continue
 side=-1 if p['material'].endswith('-1') else 1
 for t in p['triangles']:
  fixtures.append(dict(part_id=p['part_id'],object_id=p['source_object_id'],material=p['material'],triangle=t['source_lod_triangle_index'],polygon=t['source_evaluated_polygon_id'],side=side,corners=[p['vertices'][i] for i in t['vertices']],bary_q14=[[16384,0,0],[8192,8192,0],[5462,5461,5461],[2048,6144,8192]]))
states=json.loads((P.parent/'material-prototype/control-fixtures.json').read_text());keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure']
out=dict(schema='supplied-numeric-tuples-v1',source=src.name,sha256=hashlib.sha256(src.read_bytes()).hexdigest(),source_blend_sha256=j['source_blend_sha256'],sidecar_sha256=j['input_sidecar_sha256'],position_basis='Blender world metres and own-object local metres independently; input Q20',normal_basis='per-corner Blender world /32767',states=[dict(name=n,q24=[round(c[k]*(1<<24)) for k in keys]) for n,c in states],fixtures=fixtures,excluded='All non-eye-white recipes; no face-mask composition',visibility=[[65535]*3,[0]*3,[21845,43690,3855]],light_fixture='synthetic: three centers (0,4,3),(2,-4,3),(-2,4,3), Q16 metres; normals -Y,+Y,-Y; 16 supplied equal center samples per light; power RGB (1,2,3) Q16; world RGB (1/8,1/4,1/2) Q24. Repeated point samples, not physical scene disks.',four_slots='declarative triangle vertex/edge/interior points, NOT actual pixel AA')
(P/'fixtures.json').write_text(json.dumps(out,indent=2)+'\n')
print(len(fixtures),len(states))
def c(v):return '{'+','.join(c(x) if isinstance(x,list) else str(x) for x in v)+'}'
text='/* Generated only from canonical latest attribute-v2 numeric tuples. */\nstatic const kc_input latest_inputs[]={\n'
for f in fixtures:
 vs=f['corners'];slots=[]
 for b in f['bary_q14']:slots.append([[[v['local_xyz'][0],v['local_xyz'][2]] for v in vs],[v['world_xyz'] for v in vs],[v['normal_world_s32767'] for v in vs],b,[65535]*3])
 text+=c([slots])+',\n'
text+='};\nstatic const int latest_sides[]='+c([f['side'] for f in fixtures])+';\nstatic const int32_t latest_controls[][9]='+c([s['q24'] for s in out['states']])+';\n'
(P/'fixtures.inc').write_text(text)
