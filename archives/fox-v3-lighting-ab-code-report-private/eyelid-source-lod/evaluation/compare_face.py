import pathlib,json,sys,numpy as np
R=pathlib.Path(__file__).resolve().parent;W=R.parent;sys.path.insert(0,str(R/'scoring'));import score_candidate as S
ref=S.load_reference(W/'fox-reference-uncertainty-v3');roi=np.zeros((135,240),bool);roi[12:76,108:168]=True;fg=ref['foreground']['oblique']&roi
out={'scope':'Descriptive only, no additional acceptance threshold; fixed oblique crop x108:168 y12:76 inherited from existing preview. No dedicated eye mask exists; unchanged non-target geometry does not exclude occlusion regressions. Inherited muzzle geometry preservation FAIL remains separate; eye audit pending independently.','crop':[108,12,168,76],'cropPixels':int(roi.sum()),'sourceForegroundCropPixels':int(fg.sum()),'cases':{}}
def raw(root,case):
 p=root/('native-oblique-'+case+'.u16le');return np.fromfile(p,'<u2').reshape(135,240),S.decode_rgb565(p.read_bytes())
for case in S.CASES:
 mean=ref['arrays'][('oblique',case)].astype(np.float64).mean(axis=0)/255;oldword,old=raw(W/'fox-v3-normal-pair-evaluation/actual-on',case);entry={}
 for stage,root in [('eyeB',W/'fox-v3-normal-pair-evaluation/actual-on'),('lid8',R/'actual-lid8-v2'),('lid9',R/'actual-lid9-v2')]:
  if stage!='old' and not (root/'candidate-manifest.json').exists():continue
  word,rgb=raw(root,case);entry[stage]={'cropRGBMAE':float(np.abs(rgb-mean)[roi].mean()),'sourceForegroundCropRGBMAE':float(np.abs(rgb-mean)[fg].mean()),'changedRGB565PixelsVsEyeB':int(((word!=oldword)&roi).sum()),'meanAbsoluteRGBDifferenceVsEyeB':float(np.abs(rgb-old)[roi].mean()),'exactBlackPixelsInSourceForegroundCrop':int(((word==0)&fg).sum())}
 for stage in ['lid8','lid9']:
  if stage in entry:entry[stage]['cropRGBMAEDeltaVsEyeB']=entry[stage]['cropRGBMAE']-entry['eyeB']['cropRGBMAE'];entry[stage]['sourceForegroundCropRGBMAEDeltaVsEyeB']=entry[stage]['sourceForegroundCropRGBMAE']-entry['eyeB']['sourceForegroundCropRGBMAE']
 out['cases'][case]=entry
(R/'face-comparison.json').write_text(json.dumps(out,indent=2));print(json.dumps(out,indent=2))
