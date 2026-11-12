# Experimental indexed BVH storage v3

This isolated host module keeps original vertex identity, exact double bits, triangle vertex order/ordinal and all traversal/ray arithmetic. It does not weld coordinates. Runtime storage owns all original xyz, eight-byte uint16 triangle index/ordinal records, and the unchanged exact-capacity node tree. Build centers occupy a temporary 24-byte record per original triangle ordinal. The final eight-byte triangle records are sorted stably in place, and bounds are recomputed from owned xyz. The center cache is freed before atomic publication.

The API is intentionally versioned: vis_scene_required_bytes_v3(vertices,triangles) includes every original vertex. vis_scene_build_temporary_bytes_v3(triangles) is additional required construction heap; max_bytes covers persistent requested storage only. Replacement peak adds every retained generation and the new temporary. Hard count and render quotas are unchanged. New index gathers and build bookkeeping have real CPU/cache cost; this experiment makes no target-fit or performance claim.

See the root PLAN.md, ADAPTER_MEMORY.json, test-results/RESULTS.json and independent review gate. Original baseline modules remain unchanged.
