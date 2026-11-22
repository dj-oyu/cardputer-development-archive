# Chair v70: independent orbit camera and seated swivel

Open the Blender file on the main physical chair scene. In the Outliner select **CAM CONTROLS**, then open Object Properties → Custom Properties. Change `yaw_deg` (zero is rear), `pitch_deg` (positive looks downward), `distance`, and `lens_mm`. Move **CAM TARGET** to pan. The camera rig is anchored to the world, not to the rotating upper chair.

The chair swivel is separately keyed on frames 1–49; the base and casters remain stationary. The original seated character action is retained. The steering controls were sampled after reopening the file in Blender. The chair uses the 200-triangle opaque geometry with inverted tetrahedral feet. The 192-triangle fixed-angle atlas is a separate candidate, not the basis for orbiting.

This is an editable Blender camera/pose setup. Existing engine, liquid, bubbles and ignition baking sources are retained as separate scenes or offline assets. Neither arbitrary-angle combined engine playback nor Cardputer rendering was integrated here. Generated previews are not included.
