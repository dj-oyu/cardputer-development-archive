import json,math
from pathlib import Path
R=Path(__file__).resolve().parent
rule=json.loads((R/'sample-rule.json').read_text());q=rule['positiveOffset'];a=[.35875,.48829,.14128,.01168];W=3.
def F(x):
 if x<=-1.5:return 0.
 if x>=1.5:return 1.
 return .5+x/W+sum(a[k]*math.sin(2*math.pi*k*x/W)/(2*math.pi*k*a[0]) for k in range(1,4))
assert abs(F(q)-.75)<5e-16 and abs(F(-q)-.25)<5e-16
nodes=rule['offsets'];assert sum(x for x,y in nodes)==sum(y for x,y in nodes)==0
fixtures=[]
for arm,d in [('A',.25),('B',q)]:
 for w in [.01,.1,.25,.5,.6,1.,2.,3.]:
  exact=F(w/2)-F(-w/2);got=sum(-w/2<=v<=w/2 for v in [-d,d])/2
  fixtures.append(dict(arm=arm,width=w,exact=exact,quadrature=got,error=got-exact))
steps=[]
for t in [-1.5,-q,-.25,0,.25,q,1.5]:
 for side in [-1,1]:
  x=math.nextafter(t,math.inf*side);exact=1-F(x)
  steps.append(dict(threshold=x,exact=exact,A=sum(v>=x for v in [-.25,.25])/2,B=sum(v>=x for v in [-q,q])/2))
(R/'synthetic-results.json').write_text(json.dumps({'status':'PASS_FIXED_RULE_NO_TUNING','quartile':q,'constantError':0,'linearError':0,'armBSupAbsoluteErrors':{'axisStep':.25,'axisStrip':.5},'armASupAbsoluteErrorsAgainstBH':{'axisStep':1-F(.25),'axisStrip':2*(1-F(.25))},'strips':fixtures,'steps':steps,'scope':'axis aligned fixtures only, not arbitrary 2D guarantee'},indent=2)+'\n')
