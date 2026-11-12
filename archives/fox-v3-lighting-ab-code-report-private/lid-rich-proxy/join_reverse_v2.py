"""Post-hoc fixed census cohorts, no point reselection or causal attribution."""
from pathlib import Path
import sys,json,hashlib,numpy as np
from PIL import Image
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent;W=R.parent;RUN=R/'run-001';REF=W/'fox-reference-uncertainty-v3';C=W/'fox-v3-lid-transport-point-audit/capture-002';PP=W/'fox-v3-lid-display-combination/postprocess-002'
sys.path.insert(0,str(R/'code'));import exr_io
D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir();pins={}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p,h=None):
 p=Path(p);s=sha(p);assert h is None or h==s;pins[str(p)]=s;return p
def load(p):return json.loads(pin(p).read_text())
def dec(p):
 a=np.fromfile(pin(p),'<u2').reshape(135,240);return np.stack([(a>>11)/31,((a>>5)&63)/63,(a&31)/31],-1)
def classes(d):return np.where(d>2/255,'bright',np.where(d< -2/255,'dark','inactive'))
Y=np.array([.2126,.7152,.0722]);IW=np.array([2126,7152,722]);pin(Path(__file__));pin(Path(exr_io.__file__))
rays=load(W/'fox-v3-lid-response-correspondence/source-rays-private.json')['rows'];done=load(RUN/'COMPLETED.json');rows={(r['view'],r['case']):r for r in done['images']};census=load(W/'fox-v3-lid-response-correspondence/census.json')
def extract(ch):
 rgb=lambda n:np.stack([ch['ViewLayer.'+n+'.'+c] for c in 'RGB'],-1).astype(np.float64)
 d={'Combined':rgb('Combined'),'DirectDiffuse':rgb('DiffDir')*rgb('DiffCol'),'IndirectDiffuse':rgb('DiffInd')*rgb('DiffCol'),'DirectGloss':rgb('GlossDir')*rgb('GlossCol'),'IndirectGloss':rgb('GlossInd')*rgb('GlossCol'),'Emit':rgb('Emit'),'Env':rgb('Env'),'Transmission':(rgb('TransDir')+rgb('TransInd'))*rgb('TransCol'),'Volume':rgb('VolumeDir')+rgb('VolumeInd')};d['R']=d['Combined']-sum(v for k,v in d.items() if k!='Combined');return d
def stats(a):
 a=np.array(a);y=a@Y
 return {'n':len(a),'meanRGB':a.mean(0).tolist(),'meanY':float(y.mean()),'meanAbsY':float(abs(y).mean()),'minY':float(y.min()),'maxY':float(y.max()),'positiveY':int((y>0).sum()),'negativeY':int((y<0).sum()),'zeroY':int((y==0).sum())} if len(a) else {'n':0}
out={};private=[]
for view in ['front','oblique']:
 m=np.load(pin(REF/'evaluation-masks'/f'{view}-direction-response.npz'));alpha=np.array(Image.open(pin(REF/'images'/f'foreground-{view}.png')))[...,3];labels=np.full((135,240),'outside',object)
 for k in ['bright','dark','inactive','uncertain']:labels[(alpha>0)&m[k]]=k
 display={}
 for arm in ['point-off','point-on','filter3-off','filter3-on']:
  b,d=[dec(PP/f'{arm}-{view}-{c}.u16le') for c in ['baseline','direction']];display[arm]=classes((d-b)@Y)
 px={};passes={};native={}
 for case in ['baseline','direction']:
  r=rows[(view,case)];px[case]=np.array(Image.open(pin(RUN/r['PNG'],r['PNGSHA256'])))[...,:3];passes[case]=extract(exr_io.read(pin(RUN/r['EXR'],r['EXRSHA256'])));native[case]={(p['x'],p['y']):p for p in load(C/f'native-{view}-{case}-winners.json')['points']}
 display['proxyOriginalAgXBH']=classes(((px['direction'].astype(np.int64)-px['baseline'].astype(np.int64))@IW)/2550000)
 delta={k:passes['direction'][k]-passes['baseline'][k] for k in passes['baseline']}
 rr=[]
 for ray in rays:
  if ray['view']!=view:continue
  x,y=ray['x'],ray['y'];ref=labels[y,x];legacy=display['point-off'][y,x]
  if (ref,legacy) not in [('bright','dark'),('dark','bright')]:continue
  n0,n1=[native[c][x,y] for c in ['baseline','direction']];assert all(n0[k]==n1[k] for k in ['node','face','back','indices','weights','position','normal','rho'])
  row={'view':view,'x':x,'y':y,'reference':str(ref),'nativeObject':ray['nativeObject'],'correspondence':'noSourceHit' if not ray['sourceHit'] else 'sameObject' if ray['sameObject'] else 'differentObject','displayClasses':{k:str(v[y,x]) for k,v in display.items()},'nativeDelta':{k:(np.array(n1[k])-n0[k]).tolist() for k in ['rgb','direct','world','bounce','ground']},'proxyFilteredDelta':{k:a[y,x].tolist() for k,a in delta.items()}}
  rr.append(row);private.append(row)
 expected=sum(census['views'][view]['point-off']['strata']['foreground'][a][b] for a,b in [('bright','dark'),('dark','bright')]);assert len(rr)==expected,(view,len(rr),expected)
 keys=['all','sameObject','differentObject','noSourceHit']+['nativeObject/'+n for n in sorted({r['nativeObject'] for r in rr})]
 out[view]={}
 for key in keys:
  g=[r for r in rr if key=='all' or key==r['correspondence'] or key=='nativeObject/'+r['nativeObject']]
  if not g:out[view][key]={'n':0};continue
  cls={arm:{'correctSourceSign':sum(r['displayClasses'][arm]==r['reference'] for r in g),'stillReverse':sum((r['reference'],r['displayClasses'][arm]) in [('bright','dark'),('dark','bright')] for r in g),'inactive':sum(r['displayClasses'][arm]=='inactive' for r in g)} for arm in display}
  out[view][key]={'n':len(g),'displayClasses':cls,'nativePointDelta':{k:stats([r['nativeDelta'][k] for r in g]) for k in g[0]['nativeDelta']},'proxyFilteredDelta':{k:stats([r['proxyFilteredDelta'][k] for r in g]) for k in delta},'linearSignAgreement':{k:sum(np.sign(np.array(r['proxyFilteredDelta'][k])@Y)==(1 if r['reference']=='bright' else -1) for r in g) for k in delta}}
assert all(sha(Path(p))==h for p,h in pins.items())
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False,default=lambda x:x.item())+'\n')
save(D/'private-point-join.json',private);save(D/'summary.json',{'cohort':'Frozen original-foreground stable-reference sign opposite native legacy point RGB565; no selection fit','views':out,'caveats':['Native point components and proxy filtered radiance passes have different sampling and BSDF/GI contracts.','Proxy original AgX/BH display differs from point AgX LUT and integer BH3x3 native diagnostics.','Indirect diffuse does not identify ground origin.','Same object does not establish same surface or normal.','One seed, no stability or fullframe native acceptance.']});save(D/'input-hashes.json',pins)
print(json.dumps({v:{k:out[v][k] for k in ['all','sameObject','differentObject']} for v in out},default=lambda x:x.item())[:2000])
