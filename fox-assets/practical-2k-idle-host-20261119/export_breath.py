"""Run with Blender --background <production-v5.blend> --python export_breath.py -- <output.h>."""
import bpy
import numpy as np
import sys
from pathlib import Path

src = bpy.data.objects["Breathing"].animation_data.action
fcurve, = [c for c in src.fcurves if c.data_path == '["Cycle"]']
scene = bpy.context.scene
assert tuple(src.frame_range) == (1.0, 97.0)
assert scene.render.fps / scene.render.fps_base == 24
vals = [float(fcurve.evaluate(frame)) for frame in range(1, 98, 2)]
assert len(vals) == 49 and vals[0] == vals[-1] == 0 and max(vals) == 1
out = ["/* Generated from production v5 Blender source. DO NOT EDIT. */",
       "static const float fox_breath_envelope[49] = {"]
for i in range(0, len(vals), 7):
    out.append("    " + ", ".join(f"{v:.9e}f" for v in vals[i:i+7]) + ",")
out.append("};")
for suffix, name, key in (("chest", "Mass R01 chest", "Rib cage expansion"),
                           ("fore_left", "Mass R02 fore upper L", "Shoulder rise L"),
                           ("fore_right", "Mass R02 fore upper R", "Shoulder rise R")):
    obj = bpy.data.objects[name]
    keys = obj.data.shape_keys.key_blocks
    neutral = np.array([tuple(v.co) for v in keys[0].data])
    target = np.array([tuple(v.co) for v in keys[key].data])
    assert len(neutral) == len(target)
    scale, offset = np.array([np.linalg.lstsq(
        np.array([axis, np.ones(len(axis))]).T, end, rcond=None)[0]
        for axis, end in zip(neutral.T, target.T)]).T
    # The AYNM export permutes and negates the Blender x,y,z basis: (x,-z,-y).
    vals2 = (scale-1)[[0,2,1]].tolist()+(offset[[0,2,1]]*[1,-1,-1]).tolist()
    rms = float(np.sqrt(np.mean(np.sum((neutral*scale+offset-target)**2,axis=1))))
    out.append(f"/* Diagonal affine fit RMS residual, Blender object units: {rms:.6g}. */")
    out.append(f"static const float fox_breath_{suffix}[6] = {{"
               + ", ".join(f"{v:.9e}f" for v in vals2) + "};")
Path(sys.argv[sys.argv.index("--")+1]).write_text("\n".join(out)+"\n")
