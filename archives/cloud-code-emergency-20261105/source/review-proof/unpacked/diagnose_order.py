import ast,pathlib,json,numpy as np
root=pathlib.Path(__file__).resolve().parent
tree=ast.parse((root/'evaluate.py').read_text());keep=[]
for n in tree.body:
    if isinstance(n,(ast.Import,ast.ImportFrom,ast.FunctionDef)):keep.append(n)
    elif isinstance(n,ast.Assign) and any(isinstance(t,ast.Tuple) or isinstance(t,ast.Name) and t.id=='SCALE' for t in n.targets):keep.append(n)
ns={'__file__':str(root/'evaluate.py')};exec(compile(ast.Module(body=keep,type_ignores=[]),'evaluate-functions','exec'),ns)
raster=ns['raster'];direct=ns['direct_surfaces'];rows=[]
for revision,folder in [('before','exports-before-v2'),('after','exports-after')]:
 for pose in ['neutral','blink-half','blink','jaw-half','jaw','combined']:
  surfaces=direct(json.loads((root/folder/(pose+'.source.json')).read_text()))
  for yaw in [0,-35,35]:
   _,_,visible=raster(surfaces,yaw)
   layers=[raster([s],yaw)[1] for s in surfaces];edges={};cycles=[]
   for i in range(len(surfaces)):
    for j in range(len(surfaces)):
     if i==j:continue
     zi,zj=layers[i],layers[j]
     both=np.isfinite(zi)&np.isfinite(zj)
     behind=both&(visible==j)&(zi<zj-1e-3)
     if behind.any():
      y,x=np.argwhere(behind)[0];edges[(i,j)]={'behind':surfaces[i]['id'],'front':surfaces[j]['id'],'pixels':int(behind.sum()),'exampleXY':[int(x),int(y)],'behindDepth':float(zi[y,x]),'frontDepth':float(zj[y,x])}
   for (i,j),e in edges.items():
    if i<j and (j,i) in edges:cycles.append([e,edges[(j,i)]])
   rows.append({'revision':revision,'pose':pose,'yaw':yaw,'contradictorySurfaceOrderPairs':cycles,'edges':list(edges.values())})
(root/'results-v3/order-diagnosis.json').write_text(json.dumps({'scope':'offline visible per-surface depth constraints; no renderer change; two-way edges prove one whole-surface order cannot satisfy this view','cases':rows},indent=2))
print(json.dumps({'cases':len(rows),'casesWithTwoWaySurfaceOrder':sum(bool(r['contradictorySurfaceOrderPairs']) for r in rows),'first':next((r for r in rows if r['contradictorySurfaceOrderPairs']),None)},indent=2))
