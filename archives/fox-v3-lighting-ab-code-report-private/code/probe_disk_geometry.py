import pathlib,json,numpy as np,math
R=pathlib.Path(__file__).resolve().parents[1];parts=json.loads((R/'linear-on-001/model-baseline/compile.json').read_text())['parts'];source=json.loads((R/'inputs/physical-source.json').read_text());pos=[];normal=[]
for p in parts:
 for v,n in zip(p['positions'],p['normals']):
  v=np.array(v)*38;v=v.astype('float32').astype('float64')/38;pos.append([v[0],-v[2],-v[1]])
  n=np.array(n,dtype='float32').astype('float64');n/=np.linalg.norm(n);n=np.floor(n*32767+.5)/32767;normal.append([n[0],-n[2],-n[1]])
pos=np.array(pos);normal=np.array(normal);normal/=np.linalg.norm(normal,axis=1)[:,None];normal=np.concatenate([normal,-normal]);pos=np.concatenate([pos,pos]);result={'scope':'all actual model partition vertices, front/back SNORM normal; geometry-only fixed16/64/1024/4096 diagnostic, no pixels or fitting','queriesPerCase':len(pos),'cases':{}}
np.savetxt(R/'geometry-probe/queries.txt',np.concatenate([pos,normal],axis=1),fmt='%.17g')
for case in source['cases']:
 if case['name'] not in ['baseline','direction']:continue
 lights=[];values=[]
 for l in case['lights']:
  x,y,z=l['eulerXYZ'];cx,sx=math.cos(x),math.sin(x);cy,sy=math.cos(y),math.sin(y);cz,sz=math.cos(z),math.sin(z)
  rot=np.array([[cz*cy,cz*sy*sx-sz*cx,cz*sy*cx+sz*sx],[sz*cy,sz*sy*sx+cz*cx,sz*sy*cx-cz*sx],[-sy,cy*sx,cy*cx]])
  ns=-rot[:,2];u=rot[:,0];v=rot[:,1];center=np.array(l['position']);r=l['diameter']/2;d=pos-center;h=d@ns/r;dist=np.linalg.norm(d,axis=1)/r;wi=-d/np.linalg.norm(d,axis=1)[:,None];receiver=np.sum(normal*wi,axis=1);lights.append({'name':l['name'],'signedHeightOverRadiusMinMax':[float(h.min()),float(h.max())],'distanceOverRadiusMinMax':[float(dist.min()),float(dist.max())],'receiverCenterGrazingAbsCosBelowPoint1':int((abs(receiver)<.1).sum()),'receiverCenterBackFacing':int((receiver<=0).sum()),'sourceCenterGrazingAbsCosBelowPoint1':int((abs(np.sum(-wi*ns,axis=1))<.1).sum())})
  values.extend(l['position']+l['eulerXYZ']+l['color']+[l['power'],l['diameter']])
 values.extend([0,0,0,0]);(R/'geometry-probe'/('light-'+case['name']+'.txt')).write_text('FOXDISK1\n'+' '.join(map(str,values))+'\n');result['cases'][case['name']]={'lights':lights}
(R/'geometry-probe/geometry.json').write_text(json.dumps(result,indent=2))
