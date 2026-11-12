"""Read-only inventory of existing arithmetic test inputs; no renderer/query execution."""
from pathlib import Path
import json,hashlib
R=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).resolve().parent;B=R/'fox-v3-indexed-bvh-bounds'
def record(p):return {'path':str(p.relative_to(R)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
frames=[]
for arm in ['actual-on-001','actual-off-001']:
 for h in sorted((B/arm).glob('*.hdr.f64le')):
  name=h.name[:-len('.hdr.f64le')];p=B/arm/name;obs=Path(str(p)+'.hdr-observer.json');j=json.loads(obs.read_text());assert j['complete'] and j['sampleWrites']==32400 and h.stat().st_size==32400*24;rgb=Path(str(p)+'.u16le');assert rgb.stat().st_size==32400*2
  frames.append({'key':arm+'/'+name,'pixels':32400,'files':[record(h),record(rgb),record(obs)]})
assert len(frames)==40
files=['fox-v3-floor-world-reflection/capture/on/native-front-baseline.samples.jsonl','fox-v3-floor-world-reflection/capture/on/native-front-baseline.snapshot','fox-v3-floor-world-reflection/capture/on/native-front-baseline.targets.u8','fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot','fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.targets.u8','ayatsuri-fixed-integer-light-20261105/actual-input.bin','ayatsuri-fixed-integer-light-20261105/actual-provenance.json','ayatsuri-fixed-integer-chain-20261105/private/SOURCE_PINS.json','ayatsuri-fixed-integer-chain-20261105/private/RAW_RESULTS.json','ayatsuri-fixed-integer-chain-20261105/tests/test_native_geometry.c','ayatsuri-fixed-render-20261105/plan/canary-output/RESULT.json','ayatsuri-fixed-render-20261105/visibility-trace/REPORT.md','ayatsuri-fixed-render-20261105/visibility-trace/RESULT.json','ayatsuri-fixed-render-20261105/visibility-trace/OUTPUT_FREEZE.json']
for p in files:assert (R/p).is_file(),p
j={'status':'EXISTING_INPUT_CORPUS_INVENTORY_ONLY','newFrames':0,'newSceneQueries':0,'realRendererIntegrationAuthorized':False,'finalHDRCorpus':{'frames':40,'pixels':1296000,'rows':frames},'fixedInputSources':[record(R/p) for p in files],'quarterCorpus':{'slots':9540,'pixels':2385,'hits':7678,'misses':1862,'admittedAggregateParityPixels':1746,'excludedPixels':639,'postResolverSlotIdentityAvailable':False},'directionCorpus':{'rawNormals':7678,'oldQueryMasksValidForNewDirections':False},'reflectionContributionCorpus':{'realPerSampleRadiancesAvailable':False,'allowedEvidence':'Synthetic fixed arithmetic only; no real reflection-quality claim'},'laneLayout':{'widths':[1,2,4,8],'records7678TailAt8':[4,2],'admittedPixels1746TailAt8':[2],'fullFrame32400TailAt8':[]},'scriptSHA256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
with (D/'CORPUS_PLAN.json').open('x') as f:json.dump(j,f,indent=2);f.write('\n')
print('Existing corpus pinned; no computation of scenes/rays/frames.')
