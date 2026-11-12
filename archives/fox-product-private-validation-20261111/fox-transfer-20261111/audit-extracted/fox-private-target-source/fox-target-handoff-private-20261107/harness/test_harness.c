#include "frame_harness.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
typedef struct {const uint16_t*p[2];unsigned rows[2],count,sends,drains,checks;uint16_t witness[2][960];int fail_send,fail_drain;fh_owner*owner;unsigned expected_ready;bool expected_has_ready;} mock;
static fh_owner owner;static mock board;static scene_frame saved;static fh_times samples[120];
static uint64_t now(void*ctx){(void)ctx;struct timespec t;assert(!clock_gettime(CLOCK_MONOTONIC,&t));return (uint64_t)t.tv_sec*1000000+t.tv_nsec/1000;}
static void check(mock*b){assert(b->owner->ready==b->expected_ready&&b->owner->has_ready==b->expected_has_ready);for(unsigned i=0;i<b->count;i++){assert(!memcmp(b->p[i],b->witness[i],b->rows[i]*480));b->checks++;}}
static bool submit(void*ctx,unsigned y,unsigned rows,const uint16_t*p){mock*b=ctx;(void)y;check(b);assert(b->count<2);unsigned i=b->count++;b->p[i]=p;b->rows[i]=rows;memcpy(b->witness[i],p,rows*480);return (int)++b->sends!=b->fail_send;}
/* Successful mock drain completes every queued fake transfer, then releases
 * each borrow. Witness validation is test-only; no hardware completion claim. */
static bool drain(void*ctx){mock*b=ctx;check(b);if((int)++b->drains==b->fail_drain)return false;b->count=0;return true;}
static void reset(void){assert(!board.count);board.sends=board.drains=0;board.fail_send=board.fail_drain=-1;board.expected_ready=owner.ready;board.expected_has_ready=owner.has_ready;}
static int cmp(const void*a,const void*b){uint64_t x=*(const uint64_t*)a,y=*(const uint64_t*)b;return(x>y)-(x<y);}
static void stats(const char*name,unsigned field){uint64_t a[120],sum=0;for(unsigned i=0;i<120;i++){switch(field){case 0:a[i]=samples[i].prepare_us;break;case 1:a[i]=samples[i].raster_us;break;case 2:a[i]=samples[i].submit_us;break;case 3:a[i]=samples[i].drain_us;break;default:a[i]=samples[i].total_us;}sum+=a[i];}qsort(a,120,sizeof a[0],cmp);printf("STAGE %s count=120 min_us=%llu mean_us=%.3f p95_us=%llu max_us=%llu\n",name,(unsigned long long)a[0],sum/120.0,(unsigned long long)a[113],(unsigned long long)a[119]);}
int main(void){board.owner=&owner;fh_port p={&board,now,submit,drain};fh_times t;unsigned combinations[8][3]={{0}};
 for(unsigned i=0;i<150;i++){reset();assert(fh_frame(&owner,&p,i%8,i%3,-1,&t)==FH_OK);assert(owner.has_ready&&owner.display_known&&!owner.pending&&!owner.pinned&&!board.count);assert(board.sends==34);if(i>=30){samples[i-30]=t;combinations[i%8][i%3]++;}}
 for(unsigned pose=0;pose<8;pose++)for(unsigned camera=0;camera<3;camera++)assert(combinations[pose][camera]==5);
 memcpy(&saved,&owner.frames[owner.ready],sizeof saved);unsigned ready=owner.ready;
 reset();assert(fh_frame(&owner,&p,1,0,1321,&t)==FH_PREPARE);assert(!board.sends&&!board.drains&&owner.ready==ready&&!memcmp(&saved,&owner.frames[ready],sizeof saved));
 reset();board.fail_send=5;assert(fh_frame(&owner,&p,2,0,-1,&t)==FH_SEND);assert(!owner.quarantine&&!owner.pending&&!owner.pinned&&!owner.display_known&&owner.ready==ready);assert(!memcmp(&saved,&owner.frames[ready],sizeof saved));
 reset();board.fail_drain=17;assert(fh_frame(&owner,&p,3,0,-1,&t)==FH_QUARANTINE);assert(owner.quarantine&&owner.pinned&&board.count==2&&owner.ready==ready);unsigned sends=board.sends,drains=board.drains;assert(fh_frame(&owner,&p,4,0,-1,&t)==FH_BUSY);assert(sends==board.sends&&drains==board.drains);check(&board);
 board.fail_drain=board.drains+1;assert(!fh_recover(&owner,&p));assert(owner.quarantine&&owner.pinned);board.fail_drain=-1;assert(fh_recover(&owner,&p));assert(!owner.pinned&&!owner.quarantine&&!owner.display_known&&owner.ready==ready);assert(!memcmp(&saved,&owner.frames[ready],sizeof saved));
 reset();assert(fh_frame(&owner,&p,4,0,-1,&t)==FH_OK);assert(owner.display_known&&owner.ready!=ready);
 puts("PASS warmup=30 measured=120 prepare/send/final-drain/recovery-failure/blocked-quarantine/commit");for(unsigned i=0;i<5;i++)stats((const char*[]){"prepare","raster","submit","drain","total"}[i],i);
 printf("RAM owner=%zu snapshots=%zu workspace=%zu halves=%zu metadata_padding=%zu cold=%zu controls=%zu test_mock=%zu test_saved=%zu test_samples=%zu checks=%u\n",sizeof owner,sizeof owner.frames,sizeof owner.workspace,sizeof owner.halves,sizeof owner-sizeof owner.frames-sizeof owner.workspace-sizeof owner.halves,scene_constant_bytes(),scene_pose_fixture_bytes(),sizeof board,sizeof saved,sizeof samples,board.checks);return 0;}
