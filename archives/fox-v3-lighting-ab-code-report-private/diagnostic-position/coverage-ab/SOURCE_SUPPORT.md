# Original filter support, not an AA implementation

Current saved v3 render metadata (for example fox-reference-uncertainty-v3/images/seed-101-front-baseline.json) records BLACKMAN_HARRIS, filter_width1.5. Source remains the original .blend pinned in input-hashes.json.

Official Blender v4.3.2 source verified by the independent reviewer:
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/scene/film.cpp
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/util/math_cdf.cpp
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/util/math_cdf.h
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/kernel/camera/camera.h

Film table construction doubles this filter's UI width, evaluates the positive half interval0..width/2, and creates a symmetric inverse CDF. The symmetric inverse mapping and camera offset place the nominal support about pixel center: ±1.5 at UI width1.5. It is not ±.75. The source itself notes the even-sized lookup table is not exactly symmetric. This diagnostic does not emulate that table or the filter's weighting; the625 uniform midpoint samples explore the support only, excluding exact endpoints±1.5.

The source filter is wider than a one-pixel box. Consequently new hits outside the saved128-sample alpha mask are expected possibilities and are explicitly counted, not silently treated as correct pixels. Grid fractions are neither source alpha nor final antialiased output.
