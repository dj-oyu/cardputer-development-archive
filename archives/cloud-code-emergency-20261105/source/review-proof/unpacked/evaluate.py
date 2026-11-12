"""Bounded offline diagnosis. Reference z raster is NOT a replacement runtime."""
import pathlib,json,subprocess,time,math,hashlib,resource,struct,sys
import numpy as np
from PIL import Image,ImageDraw
ROOT=pathlib.Path(__file__).resolve().parent
OUT=ROOT/(sys.argv[1] if len(sys.argv)>1 else 'results');OUT.mkdir(exist_ok=False)
W,H=240,135; SCALE=38
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rgb565(c):
    c=np.asarray(c);c=np.where(c<=.0031308,12.92*c,1.055*c**(1/2.4)-.055)
    q=np.floor(c*np.array([31,63,31])+.5).astype(int)
    return int((q[0]<<11)|(q[1]<<5)|q[2])
def png565(a,p):
    a=a.astype(np.uint16); rgb=np.stack([((a>>11)&31)*255//31,((a>>5)&63)*255//63,(a&31)*255//31],axis=-1).astype(np.uint8)
    Image.fromarray(rgb).save(p)
def project(p,yaw):
    a=math.radians(yaw);c,s=math.cos(a),math.sin(a)
    return np.column_stack([120+SCALE*(c*p[:,0]-s*p[:,2]),67+SCALE*p[:,1],SCALE*(s*p[:,0]+c*p[:,2])])
def raster(surfaces,yaw):
    z=np.full((H,W),-np.inf); ids=np.full((H,W),-1,dtype=int);colors=np.zeros((H,W),dtype=np.uint16)
    for sid,surface in enumerate(surfaces):
        p=project(np.array(surface['positions']),yaw)
        for tid,tri in enumerate(surface['triangles']):
            v=p[tri]; a,b,c=v
            area=(b[0]-a[0])*(c[1]-a[1])-(b[1]-a[1])*(c[0]-a[0])
            if area<=1e-5:continue
            x0=max(0,math.ceil(min(v[:,0])));x1=min(W-1,math.floor(max(v[:,0])))
            y0=max(0,math.ceil(min(v[:,1])));y1=min(H-1,math.floor(max(v[:,1])))
            if x0>x1 or y0>y1:continue
            yy,xx=np.mgrid[y0:y1+1,x0:x1+1]
            weights=[];inside=np.ones(xx.shape,dtype=bool)
            for e0,e1 in [(b,c),(c,a),(a,b)]:
                dx=e1[0]-e0[0];dy=e1[1]-e0[1]
                val=dx*(yy-e0[1])-dy*(xx-e0[0]);closed=dy<0 or (dy==0 and dx>0)
                inside &= (val>0)|((val==0)&closed)
                weights.append(val/area)
            dep=sum(weights[k]*v[k,2] for k in range(3));sub=z[y0:y1+1,x0:x1+1]
            update=inside&(dep>sub);sub[update]=dep[update]
            ids[y0:y1+1,x0:x1+1][update]=sid
            colors[y0:y1+1,x0:x1+1][update]=surface['colors565'][tid]
    return colors,z,ids
def direct_surfaces(data):return [dict(s,colors565=[rgb565(c) for c in s['linearColors']]) for s in data['surfaces']]
def ir_surfaces(ir):
    mats={m['stableId']:rgb565(m['baseColor'][:3]) for m in ir['materials']};nodes={n['stableId']:n for n in ir['nodes']}
    return [dict(s,id=nodes[s['nodeId']]['name'].removeprefix('sample_'),colors565=[mats[s['materialId']]]*len(s['triangles'])) for s in ir['surfaces']]
def run(cmd,stem):
    begin=time.perf_counter();r=subprocess.run(cmd,cwd=ROOT,capture_output=True,text=True,timeout=120)
    (OUT/(stem+'.stdout.txt')).write_text(r.stdout);(OUT/(stem+'.stderr.txt')).write_text(r.stderr)
    return r,1000*(time.perf_counter()-begin)
summary={'scope':'ACTUAL BLENDER AUTHORING + STATIC POSE DIAGNOSTIC; no runtime morph / reduction / device acceptance','referenceCommit':'76796a5c5ae53505de7de4f79b8e205ea1dc9c19','runs':[],'cases':[]}
for revision,folder in [('before','exports-before-v2'),('after','exports-after')]:
    exp=ROOT/folder
    rejected,ms=run(['node','compile_identity.cjs',str(exp/'with-morph.glb'),str(OUT/(revision+'-must-reject-morph'))],revision+'-morph')
    assert rejected.returncode==1 and 'morph unsupported' in rejected.stderr
    summary['runs'].append({'revision':revision,'morphImport':'UNSUPPORTED; explicit error; no silent target loss','error':rejected.stderr.strip()})
    for pose in ['neutral','blink-half','blink','jaw-half','jaw','combined']:
        stem=revision+'-'+pose;compiled=OUT/(stem+'-compile')
        r,compile_ms=run(['node','compile_identity.cjs',str(exp/(pose+'.glb')),str(compiled)],stem+'-compile');assert r.returncode==0,r.stderr
        report=json.loads((compiled/'compile.json').read_text());ir=json.loads((compiled/'scene.ir.json').read_text())
        source=json.loads((exp/(pose+'.source.json')).read_text());source=direct_surfaces(source);imported=ir_surfaces(ir)
        for yaw in [0,-35,35]:
            case=stem+'-yaw'+str(yaw);dest=OUT/case;dest.mkdir()
            a=math.radians(yaw);camera=[400*math.sin(a),0,400*math.cos(a),0,0,0,1,120,67]
            cmd=[sys.executable,str(ROOT/'measure_child.py'),str(dest/'host-maxrss-kib.txt'),str(ROOT/'native-render'),str(compiled/'model.aynm'),str(dest),*map(str,camera),*map(str,[-.5,-.4,.8,1,1,1]),'0',*map(str,[0,0,0,0,0,0,1,1,1])]
            native,render_ms=run(cmd,case);assert native.returncode==0,native.stderr
            meta=json.loads((dest/'metadata.json').read_text())
            actual=np.fromfile(dest/'pixels.u16le',dtype='<u2').reshape(H,W)
            tags=np.fromfile(dest/'visible-triangles.u16le',dtype='<u2').reshape(H,W)
            source_img,source_z,source_id=raster(source,yaw);ref,depth,ref_id=raster(imported,yaw)
            png565(source_img,dest/'blender-source.png');png565(ref,dest/'export-depth-reference.png');png565(actual,dest/'native.png')
            export_difference=int(np.count_nonzero(source_img!=ref))
            source_id_by_name={s['id']:i for i,s in enumerate(source)}
            imported_name_by_sid={s['stableId']:s['id'] for s in imported}
            part_name={p['nodeId']:imported_name_by_sid[p['sourceSurface']] for p in report['parts']}
            tag_to_source={tag:source_id_by_name[part_name[p['nodeId']]] for p in meta['packets'] for tag in p['triangleTags']}
            native_id=np.full((H,W),-1,dtype=int)
            for tag,sid in tag_to_source.items():native_id[tags==tag]=sid
            # Count interior semantic errors separately from raster boundary differences.
            interior=source_id>=0
            for dy,dx in [(-1,0),(1,0),(0,-1),(0,1)]:interior &= source_id==np.roll(source_id,(dy,dx),axis=(0,1))
            wrong=interior&(native_id!=source_id)
            differing=actual!=ref;diff=np.zeros((H,W,3),dtype=np.uint8);diff[differing]=[220,95,50];diff[wrong]=[255,0,190]
            Image.fromarray(diff).save(dest/'difference.png')
            metrics={'revision':revision,'pose':pose,'yaw':yaw,'sourceToExportDifferentPixels':export_difference,'nativeDifferentPixels':int(differing.sum()),'interiorWrongPartPixels':int(wrong.sum()),'wrongPartByExpected':{s['id']:int((wrong&(source_id==i)).sum()) for i,s in enumerate(source)},'coldBytes':report['coldBytes'],'instanceArenaBytes64bit':meta['arenaBytes'],'frameSegments':meta['frameSegments'],'rasterCost':meta['frameRasterCost'],'compileWallMs':compile_ms,'compilerInternalMs':report['compileMs'],'nativeHostProcessWallMsIncludingDiagnosticPasses':render_ms,'nativeHostMaxRssKiB':int((dest/'host-maxrss-kib.txt').read_text()),'sourceVertices':report['sourceVertices'],'partitionVertices':report['partitionVertices'],'sourceTriangles':report['sourceTriangles'],'output':str(dest.relative_to(ROOT))}
            (dest/'comparison.json').write_text(json.dumps(metrics,indent=2));summary['cases'].append(metrics)
(OUT/'study.json').write_text(json.dumps(summary,indent=2))
# Review sheets preserve native pixel dimensions, enlarged only by nearest-neighbor for legibility.
for yaw in [0,-35,35]:
    rows=[('before','neutral'),('after','neutral'),('after','blink-half'),('after','blink'),('after','jaw'),('after','combined')]
    sheet=Image.new('RGB',(240*3*2+140,135*2*len(rows)+50),(24,27,33));draw=ImageDraw.Draw(sheet)
    for col,title in enumerate(['Blender evaluated source','Existing native renderer','Difference / wrong part']):draw.text((145+480*col,15),title,fill='white')
    for row,(revision,pose) in enumerate(rows):
        draw.text((6,65+270*row),revision+'\n'+pose+'\nyaw '+str(yaw),fill='white')
        dest=OUT/(revision+'-'+pose+'-yaw'+str(yaw))
        for col,name in enumerate(['blender-source.png','native.png','difference.png']):
            im=Image.open(dest/name).resize((480,270),Image.Resampling.NEAREST);sheet.paste(im,(140+480*col,40+270*row))
    sheet.save(OUT/('comparison-yaw'+str(yaw)+'.png'))
print(json.dumps({'cases':len(summary['cases']),'maxExportPixelDifference':max(x['sourceToExportDifferentPixels'] for x in summary['cases']),'minInteriorWrongPartPixels':min(x['interiorWrongPartPixels'] for x in summary['cases']),'maxInteriorWrongPartPixels':max(x['interiorWrongPartPixels'] for x in summary['cases'])}))
