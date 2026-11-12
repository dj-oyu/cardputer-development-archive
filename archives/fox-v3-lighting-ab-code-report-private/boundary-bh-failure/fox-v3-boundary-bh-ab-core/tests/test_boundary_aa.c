#include "ui/kasane/ksn_boundary_aa.h"
#include "ayatsuri/ayatsuri_shade.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct {uint8_t *owned;ksn_mesh_pixel_snapshot s;uint8_t table[40];ksn_aa_identity id;uint16_t *rgb,*center;float *depth,*olddepth;ksn_aa_workspace*w;} fixture;
static uint64_t hash(const uint8_t*p,size_t n){uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*p++;h*=UINT64_C(1099511628211);}return h;}
static ksn_aa_ledger limits(void){ksn_aa_ledger l={{2750272,32400,56128,4050,129600,97200,259200,3672,1701632,448460,1246956,129600,610560,19080,32768,9920,8192,65536,4096,310000,32400}};return l;}
static FoxDiskScene lights(void){FoxDiskLightInput l[3]={0};for(unsigned j=0;j<3;j++){l[j].shape=FOX_DISK_SHAPE_DISK;l[j].center[0]=2*j;l[j].center[2]=10;for(unsigned k=0;k<3;k++)l[j].color[k]=1;l[j].diameter=1;l[j].power=1;}FoxDiskScene s;double rgb[3]={1,1,1};assert(fox_disk_scene_init(&s,l,rgb,.1)==0);return s;}
static void init(fixture*f){memset(f,0,sizeof*f);f->owned=malloc(65536);f->rgb=calloc(32400,2);f->center=calloc(32400,2);f->depth=malloc(129600);f->olddepth=malloc(129600);f->w=malloc(sizeof*f->w);assert(f->owned&&f->rgb&&f->center&&f->depth&&f->olddepth&&f->w);FoxDiskScene light=lights();assert(ksn_mesh_pixel_begin(&f->s,f->owned,65536,&light,8000000));}
static void done(fixture*f){free(f->owned);free(f->rgb);free(f->center);free(f->depth);free(f->olddepth);free(f->w);}
static void append(fixture*f,unsigned node,float depth,int normalcase,int fallback,int square){
 unsigned nv=square?4:3,nt=square?2:1;co_pixel_vertex*v=calloc(nv,sizeof*v);uint16_t*ix=malloc(nt*3*2);uint8_t*bits=calloc(8,1);
 const float xy[4][2]={{0,0},{4,0},{4,4},{0,4}};const float tri[3][2]={{0,0},{4,0},{0,4}};
 for(unsigned j=0;j<nv;j++){const float*pos=square?xy[j]:tri[j];v[j].front=(co_vertex){pos[0],pos[1],1,depth,65535,65535};v[j].world[0]=pos[0];v[j].world[1]=pos[1];v[j].world[2]=node;
 v[j].normal_front[0]=normalcase?(j?-28672:4096):32767;v[j].normal_back[0]=-v[j].normal_front[0];if(fallback)v[j].normal_back[1]=1;}
 uint16_t idx[6]={0,1,2,0,2,3};memcpy(ix,idx,nt*6);co_pixel_input p={v,ix,bits,(uint16_t)node,(uint8_t)nv,(uint8_t)nt};assert(co_append_pixel_normal_pair(&f->s.mesh.packets,&p));
 memset(v,0xa5,nv*sizeof*v);memset(ix,0xa5,nt*6);memset(bits,0xa5,8);free(v);free(ix);free(bits);f->s.mesh.work+=20000;
}
static void table(fixture*f,unsigned records,int square){unsigned nt=square?2:1;memset(f->table,0,sizeof f->table);for(unsigned j=0;j<=records;j++)f->table[2*j]=(uint8_t)(j*nt);
 for(unsigned j=0;j<records;j++)for(unsigned k=0;k<nt;k++){uint8_t*e=f->table+2*(records+1)+5*(j*nt+k);e[0]=0;e[1]=k?2:1;e[2]=k?3:2;e[3]=(uint8_t)j;}
 f->id=(ksn_aa_identity){f->table,2*(records+1)+5*records*nt,records,records*nt,0,0};f->id.fingerprint=hash(f->table,f->id.size);f->id.snapshot_fingerprint=hash(f->s.storage,416+f->s.mesh.packets.size);}
