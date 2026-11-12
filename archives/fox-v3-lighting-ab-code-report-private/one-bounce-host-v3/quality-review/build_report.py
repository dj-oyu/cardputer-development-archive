"""Read frozen results and RGB565/masks; write only this review directory."""
import json, hashlib
from pathlib import Path
import numpy as np
ROOT=Path(__file__).resolve().parents[1]
OUT=Path(__file__).resolve().parent
sources={}
def data(path):
    p=ROOT/path;b=p.read_bytes();sources[str(path)]=hashlib.sha256(b).hexdigest();return b
def read(path):return json.loads(data(path))
def delta(a,b):
    if isinstance(a,dict) and isinstance(b,dict):return {k:delta(a[k],b[k]) for k in a if k in b}
    if isinstance(a,list) and isinstance(b,list) and len(a)==len(b):return [delta(x,y) for x,y in zip(a,b)]
    if type(a) in (int,float) and type(b) in (int,float):return a-b
    return None
arms=('off','world','bounce'); pairs=(('world','off'),('bounce','world'),('bounce','off'))
summary=read(Path('summary.json'));metrics=read(Path('metrics.json'))
evals={a:read(Path(f'score-{a}-001/evaluation.json')) for a in arms}
frames=list(metrics['off']); responses=[f for f in frames if not f.endswith('baseline')]
assert len(frames)==10 and len(responses)==8
all_values={}; scope={}; shapes={}; fp={}
for arm in arms:
    manifest=read(Path(f'{arm}-001/candidate-manifest.json'))
    assert hashlib.sha256((ROOT/f'{arm}-001/candidate-manifest.json').read_bytes()).hexdigest()==evals[arm]['candidateManifestSHA256']
    rgb={};depth={}
    for row in manifest['frames']:
        key=row['view']+'-'+row['case']; raw=data(Path(f'{arm}-001')/row['rgb565']['file']);assert hashlib.sha256(raw).hexdigest()==row['rgb565']['sha256']
        w=np.frombuffer(raw,dtype='<u2').reshape(135,240).astype(np.uint32)
        rgb[key]=np.stack(((w>>11)/31,((w>>5)&63)/63,(w&31)/31),axis=-1)
        depth[key]=row['depth']['sha256']
    all_values[arm]={};fp[arm]={}
    for key in frames:
        m=metrics[arm][key]; e=evals[arm]['conditions'][key]
        assert m['color']==e['colorMeanPrecision']['candidateScores']
        assert m['shape']==e['shapeFullFrame']
        assert m['color']['stableSubset']['rgbAgreementPercent']==summary[arm][key]['RGB']
        all_values[arm][key]={'color':m['color'], 'shape':m['shape'], 'depthSHA256':depth[key]}
        scope[key]={'color':m['colorCounts']}
        if key in responses:
            assert m['response']==e['response']['candidateScores']
            all_values[arm][key]['response']=m['response']
            # File bytes recorded as provenance; np.load only reads this existing file.
            maskpath=Path(f'score-{arm}-001/{key}-masks.npz');data(maskpath)
            with np.load(ROOT/maskpath) as masks:
                inactive=masks['responseInactive'].astype(bool)
                bright=masks['responseBright'].astype(bool);dark=masks['responseDark'].astype(bool)
                stable=masks['responseStable'].astype(bool)
                dy=(rgb[key]-rgb[key.split('-')[0]+'-baseline'])@np.array([0.2126,0.7152,0.0722])
                cb=dy>2/255;cd=dy < -2/255
                inactive_n=int(inactive.sum());ib=int((inactive&cb).sum());idd=int((inactive&cd).sum())
                fp[arm][key]={'inactivePixels':inactive_n,'inactiveBrightFP':ib,'inactiveDarkFP':idd,'inactiveAnyFP':ib+idd,
                    'inactiveAnyFPRate':(ib+idd)/inactive_n if inactive_n else None,
                    'stableBrightFP':int((stable&cb&~bright).sum()),'stableBrightFN':int((bright&~cb).sum()),
                    'stableDarkFP':int((stable&cd&~dark).sum()),'stableDarkFN':int((dark&~cd).sum())}
                assert fp[arm][key]['stableBrightFP']==summary[arm][key]['brightFP']
            all_values[arm][key]['falsePositivesAndNegatives']=fp[arm][key]
            scope[key]['response']={k:e['response'][k] for k in ('counts','stableCoverageFraction','uncertainCoverageFraction','conditionScope','qualityScope')}
    assert evals[arm]['sixtyPercentGoal']=='NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY'
    assert evals[arm]['globalAcceptance']=='NOT_ESTABLISHED'
