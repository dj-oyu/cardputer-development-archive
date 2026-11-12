import ctypes as C,json,pathlib,math,hashlib
R=pathlib.Path(__file__).resolve().parent;W=R.parent
class Controls(C.Structure):_fields_=[(n,C.c_float) for n in ['blink_both','blink_neg','blink_pos','gaze_x','gaze_up','eye_style','show_highlights','environment_reflection','bubble_pressure']]
class Snapshot(C.Structure):_fields_=[('controls',Controls),('local',(C.c_float*3)*1322),('hidden',C.c_uint8*74)]
f=C.CDLL(str(R/'runtime.so')).fox_eye_snapshot_build;f.argtypes=[C.POINTER(Snapshot),C.POINTER(Controls)];f.restype=C.c_bool
j=json.load(open(W/'fox-eye-contract-20261111/evaluated-contract.json'));mp=json.load(open(W/'fox-eye-fixtures-20261111/mapping.json'))['object_mapping'];oracle=json.load(open(R/'oracle.json'));neutral={o['name']:o for o in j['fixtures'][0]['objects']};mx=0;changed=set();exact_neutral=True
s=Snapshot();cases=[]
keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure']
for fixture in j['fixtures']:
 om={o['name']:o for o in fixture['objects']};cases.append(([fixture['controls'][k] for k in keys],[{'local':om[m['name']]['vertices_local'],'hidden':int(om[m['name']]['hide_render']),'matrix':om[m['name']]['matrix_world'],'triangles':om[m['name']]['triangles'],'material_slots':om[m['name']]['material_slots']} for m in mp]))
cases += [(x['controls'],x['objects']) for x in oracle['samples']]
for cs,objects in cases:
 c=Controls(*cs);assert f(C.byref(s),C.byref(c))
 for m,o in zip(mp,objects):
  n=neutral[m['name']];assert o['triangles']==n['triangles'] and o['material_slots']==n['material_slots'] and o['matrix']==n['matrix_world']
  assert s.hidden[m['id']]==o['hidden'],(cs,m['id'],'visibility')
  for i,v in enumerate(o['local']):
   gid=m['vertex_start']+i
   if v!=n['vertices_local'][i]:changed.add(gid)
   for k in range(3):mx=max(mx,abs(s.local[gid][k]-v[k]))
 assert mx<3e-7,mx
 if cs==cases[0][0]:assert all(list(s.local[m['vertex_start']+i])==v for m,o in zip(mp,objects) for i,v in enumerate(o['local']))
# Whole destination unchanged for every field's NaN/Inf/out-of-range/fractional enums.
rejected=0
for i in range(9):
 for value in [math.nan,math.inf,-math.inf,-100,100]+([.5] if i in [5,6] else []):
  c=Controls(*cases[0][0]);setattr(c,c._fields_[i][0],value);before=bytes(s);assert not f(C.byref(s),C.byref(c));assert bytes(s)==before;rejected+=1
assert not f(None,C.byref(c));assert not f(C.byref(s),None)
# Direct/reverse/pause/recovery: no history dependence, exact repeat snapshots.
saved={}
for ix in list(range(len(cases)))*3+list(reversed(range(len(cases)))):
 cs,_=cases[ix];c=Controls(*cs);assert f(C.byref(s),C.byref(c));b=bytes(s)
 if ix in saved:assert b==saved[ix]
 saved[ix]=b
 before=bytes(s);assert f(C.byref(s),C.byref(s.controls));assert before==bytes(s)
source=W/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend';assert hashlib.sha256(source.read_bytes()).hexdigest()==j['source_sha256']==oracle['source_sha256']
report={'passed':True,'fixture_cases':13,'fresh_blender_cases':len(oracle['samples']),'max_geometry_error_m':mx,'changed_vertex_count':len(changed),'changed_vertices':sorted(changed),'all_topology_material_slots_transforms_exact':True,'neutral_geometry_bit_exact':True,'visibility_exact':True,'rejected_with_rollback':rejected,'pause_reverse_repeat_alias_recovery_no_drift':True,'source_sha256':j['source_sha256'],'snapshot_bytes':C.sizeof(Snapshot)}
(R/'validation.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
