import sys
sys.dont_write_bytecode=True
import pathlib,json,hashlib
P=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(P.parent/'material-prototype'));import model as m
manifest=[]
for bits in (16,20,24):
 S=1<<bits;out=['/* Generated from frozen source DAG; do not hand edit. */'];maxslots=0
 for p in m.load_programs():
  idx={};cursor=0
  for n in p.order:
   kind=p.nodes[n]['type'];outputs=p.nodes[n]['outputs']
   for o in outputs:
    width=3 if o['type'] in ('NodeSocketColor','NodeSocketVector') else 1
    idx[n,o['identifier']]=list(range(cursor,cursor+width));cursor+=width
  maxslots=max(maxslots,cursor);side='left' if p.side<0 else 'right'
  out.append('static const int64_t lut_'+side+'[257][3] = {'+','.join('{'+','.join(map(str,m.qvalue(v,S)))+'}' for v in p.table)+'};')
  order=[]
  for spatial in (False,True):
   out.append('static void '+('spatial_' if spatial else 'uniform_')+side+'(int64_t *v,const int32_t *u,const int32_t *xz,int *e){(void)u;(void)xz;')
   for name in p.order:
    if p.spatial[name]!=spatial:continue
    n=p.nodes[name];kind=n['type'];ins=[]
    for i in n['inputs']:
     key=name,i['identifier'];link=p.links.get(key)
     ins.append(['v[%d]'%x for x in idx[link]] if link else [str(x) for x in (m.qvalue(p.constants[key],S) if isinstance(p.constants.get(key),tuple) else (m.qvalue(p.constants[key],S),))] if key in p.constants else [])
    def assign(socket,exprs):
     for dest,exp in zip(idx[name,socket],exprs):out.append('v[%d]=%s;'%(dest,exp))
    out.append('/* '+name+' */');order.append(name)
    if kind=='ShaderNodeValue':assign('Value',['u[%d]'%['Blink driver','Value','Value.001','Value.002','Value.003','Value.004','Value.005'].index(name)])
    elif kind=='ShaderNodeTexCoord':assign('Object',['xz[0]','0','xz[1]'])
    elif kind=='ShaderNodeSeparateXYZ':
     for i,k in enumerate('XYZ'):assign(k,[ins[0][i]])
    elif kind=='ShaderNodeMath':
     a,b=ins[0][0],ins[1][0];op=n['properties']['operation'];expr={'ADD':f'ad({a},{b},e)','SUBTRACT':f'su({a},{b},e)','MULTIPLY':f'mu({a},{b},e)','DIVIDE':f'di({a},{b},e)','SQRT':f'sq({a},e)','MINIMUM':f'mn({a},{b})','MAXIMUM':f'mx({a},{b})','LESS_THAN':f'(({a}<{b})?S:0)','GREATER_THAN':f'(({a}>{b})?S:0)'}[op];assign('Value',[expr])
    elif kind=='ShaderNodeValToRGB':
     for k in range(3):assign('Color',[]) if False else None;out.append('v[%d]=ramp(lut_%s,%s,%d,e);'%(idx[name,'Color'][k],side,ins[0][0],k))
     assign('Alpha',['S'])
    elif kind=='ShaderNodeMixRGB':
     assign('Color',[f'ad({ins[1][k]},mu(cl({ins[0][0]}),su({ins[2][k]},{ins[1][k]},e),e),e)' for k in range(3)])
    else:raise ValueError(kind)
   out.append('}')
  out.append('static const unsigned color_'+side+'[3]={'+','.join(map(str,idx['Mix (Legacy).002','Color']))+'};')
  out.append('static const unsigned mask_'+side+'='+str(idx['Math.019','Value'][0])+';')
  manifest.append({'bits':bits,'material':p.material,'slots':cursor,'topological_order':p.order,'uniform_then_spatial_order':order})
 out.insert(0,'#define NSLOTS '+str(maxslots));out.insert(0,'#define ROUGHNESS '+str(round(m.f32(.2199999988079071)*S)))
 (P/f'generated-q{bits}.inc').write_text('\n'.join(out)+'\n')
(P/'node-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
