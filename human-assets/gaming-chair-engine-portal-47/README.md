# Rear-only engine bay portal

The seated character is unchanged. This revision of the warm-gray, amber-padded four-caster chair replaces the shallow three-card engine stack with one image-bearing aperture. The existing window rim and side walls remain physical. The editable Blender material intersects the incoming ray with three virtual depth planes and alpha-composites them in order; the rays are sampled only within the aperture and only from its rear-facing side. There is no virtual mesh extending outside the shell.

- Behind the physical aperture surface, lookups are at .045, .38 and 1.20 Blender units. The backrest thickness is .365 units. The distant plate is scaled to allow some visible far wall at oblique angles. The values simulate perspective and do not describe functional mechanical parts.
- Human 1,913 triangles, chair 370 triangles (364 body, 2 portal, 4 gauges/plate), 2,283 total excluding the review floor. The prior physically stacked version was 374 chair triangles.
- The source is self-contained with packed art. The port is a Blender material proof of concept, not a Cardputer firmware build. For a first fixed-view Cardputer prototype, precompute angle-indexed RGB565 frames and a rear-aperture mask, or add a bounded texture-and-depth path for live rotation. Stock mesh import will not reproduce the material.
- `portal.py` converts the shallow integrated v46 source. `render.py` is an offline visual-review script. Comparison renders are not part of this archive.
