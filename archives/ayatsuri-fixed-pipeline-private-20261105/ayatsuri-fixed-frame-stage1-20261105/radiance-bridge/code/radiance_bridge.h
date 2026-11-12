#ifndef RADIANCE_BRIDGE_H
#define RADIANCE_BRIDGE_H
#include <stdint.h>
#include <stddef.h>
#include "../../aa/code/integer_aa.h"
typedef struct {uint64_t channel[3];} rb_rgb_q19;
typedef struct {uint64_t channel[3];} rb_rgb_q24;
typedef enum {RB_OK=0,RB_INVALID=1,RB_SCALE_OVERFLOW=2,RB_AA_RANGE=3} rb_status;
#define RB_MAX_TERMS 8
/* Exact multiply32. First reject machine overflow, then AA slot admission
 * AA_SAMPLE_MAX. No rounding, narrowing, clamp or output on rejection. */
rb_status rb_q19_to_q24(const rb_rgb_q19*,rb_rgb_q24*);
/* Terms are ALREADY RESOLVED additive linear-radiance contributions, Q24.
 * Reflection is already reduced/weighted Q19, not reweighted here.
 * count0..8; terms may beNULL iff count0. Reflection must be supplied (zero OK).
 * This does not decide material/visibility/background or which terms belong.
 * Output remains unchanged on any failure. Inputs must remain stable. */
rb_status rb_merge(const rb_rgb_q24*terms,size_t count,const rb_rgb_q19*reflection,rb_rgb_q24*out);
typedef struct {const rb_rgb_q24*terms;size_t count;rb_rgb_q19 reflection;} rb_job;
/* n1/2/4/8; all lanes commit only after all succeed. No partial publication. */
rb_status rb_merge_block(const rb_job*,unsigned n,rb_rgb_q24*out);
#endif
