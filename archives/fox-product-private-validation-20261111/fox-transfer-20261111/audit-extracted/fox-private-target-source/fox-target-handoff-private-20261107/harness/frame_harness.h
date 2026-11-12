#ifndef PRIVATE_FRAME_HARNESS_H
#define PRIVATE_FRAME_HARNESS_H
#include "scene.h"
#include <stdint.h>
/* Preconditions: zero-initialized owner; serialized single-owner calls;
 * trusted, nonaliasing owner/port/times storage; monotonic nonwrapping now_us;
 * immutable source lifetime extends through all attempts and quarantines. */
typedef struct {
 void *ctx;uint64_t (*now_us)(void*);
 /* At most two borrowed half strips. A failed submit may still retain input.
  * drain=true attests ALL accepted transfers completed successfully AND all
  * input borrows released (not merely descriptors freed). false forbids ACK
  * even if some buffers were released; owner conservatively quarantines. */
 bool (*submit)(void*,unsigned,unsigned,const uint16_t*);
 bool (*drain)(void*);
} fh_port;
typedef struct {uint64_t prepare_us,raster_us,submit_us,drain_us,total_us;} fh_times;
typedef enum {FH_OK,FH_INVALID,FH_PREPARE,FH_SEND,FH_RASTER,FH_QUARANTINE,FH_BUSY} fh_result;
typedef struct {
 scene_frame frames[2];scene_workspace workspace;uint16_t halves[2][960];
 unsigned ready,pending;bool has_ready,quarantine,pinned,display_known;
} fh_owner;
fh_result fh_frame(fh_owner*,const fh_port*,int pose,unsigned camera,int prepare_fail_vertex,fh_times*);
bool fh_recover(fh_owner*,const fh_port*);
#endif
