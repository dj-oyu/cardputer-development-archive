#include "render_adapter.h"
#include <assert.h>
#ifdef ESP_PLATFORM
#include "lease_freertos.h"
typedef lease_mutex pthread_mutex_t;
#define PTHREAD_MUTEX_INITIALIZER {0}
static int pthread_mutex_lock(lease_mutex *m){lease_mutex_lock(m);return 0;}
static int pthread_mutex_unlock(lease_mutex *m){lease_mutex_unlock(m);return 0;}
#else
#include <pthread.h>
#endif
#include <stdio.h>
#include <string.h>
static void lock(void*p){assert(!pthread_mutex_lock(p));}static void unlock(void*p){assert(!pthread_mutex_unlock(p));}
static fox_eye_snapshot snapshots[2];static leased_strip strips[2];static render_scratch scratch;
static lease_pool sp,bp;static lease_slot ss[2],bs[2];static lease_reader sr[4],br[4];static pthread_mutex_t sm=PTHREAD_MUTEX_INITIALIZER,bm=PTHREAD_MUTEX_INITIALIZER;
struct pending{const leased_strip*p;lease_ticket t;uint32_t hash;};static struct pending pending[2];static unsigned count,submits,fail_at;static bool inline_mode,cancel_snapshot;static uint32_t frame_hash;
static uint32_t hash(const leased_strip*p){uint32_t h=2166136261u;for(unsigned i=0;i<p->height*240;i++)h=(h^p->pixels[i])*16777619u;return h;}
static bool pump(void*x){(void)x;if(!count)return false;struct pending q=pending[--count];assert(hash(q.p)==q.hash);assert(lease_complete(&bp,q.t));assert(!lease_complete(&bp,q.t));return true;}
static bool submit(void*x,const leased_strip*p,lease_ticket t){(void)x;submits++;if(cancel_snapshot&&submits==1){lease_close(&sp);assert(!lease_drained(&sp));}frame_hash^=hash(p);assert(count<2);pending[count++]=(struct pending){p,t,hash(p)};if(inline_mode)assert(pump(NULL));return !fail_at||submits!=fail_at;}
static void setup(void){
#ifdef ESP_PLATFORM
 if(!sm.handle){lease_mutex_init(&sm);}
 if(!bm.handle){lease_mutex_init(&bm);}
#endif
ss[0].payload=snapshots;ss[1].payload=snapshots+1;bs[0].payload=strips;bs[1].payload=strips+1;lease_init(&sp,ss,2,sr,4,&sm,lock,unlock);lease_init(&bp,bs,2,br,4,&bm,lock,unlock);count=submits=frame_hash=0;}
static lease_key build(void){lease_key k;void*p;assert(lease_acquire(&sp,&k,&p));FoxEyeControls c=fox_eye_default_controls();assert(fox_eye_snapshot_build(p,&c));assert(lease_publish(&sp,k));return k;}
int main(void){setup();lease_key k=build();assert(render_leased(&sp,k,&bp,&scratch,submit,pump,NULL));assert(submits==34);uint32_t baseline=frame_hash;lease_close(&bp);assert(!lease_drained(&bp));while(pump(NULL)){}assert(lease_drained(&bp));assert(lease_retire(&sp,k));assert(lease_drained(&sp));
 setup();k=build();inline_mode=true;assert(render_leased(&sp,k,&bp,&scratch,submit,pump,NULL));assert(frame_hash==baseline);assert(lease_drained(&bp));assert(lease_retire(&sp,k));
 setup();k=build();inline_mode=false;fail_at=3;assert(!render_leased(&sp,k,&bp,&scratch,submit,pump,NULL));assert(count>0);lease_close(&bp);assert(!lease_drained(&bp));while(pump(NULL)){}assert(lease_drained(&bp));assert(lease_retire(&sp,k));
 setup();fail_at=0;inline_mode=false;cancel_snapshot=true;k=build();assert(render_leased(&sp,k,&bp,&scratch,submit,pump,NULL));assert(lease_drained(&sp));while(pump(NULL)){}assert(lease_drained(&bp));
 /* Invalid control update aborts unpublished slot and keeps old snapshot exact. */
 setup();cancel_snapshot=false;k=build();lease_key bad;void*dst;assert(lease_acquire(&sp,&bad,&dst));FoxEyeControls invalid=fox_eye_default_controls();invalid.gaze_x=2;fox_eye_snapshot saved=snapshots[k.slot];assert(!fox_eye_snapshot_build(dst,&invalid));assert(lease_abort(&sp,bad));assert(memcmp(&saved,&snapshots[k.slot],sizeof saved)==0);assert(lease_retire(&sp,k));
 printf("PASS actual scene renderer: 34 bands delayed/out-of-order/reentrant completion; failure retains in-flight strips; hash=%08x scratch=%zu\n",(unsigned)baseline,sizeof scratch);
 return 0;
}
