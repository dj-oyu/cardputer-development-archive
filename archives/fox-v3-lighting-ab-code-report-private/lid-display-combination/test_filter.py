from pathlib import Path
import importlib.util,json,numpy as np,hashlib
R=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('p',R/'postprocess.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p)
a=p.module('a',p.AA);o,w=a.filter_grid(3)
raw=np.ones((135,240,3));cov=np.ones((135,240),bool);x,m=p.filter3(raw,cov,o,w)
assert np.allclose(x[1:-1,1:-1],1,rtol=0,atol=1e-15)
assert np.allclose(x[0,0],(w[1]+w[2])**2,rtol=0,atol=1e-15) and (x[0,0]<1).all()
raw[:]=0;cov[:]=False;raw[50,70]=[1,2,3];cov[50,70]=True;x,m=p.filter3(raw,cov,o,w)
assert m.sum()==9 and np.allclose(x.sum((0,1)),[1,2,3],rtol=0,atol=1e-15)
for dy in range(-1,2):
 for dx in range(-1,2):assert np.allclose(x[50+dy,70+dx],w[1-dy]*w[1-dx]*np.array([1,2,3]),rtol=0,atol=1e-15)
# Legitimate black covered pixel retains support; it is not inferred from color.
raw[:]=0;x,m=p.filter3(raw,cov,o,w);assert not x.any() and m.sum()==9
cov[:]=False;cov[0,0]=True;raw[0,0]=1;x,m=p.filter3(raw,cov,o,w);assert m.sum()==4 and np.allclose(x[0,0],w[1]**2,rtol=0,atol=1e-15)
(R/'filter-tests.json').write_text(json.dumps({'passed':True,'tests':['constant interior','black zero-padding boundary loss, no renormalization','impulse nine weights','interior energy','black foreground support','corner impulse four support'], 'postprocessSHA256':hashlib.sha256((R/'postprocess.py').read_bytes()).hexdigest(),'aaMathSHA256':hashlib.sha256(p.AA.read_bytes()).hexdigest()},indent=2));print('PASS')
# Preserve exact implementations for existing math and recursive metric differences.
import ast
old=ast.parse((R.parent/'fox-v3-bounce-combination/postprocess.py').read_text())
new=ast.parse((R/'postprocess.py').read_text())
for name in ('filter3','decode','diff','shape'):
 a0=next(n for n in old.body if isinstance(n,ast.FunctionDef) and n.name==name)
 a1=next(n for n in new.body if isinstance(n,ast.FunctionDef) and n.name==name)
 assert ast.dump(a0)==ast.dump(a1),name+' implementation drift'
assert p.diff({'score':None,'flag':True,'metric':4},{'score':9,'flag':False,'metric':1})=={'score':None,'flag':None,'metric':3}
assert p.fmt(None)=='UNKNOWN'
assert p.CASES==('baseline','direction','intensity','ambient','albedo') and len(p.RESPONSES)==4
sample={'brightening':{'candidatePixels':7,'referencePixels':6,'intersection':4},'darkening':{'candidatePixels':2,'referencePixels':5,'intersection':1}}
assert p.response_confusion(sample)=={'brightening':{'falsePositives':3,'falseNegatives':2,'truePositives':4},'darkening':{'falsePositives':1,'falseNegatives':4,'truePositives':1}}
assert p.response_confusion({'status':'NO_EVALUATION_DOMAIN','pixels':0,'metrics':None})=={'status':'NO_EVALUATION_DOMAIN','metrics':None}
q=R/'filter-tests.json';r=json.loads(q.read_text());r['tests']+=['unchanged filter/decode/diff/support function ASTs','null and bool contrasts are not numeric scores','all five conditions/four responses declared','response FP/FN derived counts','empty domain remains unknown'];q.write_text(json.dumps(r,indent=2)+'\n');print('EXTENDED PASS')
