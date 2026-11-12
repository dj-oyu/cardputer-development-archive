#ifndef KSN_MESH_DEPTH_H
#define KSN_MESH_DEPTH_H
#include "ayatsuri/compact_opaque.h"
#include "ksn_procedural.h"
#include "fox_disk_lighting.h"
/* Explicit bounded opaque scope. All packets in a snapshot share depth.
 * Larger evaluated view depth wins; exact ties retain first submitted face.
 * No alpha/holes/clips. No source pointers survive append. */
typedef struct { co_buffer packets; uint32_t work,work_limit; bool enabled; } ksn_mesh_snapshot;
/* Copy one contiguous side run from a validated Model sided-mesh view.
 * No retention/allocation; source/back-colors/bits are borrowed. Caller owns
 * a full patch output, disjoint from the inputs. cursor advances on success.
 * false (bad counts/cursor/output overlap) leaves output/cursor untouched. */
bool ksn_mesh_sided_run(const ksn_proc_gouraud_patch *source,const uint16_t *back_colors,
                      const uint8_t back_faces[8],unsigned *cursor,ksn_proc_gouraud_patch *out);
bool ksn_mesh_append(ksn_mesh_snapshot *s,const ksn_proc_gouraud_patch *p,const float *depth,uint16_t node);
/* One owned record for a full sided logical mesh; side choices and palettes
 * are copied. No regrouping/reordering or per-run packet amplification. */
bool ksn_mesh_append_sided(ksn_mesh_snapshot *s,const ksn_proc_gouraud_patch *p,const float *depth,
                           const uint16_t *back_colors,const uint8_t back_faces[8],uint16_t node);
/* scratch has width*rows floats, rows is 1 or 8. Caller supplies background
 * pixels. A complete band can be processed in smaller scratch-sized strips. */
bool ksn_mesh_render(const ksn_mesh_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,
                     float *scratch,unsigned rows);
/* Private explicit pixel-light host path. Header+records share the caller's
 * existing <=65536B storage. No scene or model pointer survives begin/append.
 * Failed render leaves snapshot immutable; caller must discard partial pixels
 * and must not present/commit them. Stats publish only on successful calls. */
enum { KSN_PIXEL_HEADER_BYTES=416, KSN_PIXEL_MAX_STORAGE=65536 };
typedef struct { ksn_mesh_snapshot mesh; uint8_t *storage; size_t capacity; } ksn_mesh_pixel_snapshot;
typedef struct { uint64_t shade_updates, disk_samples; } ksn_mesh_pixel_stats;
bool ksn_mesh_pixel_begin(ksn_mesh_pixel_snapshot *,void *,size_t,const FoxDiskScene *,uint32_t);
bool ksn_mesh_pixel_append(ksn_mesh_pixel_snapshot *,const ksn_proc_gouraud_patch *,const co_pixel_vertex *,const uint8_t[8],uint16_t);
bool ksn_mesh_pixel_render(const ksn_mesh_pixel_snapshot *,uint16_t *,unsigned,unsigned,float *,unsigned,ksn_mesh_pixel_stats *);
/* Host-only callback variant. Callback lifetime/context is caller-owned for this synchronous call. Failure discards partial band. */
bool ksn_mesh_pixel_render_visible(const ksn_mesh_pixel_snapshot *,uint16_t *,unsigned,unsigned,float *,unsigned,ksn_mesh_pixel_stats *,FoxDiskVisibilityCallback,void *);
#endif
