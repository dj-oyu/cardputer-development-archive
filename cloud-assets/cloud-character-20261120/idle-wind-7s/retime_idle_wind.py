"""Retime all idle-wind animation channels from 10 s to exactly 7 s in Blender 4.3."""
import bpy,os,sys,json,math,hashlib
from bpy_extras.object_utils import world_to_camera_view
p=os.path.dirname(os.path.realpath(__file__))
argv=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
defaults=[os.path.join(p,'..',d,'cloud-idle-wind-02.blend') for d in ('idle-wind-02','cloud-character-idle-wind-02')]
src=os.path.abspath(argv[0]) if argv else next(f for f in defaults if os.path.isfile(f))
digest=lambda f:hashlib.sha256(open(f,'rb').read()).hexdigest()
orig=digest(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene;rig=bpy.data.objects['Cloud_Rig'];body=bpy.data.objects['Cloud body']
objects=sorted((o for o in s.objects if o.parent==rig and o.type in ('MESH','CURVE')),key=lambda x:x.name)
assert s.render.fps == 24 and s.render.fps_base==1 and (s.frame_start,s.frame_end)==(1,241)
def at(frame):
 it=math.floor(frame);s.frame_set(it,subframe=frame-it)
def coords():
 dg=bpy.context.evaluated_depsgraph_get(); result=[]
 for o in objects:
  e=o.evaluated_get(dg);me=e.to_mesh()
  try:result.extend(e.matrix_world@v.co for v in me.vertices)
  finally:e.to_mesh_clear()
 return result
s.frame_set(1);dep=bpy.context.evaluated_depsgraph_get()
counts={}
for o in objects:
 e=o.evaluated_get(dep);m=e.to_mesh()
 try:m.calc_loop_triangles();counts[o.name]=len(m.loop_triangles)
 finally:e.to_mesh_clear()
print('Triangulated rest mesh, excluding studio:',sum(counts.values()), counts,flush=True)
samples=[1,2.1,15.35,39.0,61.3,89.7,112.5,142.0,163.2,169]
before={}
for f in samples:
 at(1+(f-1)/.7);before[f]=coords()
s.frame_set(1)
orig_chans=[]
for label,ds in [('Rig',rig),('Cloud shape keys',body.data.shape_keys)]:
 ac=ds.animation_data.action
 for fc in ac.fcurves:
  orig_chans.append((label,fc.data_path,fc.array_index,len(fc.keyframe_points)))
  for k in fc.keyframe_points:
   # Capture originals first; Blender moves handles when key x is translated.
   center,lh,rh=k.co.copy(),k.handle_left.copy(),k.handle_right.copy()
   k.co=(1+.7*(center.x-1),center.y)
   k.handle_left=(1+.7*(lh.x-1),lh.y)
   k.handle_right=(1+.7*(rh.x-1),rh.y)
  fc.update()
 ac.name += ' (7 seconds)'
for m in s.timeline_markers:m.frame=round(1+.7*(m.frame-1))
s.frame_end=169;s['motion_variant']='Idle wind 02 • same shapes at 70% duration'
s.frame_set(1);bpy.context.preferences.filepaths.save_version=0
out=os.path.join(p,'cloud-idle-wind-7s.blend');bpy.ops.wm.save_as_mainfile(filepath=out,compress=True)
bpy.ops.wm.open_mainfile(filepath=out);s=bpy.context.scene
rig=bpy.data.objects['Cloud_Rig'];body=bpy.data.objects['Cloud body']
objects=sorted((o for o in s.objects if o.parent==rig and o.type in ('MESH','CURVE')),key=lambda x:x.name)
assert s.frame_end==169 and s.frame_start==1 and s.render.fps/s.render.fps_base==24
maxerr=0.
for f in samples:
 at(f);actual=coords();expected=before[f]
 assert len(actual)==len(expected)
 maxerr=max(maxerr,max((x-y).length for x,y in zip(actual,expected)))
assert maxerr<1e-4,maxerr
at(1);start=coords();at(169);last=coords()
seam=max((x-y).length for x,y in zip(start,last));assert seam<1e-6 and digest(src)==orig
assert all(m.frame<=169 for m in s.timeline_markers)
with open(os.path.join(p,'idle-wind-7s-manifest.json'),'w') as f:json.dump(dict(source_sha256=orig,retime_sha256=digest(out),fps=24,first_frame=1,duplicate_end_frame=169,seconds=7,time_scale=.7,pose_comparison_samples=samples,pose_max_vertex_difference=maxerr,seam_max_vertex_difference=seam,keyed_channel_count=len(orig_chans),keyframe_count=sum(r[3] for r in orig_chans),triangles_evaluated_editable_design=sum(counts.values()),triangle_counts_by_mesh=counts),f,ensure_ascii=False,indent=1)
s.render.resolution_x=240;s.render.resolution_y=135;s.cycles.samples=40
d=os.path.join(p,'frames');os.makedirs(d,exist_ok=True)
for i,frame in enumerate(range(1,169,3)):
 s.frame_set(frame);s.render.filepath=os.path.join(d,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
