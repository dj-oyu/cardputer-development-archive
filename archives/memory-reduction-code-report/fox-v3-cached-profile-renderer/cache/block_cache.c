/* Independent research decoder. No LUT data. Not integrated into firmware.
 * Decode one channel of a cube4 block into caller-owned 64-word scratch.
 * All reads bounded by len<=396. out is private scratch and may be changed
 * on error; never expose this helper as the transactional public RGB API.
 * Returns channel record byte count or zero on error.
 */
#include <stdint.h>
#include <stddef.h>
static int getbits(const uint8_t *p,size_t len,size_t *bit,unsigned n,uint32_t *v){
 if(*bit>len*8 || n>len*8-*bit)return 0;
 uint32_t r=0;
#if FAST_BITS
 /* n <= 16 at all call sites. Load only bytes containing requested bits. */
 if(n){size_t byte=*bit/8;unsigned shift=(unsigned)(*bit%8);
  unsigned bytes=(shift+n+7)/8;
  for(unsigned j=0;j<bytes;j++)r|=(uint32_t)p[byte+j]<<(8*j);
  r=(r>>shift)&((1u<<n)-1u);*bit+=n;}
#else
 for(unsigned k=0;k<n;k++,(*bit)++)r|=((p[*bit/8]>>(*bit%8))&1u)<<k;
#endif
 *v=r;return 1;
}
static size_t decode_channel(const uint8_t *p,size_t len,unsigned sx,unsigned sy,unsigned sz,uint16_t out[64]){
 if(!p||!out||len<2||len>396||!sx||!sy||!sz||sx>4||sy>4||sz>4)return 0;
 unsigned mode=p[0],k=p[1],n=sx*sy*sz;size_t head=2,bit=0;uint32_t base=0;
 if(mode>7||mode==4||k>16)return 0;
 if(mode==0){if(len<4)return 0;base=(uint32_t)p[2]|((uint32_t)p[3]<<8);head=4;}
 p+=head;len-=head;
 for(unsigned i=0;i<n;i++){
  uint32_t r=0,q=0,t;
  if(mode>=5){do{if(!getbits(p,len,&bit,1,&t))return 0;if(!t&&++q>(65535u>>k))return 0;}while(!t);}
  if(!getbits(p,len,&bit,k,&r))return 0;
  r|=q<<k;
  if(mode==0){if(base+r>65535)return 0;out[i]=(uint16_t)(base+r);continue;}
  unsigned m=mode>=5?mode-4:mode;int32_t pred=0;
  if(m==1){if(i)pred=out[i-1];}
  else if(m==2){if(i)pred=2*(int32_t)out[i-1]-(i>1?out[i-2]:0);}
  else {
   unsigned x=i/(sy*sz),y=(i/sz)%sy,z=i%sz;
   if(x)pred+=out[i-sy*sz];
   if(y)pred+=out[i-sz];
   if(z)pred+=out[i-1];
   if(x&&y)pred-=out[i-sy*sz-sz];
   if(x&&z)pred-=out[i-sy*sz-1];
   if(y&&z)pred-=out[i-sz-1];
   if(x&&y&&z)pred+=out[i-sy*sz-sz-1];
  }
  int32_t delta=(int32_t)(r>>1);if(r&1)delta=-delta-1;
  out[i]=(uint16_t)(pred+delta);
 }
 return head+(bit+7)/8;
}