static bool shade(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){(void)s;(void)n;(void)rho;unsigned*c=p;(*c)++;out[0]=pos[1]>-.04?2:0;out[1]=pos[1]<-.04?1:0;out[2]=0;return true;}
static bool finalsamplefail(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){double x=pos[0]*38;if(fabs(x-nearbyint(x))>1e-9)return false;return shade(p,s,pos,n,rho,out);}
static bool failshade(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){(void)p;(void)s;(void)pos;(void)n;(void)rho;(void)out;return false;}
typedef struct {unsigned events,hit,miss;double sum[5][5][3];unsigned bits[5][5];} proof;
static bool observe(void*p,const ksn_aa_sample*e){proof*q=p;q->events++;assert(e->x<5&&e->y<5);if(e->hit){double d=0x1.272062ae104d0p-2;double ex=e->x+((e->sample&1)?d:-d),ey=e->y+((e->sample&2)?d:-d);assert(fabs(e->position[0]*38-ex)<1e-12);assert(fabs(-e->position[2]*38-ey)<1e-12);q->hit++;q->bits[e->y][e->x]|=1u<<e->sample;assert(e->record_offset!=65535&&e->face<2);for(unsigned k=0;k<3;k++)q->sum[e->y][e->x][k]+=e->linear_rgb[k];}else{q->miss++;assert(e->record_offset==65535&&e->source_id==65535);for(unsigned k=0;k<3;k++)assert(e->linear_rgb[k]==0);}return true;}
static int run(fixture*f,ksn_aa_ledger*l,FoxPixelShader sh,void*ctx,proof*p){memset(f->rgb,0,64800);return ksn_mesh_pixel_render_boundary_experimental(&f->s,f->rgb,f->depth,f->w,&f->id,l,sh,ctx,p?observe:NULL,p);}
static void old(fixture*f,FoxPixelShader sh,void*ctx){ksn_mesh_pixel_stats st={0};for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;assert(ksn_mesh_pixel_render_shaded(&f->s,f->center+y*240,y,rows,f->olddepth+y*240,8,&st,sh,ctx));}}
static bool backobserve(void*p,const ksn_aa_sample*e){unsigned*n=p;if(e->hit){assert(e->back&&e->normal[0]<0);(*n)++;}return true;}
static bool refuseobserve(void*p,const ksn_aa_sample*e){(void)p;(void)e;return false;}
int main(void){
 fixture f;ksn_aa_ledger l=limits();unsigned calls=0,oldcalls=0;proof p={0};init(&f);append(&f,1,1,0,0,1);table(&f,1,1);old(&f,shade,&oldcalls);assert(run(&f,&l,shade,&calls,&p));
 assert(f.w->report.complete&&p.events==4*f.w->report.targets&&p.hit==f.w->report.sample_shades&&calls==f.w->report.center_shades+f.w->report.sample_shades);
 assert(!memcmp(f.depth,f.olddepth,129600));unsigned non=0;for(unsigned k=0;k<32400;k++)if(!((f.w->targets[k/8]>>(k%8))&1)){assert(f.rgb[k]==f.center[k]);non++;}
 /* Frame-exterior sentinel selects (0,0). Only (+q,+q) hits there;
  * HDR red2 /4=.5, rather than clamp2 to1 first or divide byhitcount. */
 assert(f.w->targets[0]&1);assert(p.bits[0][0]==8);unsigned red=(unsigned)lroundf(ayatsuri_srgb_encode(.5f)*31);assert(f.rgb[0]==(red<<11));
 assert(p.bits[1][1]==0); /* Interior is not selected, observer never visits it. */
 /* Exact shared diagonal: no gap, only one face shades each sample. */
 assert(p.bits[0][1]==12);assert(f.depth[0]==1);assert(non>32000);
 uint64_t actual[AA_CATEGORY_COUNT];memcpy(actual,f.w->report.observed.value,sizeof actual);
 for(unsigned k=0;k<AA_CATEGORY_COUNT;k++)assert(actual[k]<=l.value[k]);
 /* Every category exhausts without publishing a complete frame. */
 for(unsigned k=0;k<AA_CATEGORY_COUNT;k++)if(actual[k]){ksn_aa_ledger low=l;low.value[k]=actual[k]-1;unsigned c=0;assert(!run(&f,&low,shade,&c,NULL));assert(!f.w->report.complete&&f.w->report.failed_category==k);}
 uint64_t pin=f.id.fingerprint;f.id.fingerprint^=1;assert(!run(&f,&l,shade,&calls,NULL));f.id.fingerprint=pin;
 f.table[5]=0;f.id.fingerprint=hash(f.table,f.id.size);assert(!run(&f,&l,shade,&calls,NULL));table(&f,1,1);
 /* Duplicate table key, with intentionally refreshed checksum, still rejects. */
 memcpy(f.table+9,f.table+4,3);f.id.fingerprint=hash(f.table,f.id.size);assert(!run(&f,&l,shade,&calls,NULL));table(&f,1,1);
 assert(!run(&f,&l,failshade,NULL,NULL));assert(!f.w->report.complete);done(&f);
 /* Exact depth tie retains first record, and reversing traversal changes winner
  * without changing the source lookup or corrupting the physical side. */
 for(unsigned reverse=0;reverse<2;reverse++){init(&f);append(&f,reverse?2:1,1,0,reverse,0);append(&f,reverse?1:2,1,0,0,0);table(&f,2,0);calls=0;assert(run(&f,&l,shade,&calls,NULL));assert(f.w->center_id[0]==reverse);assert(reverse?(f.rgb[0]&2016):(f.rgb[0]&63488));done(&f);}
 /* New explicitly allowed contract: invalid hidden interpolated normal is not
  * shaded at (+q,+q), valid closer final winner still succeeds. */
 init(&f);append(&f,1,1,1,0,0);append(&f,2,2,0,0,0);table(&f,2,0);assert(run(&f,&l,NULL,NULL,NULL));done(&f);
 /* Owned snapshot mutation and physical-side/original-winding mismatch reject. */
 init(&f);append(&f,1,1,0,0,0);table(&f,1,0);uint8_t *record=f.s.mesh.packets.data;unsigned side=12+50*3+3;record[side]=1;f.id.snapshot_fingerprint=hash(f.s.storage,416+f.s.mesh.packets.size);assert(!run(&f,&l,shade,&calls,NULL));
 f.table[5]=2;f.table[6]=1;f.id.fingerprint=hash(f.table,f.id.size);unsigned backhits=0;assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&calls,backobserve,&backhits));assert(backhits);
 assert(!ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&calls,refuseobserve,NULL));assert(!f.w->report.complete);
 f.id.snapshot_fingerprint^=1;assert(!run(&f,&l,shade,&calls,NULL));done(&f);
 /* Old quarter-node zero-normal fixture remains mandatory in A control.
  * Its cancellation point is not q; B separately proves final-sample shader
  * failure abort after successful integer center, without changing geometry. */
 init(&f);append(&f,1,1,0,0,0);table(&f,1,0);calls=0;oldcalls=0;old(&f,finalsamplefail,&oldcalls);assert(oldcalls);assert(!run(&f,&l,finalsamplefail,&calls,NULL));assert(!f.w->report.complete);done(&f);
 /* A nonfinite owned hidden field always rejects, before any shading. */
 init(&f);append(&f,1,1,0,0,0);append(&f,2,2,0,0,0);table(&f,2,0);double nan=NAN;memcpy(f.s.mesh.packets.data+12+20,&nan,sizeof nan);f.id.snapshot_fingerprint=hash(f.s.storage,416+f.s.mesh.packets.size);calls=0;assert(!run(&f,&l,shade,&calls,NULL));assert(!calls);done(&f);
 printf("{\"unitFixtures\":\"PASS\",\"targetExterior\":true,\"nohitBlackFourDenominator\":true,\"linearHDRBeforeEncode\":true,\"topLeftSharedEdge\":true,\"depthTieFirstWinnerReverse\":true,\"centerDepthExact\":true,\"nonTargetRGBExact\":true,\"allCategoryExhaustion\":true,\"lookupDuplicateMutationRejection\":true,\"mode4FallbackAndMode5\":true,\"poisonFreeBeforeRender\":true,\"finalOnlyHiddenFailureContract\":true,\"workspaceBytes\":%zu}\n",sizeof(ksn_aa_workspace));
}
