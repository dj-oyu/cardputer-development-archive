# Gaming chair v50: nine engine-bay depths

Editable Blender scene. The seated human, chair geometry and pose are unchanged from v49: 1,913 human and 370 chair triangles (2,283 total). The aperture is a two-triangle surface; shader and blending costs are separate.

Back-to-front nominal depths in Blender units: bulkhead 2.85, radiator 1.04, brackets .86, valve cover .60, reservoir .44, intake root .31, headers .22, intake elbow .13, front cables .05. The intake root and elbow use separate depths; their ends are tucked behind hardware. A loose conductor crosses the valve cover. Layers are deliberately obscured depending on view. All artwork is packed.

To rebuild the material, unpack the eight numbered PNGs into textures/ and run build_layers.py against the archived v49 Blender source. verify.py records geometry and pose; render.py and bake_nine.py generate review views offline. No generated review images are stored separately here.

On a desktop host, the unchanged Kasane compositor from firmware 4d2b1255da6e881f72af8546ffb5d72b26030d7d composited baked 240×135 layers correctly against an independent RGB565 oracle. At straight rear, one, three and nine groups of the same art requested respectively 1,558, 3,489 and 5,584 overlay samples. This did not include runtime 3D projection, hardware timings or LCD transfer.
