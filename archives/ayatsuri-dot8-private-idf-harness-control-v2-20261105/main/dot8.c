#include "dot8.h"
bool dot8_scalar(const dot8_input *n, const dot8_input *d, int32_t out[8]) {
    if (!n || !d || !out) return false;
    for (unsigned k=0;k<3;k++) for(unsigned i=0;i<8;i++)
        if(d->v[k][i]<-16385 || d->v[k][i]>16385) return false;
    for(unsigned i=0;i<8;i++) {
        int32_t sum=0;
        for(unsigned k=0;k<3;k++) sum+=(int32_t)n->v[k][i]*d->v[k][i];
        out[i]=sum;
    }
    return true;
}
void dot8_unpack(const dot8_packed *s, int32_t out[8]) {
    for(unsigned i=0;i<8;i++) {
        const uint8_t *p=(i<4?s->low:s->high)+(i%4)*5;
        uint32_t u=(uint32_t)p[0] | (uint32_t)p[1]<<8 |
                   (uint32_t)p[2]<<16 | (uint32_t)p[3]<<24;
        out[i]=(int32_t)(u <= INT32_MAX ? (int64_t)u : (int64_t)u-INT64_C(4294967296));
    }
}
#if defined(__XTENSA__)
__attribute__((noinline))
void dot8_pie_raw(const dot8_input *n, const dot8_input *d, dot8_packed *s) {
    const int16_t *np=&n->v[0][0], *dp=&d->v[0][0];
    uint8_t *lo=s->low, *hi=s->high;
    __asm__ volatile(
        "ee.zero.qacc\n"
        "ee.vld.128.ip q0, %[n], 16\n"
        "ee.vld.128.ip q1, %[d], 16\n"
        "ee.vmulas.s16.qacc q0, q1\n"
        "ee.vld.128.ip q0, %[n], 16\n"
        "ee.vld.128.ip q1, %[d], 16\n"
        "ee.vmulas.s16.qacc q0, q1\n"
        "ee.vld.128.ip q0, %[n], 16\n"
        "ee.vld.128.ip q1, %[d], 16\n"
        "ee.vmulas.s16.qacc q0, q1\n"
        "ee.st.qacc_l.l.128.ip %[lo], 16\n"
        "ee.st.qacc_l.h.32.ip %[lo], 0\n"
        "ee.st.qacc_h.l.128.ip %[hi], 16\n"
        "ee.st.qacc_h.h.32.ip %[hi], 0\n"
        : [n] "+&a"(np), [d] "+&a"(dp), [lo] "+&a"(lo), [hi] "+&a"(hi)
        :
        : "memory");
}
#endif
