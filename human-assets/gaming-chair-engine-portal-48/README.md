# Thin-shell gaming chair / deep engine bay

Editable seated character and prop scene. Source art is packed in the Blender file.

- Revised physical backrest thickness at a solid shoulder sample: .365 to .220 Blender units (about 40% less). Front surface, seat, armrests and seated human are unchanged; only the intended waist/seat overlap remains. See thin-shell.json.
- The rear-only two-triangle material traces into a 2.85-unit virtual bay, compared with 1.20 in v47. It resolves the first wall or floor hit, projects structural ribs and rails at their virtual intersections, and composites the existing art in front where visible. No geometry protrudes behind the shell.
- 1,913 human + 370 chair = 2,283 evaluated triangles, excluding the preview floor. No polygons were added in v48. The triangle count does not reflect the material sampling cost.
- The effect is demonstrated in Blender; the firmware does not import this shader. A small angle-indexed pre-baked overlay is the lowest-risk first device test, with no performance claims yet.
- Reproduction: apply thin_shell.py to archived v47, then tunnel.py to the thin-shell Blender file. render.py is for visual inspection; verify.py checks counts and packed portal images.
