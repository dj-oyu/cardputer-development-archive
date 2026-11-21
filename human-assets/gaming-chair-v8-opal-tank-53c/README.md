# Gaming chair v53c: opposed engine and opal tank

Fictional opposed-eight engine decoration, two banks above the existing folded intake. The original pale case remains in place as the coolant tank; the opal stripe shows the dark liquid silhouette. The original small bottle has a blue fill and is stationary. The chair exterior, seated character and rig are unchanged.

The .blend contains the existing physical and intake source scenes, a separate editable engine source scene, the opal case textures, masked three-view proofs and cropped settled/left/right phase imagery. The optical effect is an offline, view-specific RGB565 overlay, not fluid simulation. Selecting camera view and liquid phase are separate, and the existing scene should not be interpreted as a deployed frame controller. Any separate prototype tank shapes in the source collection are not used in the displayed v53c composite.
 
The v53c proof reuses the exact inherited aperture masks and non-engine/box/bottle layers. V52 ray-traced pipe is retained. The frozen host run at 240×135 checks static composition and Kasane KSN_PATCH phase replacement against an independent RGB565 calculation. On the host, the center phase changes required 3,072 bytes of dirty-region output, not a full 64,800-byte repaint; not LCD timing, firmware integration, or FPS evidence.

engine.py generates editable engine art; stripe.py authors the water silhouettes for the former silver case; legacy_bake.py and compose.py build the clipped assets; assemble.py packs the final source. See its packed images for the per-angle crops. Review PNGs and GIF are not stored separately in the archive.
