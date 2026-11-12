import ast,pathlib,numpy as np,struct,zlib,json
P=pathlib.Path(__file__).resolve().parent
m=ast.parse((P/'validate.py').read_text());exec(compile(ast.Module(body=[n for n in m.body if isinstance(n,ast.FunctionDef) and n.name=='png'],type_ignores=[]),'png_decoder','exec'))
a=png(P/'control-save.png');b=png(P/'control-composite.png');e=np.abs(a-b);r=dict(count=len(a),max_display=e.max(0).tolist(),max_png16_codes=(e.max(0)*65535).tolist(),max_565_quantum=(e.max(0)*[31,63,31]).tolist(),rmse_565_quantum=np.sqrt(np.mean((e*[31,63,31])**2,axis=0)).tolist(),differing_pixel_count=int(np.any(e!=0,axis=1).sum()),seed=92031,compositor='Image -> Composite only; no RenderLayers; no scene evaluation')
(P/'control-comparison.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2))
