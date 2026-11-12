#include "bridge.h"
#include "../../fox-snapshot-lifetime-20261111/render_adapter.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#ifdef ESP_PLATFORM
#include "../../fox-snapshot-lifetime-20261111/lease_freertos.h"
static lease_mutex sm,bm;
static void lock(void*p){lease_mutex_lock(p);}static void unlock(void*p){lease_mutex_unlock(p);}
#else
#include <pthread.h>
static pthread_mutex_t sm=PTHREAD_MUTEX_INITIALIZER,bm=PTHREAD_MUTEX_INITIALIZER;
static void lock(void*p){assert(!pthread_mutex_lock(p));}static void unlock(void*p){assert(!pthread_mutex_unlock(p));}
#endif
static fox_eye_snapshot snapshots[2];static leased_strip strips[2];static render_scratch scratch;
static lease_pool sp,bp;static lease_slot ss[2],bs[2];static lease_reader sr[4],br[4];
static lease_key latest;static bool initialized,has_latest,closed,joined;
struct pending {const leased_strip*p;lease_ticket t;leased_strip saved;};
static struct pending pending[2];static unsigned count,submits,fail_at,completed,duplicates;
static bool inline_mode,no_pump,close_inflight;static uint32_t frame_hash;
static uint16_t image[240*135];static unsigned capture=99;
static void init(void){if(initialized)return;
#ifdef ESP_PLATFORM
lease_mutex_init(&sm);lease_mutex_init(&bm);
#endif
ss[0].payload=snapshots;ss[1].payload=snapshots+1;bs[0].payload=strips;bs[1].payload=strips+1;lease_init(&sp,ss,2,sr,4,&sm,lock,unlock);lease_init(&bp,bs,2,br,4,&bm,lock,unlock);initialized=true;}
static bool pump(void*x){(void)x;if(!count||no_pump)return false;struct pending q=pending[--count];assert(!memcmp(q.p,&q.saved,sizeof q.saved));assert(lease_complete(&bp,q.t));completed++;assert(!lease_complete(&bp,q.t));duplicates++;return true;}
static bool submit(void*x,const leased_strip*p,lease_ticket t){(void)x;assert(!joined);assert(count<2);submits++;
 for(unsigned i=0;i<p->height*240;i++)frame_hash=(frame_hash^p->pixels[i])*16777619u;
 memcpy(image+p->y*240,p->pixels,p->height*240*sizeof(uint16_t));
 pending[count++]=(struct pending){.p=p,.t=t,.saved=*p};
 if(close_inflight&&submits==1){closed=true;no_pump=true;lease_close(&sp);lease_close(&bp);assert(!lease_drained(&sp));assert(!lease_drained(&bp));}
 if(inline_mode)assert(pump(NULL));return !fail_at||submits!=fail_at;
}
bool fox_composed_commit(const FoxEyeControls*c,uint32_t*out){init();if(closed)return false;lease_key key;void*dst;if(!lease_acquire(&sp,&key,&dst))return false;
 if(!fox_eye_snapshot_build(dst,c)){assert(lease_abort(&sp,key));return false;}
 assert(lease_publish(&sp,key));submits=0;frame_hash=2166136261u;
 bool ok=render_leased(&sp,key,&bp,&scratch,submit,pump,NULL);
 if(ok){while(pump(NULL)){}assert(count==0);if(has_latest)assert(lease_retire(&sp,latest));latest=key;has_latest=true;*out=frame_hash;
 if(capture<9){
#ifdef ESP_PLATFORM
 for(unsigned y=0;y<135;y++){printf("COMPOSED_ROW sample=%u y=%u ",capture,y);for(unsigned x=0;x<240;x++){uint16_t v=image[y*240+x];printf("%02x%02x",v&255,v>>8);}putchar('\n');}
#else
 char path[120];snprintf(path,sizeof path,"fox-product-composed-20261111/motion-%ums.rgb565",capture*125);FILE*f=fopen(path,"wb");assert(f);for(unsigned i=0;i<240*135;i++){unsigned char bytes[2]={image[i]&255,image[i]>>8};assert(fwrite(bytes,1,2,f)==2);}fclose(f);
#endif
 printf("COMPOSED_FRAME sample=%u hash=%08x\n",capture,frame_hash);capture=99;}
 }else {assert(lease_retire(&sp,key)||closed);}
 return ok;
}
unsigned fox_composed_hidden(void){if(!has_latest)return 0;unsigned n=0;for(unsigned i=0;i<74;i++)n+=snapshots[latest.slot].hidden[i]!=0;return n;}
unsigned fox_composed_mode(int mode){init();if(mode>=100&&mode<109){capture=mode-100;return 0;}switch(mode){
 case 0:fail_at=0;inline_mode=false;no_pump=false;break;
 case 1:inline_mode=true;break;
 case 2:fail_at=3;break;
 case 3:no_pump=true;break;
 case 4:return count;
 case 5:no_pump=false;while(pump(NULL)){}return count;
 case 6:closed=true;lease_close(&sp);lease_close(&bp);return lease_drained(&sp)&&lease_drained(&bp);
 case 7:close_inflight=true;break;
 default:assert(0);
 }return count;}
void fox_composed_finish(void){init();closed=true;lease_close(&sp);lease_close(&bp);no_pump=false;while(pump(NULL)){}/* Mock callback source is fully synchronous and empty now. No future source may run. */joined=true;assert(lease_drained(&sp)&&lease_drained(&bp));assert(completed==duplicates);printf("PASS composed source joined, pools drained, exact completions=%u duplicate rejections=%u\n",completed,duplicates);}
