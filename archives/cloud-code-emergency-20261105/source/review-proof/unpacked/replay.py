import pathlib,subprocess,json,time,hashlib,sys
ROOT=pathlib.Path(__file__).resolve().parent
out=ROOT/(sys.argv[1] if len(sys.argv)>1 else 'replay');out.mkdir(exist_ok=False)
rows=[]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run(cmd,label):
 start=time.perf_counter();p=subprocess.run(cmd,cwd=ROOT,capture_output=True,text=True,timeout=120)
 (out/(label+'.stdout.txt')).write_text(p.stdout);(out/(label+'.stderr.txt')).write_text(p.stderr)
 assert p.returncode==0,p.stderr
 return (time.perf_counter()-start)*1000
for rev,old in [('before','exports-before-v2'),('after','exports-after')]:
 dest=out/(rev+'-exports')
 exportms=run(['blender','-b','-t','2','--python','export_source.py','--',str(ROOT/'sources'/(rev+'.blend')),str(dest)],rev+'-export')
 files=sorted((ROOT/old).glob('*.glb'))
 matches={f.name:sha(f)==sha(dest/f.name) for f in files};assert all(matches.values())
 compiled=out/(rev+'-compile');compilems=run(['node','compile_identity.cjs',str(dest/'neutral.glb'),str(compiled)],rev+'-compile')
 assert sha(compiled/'model.aynm')==sha(ROOT/'results-v3'/(rev+'-neutral-compile')/'model.aynm')
 row={'revision':rev,'exportAllSevenGLBsWallMsIncludingBlenderLaunch':exportms,'neutralCompileWallMsIncludingNodeLaunch':compilems,'allGLBByteReplayEqual':matches,'neutralAynmReplayEqual':True,'nativePixelReplayEqual':{}}
 for yaw in [0,-35,35]:
  import math
  a=math.radians(yaw);camera=[400*math.sin(a),0,400*math.cos(a),0,0,0,1,120,67]
  target=out/(rev+'-yaw'+str(yaw));target.mkdir()
  ms=run([str(ROOT/'native-render-exact'),str(compiled/'model.aynm'),str(target),*map(str,camera),*map(str,[-.5,-.4,.8,1,1,1]),'0',*map(str,[0,0,0,0,0,0,1,1,1])],rev+'-yaw'+str(yaw))
  reference=ROOT/'results-v3'/(rev+'-neutral-yaw'+str(yaw))
  equal={n:sha(target/n)==sha(reference/n) for n in ['pixels.u16le','coverage.u16le','visible-triangles.u16le']};assert all(equal.values())
  row['nativePixelReplayEqual'][str(yaw)]={'files':equal,'nativeProcessMsIncludingAllDiagnosticPasses':ms}
 rows.append(row)
(out/'replay.json').write_text(json.dumps({'scope':'same export/compiler/render operations after spatial/topology edit; no code/index/order fixes','rows':rows},indent=2))
print(json.dumps(rows,indent=2))
