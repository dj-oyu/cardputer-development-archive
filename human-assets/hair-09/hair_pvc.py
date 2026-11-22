"""Replace fine sculpted hair locks with a few PVC-like forms and packed albedo artwork."""
import bpy, sys, math, hashlib, json
from pathlib import Path
from array import array
from math import cos,sin,pi,exp
src,out=map(Path,sys.argv[-2:]);src=src.resolve();out=out.resolve()
bpy.ops.wm.open_mainfile(filepath=str(src));s=bpy.context.scene;s.frame_set(1)
hair=bpy.data.collections['Hair – sculpted locks']
dg=bpy.context.evaluated_depsgraph_get()
def tris(ob):
    o=ob.evaluated_get(dg);m=o.to_mesh();m.calc_loop_triangles();n=len(m.loop_triangles);o.to_mesh_clear();return n
before={o.name:tris(o) for o in hair.objects}
keep={'Bob back mass':16,'Large right side-sweep':10,'Left wide brushed fringe':10,'Left swept temple curl':10,'Right framing curl':10,'Little lifted crown tuft':10,'Outer light airy tuft':10}
for o in list(hair.objects):
    if o.name not in keep: bpy.data.objects.remove(o,do_unlink=True)
# The original ring cap was underneath 12 disconnected tips. Turn it into the
# single rear shell; eye-side ear cutouts and original silhouette wire stay intact.
cap=bpy.data.objects['Bob back mass']
for v in cap.data.vertices:
    x,y,z=v.co
    a=(v.index%16)*2*pi/16
    mid=exp(-((z-4.52)/.33)**2)
    back=(.5+.5*sin(a))**1.65
    ear=exp(-((z-4.58)/.16)**2)*exp(-((y+.045)/.15)**2)
    x*=1+(.17*mid+.08*exp(-((z-4.83)/.28)**2))*(1-.73*ear)
    y+=.11*mid*back
    # Two asymmetric sculpt volumes blended into one structural cap.
    y+=back*(.042*cos(5*a+.46)-.026*cos(3*a-.21))*sin(pi*max(0,min(1,(z-4.17)/1.35)))
    # Hem varies with the uneven bob sweep, instead of twelve repeated tips.
    low=exp(-((z-4.29)/.21)**2)
    z+=low*(.038*cos(2*a+.62)+.042*sin(3*a-.46)+.023*sin(5*a+.80))
    v.co=(x,y,z)
# Longitudinal UV from the existing sculpt construction order. Unwrapped U
# follows the section, V follows the volume root-to-tip (cap bottom-to-crown).
def uv_ring(o,k):
    m=o.data; n=len(m.vertices)//k;assert k*n==len(m.vertices)
    uv=m.uv_layers.new(name='MoldedHair_PaintedFlow')
    for p in m.polygons:
        ids=[m.loops[i].vertex_index for i in p.loop_indices]
        cols=[j%k for j in ids]
        cap=len(ids)==k
        seam=0 in cols and k-1 in cols and not cap
        for i,j in zip(p.loop_indices,ids):
            if cap:
                # Keep end caps almost uniform; never sample a groove.
                uv.data[i].uv=(.50,.002 if j//k==0 else .998)
            else:
                c=j%k; uv.data[i].uv=((k if c==0 and seam else c)/k,(j//k)/(n-1))
    return uv.name
def fade(a,b,x):
    t=min(1,max(0,(x-a)/(b-a)));return t*t*(3-2*t)
def stylize(o,k,index,path):
    uv=uv_ring(o,k); old=o.data.materials[0];m=old.copy();m.name='Painted chestnut · '+o.name
    o.data.materials[0]=m;p=next(n for n in m.node_tree.nodes if n.type=='BSDF_PRINCIPLED')
    base=tuple(p.inputs['Base Color'].default_value[:3]);p.inputs['Roughness'].default_value=.68; p.inputs['Specular IOR Level'].default_value=.30
    cap=o.name=='Bob back mass'
    # Deterministic, shape-following brushwork. A few broad grouping stripes and
    # interrupted finer highlights; no geometry, bump, or baked illumination.
    N=256;im=bpy.data.images.new('Flow · '+o.name,width=N,height=N,alpha=False,float_buffer=False)
    im.colorspace_settings.name='sRGB'
    px=array('f')
    strands=([(.017,.012,.68,.045),(.098,.017,.92,.05),(.195,.014,.90,.01),(.285,.019,.72,.13),(.391,.014,.86,.041),(.56,.013,.79,.11),(.74,.015,.78,.02),(.855,.017,.86,.12)] if cap
      else [(j/9+.035*sin(index*3+j),.009+.005*(j%3)/2,.83-.07*(j%4),.075+.072*(j%3)) for j in range(9)])
    lin_to_srgb=lambda q:12.92*q if q<.0031308 else 1.055*q**(1/2.4)-.055
    for iy in range(N):
      v=(iy+.5)/N
      terms=[]
      for j,(u0,w,end,start) in enumerate(strands):
        w*=.55+.45*sin(pi*v)
        ramp=fade(start,start+.16,v)*(1-fade(end-.19,end,v))
        bend=(.115*v+.022*sin(2*pi*v+j*.6))*(1 if index%2 else -1)
        if cap: bend=.070*v+.146*v*v+.030*sin(pi*v)*(1 if j%2 else -1)
        terms.append((u0+bend, w,ramp))
      for ix in range(N):
        u=(ix+.5)/N
        broad=.11*cos(2*pi*(u-.34+.095*v))+.075*sin(pi*v)+.05*cos(6*pi*(u-.075*v+index*.08))
        groove=0.;warm=0.
        for c,w,ramp in terms:
            d=((u-c+.5)%1)-.5
            groove-= (.80 if cap else .43)*exp(-(d/w)**2)*ramp
            warm+= ((1.20 if cap else .41)*exp(-((d-w*1.75)/(w*1.65))**2)+.11*exp(-((d+w*2.1)/(w*2.05))**2))*ramp
        rgb=tuple(lin_to_srgb(max(0,b*(1+broad+groove+warm*f))) for b,f in zip(base,(1.16,1.00,.72)))
        px.extend((*rgb,1))
    im.pixels.foreach_set(px); im.update();im.file_format='PNG';im.filepath_raw=str(path);im.save();im.pack()
    n=m.node_tree.nodes.new('ShaderNodeTexImage');n.label='Painted flow, packed sRGB albedo';n.image=im;n.extension='REPEAT'
    u=m.node_tree.nodes.new('ShaderNodeUVMap');u.uv_map=uv
    m.node_tree.links.new(u.outputs['UV'],n.inputs['Vector']);m.node_tree.links.new(n.outputs['Color'],p.inputs['Base Color'])
out.parent.mkdir(exist_ok=True,parents=True)
texdir=out.parent/'flow_textures';texdir.mkdir(exist_ok=True)
for i,(n,k) in enumerate(keep.items()):
    stylize(bpy.data.objects[n],k,i,texdir/f'hair-flow-{i:02d}.png')
bpy.context.view_layer.update()
dg=bpy.context.evaluated_depsgraph_get()
after={o.name:tris(o) for o in hair.objects}
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'hair-stats.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'before':before,'after':after,'before_sum':sum(before.values()),'after_sum':sum(after.values()),'painted_uv_parts':len(keep)},ensure_ascii=False,indent=2)+'\n')