for key in frames:
    assert all(all_values[a][key]['shape']==all_values['off'][key]['shape'] for a in arms)
    assert len({all_values[a][key]['depthSHA256'] for a in arms})==1
    assert all(metrics[a][key]['colorCounts']==metrics['off'][key]['colorCounts'] for a in arms)
    if key in responses:assert all(metrics[a][key]['responseDomain']==metrics['off'][key]['responseDomain'] for a in arms)
comparisons={}
for a,b in pairs:
    d={key:delta(all_values[a][key],all_values[b][key]) for key in frames}
    rgbds=[d[k]['color']['stableSubset']['rgbAgreementPercent'] for k in frames]
    rds=[d[k]['response']['stableSubset'] for k in responses]
    comparisons[f'{a}-minus-{b}']={'deltaConvention':'first arm minus second; percentage metrics in percentage points; IoU in fraction units',
        'perFrame':d,'descriptiveEqualCaseSummary':{'stableRGBMeanDeltaPP':sum(rgbds)/10,'stableRGBRangeDeltaPP':[min(rgbds),max(rgbds)],
        'stableRGBImprovedCases':sum(x>0 for x in rgbds),'stableRGBWorsenedCases':sum(x<0 for x in rgbds),
        'responseSignImprovedCases':sum(x['directionAgreementPercent']>0 for x in rds),
        'responseLumaRMSEImprovedCases':sum(x['deltaLumaRMSE']<0 for x in rds),
        'responseRGBRMSEImprovedCases':sum(x['deltaRGBRMSE']<0 for x in rds),
        'responseMagnitudeImprovedCases':sum(x['responseMagnitudeAgreementPercent']>0 for x in rds)}}
report={'title':'Frozen 16x16 transport-arm numerical quality comparison','scope':'Read-only comparison, no rendering or rescoring.',
 'globalAcceptance':'NOT_ESTABLISHED','sixtyPercentGoal':'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY',
 'arms':all_values,'referenceOnlyScopeIdenticalAcrossArms':scope,'shapeAndDepthUnchangedAcrossAll10':True,
 'comparisons':comparisons,'inactiveFPMethod':'Exact supplied RGB565 R5/31 G6/63 B5/31; candidate case minus same-arm baseline, luma [0.2126,0.7152,0.0722], strict +/-2/255 threshold on frozen reference responseInactive mask. Stable class FP also counts opposite reference class, so is distinct from inactive-only FP.',
 'limitations':['Stable subset values are conditional, not global acceptance.','Uncertain, pooled and per-reference-seed scores remain descriptive; null metrics remain null, not zero or pass.',
 'Fine direction attempt failed generic rendering; no quality result and no confirmed budget attribution.','No statistical significance or converged transport claim is established by this comparison.'],
 'sourceSHA256':sources}
(OUT/'comparison.json').write_text(json.dumps(report,indent=2,allow_nan=False)+'\n')
def fmt(x,n=3):return 'N/A' if x is None else f'{x:.{n}f}'
lines=['# Frozen transport quality review','','Scope: formal OFF / WORLD / BOUNCE 16×16 runs only. No rendering or rescoring. All deltas are first arm minus second. Positive agreement/IoU is better; negative RMSE/FP is better. Null stays N/A.','',
 '**Global acceptance and the 60% goal remain NOT_ESTABLISHED.** Stable-subset values do not establish whole-image success. Uncertain/pooled/per-seed results remain descriptive.','',
 '## Findings','']
