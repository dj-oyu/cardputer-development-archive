"""Read-only raw owned-geometry audit; aggregate output only, no image fitting."""
from pathlib import Path
import json,sys,math,hashlib,numpy as np
O=Path(sys.argv[1]).resolve();OUT=Path(sys.argv[2]);assert not OUT.exists();done=json.load(open(O/'COMPLETED.json'));assert done['status']=='ALL4_CHAINS_COMPLETE';rows=[]
for row in done['rows']:
 p=O/row['prefix'];l=row['lifecycle'];base=np.fromfile(str(p)+'.identity.geometry.f64le','<f8').reshape(-1,3);idx=Path(str(p)+'.identity.indices.u32le').read_bytes();attr0=np.fromfile(str(p)+'.identity.attributes.bin',np.uint8).reshape(1566,64);n0=np.fromfile(str(p)+'.identity.normals.i16le','<i2').reshape(1163,2,3).astype(np.int32)
 assert base.shape==(1167,3) and len(idx)==1566*3*4
 for m in l['poses']:
  label=m['pose'];v=np.fromfile(str(p)+'.'+label+'.geometry.f64le','<f8').reshape(-1,3);a=np.fromfile(str(p)+'.'+label+'.attributes.bin',np.uint8).reshape(1566,64);n=np.fromfile(str(p)+'.'+label+'.normals.i16le','<i2').reshape(1163,2,3).astype(np.int32);assert np.isfinite(v).all() and np.array_equal(v[1163:],base[1163:]);assert Path(str(p)+'.'+label+'.indices.u32le').read_bytes()==idx;assert np.array_equal(n[:,1,:],-n[:,0,:]);assert np.array_equal(a[1564:],attr0[1564:])
  # Every triangle retains mask, A/B565, sidedness, and padding. Only normals may change.
  keep=[k for j in range(3) for k in range(j*20+12,j*20+20)]+list(range(60,64));assert np.array_equal(a[:,keep],attr0[:,keep]);height=float(np.max(np.abs(v[:1163,2]-base[:1163,2])));assert height==m['maxSourceHeightDelta']==0
  angle=float(m['yawRadiansFloat']);c,s=math.cos(angle),math.sin(angle);want=base[:1163].copy();want[:,0]=c*base[:1163,0]-s*base[:1163,1];want[:,1]=s*base[:1163,0]+c*base[:1163,1];res=float(np.max(np.abs(v[:1163]-want)));assert abs(res-m['maxRootRotationResidual'])<1e-15
  pair=0.;count=0
  for i in range(1,1163):
   before=np.sqrt(np.sum((base[i]-base[:i])**2,axis=1));after=np.sqrt(np.sum((v[i]-v[:i])**2,axis=1));pair=max(pair,float(np.max(np.abs(before-after))));count+=i
  assert count==m['pairDistancesChecked']==675703 and abs(pair-m['maxPairDistanceDelta'])<2e-15
  if label in ['identity','return-identity']:assert np.array_equal(v,base) and np.array_equal(n,n0) and np.array_equal(a,attr0)
  rows.append({'view':row['view'],'reverse':row['reverse'],'pose':label,'vertices':1163,'triangles':1564,'allPairDistancesChecked':count,'maxPairDistanceDeltaSourceUnits':pair,'maxYawResidualSourceUnits':res,'heightDelta':height,'allFrontBackExactlyOpposite':True,'groundBytesExact':True,'indicesExact':True,'allMaskRhoSidePaddingExact':True,'identityReturnArraysExact':label in ['identity','return-identity']})
OUT.write_text(json.dumps({'status':'ALL16_OWNED_GEOMETRY_POSE_AUDITS_PASS','scope':'Source-unit rigid position/normal-pair/material-field checks; no skin or visible-contact guarantee','rows':rows},indent=2)+'\n');print('ALL16_OWNED_GEOMETRY_POSE_AUDITS_PASS')
