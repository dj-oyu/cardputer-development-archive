# True subpixel AA, v16 host-only preview
One existing oblique baseline, unchanged geometry, material, light and transport. Center control is byte-identical to v16 LE001 RGB/depth and its saved PNG. Four actual C renders evaluate sample coordinates (x±.25,y±.25) via opposite projection-center shifts, not integer9-neighbor blur. Final-winner preclamp linear HDR is averaged uniformly including zero/nohit, then original C clamp/sRGB/565 once. AgX remains OFF. No reference pixel input or fitted coefficient.

Independent fresh O2 five-frame replay reproduces15 RGB/depth/HDR buffers and385 non-timing metadata fields exactly. Separate float encoder reproduces every original sample565 and final average output.393 pixels have partial sample coverage. Coverage is a hit fraction, not a new single geometry depth. Formal reference/scoring is unchanged; one diagnostic view is not a goal result.

The 4pass total raster time was32.777s; this is one host observation, not a speed benchmark or device prediction. Four-pass totals829461956 node visits,314190291 triangle tests,10671710 charged work EXCEED original single-frame limits. Each separate pass respects its existing limits, so this is a completed host4-render experiment, not an admitted one-product-frame AA feature. Added diagnostic static HDR observer777600B, one process/oneframe only; Python HDR arrays/mean/coverage are additional host workspace.

Pixel inspection: ear/face silhouette and eye edges become less harsh, while eyebrow/mouth and coarse geometry remain visibly pixelated. This does not isolate or fix geometry loss. Native resolution remains240×135. User preview crops use fixed ROI(108,12,168,76) and nearest-neighbor6× enlargement only; neither source nor output is retouched.

Private native images saved separately, no public repo/media or original geometry upload. Code/report bundle excludes images/models/geometry/raw buffers. Source/scene/code hashes and commands are pinned in run and postprocess manifests.
