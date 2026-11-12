"""Read-only retained output verification; never launches any render."""
from pathlib import Path
import math
from run_fixed40 import R,B,C,G,check,sha,read,write,validate,base_root

def audit():
 pins,build,contract=check();counts={'diagnosticFrames':0,'noDepthCaptureHDRCanaries':0,'raw':0,'reports':0,'sidecars':0,'forwardReverse':0};observations={}
 for mode in ('diagnostic','production'):
  for arm in ('off','on'):
   root=R/(f'actual-{arm}-001' if mode=='diagnostic' else f'production-{arm}-001');manifest=read(root/'COMPLETED.json')
   expected='ALL20_EXACT_COMPLETE' if mode=='diagnostic' else 'PRODUCTION_CANARY_EXACT_COMPLETE';assert manifest['status']==expected
   names=pins['cases'][arm] if mode=='diagnostic' else ['native-front-baseline'];assert [f['name'] for f in manifest['frames']]==names
   measures=[]
   for f in manifest['frames']:
    name=f['name'];assert f['status']=='PASS' and f['mode']==mode and f['arm']==arm
    oldframe=next(x for x in read(base_root(arm,mode)/'COMPLETED.json')['frames'] if x['name']==name)
    assert all(f[k]==oldframe[k] for k in ('name','view','case','reverse','arm'))
    prefix=root/name;old=base_root(arm,mode)/name
    assert Path(str(prefix)+'.stderr').read_bytes()==b''
    assert not Path(str(prefix)+'.stdout-pending').exists()
    files,deltas=validate(prefix,old,arm,name,mode);assert set(f['files'])==set(files) and f['reportObservations']==deltas
    for e,h in f['files'].items():assert sha(str(prefix)+e)==h
    c=read(str(prefix)+'.command.json');bc=read(str(old)+'.command.json')
    assert c['command']==[str(R/'build-adapter/native-render'),bc['command'][1],str(prefix),*bc['command'][3:]]
    assert c['environment']=={**bc['environment'],**contract['environmentByMode'][mode]} and c['runtimeInputs']==bc['runtimeInputs']
    assert c['binarySHA256']==build['binarySHA256'] and c['gateSHA256']==sha(G) and c['mode']==mode
    aa=read(str(prefix)+'.aa.json');row=read(str(prefix)+'.row.json');v=read(str(prefix)+'.json')
    assert aa['complete'] is True and row['complete'] is True and v['visibilityComplete'] is True and v['transportComplete'] is True
    assert aa['observedTotal']<=aa['reservedTotal']<=8000000
    depth=read(str(prefix)+'.depth-stream.json')
    assert depth['producerWorkIncludingDepth']==sum(row['producerUsed'])+depth['pendingCopyFloats']+depth['captureCopyFloats']<=637599
    assert sum(row['producerUsed'])<=637599 and row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728 and row['adapterGuardUpper']==1024
    for kind in ('visibility','transport'):
     for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert v[kind+used]<=v[kind+limit]
    if mode=='diagnostic' and not f['reverse']:
     for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:
      assert Path(str(prefix)+e).read_bytes()==Path(str(root/(name+'-reverse'))+e).read_bytes();counts['forwardReverse']+=1
    measures.append({k:f[k] for k in ('elapsedSecondsDescriptiveOnly','hostUserCPUSeconds','hostSystemCPUSeconds','hostPeakRSSKiB')})
    assert all(type(x) in (int,float) and math.isfinite(x) and x>=0 for x in measures[-1].values())
    counts['diagnosticFrames' if mode=='diagnostic' else 'noDepthCaptureHDRCanaries']+=1;counts['raw']+=5 if mode=='diagnostic' else 4;counts['reports']+=9;counts['sidecars']+=0
   observations[mode+'-'+arm]={'wallSeconds':sum(x['elapsedSecondsDescriptiveOnly'] for x in measures),'userCPUSeconds':sum(x['hostUserCPUSeconds'] for x in measures),'systemCPUSeconds':sum(x['hostSystemCPUSeconds'] for x in measures),'maximumProcessPeakRSSKiB':max(x['hostPeakRSSKiB'] for x in measures)}
 assert counts=={'diagnosticFrames':40,'noDepthCaptureHDRCanaries':2,'raw':208,'reports':378,'sidecars':0,'forwardReverse':80}
 check();result={'status':'PASS_RETAINED_FIXED42_COMPARISON','counts':counts,'observations':observations,'actualNoFullDepthObserverCoverage':2,'actualDiagnosticCoverage':40,'historicalLifetimeFixed40WallSecondsDescriptiveOnly':702.4117662550416,'full42TimingNotComparableToHistorical40':True,'memoryClaim':'Diagnostic full-frame depth and HDR observation are separately charged, not production memory. Named payload/stack figures are not process RAM or device fit.','rerenders':0,'gateSHA256':sha(G),'auditSHA256':sha(__file__)}
 write(C/'FIXED42_RESULT.json',result);return result
if __name__=='__main__':print(audit())
