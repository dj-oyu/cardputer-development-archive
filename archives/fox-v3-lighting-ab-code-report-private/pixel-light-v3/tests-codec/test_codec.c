#include "compact_opaque.h"
#include "legacy_golden.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

static unsigned checks;
#define CHECK(x) do { checks++; assert(x); } while(0)
static uint8_t data[8192],saved[8192];
static co_pixel_vertex pv[32];
static uint16_t ix[192];
static uint8_t sides[8];
static co_pixel_input input={pv,ix,sides,0x1234,4,2};
static co_buffer buffer={data,sizeof data,0,0};
static void reset(void){
 memset(data,0xa5,sizeof data);memset(pv,0,sizeof pv);memset(sides,0,sizeof sides);
 for(unsigned v=0;v<32;v++){
  pv[v].front=(co_vertex){(float)v,-(float)v,.25f,1.5f,0x4567,0x89ab};
  for(unsigned k=0;k<3;k++){pv[v].world[k]=(v+1)*.125+k;pv[v].normal_front[k]=(int16_t)(k*100-100);pv[v].normal_back[k]=(int16_t)(100-k*100);}
 }
 for(unsigned t=0;t<64;t++){ix[3*t]=3;ix[3*t+1]=0;ix[3*t+2]=2;}
 sides[0]=2;input=(co_pixel_input){pv,ix,sides,0x1234,4,2};buffer=(co_buffer){data,sizeof data,0,0};
}
static void rejected(void){
 memcpy(saved,data,sizeof data);size_t n=buffer.size;unsigned p=buffer.packets;
 CHECK(!co_append_pixel(&buffer,&input));CHECK(!memcmp(saved,data,sizeof data));CHECK(buffer.size==n&&buffer.packets==p);
}
static void bad_byte(size_t at,uint8_t val){uint8_t old=data[at];data[at]=val;co_view v;CHECK(!co_read(data,buffer.size,&v));data[at]=old;}
static void compatibility(void){
 co_vertex v[4]={{1,2,.25f,3,7,7},{4,5,.5f,6,7,7},{7,8,.75f,9,7,7},{10,11,0,12,7,7}};
 uint16_t idx[]={2,0,3,3,0,2},back[]={8,9,8,9,8,9,8,9};uint8_t sb[]={2};
 co_input in={v,idx,99,4,2};co_sided_input si={in,back,sb};
 const uint8_t *gold[]={golden0,golden1,golden2};size_t sizes[]={sizeof golden0,sizeof golden1,sizeof golden2};
 for(unsigned m=0;m<3;m++){
  v[0].color_b=m==1?7:10;co_buffer b={data,sizeof data,0,0};
  CHECK(m==2?co_append_sided(&b,&si):co_append(&b,&in));CHECK(b.size==sizes[m]);CHECK(!memcmp(data,gold[m],b.size));
  co_view view;CHECK(co_read(data,b.size,&view));CHECK(view.mode==m);co_pixel_vertex p;CHECK(!co_pixel_vertex_at(&view,0,&p));
 }
}
int main(void){
 compatibility();reset();CHECK(co_append_pixel(&buffer,&input));CHECK(buffer.size==188&&buffer.packets==1);
 CHECK(data[0]==3&&data[1]==2&&data[2]==4&&data[4]==0x34&&data[5]==0x12);
 CHECK(data[12+16]==0x67&&data[12+17]==0x45&&data[12+18]==0xab&&data[12+19]==0x89);
 /* F64 .125 has LE bytes 00 00 00 00 00 00 c0 3f; SNORM -100 = ff9c. */
 CHECK(data[12+26]==0xc0&&data[12+27]==0x3f&&data[12+44]==0x9c&&data[12+45]==0xff);
 co_view view;CHECK(co_read(data,buffer.size,&view));
 for(unsigned j=0;j<3;j++){
  co_pixel_vertex p;unsigned src=j==0?0:j==1?2:3;CHECK(co_pixel_vertex_at(&view,j,&p));
  CHECK(!memcmp(&p.front,&pv[src].front,sizeof(co_vertex)));CHECK(!memcmp(p.world,pv[src].world,sizeof p.world));CHECK(!memcmp(p.normal_front,pv[src].normal_front,sizeof p.normal_front));CHECK(!memcmp(p.normal_back,pv[src].normal_back,sizeof p.normal_back));
  co_vertex front,back;CHECK(co_vertex_at_side(&view,j,false,&front)&&co_vertex_at_side(&view,j,true,&back));CHECK(!memcmp(&front,&back,sizeof front));
 }
 uint8_t tri[3];bool back;CHECK(co_triangle_at(&view,0,tri));CHECK(tri[0]==2&&tri[1]==0&&tri[2]==1);CHECK(co_triangle_side(&view,0,&back)&&!back);CHECK(co_triangle_side(&view,1,&back)&&back);
 CHECK(!co_pixel_vertex_at(&view,3,pv));CHECK(!co_triangle_at(&view,2,tri));CHECK(!co_triangle_side(&view,2,&back));
 for(size_t n=0;n<buffer.size;n++)CHECK(!co_read(data,n,&view));
 bad_byte(0,2);bad_byte(0,33);bad_byte(1,0);bad_byte(1,65);bad_byte(2,3);bad_byte(2,5);bad_byte(3,1);bad_byte(6,1);bad_byte(8,1);bad_byte(10,192);bad_byte(11,1);bad_byte(187,1);bad_byte(186,0x82);bad_byte(180,3);bad_byte(180,0);
 /* Infinity / NaN binary64; invalid normals on either side. */
 for(unsigned k=0;k<3;k++){
  size_t at=12+20+8*k;uint8_t copy[8];memcpy(copy,data+at,8);memset(data+at,0,8);data[at+6]=0xf0;data[at+7]=0x7f;CHECK(!co_read(data,buffer.size,&view));data[at]=1;CHECK(!co_read(data,buffer.size,&view));memcpy(data+at,copy,8);
 }
 for(unsigned n=44;n<=50;n+=6){uint8_t copy[6];memcpy(copy,data+12+n,6);memset(data+12+n,0,6);CHECK(!co_read(data,buffer.size,&view));memcpy(data+12+n,copy,6);data[12+n]=0;data[12+n+1]=0x80;CHECK(!co_read(data,buffer.size,&view));memcpy(data+12+n,copy,6);}
 for(unsigned k=0;k<3;k++){reset();pv[0].world[k]=NAN;rejected();reset();pv[0].world[k]=INFINITY;rejected();reset();pv[0].normal_front[k]=INT16_MIN;rejected();reset();pv[0].normal_back[k]=INT16_MIN;rejected();}
 reset();memset(pv[0].normal_front,0,6);rejected();reset();memset(pv[0].normal_back,0,6);rejected();
 reset();pv[0].front.x=4097;rejected();reset();pv[0].front.y=-4097;rejected();reset();pv[0].front.depth=NAN;rejected();reset();pv[0].front.mask=INFINITY;rejected();
 reset();input.vertex_count=2;rejected();reset();input.vertex_count=33;rejected();reset();input.triangle_count=0;rejected();reset();input.triangle_count=65;rejected();
 reset();ix[0]=4;rejected();reset();ix[0]=0;rejected();reset();sides[0]=4;rejected();
 reset();buffer.capacity=187;rejected();reset();buffer.size=8193;rejected();reset();buffer.packets=256;rejected();
 reset();input.vertices=NULL;rejected();reset();input.indices=NULL;rejected();reset();input.back_faces=NULL;rejected();
 reset();buffer.size=13;buffer.capacity=200;rejected();
 reset();buffer.size=13;buffer.capacity=201;CHECK(co_append_pixel(&buffer,&input));CHECK(buffer.size==201);for(unsigned j=0;j<13;j++)CHECK(data[j]==0xa5);CHECK(co_read(data+13,188,&view));
 /* Unreferenced values are intentionally ignored, preserving old compaction. */
 reset();pv[1].world[0]=NAN;memset(pv[1].normal_front,0,6);CHECK(co_append_pixel(&buffer,&input));CHECK(data[0]==3);
 for(unsigned nt=1;nt<=64;nt++){
  reset();input.vertex_count=32;input.triangle_count=(uint8_t)nt;memset(sides,0xff,sizeof sides);if(nt%8)sides[(nt-1)/8]=(uint8_t)((1u<<(nt%8))-1u);
  for(unsigned t=0;t<nt;t++){ix[3*t]=(uint16_t)(t%30);ix[3*t+1]=(uint16_t)(t%30+1);ix[3*t+2]=(uint16_t)(t%30+2);}
  CHECK(co_append_pixel(&buffer,&input));CHECK(co_read(data,buffer.size,&view));
  for(unsigned t=0;t<nt;t++)CHECK(co_triangle_side(&view,t,&back)&&back);
 }
 reset();pv[0].world[0]=DBL_MAX;pv[0].world[1]=-DBL_MAX;pv[0].world[2]=-0.0;pv[0].front.x=4096;pv[0].front.y=-4096;pv[0].normal_front[0]=32767;pv[0].normal_back[0]=-32767;CHECK(co_append_pixel(&buffer,&input));CHECK(co_read(data,buffer.size,&view));co_pixel_vertex decoded;CHECK(co_pixel_vertex_at(&view,0,&decoded));CHECK(!memcmp(decoded.world,pv[0].world,sizeof decoded.world));
 reset();buffer.packets=255;CHECK(co_append_pixel(&buffer,&input));rejected();
 /* Borrow contract: adjacent but disjoint storage is legal, sources unchanged.
  * Overlapping source/destination is a caller violation, not a reject guarantee.
  * Never invoke it, since old mode0/1/2 APIs explicitly require non-overlap. */
 struct { co_pixel_vertex vertices[4];uint16_t indices[6];uint8_t side[1];uint8_t destination[188]; } adjacent;
 reset();memcpy(adjacent.vertices,pv,sizeof adjacent.vertices);memcpy(adjacent.indices,ix,sizeof adjacent.indices);adjacent.side[0]=2;
 co_pixel_vertex source_copy[4];memcpy(source_copy,adjacent.vertices,sizeof source_copy);
 co_pixel_input adjacent_input={adjacent.vertices,adjacent.indices,adjacent.side,0,4,2};co_buffer adjacent_buffer={adjacent.destination,sizeof adjacent.destination,0,0};
 CHECK(co_append_pixel(&adjacent_buffer,&adjacent_input));CHECK(!memcmp(source_copy,adjacent.vertices,sizeof source_copy));CHECK(!memcmp(adjacent.indices,ix,sizeof adjacent.indices));CHECK(adjacent.side[0]==2);
 CHECK(!co_append_pixel(NULL,&input));CHECK(!co_append_pixel(&buffer,NULL));CHECK(!co_read(NULL,0,&view));CHECK(!co_pixel_vertex_at(NULL,0,&decoded));CHECK(!co_pixel_vertex_at(&view,0,NULL));
 printf("codec: %u checks passed\n",checks);
 return 0;
}
