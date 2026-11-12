#include "ayatsuri/compact_opaque.h"
#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
int main(void){co_pixel_vertex v[4]={0};uint16_t ix[]={2,0,1};uint8_t side[]={1};uint8_t store[1000],saved[1000];co_pixel_input in={v,ix,side,65535,4,1};for(int j=0;j<4;j++){v[j].front=(co_vertex){j,j,-0.f,1.f,0x1234,0xabcd};v[j].world[0]=-0.;v[j].world[1]=0x1.abcdefp-100;v[j].world[2]=-0x1.abcdefp100;v[j].normal_front[2]=32767;v[j].normal_back[2]=-32767;}v[3].world[0]=NAN;v[3].normal_front[1]=INT16_MIN;
for(int x=-32767;x<=32767;x++){v[0].normal_front[0]=(int16_t)x;v[0].normal_back[0]=(int16_t)-x;co_buffer b={store+1,999,0,0};assert(co_append_pixel_normal_pair(&b,&in));assert(b.size==168&&b.packets==1);co_view view;assert(co_read(b.data,b.size,&view)&&view.mode==5);co_pixel_vertex got;assert(co_pixel_vertex_at(&view,0,&got));assert(!memcmp(got.world,v[0].world,24));assert(!memcmp(got.normal_front,v[0].normal_front,6));assert(!memcmp(got.normal_back,v[0].normal_back,6));}
co_buffer b={store+1,999,0,0};assert(co_append_pixel_normal_pair(&b,&in));v[1].normal_back[0]=1;assert(co_append_pixel_normal_pair(&b,&in));assert(b.size==168+184&&b.packets==2);co_view a,c;assert(co_read(b.data,b.size,&a)&&a.mode==5&&a.size==168);assert(co_read(b.data+a.size,b.size-a.size,&c)&&c.mode==4&&c.size==184);co_pixel_vertex got;assert(co_pixel_vertex_at(&c,1,&got)&&got.normal_back[0]==1);memset(v,0xa5,sizeof v);assert(co_pixel_vertex_at(&a,0,&got)&&got.normal_back[0]==-32767);
for(unsigned n=0;n<168;n++){co_view out,old;memset(&out,0x5a,sizeof out);old=out;assert(!co_read(b.data,n,&out));assert(!memcmp(&out,&old,sizeof out));}
// Used invalid normal rejects atomically even after fallback became necessary.
memset(v,0,sizeof v);for(int j=0;j<4;j++){v[j].normal_front[2]=32767;v[j].normal_back[2]=-32767;}v[0].normal_back[0]=1;v[2].normal_front[0]=INT16_MIN;memcpy(saved,store,sizeof store);co_buffer old=b;assert(!co_append_pixel_normal_pair(&b,&in));assert(!memcmp(store,saved,sizeof store)&&!memcmp(&b,&old,sizeof b));v[2].normal_front[0]=0;
// Cap−1 and packet ceiling do not mutate any bytes, including spare storage.
b.capacity=b.size+183;old=b;assert(!co_append_pixel_normal_pair(&b,&in));assert(!memcmp(store,saved,sizeof store)&&!memcmp(&b,&old,sizeof b));b.capacity=999;b.packets=256;old=b;assert(!co_append_pixel_normal_pair(&b,&in));assert(!memcmp(store,saved,sizeof store)&&!memcmp(&b,&old,sizeof b));puts("independent all65535 SNORM values, unaligned50B, unused-invalid, mixed5/4, poisonedinputs,168truncations, fallback-invalid/cap/count atomic PASS");}
