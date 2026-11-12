"""New strict experimental loader, unchanged frozen formal v3 score function/reference."""
from pathlib import Path
import json,sys,hashlib,importlib.util,numpy as np
from aa_contract import validate as validate_aa
D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['off','on'];O=D/arm;OUT=O/'score';assert not OUT.exists();W=next(p for p in Path(__file__).resolve().parents if (p/'fox-v3-lid-evaluation/actual-lid8-v2').is_dir());B=W/'fox-v3-lid-evaluation/actual-lid8-v2';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
done=json.loads((O/'COMPLETED.json').read_text());assert done['status']=='ALL20_ACTUAL_COMPLETE' and len(done['frames'])==20 and done['allForwardReverseRGBDepthExact'] and done['sourceInputsUnchanged'];pins=json.load(open(D/'input-hashes.json'));assert all(sha(D/p)==h for p,h in pins.items());assert sha(D/'native-render')==done['binarySHA256']
if arm=='on':
 audit=json.load(open(O/'SAMPLE_AUDIT.json'));assert audit['status']=='ALL20_SAMPLE_LINEAR_OUTPUT_CONTROLS_PASS' and len(audit['frames'])==20
for row in done['frames']:
 p=O/row['prefix'];assert all(sha(Path(str(p)+ext))==h for ext,h in row['files'].items())
 if arm=='on':
  aa=json.load(open(str(p)+'.aa.json'));validate_aa(aa,list(map(int,(D/f"ledger-{row['view']}.txt").read_text().split())),2385 if row['view']=='front' else 2391,'912ba9aa3cfbfb2c')
  old=json.load(open(str(D/'off'/row['prefix'])+'.json'));assert aa['centerShades']==old['shadeUpdates'];assert row['metadata']['snapshotBytes']==old['snapshotBytes']==64208 and row['metadata']['snapshotCapacity']==old['snapshotCapacity']==65536
  a=next(z for z in audit['frames'] if all(z[k]==row[k] for k in ['view','case','reverse']));assert sha(Path(str(p)+'.samples.jsonl'))==a['samplesSHA256'] and sha(Path(str(p)+'.targets.u8'))==a['targetSHA256'];assert a['linearFourMeanEncodeExact'] and a['nonTargetsByteExact']
# Load the frozen scorer itself without editing score(), reference pins or numeric functions.
path=B/'scoring/score_candidate.py';spec=importlib.util.spec_from_file_location('frozen_formal_v3',path);S=importlib.util.module_from_spec(spec);spec.loader.exec_module(S);ref=S.load_reference(W/'fox-reference-uncertainty-v3')
frames={};manifest={'schemaVersion':'host-experimental-boundary-aa-v2','candidate':{'label':'lid8-boundary-'+arm,'newAPIOnly':arm=='on','oldErrorAndWorkEquivalent':False if arm=='on' else True,'sourceFilesSHA256':sha(D/'input-hashes.json')},'runtimeCompleteSHA256':sha(O/'COMPLETED.json'),'strictAdmissionVersion':2,'strictAdmissionSHA256':sha(Path(__file__).with_name('aa_contract.py')),'newLoaderSHA256':sha(Path(__file__)),'frozenScoreSHA256':sha(path),'sourceGeometryUnchanged':True,'formalDepth':'center depth retained; sample support separate','referenceThresholdsUnchanged':True,'frames':[]}
for row in done['frames']:
 if row['reverse']:continue
 p=O/row['prefix'];r={'view':row['view'],'case':row['case'],'rgb565':{'file':str(p.relative_to(O))+'.u16le','sha256':row['files']['.u16le']},'depth':{'file':str(p.relative_to(O))+'.f32le','sha256':row['files']['.f32le']},'metadata':row['metadata']};manifest['frames'].append(r)
 frames[(row['view'],row['case'])]={'rgb':S.decode_rgb565(Path(str(p)+'.u16le').read_bytes()),'depth':S.decode_depth(Path(str(p)+'.f32le').read_bytes()),'row':r}
assert len(frames)==10
mp=O/'candidate-manifest.json';mp.write_text(json.dumps(manifest,indent=2)+'\n');candidate={'frames':frames,'manifest':manifest,'manifestSHA256':sha(mp)};result,masks=S.score(ref,candidate);S.write_output(OUT,result,masks)
# Separately expose AA support, not a substituted depth/reference foreground or geometry improvement.
if arm=='on':
 support={}
 for row in done['frames']:
  if row['reverse']:continue
  p=O/row['prefix'];z=np.load(str(p)+'.support.npz');fg=ref['foreground'][row['view']];support[row['view']+'-'+row['case']]={'centerDepthShape':S.shape_metrics(fg,z['center']),'aaSampleSupportShape':S.shape_metrics(fg,z['aaSupport']),'targets':int(z['target'].sum()),'meaning':'Filter sample support only; formal depth and original geometry unchanged'}
 (OUT/'support-diagnostic.json').write_text(json.dumps(support,indent=2)+'\n')
assert all(sha(D/p)==h for p,h in pins.items());print('FORMAL_UNCHANGED_SCORE_COMPLETE',arm)
