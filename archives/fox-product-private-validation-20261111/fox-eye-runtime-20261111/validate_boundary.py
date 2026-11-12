import json,pathlib,ctypes as C,struct,math,ast
R=pathlib.Path(__file__).resolve().parent;W=R.parent
j=json.load(open(R/'boundary-oracle.json'));f32=lambda a:struct.unpack('f',struct.pack('f',a))[0]
class Controls(C.Structure):_fields_=[(n,C.c_float) for n in ['blink_both','blink_neg','blink_pos','gaze_x','gaze_up','eye_style','show_highlights','environment_reflection','bubble_pressure']]
class Snapshot(C.Structure):_fields_=[('controls',Controls),('local',(C.c_float*3)*1322),('hidden',C.c_uint8*74)]
lib=C.CDLL(str(R/'runtime.so'));build=lib.fox_eye_snapshot_build;build.argtypes=[C.POINTER(Snapshot),C.POINTER(Controls)];build.restype=C.c_bool
surface=lib.fox_eye_snapshot_surface;surface.argtypes=[C.POINTER(Snapshot),C.c_uint,C.c_float,C.c_float,C.c_float,C.POINTER(C.c_float),C.POINTER(C.c_float)];surface.restype=C.c_bool
# Reuse only pure float32 source node interpreter, not validation module side effects.
tree=ast.parse((W/'fox-eye-contract-20261111/validate.py').read_text());fn=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='graph');exec(compile(ast.Module(body=[fn],type_ignores=[]),'source_graph_interpreter','exec'))
ir=json.load(open(W/'fox-eye-contract-20261111/alpha-ir.json'));s=Snapshot();checks=0;alphas=[]
for r in j['rows']:
 c=Controls(0,0,0,0,0,0,1,.5,0);setattr(c,{'Blink Both':'blink_both','Blink -X':'blink_neg','Blink +X':'blink_pos'}[r['key']],r['input_double']);assert build(C.byref(s),C.byref(c))
 for obs in r['observed']:
  side=obs['side'];oid=35 if side<0 else 36;mi=0 if side<0 else 1;gm=5 if side<0 else 6
  assert bool(s.hidden[oid])==obs['hidden'];expected_b=max(c.blink_both,c.blink_neg if side<0 else c.blink_pos);assert expected_b==obs['shader_blink'];checks+=1
  for x,z in [(10,10),(ir[mi]['center_x'],ir[mi]['center_z'])]:
   rgb=(C.c_float*3)();a=C.c_float();assert surface(C.byref(s),gm,x,0,z,rgb,C.byref(a));expected=graph(ir[mi],f32(x),f32(z),obs['shader_blink']);assert a.value==expected,(r,a.value,expected)
   if r['key']=='Blink Both' and r['input_double']<.1 and side<0 and x==10:alphas.append({'double':r['input_double'],'driver_f32':obs['shader_blink'],'outside_alpha':a.value})
report={'passed':True,'live_driver_visibility_checks':checks,'shader_driver_matches_f32_narrowing':True,'runtime_visibility_matches_live_blender':True,'alpha_source_node_comparisons':checks*2,'alpha_boundary':alphas,'precision_contract':'UI property retains double but source driver input/output evaluation demonstrably narrows to float32; runtime narrows after double-domain validation then uses float32 .98 threshold and source alpha float32 node arithmetic.'}
(R/'boundary-validation.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
