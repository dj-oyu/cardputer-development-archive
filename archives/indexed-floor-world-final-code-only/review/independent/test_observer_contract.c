#include "hdr_observer.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
int main(int argc,char**argv){assert(argc==2);uint16_t*p=malloc(64800);assert(p);memset(p,0x5a,64800);double a[3]={.25,.5,.75};assert(!row_hdr_observer_begin(NULL));assert(row_hdr_observe(a,p));assert(row_hdr_observer_begin(p));assert(!row_hdr_observer_begin(p));assert(!row_hdr_observer_write(argv[1]));assert(!row_hdr_observe(NULL,p));assert(!row_hdr_observe(a,(uint16_t*)((uintptr_t)p-2)));assert(!row_hdr_observe(a,p+32400));assert(!row_hdr_observe(a,(uint16_t*)((uintptr_t)p+1)));a[0]=NAN;assert(!row_hdr_observe(a,p));a[0]=-1;assert(!row_hdr_observe(a,p));
for(unsigned i=0;i<32400;i++){a[0]=(double)i/10000;a[1]=a[0]+.25;a[2]=a[0]+.5;assert(row_hdr_observe(a,p+i));assert(!row_hdr_observe(a,p+i));}
for(unsigned i=0;i<32400;i++)assert(p[i]==0x5a5a);assert(row_hdr_observer_write(argv[1]));assert(!row_hdr_observer_write(argv[1]));row_hdr_observer_clear();row_hdr_observer_clear();assert(row_hdr_observer_begin(p));row_hdr_observer_clear();free(p);puts("OBSERVER_CONTRACT_PASS unique=32400 writes=777600 init=259200 product_pixels_unchanged=1");return 0;}
