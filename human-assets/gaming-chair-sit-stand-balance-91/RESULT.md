# Blender chair sit/stand, forward weight transfer (v91)

Based on the editable Blender IK project v89. The heels and toes stay in their original positions; the head and chest move forward as the hip travels down and rearward. The pelvis meets the front of the cushion first and recenters once supported, then the upper body straightens. The arms follow the body with only necessary clearance changes, without an exaggerated forward reach.

At 24 fps, v89's approximate projected center of mass was behind the heel from frame 22.50 until frame 33.75 before actual seat contact at frame 34. The revised descent first contacts at frame 31.50. Three segment-mass approximations stayed within the projected foot support extent up to contact, with conservative rear clearance 0.0338 BU. These are geometric estimates, not dynamic physics or hardware data. Existing seated endpoints and the rise portion match v89 in the checked geometry and both matched renders.

The editable scene retains ankle target, knee pole and sole rotation controls. No firmware or deployed assets were changed; media previews are not in this archive.