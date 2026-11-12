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
size_t lossless_decode_channel(const uint8_t *p,size_t len,unsigned sx,unsigned sy,unsigned sz,uint16_t out[64]){
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
static uint32_t u32(const uint8_t *p){return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
/* Validated random vertex fetch. Output is transactional even for corrupt data.
 * Header and selected offset pair checked per call. Full index monotonicity is
 * a separate load-time/generator validation, not a per-access full-table scan.
 */
int lossless_fetch(const uint8_t *blob,size_t len,uint32_t vertex,uint16_t rgb[3]){
 static const uint8_t magic[8]={'A','G','X','L','4','R','0','1'};
 if(!blob||!rgb||len<19688||len>19688u+4913u*396u||vertex>=274625)return 0;
 uintptr_t a=(uintptr_t)blob,b=(uintptr_t)rgb;
 if(a<=b ? b-a<len : a-b<3*sizeof(uint16_t))return 0;
 for(unsigned i=0;i<8;i++)if(blob[i]!=magic[i])return 0;
 if(blob[8]!=65||blob[9]||blob[10]!=4||blob[11]||u32(blob+12)!=4913||u32(blob+16)!=len||u32(blob+20)!=32||u32(blob+24)!=19688||u32(blob+28))return 0;
 size_t ds=19688,dl=len-ds;
 if(u32(blob+32)!=0||u32(blob+32+4913*4)!=dl)return 0;
 unsigned x=vertex/4225,y=vertex/65%65,z=vertex%65,bx=x/4,by=y/4,bz=z/4;
 unsigned bi=(bx*17+by)*17+bz,sx=bx==16?1:4,sy=by==16?1:4,sz=bz==16?1:4;
 unsigned target=((x%4)*sy+y%4)*sz+z%4;
 size_t start=u32(blob+32+bi*4),end=u32(blob+32+(bi+1)*4);
 if(start>=end||end>dl||end-start>396)return 0;
 const uint8_t *p=blob+ds+start;size_t avail=end-start;uint16_t scratch[64],result[3];
 for(unsigned c=0;c<3;c++){
  size_t used=lossless_decode_channel(p,avail,sx,sy,sz,scratch);
  if(!used||used>avail)return 0;
  result[c]=scratch[target];p+=used;avail-=used;
 }
 if(avail)return 0;
 for(unsigned c=0;c<3;c++)rgb[c]=result[c];
 return 1;
}

/* Four-corner API. All selected blocks are fully checked before any public
 * output write. Indices may alias output. Output may not overlap blob.
 * No state survives this call; callers must keep blob stable while running. */
int lossless_fetch4(const uint8_t *blob,size_t len,const uint32_t vertices[4],uint16_t rgb[4][3]){
 static const uint8_t magic[8]={'A','G','X','L','4','R','0','1'};
 if(!blob||!vertices||!rgb||len<19688||len>19688u+4913u*396u)return 0;
 uintptr_t a=(uintptr_t)blob,b=(uintptr_t)rgb;
 if(a<=b ? b-a<len : a-b<12*sizeof(uint16_t))return 0;
 uint32_t v[4];for(unsigned j=0;j<4;j++){v[j]=vertices[j];if(v[j]>=274625)return 0;}
 for(unsigned i=0;i<8;i++)if(blob[i]!=magic[i])return 0;
 if(blob[8]!=65||blob[9]||blob[10]!=4||blob[11]||u32(blob+12)!=4913||u32(blob+16)!=len||u32(blob+20)!=32||u32(blob+24)!=19688||u32(blob+28))return 0;
 size_t ds=19688,dl=len-ds;
 if(u32(blob+32)!=0||u32(blob+32+4913*4)!=dl)return 0;
 unsigned block[4],target[4],sx[4],sy[4],sz[4];uint16_t result[4][3];
 for(unsigned j=0;j<4;j++){
  unsigned x=v[j]/4225,y=v[j]/65%65,z=v[j]%65,bx=x/4,by=y/4,bz=z/4;
  block[j]=(bx*17+by)*17+bz;sx[j]=bx==16?1:4;sy[j]=by==16?1:4;sz[j]=bz==16?1:4;
  target[j]=((x%4)*sy[j]+y%4)*sz[j]+z%4;
 }
 for(unsigned j=0;j<4;j++){
  unsigned previous=0;for(unsigned k=0;k<j;k++)if(block[k]==block[j])previous=1;
  if(previous)continue;
  size_t start=u32(blob+32+block[j]*4),end=u32(blob+32+(block[j]+1)*4);
  if(start>=end||end>dl||end-start>396)return 0;
  const uint8_t *p=blob+ds+start;size_t avail=end-start;uint16_t scratch[64];
  for(unsigned c=0;c<3;c++){
   size_t used=lossless_decode_channel(p,avail,sx[j],sy[j],sz[j],scratch);
   if(!used||used>avail)return 0;
   for(unsigned k=j;k<4;k++)if(block[k]==block[j])result[k][c]=scratch[target[k]];
   p+=used;avail-=used;
  }
  if(avail)return 0;
 }
 for(unsigned j=0;j<4;j++)for(unsigned c=0;c<3;c++)rgb[j][c]=result[j][c];
 return 1;
}
