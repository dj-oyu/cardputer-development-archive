import pathlib,json,sys,numpy as np
R=pathlib.Path(__file__).resolve().parents[1];r=R/'geometry-probe';o=json.loads((r/'geometry.json').read_text());actual='--actual' in sys.argv
if actual:o['scope']='Actual observed model position/SNORM queries; observation output RGB/depth unchanged; fixed16/64/1024/4096 no pixels or fitting'
for case,row in o['cases'].items():
 a=np.loadtxt(r/(('actual-' if actual else '')+case+'.txt')).reshape(-1,4,3);assert a.shape==(1698,4,3) and np.isfinite(a).all();row['convergence']={}
 for j,name in enumerate(['16','64','1024']):
  diff=a[:,j]-a[:,3];norm=np.linalg.norm(a[:,3],axis=1);active=norm>1e-12;rel=np.linalg.norm(diff[active],axis=1)/norm[active];row['convergence'][name+'vs4096']={'relativeL2':float(np.linalg.norm(diff)/np.linalg.norm(a[:,3])),'activeVertexCount':int(active.sum()),'relativePerVertexP50P95Max':list(map(float,np.percentile(rel,[50,95,100]))),'absoluteMaxRGB':float(abs(diff).max())}
 missing=(np.linalg.norm(a[:,0],axis=1)==0)&(np.linalg.norm(a[:,3],axis=1)>1e-12);row['missedDirectAt16']={'vertices':int(missing.sum()),'maxReferenceRGB':float(a[missing,3].max()) if missing.any() else None}
(r/('actual-report.json' if actual else 'report.json')).write_text(json.dumps(o,indent=2))
