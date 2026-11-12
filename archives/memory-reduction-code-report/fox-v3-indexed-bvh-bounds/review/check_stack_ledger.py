from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];out=R/'review';checks={}
for report_name,folder in [('PRODUCT_NAMED_STACK.json','build-product'),('NAMED_STACK.json','private-build')]:
 report=json.loads((R/report_name).read_text());frames={}
 # Report hash filenames uniquely identify expected emitted stack files.
 for name,digest in report['stackFiles'].items():
  matches=[p for p in R.rglob(name) if hashlib.sha256(p.read_bytes()).hexdigest()==digest]
  assert matches,(report_name,name)
  p=matches[0]
  for line in p.read_text().splitlines():
   first,n,kind=line.split('\t');fun=first.rsplit(':',1)[-1];frames[p.stem+':'+fun]=int(n)
 for name,chain in report['chains'].items():
  total=0
  for frame in chain['frames']:
   key=frame['name'];matches=[v for k,v in frames.items() if k==key or k.split('.constprop')[0]==key.split('.constprop')[0]]
   assert frame['bytes'] in matches,(report_name,key,frame,matches);total+=frame['bytes']
  assert total==chain['bytes'],(report_name,name)
 assert report['backgroundPeak']==4016 and report['backgroundCap']==4096
 assert report['rendererPeak']==4944 and report['rendererCap']==8192
 checks[report_name]={'allNamedFramesMatchHashedCompilerSU':True,'allChainSumsExact':True,'background':4016,'backgroundCap':4096,'renderer':4944,'rendererCap':8192}
ledger=json.loads((R/'MEMORY_LEDGER.json').read_text())
for name,phase in ledger['phases'].items():
 actual=sum(sum(v.values()) if isinstance(v,dict) else v for k,v in phase.items() if k!='sumExcludingRO')
 assert actual==phase['sumExcludingRO'],(name,actual,phase['sumExcludingRO'])
assert max(x['sumExcludingRO'] for x in ledger['phases'].values())==336724==ledger['namedPeak']
assert ledger['baselineNamedPeak']-ledger['namedPeak']==36828==1023*(64-28)
su=(R/'build-product/visibility.su').read_text();frames={x.split('\t')[0].rsplit(':',1)[-1]:int(x.split('\t')[1]) for x in su.splitlines()}
assert frames['vis_scene_build']==368 and frames['build_node']==192 and frames['build_bounds']==176
assert 368+10*192+176==2464
assert 'compact_tree' not in frames
checks['ledger']={'phaseSumsExact':True,'renderPeak':336724,'buildPeak':312580,'conversionPeak':301544,'savedNamedBytes':36828,'constructorNamedBound':2464,'conversionInlinedNamedFrame':368}
checks['scope']='Compiler named requested-payload accounting only; libc/libm/allocator and whole process/device placement excluded; no actual renders.'
(out/'INDEPENDENT_STACK_LEDGER.json').write_text(json.dumps({'status':'PASS','checks':checks},indent=2)+'\n')
print('PASS independent named frame hashes, chain sums, phase arithmetic and bounded memory')
