import pathlib,json,subprocess,sys
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent
report=json.loads((W/'fox-v3-occlusion-reduction/build-report.json').read_text());rows=[]
for s in report['stages']:
 if 'path' not in s:continue
 out=R/('prepare-'+s['stage']);log=R/(s['stage']+'-compile.log')
 with log.open('w') as f:r=subprocess.run([sys.executable,str(R/'code/prepare_geometry.py'),'--glb',s['path'],'--glb-sha256',s['sha256'],'--output',str(out)],stdout=f,stderr=subprocess.STDOUT)
 p=out/'inputs/geometry-certificate.json'
 if p.exists():
  c=json.loads(p.read_text());rows.append({'stage':s['stage'],**c['counts'],'arenaBytes64bit':c['arenaBytes64bit'],'compileSnapshotEstimateFits65536':c['counts']['snapshotBytes']<=65536,'prepareAccepted':r.returncode==0,'actualAppendExecuted':False,'actualRenderExecuted':False})
 else:rows.append({'stage':s['stage'],'prepareAccepted':False,'errorLog':str(log)})
(R/'ladder-compile-accounting.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
