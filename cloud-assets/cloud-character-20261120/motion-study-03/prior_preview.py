import bpy, os, sys
cwd=os.path.dirname(os.path.realpath(__file__))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
archive=os.path.join(cwd,'..','motion-study-02','cloud-amorphous.blend')
local=os.path.join(cwd,'..','cloud-character-amorphous','cloud-amorphous.blend')
src=args[0] if args else (archive if os.path.isfile(archive) else local)
bpy.ops.wm.open_mainfile(filepath=os.path.abspath(src))
d=os.path.join(cwd,'prior-frames');os.makedirs(d,exist_ok=True)
s=bpy.context.scene;s.cycles.samples=48;s.render.resolution_x=240;s.render.resolution_y=135
for i,f in enumerate(range(1,145,3)):
 s.frame_set(f);s.render.filepath=os.path.join(d,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
