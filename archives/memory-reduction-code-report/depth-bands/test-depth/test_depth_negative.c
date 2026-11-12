#include "fixture.h"
#include "depth_band_alloc.h"
static unsigned alloc_calls,fail_alloc,profiles,fail_profile;
static void *allocate(size_t n){alloc_calls++;if(alloc_calls==fail_alloc)return NULL;return malloc(n);}
static int profile(const float in[3],float out[3]){profiles++;if(profiles==fail_profile)return 2;for(unsigned k=0;k<3;k++)out[k]=in[k]/(1+in[k]);return 0;}
static bool run(fixture*f,const KsnDepthBands*d,ksn_aa_ledger*l,unsigned*sh,KsnSceneBinding*b,KsnSceneLedger*nl,KsnSceneReport*nr,KsnBandHDRReport*hr){profiles=0;return ksn_mesh_pixel_render_depth_bands_experimental(&f->s,f->rgb,64800,d,f->rw,sizeof*f->rw,&f->id,l,shade,sh,sizeof*sh,b,nl,nr,profile,hr);}
int main(void){
 fixture f;init(&f);append(&f,1,1,0,0,1);table(&f,1,1);ksn_aa_ledger l=limits();unsigned sh=0;
 assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,NULL,NULL));
 uint8_t mask[4050];memcpy(mask,f.w->targets,sizeof mask);mock m={.mask=mask};uint8_t descriptor[32]={0};uint64_t budget[6]={2000000,200000000,100000000,0,0,0};
 KsnSceneBinding b={.compose=compose,.overlaps=owned_overlap,.context=&m,.context_bytes=sizeof m,.descriptor=descriptor,.descriptor_bytes=32,.shadow_budget=budget,.shadow_budget_bytes=48,.resolver_owned_bytes=sizeof m+80,.snapshot_fingerprint=f.id.snapshot_fingerprint,.identity_fingerprint=f.id.fingerprint,.target_mask_fingerprint=hash(mask,4050),.expected_targets=f.w->report.targets};
 KsnSceneLedger nl=newlimits(b.expected_targets,false);KsnSceneReport nr;KsnBandHDRReport hr;KsnDepthBands d;
 assert(depth_bands_allocate(&d,malloc));assert(sizeof d==80);assert(run(&f,&d,&l,&sh,&b,&nl,&nr,&hr));assert(nr.complete&&hr.complete);
 /* Prior completed reports are intentionally retained at admission failure: false is authoritative. */
 memcpy(f.center,f.rgb,64800);for(unsigned i=0;i<5;i++)memcpy((char*)f.olddepth+i*30720,d.band[i],d.bytes[i]);
 ksn_bounded_ring_workspace *saved=malloc(sizeof*saved);assert(saved);memcpy(saved,f.rw,sizeof*saved);KsnSceneReport ns=nr;KsnBandHDRReport hs=hr;unsigned failures=0;
 #define UNCHANGED() do { assert(!memcmp(f.center,f.rgb,64800));assert(!memcmp(saved,f.rw,sizeof*saved));assert(!memcmp(&ns,&nr,sizeof nr));assert(!memcmp(&hs,&hr,sizeof hr));for(unsigned k=0;k<5;k++)assert(!memcmp((char*)f.olddepth+k*30720,d.band[k],d.bytes[k])); } while(0)
 #define REJECT(p) do {assert(!run(&f,p,&l,&sh,&b,&nl,&nr,&hr));UNCHANGED();failures++;}while(0)
 REJECT(NULL);REJECT((KsnDepthBands*)((char*)&d+1));REJECT((KsnDepthBands*)(UINTPTR_MAX-7));
 for(unsigned i=0;i<5;i++)for(unsigned c=0;c<7;c++){KsnDepthBands bad=d;if(c==0)bad.band[i]=NULL;if(c==1)bad.band[i]=(float*)((char*)d.band[i]+1);if(c==2)bad.bytes[i]--;if(c==3)bad.bytes[i]++;if(c==4)bad.bytes[i]=0;if(c==5)bad.bytes[i]=SIZE_MAX;if(c==6)bad.band[i]=(float*)(UINTPTR_MAX-3);REJECT(&bad);}
 for(unsigned i=0;i<5;i++)for(unsigned j=0;j<5;j++)if(i!=j){KsnDepthBands bad=d;bad.band[i]=d.band[j];REJECT(&bad);}
 const void *spans[]={&f.s,f.s.storage,f.rgb,&d,f.rw,&f.id,f.id.bytes,&l,&sh,&b,&nl,&nr,&hr,&m,descriptor,budget};
 const size_t sizes[]={sizeof f.s,f.s.capacity,64800,sizeof d,sizeof*f.rw,sizeof f.id,f.id.size,sizeof l,sizeof sh,sizeof b,sizeof nl,sizeof nr,sizeof hr,sizeof m,32,48};
 for(unsigned i=0;i<5;i++)for(unsigned j=0;j<sizeof spans/sizeof*spans;j++)for(unsigned edge=0;edge<3;edge++){KsnDepthBands bad=d;uintptr_t p=(uintptr_t)spans[j];if(edge==1)p=(p+sizes[j]-1)&~(uintptr_t)3;if(edge==2)p=(p-4)&~(uintptr_t)3;bad.band[i]=(float*)p;REJECT(&bad);}
 for(unsigned i=0;i<5;i++){m.owned_alias=d.band[i];m.alias_size=d.bytes[i];REJECT(&d);}m.owned_alias=NULL;m.alias_size=0;
 m.owned_alias=&d;m.alias_size=sizeof d;REJECT(&d);m.owned_alias=NULL;m.alias_size=0;
 /* Allocation failures at each of five requests never fall back to a contiguous allocation. */
 for(unsigned i=1;i<=5;i++){KsnDepthBands bad;memset(&bad,0xa5,sizeof bad);alloc_calls=0;fail_alloc=i;assert(!depth_bands_allocate(&bad,allocate));assert(alloc_calls==i);KsnDepthBands zero={0};assert(!memcmp(&bad,&zero,sizeof bad));UNCHANGED();failures++;}fail_alloc=0;
 uint64_t committed_rgb=hash((uint8_t*)f.center,64800),committed_depth=hash((uint8_t*)f.olddepth,129600);
 /* Private scratch can change on runtime failure; committed publication is gated on true. */
 for(unsigned i=0;i<3;i++){fail_profile=i==0?1:i==1?16000:32400;assert(!run(&f,&d,&l,&sh,&b,&nl,&nr,&hr));assert(profiles==fail_profile&&!hr.complete);assert(hash((uint8_t*)f.center,64800)==committed_rgb);assert(hash((uint8_t*)f.olddepth,129600)==committed_depth);failures++;}fail_profile=0;
 /* Late mask verification failure is not successful publication. */
 b.target_mask_fingerprint^=1;assert(!run(&f,&d,&l,&sh,&b,&nl,&nr,&hr));assert(!hr.complete);b.target_mask_fingerprint^=1;failures++;
 printf("{\"status\":\"PASS\",\"negativeCases\":%u,\"allocationFailures\":5,\"admissionPreservesCompleteReports\":true,\"actualFrames\":0}\n",failures);
 depth_bands_release(&d);free(saved);done(&f);
}
