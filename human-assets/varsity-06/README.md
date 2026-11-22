# Human character: retro varsity outfit 06

Editable authoring model, based on the verified detail-05 source. Cropped forest-green varsity jacket, warm ivory full-length sleeves, forest wrist cuffs with ivory knit stripe, ivory pocket welts, tobacco shorts with pressed pleats and oxblood boots. An embroidered amber badge and charcoal lightning glyph are on the anatomical right upper sleeve only. All accents are actual geometry or editable mesh material slots. No concept images or reviews are linked or embedded.

The 20-bone rig and authored keyframes were kept exactly. The torso, head and facial model, hair, hands and legs are unchanged; only clothing and boot colors/geometry were updated. No decimation was done. This file is for editing, not the target runtime mesh.

From this archive directory:

    blender -b -t 4 --python-exit-code 2 --python ./dress_varsity.py -- ../detail-05/human-detail-05.blend ./rebuild/human-varsity-06.blend
    blender -b -t 4 --python-exit-code 2 --python ./verify_varsity.py -- ../detail-05/human-detail-05.blend ./rebuild/human-varsity-06.blend
    blender -b -t 4 --python-exit-code 2 --python ./pose_check.py -- --metrics-only ./rebuild/human-varsity-06.blend ./rebuild

The 240 × 135 neutral, 95° elbow and planted-weight-shift comparisons are Blender renders, not device evidence. Right/left level comparisons use world X=-13 and X=+13. At native size the amber patch reads as an accent; use the larger inspection render to assess the bolt shape. Like the earlier source, this is a provisional rig; the 95° test is only a static stress probe.
