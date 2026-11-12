#ifndef INTEGER_AA_H
#define INTEGER_AA_H
#include <stdint.h>
#include <stdbool.h>
#define AA_SAMPLE_MAX ((UINT64_C(1)<<40)-1)
typedef struct {uint64_t sum[3];uint8_t count,seen;} aa_state;
typedef struct {uint32_t hdr19[3];uint16_t pixel;uint8_t high_clamped;} aa_result;
typedef enum {AA_OK=0,AA_INVALID=1,AA_INCOMPLETE=2,AA_RANGE=3,AA_HDR19_OVERFLOW=4,AA_ENCODE_ERROR=5} aa_status;
typedef enum {AA_KEEP=0,AA_REPLACE=1} aa_action;
/* Encoder receives averaged HDR exactly once; returns profile flags0/1 or
 * error>=2. It must not change rgb565 on error. External context may mutate. */
/* Caller-owned states, encoder context and results must not overlap. Context
 * and tables remain valid throughout calls; no implicit thread synchronization. */
typedef int (*aa_encoder)(void*,const uint32_t[3],uint16_t*);
aa_status aa_init(aa_state*,unsigned sample_count); /* 1 center,4 AA */
/* Put each slot exactly once. Replacement selected BEFORE accumulation.
 * For REPLACE, original may beNULL; for KEEP, replacement may beNULL.
 * Unselected input is not inspected. State unchanged on any rejection. */
aa_status aa_put(aa_state*,unsigned slot,aa_action,const uint64_t original[3],const uint64_t replacement[3]);
/* Exact-sum conversion toQ19: divide by count*32, nearest ties-even.
 * Never first round the mean toQ24. Output unchanged on incomplete/error. */
aa_status aa_reduce(const aa_state*,uint32_t hdr19[3]);
aa_status aa_finish(const aa_state*,aa_encoder,void*,aa_result*);
/* n1/2/4/8. ALL result lanes commit only if ALL succeed. Failing callback may
 * already have mutated its external cache, but input states/results unchanged.
 * high_clamped is per-lane successful flag, not an error. */
aa_status aa_finish_block(const aa_state*,unsigned n,aa_encoder,void*,aa_result*);
#endif
