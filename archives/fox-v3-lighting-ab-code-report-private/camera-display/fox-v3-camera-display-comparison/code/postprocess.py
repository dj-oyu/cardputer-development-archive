"""Same pinned composed HDR, existing legacy/AgX profile; no filtering or fitting."""
from common import *
import time,statistics,resource
assert len(sys.argv)==3;O=Path(sys.argv[1]).resolve();assert O.parent==R;gate=O/'LEGACY_CONTROL.json';assert sha(gate)==sys.argv[2];g=json.load(open(gate));assert g['status']=='ALL10_LEGACY_BYTE_EXACT' and len(g['frames'])==10 and all(f['all565Exact'] for f in g['frames']);assert not (O/'COMPLETED.json').exists();lib,fun=check_profile();a=admission();frames=[];cost=[];clamps=[];inputpins=json.load(open(O/'INPUT_PINS.json'))
inputpins.update({str(Path(__file__)):sha(Path(__file__)),str(R/'code/common.py'):sha(R/'code/common.py'),str(gate):sha(gate),str(R/'PROFILE_INPUT_FREEZE.json'):sha(R/'PROFILE_INPUT_FREEZE.json'),str(LIB):sha(LIB)})
for f in g['frames']:
 view,case=f['view'],f['case'];key=view+'-'+case;hp=O/f['hdr'];assert sha(hp)==f['hdrSHA256'];raw=np.fromfile(hp,'<f8').reshape(135,240,3);inputpins[str(hp)]=sha(hp);assert sha(O/f['legacy'])==f['legacySHA256'];expected=np.fromfile(O/f['legacy'],'<u2').reshape(135,240);times={0:[],1:[]};reference={};flags={}
 # Fixed11 alternate calls, all resulting bytes consumed and checked, not best-of selection.
 for repeat in range(11):
  for enabled in [0,1]:
   start=time.perf_counter_ns();encoded,clamp=encode(fun,raw,enabled);elapsed=time.perf_counter_ns()-start;times[enabled].append(elapsed)
   if enabled not in reference:reference[enabled]=encoded.copy();flags[enabled]=clamp
   assert np.array_equal(encoded,reference[enabled]) and clamp==flags[enabled]
 assert np.array_equal(reference[0],expected) and flags[0]==0
 ap=O/('agx-'+key+'.u16le');assert not ap.exists();reference[1].astype('<u2').tofile(ap)
 domain=np.any(raw.astype(np.float32).astype(np.float64)>5898.240000132513,axis=2);saturation=np.any(raw>1,axis=2);assert int(domain.sum())==flags[1]
 u=reference[1];rgbcodes=np.stack([u>>11,(u>>5)&63,u&31],axis=-1);zero=np.any(rgbcodes==0,axis=2);maximum=np.any(rgbcodes==np.array([31,63,31]),axis=2)
 cp=O/('profile-clamps-'+key+'.npz');np.savez_compressed(cp,profileDomainClamp=domain,legacySaturation=saturation,agxQuantizedAnyZero=zero,agxQuantizedAnyMax=maximum)
 clamps.append({'view':view,'case':case,'profileDomainClampPixels':int(domain.sum()),'legacySaturationPixels':int(saturation.sum()),'agxQuantizedAnyZeroPixels':int(zero.sum()),'agxQuantizedAnyMaxPixels':int(maximum.sum()),'pixels':32400,'noExcludedPixels':True,'endpointCountsAreQuantizedNotLUTDomainClipping':True,'flagsFile':cp.name,'flagsSHA256':sha(cp)})
 frames.append({'view':view,'case':case,'legacySHA256':f['legacySHA256'],'agxSHA256':sha(ap),'hdrSHA256':f['hdrSHA256'],'characterDepthSHA256':f['characterDepthSHA256'],'clampFlagsSHA256':sha(cp)})
 for enabled in [0,1]:cost.append({'view':view,'case':case,'arm':'agx' if enabled else 'legacy','rawNs':times[enabled],'minNs':min(times[enabled]),'medianNs':statistics.median(times[enabled]),'maxNs':max(times[enabled]),'repetitions':11,'allOutputBytesConsumedAndEqual':True})
 print(key,'PROFILE_COMPLETE',flush=True)
a.recheck();check_profile();assert all(sha(p)==h for p,h in inputpins.items());save(O/'POSTPROCESS_INPUT_PINS.json',inputpins);save(O/'CLAMPS.json',{'frames':clamps,'profileDomainMaximum':5898.240000132513,'clampExclusion':False});save(O/'COST.json',{'rows':cost,'scope':'Python ctypes existing compiled C buffer including validation/encode, allocation and counter handoff. Host elapsed11 repetitions, not device time.','fixedSchedule':'frame order from gate,11 repetitions,legacy thenAgX','lutReadOnlyPayloadBytes':3295500,'oneHDRArrayBytes':777600,'oneRGB565ArrayBytes':64800,'diagnosticProcessPeakRSSKiB':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,'fullHDRProductFitClaim':False});save(O/'COMPLETED.json',{'status':'ALL10_DISPLAY_COMPLETE','frames':frames,'legacyGateSHA256':sha(gate),'inputPinsSHA256':sha(O/'POSTPROCESS_INPUT_PINS.json'),'sameHDRBothArms':True,'sourceInputsUnchanged':True,'formalCharacterDepthUnchanged':True,'clampExcludedFromScoring':False,'profileInputFreezeSHA256':sha(R/'PROFILE_INPUT_FREEZE.json'),'existingProfileBinarySHA256':sha(LIB),'noNewRendererExecution':True});print('ALL10_DISPLAY_COMPLETE')
