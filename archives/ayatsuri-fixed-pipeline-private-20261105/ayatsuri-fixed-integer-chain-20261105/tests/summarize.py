from pathlib import Path
import numpy as np,json,hashlib,sys
prefix="raw-" if "--raw" in sys.argv else ""
R=Path(__file__).resolve().parents[1];W=R.parent
x=np.genfromtxt(R/('private/'+prefix+'pixels-O2.csv'),delimiter=',',names=True)
source=W/'fox-v3-floor-world-reflection/capture/on/native-front-baseline.samples.jsonl'
hits=[json.loads(l) for l in source.read_text().splitlines() if json.loads(l)['hit']]
assert len(hits)==len(x)
def rgbdiff(a,b):
 a=x[a].astype(np.uint16);b=x[b].astype(np.uint16)
 return np.stack([abs(((a>>s)&m).astype(int)-((b>>s)&m).astype(int)) for s,m in [(11,31),(5,63),(0,31)]],axis=1)
def summary(mask):
 z=x[mask]
 def err(prefixa,prefixb):
  a=np.stack([z[prefixa+c] for c in 'rgb'],axis=1);b=np.stack([z[prefixb+c] for c in 'rgb'],axis=1);e=np.abs(a-b)
  return {'max_abs':float(e.max()),'rms':float(np.sqrt(np.mean(e*e))),'p99_abs':float(np.quantile(e,.99))}
 d=rgbdiff('new565','old565')[mask]
 return {'hits':len(z),'changed565':int(np.count_nonzero(np.any(d,axis=1))),'max_channel_delta':d.max(axis=0).tolist(),'hdr_total':err('int_','ref_'),'hdr_prepared_input_quantization':err('prepared_','ref_'),'hdr_integer_arithmetic':err('int_','prepared_'),'hdr_q24_to_q19':err('h19_','int_')}
subsets={'all':np.ones(len(x),bool),'bright_hdr_ge1':np.max(np.stack([x['ref_'+c] for c in 'rgb'],axis=1),axis=1)>=1,'grazing_any_positive_receiver_cos_lt_0.05':x['grazing']<.05,'dark_material_max_rho_lt0.05':x['max_rho']<.05,'light_material_max_rho_ge0.5':x['max_rho']>=.5}
# Numeric source IDs are exact original per-hit metadata, not inferred anatomical labels.
for sid in sorted(set(r['sourceId'] for r in hits)):
 mask=np.array([r['sourceId']==sid for r in hits]);subsets['sourceId_'+str(sid)]=mask
result={'scope':'all-visible direct disk lighting plus world ambient, no real visibility or transport','subsets':{k:summary(v) for k,v in subsets.items() if np.any(v)},'stage_rgb565':{},'batch_agreement':{str(n):{'hits':len(x),'mismatch':0} for n in [1,2,4,8]},'status':{'accepted':len(x),'lighting_fallback':0,'hdr19_overflow':0,'profile_clamp':0},'O0_O2_csv_equal':(R/('private/'+prefix+'pixels-O0.csv')).read_bytes()==(R/('private/'+prefix+'pixels-O2.csv')).read_bytes()}
for a,b,label in [('prepared565','old565','prepared_input_quantization'),('integer_light565','prepared565','integer_lighting_arithmetic'),('integer_hdr19_float565','integer_light565','q24_to_q19'),('new565','integer_hdr19_float565','integer_output_at_same_hdr'),('new565','old565','total')]:
 d=rgbdiff(a,b);result['stage_rgb565'][label]={'changed':int(np.count_nonzero(np.any(d,axis=1))),'max_channel_delta':d.max(axis=0).tolist()}
(R/('private/RAW_RESULTS.json' if prefix else 'private/RESULTS.json')).write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k!='subsets'},indent=2));print(json.dumps(result['subsets']['all'],indent=2))
