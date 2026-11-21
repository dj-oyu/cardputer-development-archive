# v52 offline intake relight

Same continuous intake and chair/character as v51. Sweep and receiver surface winding is corrected without moving vertices, and two camera-invisible baffles only affect lighting. Broad reflected bands, self-shadow and metal-vs-rubber are baked, not evaluated on the device.

- Physical scene is unchanged (1,913 human + 370 chair = 2,283 triangles); isolated high-detail virtual bake source is not another runtime mesh.
- Cycles 128 samples for native 240×135 tube RGB, 192 for 720×405 diagnostic detail. All other native plates and tube alpha are byte-equivalent to v51.
- Same camera/light/material shadow control disabled only shadow visibility of the rubber tube. 19 of 1,472 opaque isolated tube/mount pixels darkened by over 8/255 in mean channel, max 22.67. This measures tube shadow on itself and its receivers, not shadow on the separate valve artwork. It is independent of host quantization.
- Rebuild by running relight.py on v51 virtual-tube-51.blend, render selected details with bake_aperture.py, then call compose.py and assemble.py (same source contracts as v51). The isolated-source scene and compiled native projection are distinct. Generate local proofs with review.py.
- No V8 change or hardware performance claim.
