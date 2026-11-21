# GPT Image gekiga UV paintover, isolated face authoring
Source Blender: v84-D d0daeedb91d7438aa14c7b66a1dff623c1458cef5985125af0e679ea92dcb627. This face work uses the seat pose already in that scene; it does not consolidate the separately revised ankle animation.
Exact user-accepted GPT Image source: assets/accepted-generated-reference.png SHA 8397e35ca8e2b14d6e6d2d2666af56048e7814e899ec35a9242f1efeb7f03022.
Editable candidate: girl-gekiga-gpt-strong.blend SHA a34e6f009b36d701ccd144a5bea70a84e9cd6a01af4bc7a4fcc563e242acbd5f.

Production texture takes the actual generated eyes, ink eyebrows, forehead tension, lips and nose, cheekbone undersides and jaw crosshatch from that reference, not a substitute drawing. Warped image pixels follow explicit landmark alignment to the existing face UV. Multi-zone masks discard background, hair, source outline and outer eye wrinkles. Shadow strength is derived from the local source-ink pixel density instead of pasting the base skin or imposing a strip. Original D inner area is byte-exact (9,256 texels), with all generated long inner/nose strokes excluded. Original face/hair silhouette and 3D geometry are unchanged.

Compared low/full/strong generated hatch densities. Selected strong so lower cheek and underside of jaw remain distinct at 240×135. Side unscaled and 4× nearby face show no hard seam. In matched front/quarter f25 frames, lower-face luminance drops by more than 12/255 at 72/63 pixels relative to D (34/24 compared with first mapping). This native render reads at small size, but is not a full-color printed image. Public discussion previews excluded from authoring manifest.

Reopened scene preserves v84 geometry, topology, UV, rig bones and all animation curves, face links, and four comic driver poses. All 18 front/quarter non-target expression and ordinary emote pairs are RGB-exact relative to D; new gag+ sweat verified together. This does not change other characters.

The final painted atlas is packed into the editable model; the generated source image is identified by the digest above but is not included here. No rendered previews are included. User selected the stronger right-hand rendering. No firmware or device result is implied.
