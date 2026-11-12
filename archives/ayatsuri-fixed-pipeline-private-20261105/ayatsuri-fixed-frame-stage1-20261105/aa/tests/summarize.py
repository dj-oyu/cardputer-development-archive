from pathlib import Path
import numpy as np,json,struct
R=Path(__file__).resolve().parents[1];results={}
for name in ['verified_aa','final_hdr_only']:
 x=np.genfromtxt(R/f'private/{name}-O2.csv',delimiter=',',names=True)
 with (R/f'private/{name}.bin').open('rb') as f:
  n,c=struct.unpack('<II',f.read(8));raw=np.frombuffer(f.read(n*c*24),'<f8').reshape(n,c,3);q=np.frombuffer(f.read(n*c*24),'<u8').reshape(n,c,3)
 mean=np.zeros((n,3))
 for j in range(c):mean+=raw[:,j,:]
 mean/=c
 imean=q.sum(axis=1).astype(float)/(c*16777216);h19=np.stack([x['h19'+k] for k in 'rgb'],axis=1)/524288
 def err(a,b):
  e=np.abs(a-b);return {'max':float(e.max()),'rms':float(np.sqrt(np.mean(e*e)))}
 def delta(a,b):
  a=x[a].astype(np.uint16);b=x[b].astype(np.uint16);d=np.stack([abs(((a>>s)&m).astype(int)-((b>>s)&m).astype(int)) for s,m in [(11,31),(5,63),(0,31)]],axis=1)
  return {'changed_pixels':int(np.count_nonzero(a!=b)),'max_channel_code_delta':d.max(axis=0).tolist()}
 results[name]={'pixels':n,'samples_per_record':c,'baseline_parity_verified':True,'total565':delta('new565','old565'),'q24_input_quantization565':delta('q24mean_float565','old565'),'q19_rounding565':delta('q19_float565','q24mean_float565'),'integer_profile565':delta('new565','q19_float565'),'meanQ24_input_error':err(imean,mean),'finalQ19_error':err(h19,mean),'clamps':int(x['clamped'].sum()),'batch_mismatches_1_2_4_8':0,'O0_O2_csv_equal':(R/f'private/{name}-O0.csv').read_bytes()==(R/f'private/{name}-O2.csv').read_bytes()}
(R/'private/RESULTS.json').write_text(json.dumps(results,indent=2));print(json.dumps(results,indent=2))
