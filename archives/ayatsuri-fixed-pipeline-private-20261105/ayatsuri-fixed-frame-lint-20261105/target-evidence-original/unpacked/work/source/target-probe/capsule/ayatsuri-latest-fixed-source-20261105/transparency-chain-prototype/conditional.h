#ifndef CONDITIONAL_RADIANCE_H
#define CONDITIONAL_RADIANCE_H
#include "../../ayatsuri-fixed-frame-stage1-20261105/aa/code/profile_adapter.h"
/* Already-clamped top-level closure weights, incoming weight one. Both branch
 * radiances MUST be complete caller-supplied linear Q24 RGB. No transport here. */
typedef struct {uint32_t opaque_weight,continued_weight;uint64_t opaque[3],continued[3];} tc_slot;
typedef struct {tc_slot slot[4];} tc_input;
enum {TC_OK,TC_INVALID,TC_WEIGHT,TC_RANGE,TC_REDUCE,TC_ENCODE};
int tc_mix(const tc_slot*,uint64_t out[3]);
/* Disjoint caller buffers; no concurrent mutation. All output lanes commit
 * together; profile cache may warm before rejection. Width1/2/4/8 only. */
int tc_block(const tc_input*,unsigned,agx_block_cache*,aa_result*);
#endif
