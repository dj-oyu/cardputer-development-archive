#include "radiance_bridge.h"
#include <string.h>

rb_status rb_q19_to_q24(const rb_rgb_q19 *in, rb_rgb_q24 *out) {
    if (!in || !out) return RB_INVALID;
    rb_rgb_q24 tmp;
    for (unsigned k = 0; k < 3; k++) {
        if (in->channel[k] > (UINT64_MAX >> 5)) return RB_SCALE_OVERFLOW;
        tmp.channel[k] = in->channel[k] << 5;
        if (tmp.channel[k] > AA_SAMPLE_MAX) return RB_AA_RANGE;
    }
    *out = tmp;
    return RB_OK;
}

rb_status rb_merge(const rb_rgb_q24 *terms, size_t count,
                   const rb_rgb_q19 *reflection, rb_rgb_q24 *out) {
    if (!out || !reflection || count > RB_MAX_TERMS || (count && !terms))
        return RB_INVALID;
    rb_rgb_q24 sum;
    rb_status s = rb_q19_to_q24(reflection, &sum);
    if (s != RB_OK) return s;
    for (size_t i = 0; i < count; i++) {
        for (unsigned k = 0; k < 3; k++) {
            if (terms[i].channel[k] > AA_SAMPLE_MAX - sum.channel[k])
                return RB_AA_RANGE;
            sum.channel[k] += terms[i].channel[k];
        }
    }
    *out = sum;
    return RB_OK;
}

rb_status rb_merge_block(const rb_job *jobs, unsigned n, rb_rgb_q24 *out) {
    if (!jobs || !out || (n != 1 && n != 2 && n != 4 && n != 8))
        return RB_INVALID;
    rb_rgb_q24 tmp[8];
    for (unsigned i = 0; i < n; i++) {
        rb_status s = rb_merge(jobs[i].terms, jobs[i].count,
                               &jobs[i].reflection, tmp + i);
        if (s != RB_OK) return s;
    }
    memcpy(out, tmp, n * sizeof *out);
    return RB_OK;
}