#include "block_cache.h"
#include <string.h>
static uint32_t u32(const uint8_t *p){return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
static int overlap(const void *x,size_t nx,const void *y,size_t ny){
 uintptr_t a=(uintptr_t)x,b=(uintptr_t)y;
 return nx&&ny&&(a<=b?b-a<nx:a-b<ny);
}
static int header(const uint8_t *p,size_t n){
 static const uint8_t magic[8]={'A','G','X','L','4','R','0','1'};
 if(!p||n<19688||n>19688u+4913u*396u)return 0;
 if(memcmp(p,magic,8)||p[8]!=65||p[9]||p[10]!=4||p[11]||u32(p+12)!=4913||u32(p+16)!=n||u32(p+20)!=32||u32(p+24)!=19688||u32(p+28))return 0;
 return u32(p+32)==0&&u32(p+32+4913*4)==n-19688;
}
void agx_cache_init(agx_block_cache *c){if(c)memset(c,0,sizeof *c);}
void agx_cache_clear(agx_block_cache *c){agx_cache_init(c);}
int agx_cache_bind(agx_block_cache *c,const uint8_t *p,size_t n){
 if(!c)return 0;
 if(p&&overlap(c,sizeof *c,p,n))return 0;
 agx_cache_clear(c);
 if(!header(p,n))return 0;
 uint32_t prev=0;
 for(unsigned i=1;i<=4913;i++){
  uint32_t end=u32(p+32+i*4);
  if(end<=prev||end>n-19688||end-prev>396)return 0;
  prev=end;
 }
 c->blob=p;c->length=n;return 1;
}
static void remove_entry(agx_block_cache *c,unsigned slot){
 if(!c->entries[slot].valid)return;
 unsigned old=c->entries[slot].age;
 c->entries[slot].valid=0;
 for(unsigned i=0;i<4;i++)if(c->entries[i].valid&&c->entries[i].age>old)c->entries[i].age--;
}
static void touch(agx_block_cache *c,unsigned slot){
 unsigned old=c->entries[slot].age;
 for(unsigned i=0;i<4;i++)if(c->entries[i].valid&&i!=slot&&c->entries[i].age<old)c->entries[i].age++;
 c->entries[slot].age=0;
}
int agx_cache_fetch4(agx_block_cache *c,const uint32_t vertices[4],uint16_t rgb[4][3]){
 if(!c||!vertices||!rgb)return 0;
 if(overlap(c,sizeof *c,vertices,16)||overlap(c,sizeof *c,rgb,24))return 0;
 const uint8_t *p=c->blob;size_t n=c->length;
 if(overlap(c,sizeof *c,p,n)||overlap(p,n,rgb,24))return 0;
 uint32_t v[4];memcpy(v,vertices,sizeof v);
 for(unsigned j=0;j<4;j++)if(v[j]>=274625)return 0;
 if(!header(p,n))return 0;
 uint16_t result[4][3];
 for(unsigned j=0;j<4;j++){
  unsigned x=v[j]/4225,y=v[j]/65%65,z=v[j]%65,bx=x/4,by=y/4,bz=z/4;
  unsigned block=(bx*17+by)*17+bz,sx=bx==16?1:4,sy=by==16?1:4,sz=bz==16?1:4;
  unsigned target=((x%4)*sy+y%4)*sz+z%4;
  uint32_t start=u32(p+32+block*4),end=u32(p+32+(block+1)*4);
  if(start>=end||end>n-19688||end-start>396)return 0;
  unsigned slot=4;
  for(unsigned i=0;i<4;i++)if(c->entries[i].valid&&c->entries[i].block==block){
   agx_cache_entry *e=&c->entries[i];
   if(e->start==start&&e->end==end&&!memcmp(e->encoded,p+19688+start,end-start)){slot=i;c->hits++;}
   else {remove_entry(c,i);c->invalidations++;}
   break;
  }
  if(slot==4){
   c->misses++;slot=0;
   for(unsigned i=0;i<4;i++){
    if(!c->entries[i].valid){slot=i;break;}
    if(c->entries[i].age>c->entries[slot].age)slot=i;
   }
   agx_cache_entry *e=&c->entries[slot];remove_entry(c,slot);
   const uint8_t *record=p+19688+start;size_t avail=end-start;
   for(unsigned ch=0;ch<3;ch++){
    size_t used=decode_channel(record,avail,sx,sy,sz,e->values[ch]);
    if(!used||used>avail)return 0;
    record+=used;avail-=used;
   }
   if(avail)return 0;
   e->block=block;e->start=start;e->end=end;
   memcpy(e->encoded,p+19688+start,end-start);e->age=0;
   for(unsigned i=0;i<4;i++)if(c->entries[i].valid)e->age++;
   e->valid=1;
  }
  touch(c,slot);
  for(unsigned ch=0;ch<3;ch++)result[j][ch]=c->entries[slot].values[ch][target];
 }
 memcpy(rgb,result,sizeof result);return 1;
}
