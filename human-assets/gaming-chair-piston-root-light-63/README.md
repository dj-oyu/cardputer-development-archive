# v63 wrist-pin source

Values are Blender world units, XYZ. Nearest piston–rod joint centers at frame1:
- Bank 1 pin (−.263849, .371000, 2.762849); emitter (−.252849, .385000, 2.748849).
- Bank 2 pin (.233849, .413000, 2.762849); emitter (.222849, .427000, 2.748849).
- Displacement approximately .023; no final model geometry change. Positive Y faces the rear camera. No visible flame, spark plug or tank emitter.

source63.py combines actual v56 V8 with exact v52 hose and a registered white case probe, Cycles paired controls. The engine and hose shadow toggles are separate, baseline corrected. The actual position no longer produces a substantial hose shadow on the case (straight view red-channel deficit ≤8 in the source probe); the hose is a receiver. Actual engine structure does substantially occlude the new light. mix.py transfers these locations for graphic readability, especially case light and true projected cast footprint, rather than claiming raw complete physical transport. Current signed deltas replace older ignition art in slots 02,03,04,05,08,09 and do not stack with them. Original reference alpha, other slots, exterior geometry and motions are exact. Quiescent steps 5,11 unchanged. Derived changes render only within the aperture and current visible receptive surfaces. The six source crank poses, three slosh states and approved six blue bottle states are unchanged. This artifact intentionally does not redefine behavior timing. Independent host proof and raw moving playback are separate. Signed plus/minus maps reconstruct exact scene colors.

Phase-assets contains manifests (slot names, step, view, crop coordinates) + production signed PNGs. .blend includes editable isolated source geometry and packed maps. Source test, fixtures, rendered previews and animation previews are regenerable; do not archive as authored production unless specifically needed.