for name,c in comparisons.items():
 s=c['descriptiveEqualCaseSummary'];lines.append(f"- {name}: stable RGB improves {s['stableRGBImprovedCases']}/10, worsens {s['stableRGBWorsenedCases']}/10; equal-case mean Δ {s['stableRGBMeanDeltaPP']:+.3f} pp (descriptive only). Response sign improves {s['responseSignImprovedCases']}/8, luma RMSE {s['responseLumaRMSEImprovedCases']}/8, RGB RMSE {s['responseRGBRMSEImprovedCases']}/8, magnitude agreement {s['responseMagnitudeImprovedCases']}/8.")
lines+=['','Bounce recovers RGB relative to WORLD in every case but remains below OFF in every case. Response benefits are mixed. No single overall quality win is supported.','',
 '## All 10 stable RGB agreement values and deltas (percentage points)','', '| Case | OFF | WORLD | BOUNCE | W−O | B−W | B−O |','|---|---:|---:|---:|---:|---:|---:|']
for k in frames:
 vals=[all_values[a][k]['color']['stableSubset']['rgbAgreementPercent'] for a in arms]
 ds=[comparisons[f'{a}-minus-{b}']['perFrame'][k]['color']['stableSubset']['rgbAgreementPercent'] for a,b in pairs]
 lines.append('| '+k+' | '+' | '.join(fmt(v) for v in vals+ds)+' |')
lines+=['','## All 8 stable response changes','', 'Sign and magnitude are percentage-point deltas; bright/dark IoU deltas are converted to percentage points below. Inactive FP is an exact pixel-count delta. Full values, uncertain/pooled/per-seed changes, class FP/FN and signed correlations are in comparison.json.']
for a,b in pairs:
 lines+=['',f'### {a} minus {b}','','| Case | Sign pp | Luma RMSE | RGB RMSE | Magnitude pp | Bright IoU pp | Dark IoU pp | Inactive bright FP | Inactive dark FP | Inactive total FP |','|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|']
 for k in responses:
  d=comparisons[f'{a}-minus-{b}']['perFrame'][k];r=d['response']['stableSubset'];f=d['falsePositivesAndNegatives']
  vals=[fmt(r['directionAgreementPercent']),fmt(r['deltaLumaRMSE'],6),fmt(r['deltaRGBRMSE'],6),fmt(r['responseMagnitudeAgreementPercent'])]
  vals += [fmt(None if r[t]['IoU'] is None else 100*r[t]['IoU']) for t in ['brightening','darkening']]
  vals += [str(f[t]) for t in ['inactiveBrightFP','inactiveDarkFP','inactiveAnyFP']]
  lines.append('| '+k+' | '+' | '.join(vals)+' |')
lines+=['','## Fixed stable/uncertain scope','','| Case | Color stable | Color uncertain | Response stable | Response uncertain | Inactive |','|---|---:|---:|---:|---:|---:|']
for k,v in scope.items():
 r=v.get('response',{}).get('counts',{});lines.append(f"| {k} | {v['color']['stable']} | {v['color']['uncertain']} | {r.get('stable','N/A')} | {r.get('uncertain','N/A')} | {r.get('inactive','N/A')} |")
lines+=['','These reference-only masks/counts are identical across arms. Color and response use fixed source foreground, not candidate depth; missing candidate silhouette pixels are not silently excluded. Response stable includes inactive pixels.','',
 '## Shape and caveats','','- All 10 depth hashes and full shape metrics are identical across arms. Front IoU 88.134637%, missing 620, extra 11; oblique IoU 87.610619%, missing 720, extra 8. Shape is descriptive, not an acceptance gate.',
 '- Frozen evaluation files independently retain globalAcceptance=NOT_ESTABLISHED and sixtyPercentGoal=NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY for all arms.',
 '- Fine direction attempt failed generic rendering. No fine quality or convergence conclusion; budget cause is not confirmed.',
 '- comparison.json contains exact per-arm values and all three pairwise deltas, source SHA256s, scope, and inactive-FP derivation. Supplied summaries were checked against evaluation values. RGB565 and manifest hashes were checked; no claim that hashes prove renderer fidelity.',
 '- Existing scorer, reference, results and masks were not modified.','']
(OUT/'comparison.md').write_text('\n'.join(lines))
assert all(hashlib.sha256((ROOT/p).read_bytes()).hexdigest()==h for p,h in sources.items())
print(json.dumps({k:v['descriptiveEqualCaseSummary'] for k,v in comparisons.items()},indent=2))
