#include "checked.h"
static bool overlaps(const void *a,size_t an,const void *b,size_t bn) {
    const uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
    if(x>UINTPTR_MAX-an || y>UINTPTR_MAX-bn) return true;
    return x<y+bn && y<x+an;
}
bool dot8_checked(const dot8_input *n,const dot8_input *d,dot8_packed *packed,int32_t out[8]) {
    if(!n || !d || !packed || !out) return false;
    if(((uintptr_t)n%16) || ((uintptr_t)d%16) || ((uintptr_t)packed%16) || ((uintptr_t)out%_Alignof(int32_t))) return false;
    const void *p[4]={n,d,packed,out}; const size_t z[4]={sizeof *n,sizeof *d,sizeof *packed,8*sizeof *out};
    for(unsigned i=0;i<4;i++) for(unsigned j=i+1;j<4;j++) if(overlaps(p[i],z[i],p[j],z[j])) return false;
    for(unsigned k=0;k<3;k++) for(unsigned i=0;i<8;i++) if(d->v[k][i]<-16385 || d->v[k][i]>16385) return false;
    /* Raw owns this task's transient PIE state; no yield/callback within raw. */
    dot8_pie_raw(n,d,packed);
    dot8_unpack(packed,out);
    return true;
}
