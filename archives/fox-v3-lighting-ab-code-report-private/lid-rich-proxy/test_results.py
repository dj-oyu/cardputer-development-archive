"""Aggregate contract regressions, including nohit schema and both threshold columns."""
from pathlib import Path
import ast,json,numpy as np
R=Path(__file__).resolve().parent
s=json.loads((R/'sign-mechanism-001/summary.json').read_text())
f=json.loads((R/'filtered-direct-003/summary.json').read_text())
assert f['filter']==json.loads((R.parent/'fox-v3-lid-display-combination/postprocess-002/filter.json').read_text())
checks=1
for view,groups in s['views'].items():
 for cohort,g in groups.items():
  assert set(g['thresholds'])=={'rawSignNoThreshold','existing2over255NumericScale'};checks+=1
  for threshold,z in g['thresholds'].items():
   assert z['n']==g['n'];checks+=1
   for k in ['nativeDirectVersusProxyDirect','proxyDirectVersusCombined']:
    assert sum(z[k].values())==g['n'];checks+=1
   ff=f['views'][view][cohort][threshold];assert ff['n']==g['n'];checks+=1
   assert ff['point']['opposite']==z['nativeDirectVersusProxyDirect']['oppositeSign'];checks+=1
   for a in ['point','filtered']:assert sum(ff[a].values())==g['n'];checks+=1
   for c in z['components'].values():
    assert c['sourceDirectionSign']+c['oppositeSourceDirection']+c['zeroOrSmall']==g['n'];checks+=1
   for c in z['leaveOneOut'].values():
    assert c['sourceDirectionSignWithout']+c['oppositeSourceDirectionWithout']+c['zeroOrSmallWithout']==g['n'];checks+=1
# Defensive source-nohit branch: extract exact field expression, avoid running join's I/O.
t=ast.parse((R/'join_reverse_v2.py').read_text());expr=None
for node in ast.walk(t):
 if isinstance(node,ast.Dict):
  for k,v in zip(node.keys,node.values):
   if isinstance(k,ast.Constant) and k.value=='correspondence':expr=v
assert expr is not None
code=compile(ast.Expression(expr),'join-branch','eval')
assert eval(code,{'ray':{'sourceHit':False}})=='noSourceHit';checks+=1
for yes,result in [(True,'sameObject'),(False,'differentObject')]:
 assert eval(code,{'ray':{'sourceHit':True,'sameObject':yes}})==result;checks+=1
# Fixed filter edge/nohit denominator, using exact deployed filter AST.
P=R.parent/'fox-v3-lid-display-combination/postprocess_v2.py';t=ast.parse(P.read_text());fn=next(n for n in t.body if isinstance(n,ast.FunctionDef) and n.name=='filter3');ns={'np':np};exec(compile(ast.Module(body=[fn],type_ignores=[]),str(P),'exec'),ns)
filter_config=json.loads((R.parent/'fox-v3-lid-display-combination/postprocess-002/filter.json').read_text());o=np.array(filter_config['offsets']);w=np.array(filter_config['weights1D']);raw=np.zeros((135,240,3));mask=np.zeros((135,240),bool);raw[0,0]=1;mask[0,0]=True
out,support=ns['filter3'](raw,mask,o,w);assert np.array_equal(out[0,0],np.full(3,w[1]*w[1]));assert out[0,0,0]<1;assert (out[~support]==0).all();checks+=3
# Every current result stays descriptive; original versus proxy no new reverse omitted.
e=json.loads((R/'analysis-001/evaluation.json').read_text());reg=json.loads((R/'full-domain-regressions.json').read_text())
for view in e:
 c=e[view]['proxy']['classCensus'];assert c['stableBright']['dark']+c['stableDark']['bright']==reg[view]['proxyFullForegroundReverse'];checks+=1
print(json.dumps({'status':'PASS','checks':checks,'nohitSchema':True,'bothThresholdColumns':True,'fixedBlackDenominator':True,'fullDomainRegressions':True},indent=2))
