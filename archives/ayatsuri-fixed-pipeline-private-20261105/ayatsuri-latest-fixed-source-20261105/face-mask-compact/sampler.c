#include "sampler.h"
#include "compact-data.h"
static int valid(const FaceQuery*q){
 if(q->mask>=8||!(q->mode==1||q->mode==2)||!(q->frac==0||q->frac==16||q->frac==20||q->frac==24))return 0;
 int64_t scale=q->frac?((int64_t)1<<q->frac):1,mul=q->frac?1000000:1,bound=16000000*scale;
 return (int64_t)q->x*mul>=-bound&&(int64_t)q->x*mul<=bound&&(int64_t)q->y*mul>=-bound&&(int64_t)q->y*mul<=bound&&(int64_t)q->z*mul>=-bound&&(int64_t)q->z*mul<=bound;
}
/* Exact floor of a*65536/b without overflowing the bounded int64 range. */
static int64_t q16ratio(int64_t a,int64_t b){return (a/b)*65536+(a%b)*65536/b;}
static int64_t floordiv(int64_t a,int64_t b){int64_t q=a/b;return q-(a%b<0);}
/* Fixed validated blob: 8 state bytes, 769 little-endian uint16 offsets,
   then 6417 span bytes. No cast, alignment or native-endian dependency. */
static uint8_t pixel(unsigned m,int x,int y){
 if(x<0||x>=128||y<0||y>=64)return 0;
 unsigned c=(unsigned)face_compact_blob[m]*128+(unsigned)x;
 unsigned o=8+c*2;
 unsigned p=1546+(unsigned)face_compact_blob[o]+(unsigned)face_compact_blob[o+1]*256;
 unsigned start=face_compact_blob[p],len=face_compact_blob[p+1];
 return (unsigned)y>=start&&(unsigned)y<start+len?face_compact_blob[p+2+(unsigned)y-start]:0;
}
static uint8_t sample(const FaceQuery*q){
 int mouth=q->mask>=4;int64_t x0=mouth?-380000:-420000,w=mouth?760000:840000,z1=mouth?2340000:3130000,h=mouth?265000:450000;
 int64_t scale=q->frac?((int64_t)1<<q->frac):1,mul=q->frac?1000000:1;
 x0*=scale;w*=scale;z1*=scale;h*=scale;
 int64_t dx=(int64_t)q->x*mul-x0,dz=z1-(int64_t)q->z*mul;
 if((int64_t)q->y*mul>=(mouth?-850000:-450000)*scale||dx<0||dx>=w||dz<0||dz>=h)return 0;
 if(q->mode!=2)return pixel(q->mask,(int)(dx*128/w),(int)(dz*64/h));
 int64_t sx=q16ratio(dx*128,w)-32768,sy=q16ratio(dz*64,h)-32768;
 int x=(int)floordiv(sx,65536),y=(int)floordiv(sy,65536);
 uint64_t fx=(uint64_t)(sx-(int64_t)x*65536),fy=(uint64_t)(sy-(int64_t)y*65536),ix=65536-fx,iy=65536-fy;
 uint64_t v=(uint64_t)pixel(q->mask,x,y)*ix*iy+(uint64_t)pixel(q->mask,x+1,y)*fx*iy+(uint64_t)pixel(q->mask,x,y+1)*ix*fy+(uint64_t)pixel(q->mask,x+1,y+1)*fx*fy;
 return (uint8_t)((v+2147483648ULL)/4294967296ULL);
}
int face_block(const FaceQuery*q,size_t n,uint8_t*out){
 if(!q||!out||!(n==1||n==2||n==4||n==8))return -1;
 uint8_t tmp[8];for(size_t i=0;i<n;i++)if(!valid(q+i))return -1;
 for(size_t i=0;i<n;i++)tmp[i]=sample(q+i);
 for(size_t i=0;i<n;i++)out[i]=tmp[i];
 return 0;
}
int face_scalar(const FaceQuery*q,uint8_t*out){return face_block(q,1,out);}
