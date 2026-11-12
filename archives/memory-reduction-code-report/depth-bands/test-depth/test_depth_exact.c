#include "fixture.h"
static uint64_t shader_digest,profile_digest,query_digest,event_digest;
static void mix(uint64_t*h,const void*p,size_t n){const uint8_t*b=p;while(n--){*h^=*b++;*h*=UINT64_C(1099511628211);}}
static bool tracked_shade(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){mix(&event_digest,"S",1);mix(&event_digest,pos,24);mix(&shader_digest,pos,24);mix(&shader_digest,n,24);mix(&shader_digest,rho,24);return shade(p,s,pos,n,rho,out);}
static int profile(const float in[3],float out[3]){mix(&event_digest,"P",1);mix(&event_digest,in,12);mix(&profile_digest,in,12);for(unsigned k=0;k<3;k++)out[k]=in[k]/(1+in[k]);return 0;}
static bool tracked_compose(void*p,const KsnSceneQuery*q,KsnSceneResult*r){mix(&event_digest,"Q",1);mix(&event_digest,&q->x,sizeof q->x);mix(&event_digest,&q->y,sizeof q->y);mix(&query_digest,&q->x,sizeof q->x);mix(&query_digest,&q->y,sizeof q->y);mix(&query_digest,&q->sample,sizeof q->sample);mix(&query_digest,&q->character_hit,sizeof q->character_hit);mix(&query_digest,&q->character_depth,sizeof q->character_depth);return compose(p,q,r);}
static void quad(fixture*f,unsigned node,float x,float y,float width,float height,float z){
 co_pixel_vertex v[4]={0};uint16_t ix[6]={0,1,2,0,2,3};uint8_t bits[8]={0};
 for(unsigned j=0;j<4;j++){float xx=x+((j==1||j==2)?width:0),yy=y+(j>=2?height:0);v[j].front=(co_vertex){xx,yy,(j&1)?-1:1,z,0x39e7,0xf800};v[j].world[0]=xx;v[j].world[1]=yy;v[j].world[2]=node;v[j].normal_front[0]=32767;v[j].normal_back[0]=-32767;}
 co_pixel_input p={v,ix,bits,(uint16_t)node,4,2};assert(co_append_pixel_normal_pair(&f->s.mesh.packets,&p));f->s.mesh.work+=40000;
}
int main(void){unsigned cases=0;
 assert(sizeof(ksn_aa_workspace)==137312);assert(sizeof(ksn_bounded_ring_workspace)==77312);
 for(unsigned mode=0;mode<5;mode++)for(unsigned reverse=0;reverse<2;reverse++){
 fixture f;init(&f);KsnDepthBands db={0};for(unsigned i=0;i<5;i++){db.bytes[i]=i<4?30720:6720;db.band[i]=malloc(db.bytes[i]);assert(db.band[i]);}assert(sizeof db==80);
 for(unsigned j=0;j<2;j++){unsigned node=reverse?2-j:1+j;
  if(mode==0)quad(&f,node,-8,-8,2,2,node); /* all nohit */
  if(mode==1)quad(&f,node,node==1?0:236,0,4,134,node); /* both x edges, every ring wrap */
  if(mode==2)quad(&f,node,node==1?11:13,6,4,123,node); /* boundary and 128/129 */
  if(mode==3)quad(&f,node,node==1?20:22,128,4,6,node); /* seven-row tail */
  if(mode==4)quad(&f,node,node==1?100:102,7,4,9,node); /* delayed rows7,15 */
 }
 table(&f,2,1); /* Arbitrary stable source IDs, including maximum accepted91. */
 for(unsigned j=0;j<4;j++){unsigned id=j<2?91:73;f.table[6+5*j+3]=id&255;f.table[6+5*j+4]=id>>8;}f.id.fingerprint=hash(f.table,f.id.size);
 ksn_aa_ledger l=limits();unsigned sh=0;assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,NULL,NULL));
 uint8_t mask[4050];memcpy(mask,f.w->targets,4050);mock m={.mask=mask};uint8_t descriptor[32]={0};uint64_t budget[6]={2000000,200000000,100000000,0,0,0};
 KsnSceneBinding b={.compose=tracked_compose,.overlaps=owned_overlap,.context=&m,.context_bytes=sizeof m,.descriptor=descriptor,.descriptor_bytes=32,.shadow_budget=budget,.shadow_budget_bytes=48,.resolver_owned_bytes=sizeof m+32+48,.snapshot_fingerprint=f.id.snapshot_fingerprint,.identity_fingerprint=f.id.fingerprint,.target_mask_fingerprint=hash(mask,4050),.mode=0,.expected_targets=f.w->report.targets};KsnSceneLedger nl=newlimits(b.expected_targets,false);KsnSceneReport nr0,nr1;KsnBandHDRReport rd0,rd1;
 for(unsigned override=0;override<4;override++){
 m=(mock){.mask=mask,.override=override};event_digest=shader_digest=profile_digest=query_digest=UINT64_C(14695981039346656037);memset(f.rgb,0,64800);sh=0;
 assert(ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,tracked_shade,&sh,sizeof sh,&b,&nl,&nr0,profile,&rd0));
 memcpy(f.center,f.rgb,64800);memcpy(f.olddepth,f.depth,129600);ksn_bounded_ring_workspace prior=*f.rw;uint64_t ed=event_digest,sd=shader_digest,pd=profile_digest,qd=query_digest;unsigned oldsh=sh;mock oldm=m;
 m=(mock){.mask=mask,.override=override};event_digest=shader_digest=profile_digest=query_digest=UINT64_C(14695981039346656037);memset(f.rgb,0,64800);memset(f.rw,0xa5,sizeof*f.rw);sh=0;
 assert(ksn_mesh_pixel_render_depth_bands_experimental(&f.s,f.rgb,64800,&db,f.rw,sizeof*f.rw,&f.id,&l,tracked_shade,&sh,sizeof sh,&b,&nl,&nr1,profile,&rd1));
 assert(!memcmp(f.center,f.rgb,64800));for(unsigned i=0;i<5;i++)assert(!memcmp((char*)f.olddepth+i*30720,db.band[i],db.bytes[i]));assert(!memcmp(prior.targets,f.rw->targets,4050));assert(!memcmp(&prior.report,&f.rw->report,sizeof prior.report));assert(!memcmp(&nr0,&nr1,sizeof nr0));assert(rd0.used[RH_ADMISSION]==120&&rd1.used[RH_ADMISSION]==210);rd0.used[RH_ADMISSION]+=90;assert(!memcmp(&rd0,&rd1,sizeof rd0));assert(sh==oldsh&&ed==event_digest&&sd==shader_digest&&pd==profile_digest&&qd==query_digest);assert(!memcmp(&oldm,&m,sizeof m));cases++;
 }
 for(unsigned i=0;i<5;i++)free(db.band[i]);done(&f);
 }
 printf("{\"status\":\"PASS\",\"syntheticExactCases\":%u,\"rgbDepthMaskReports\":true,\"shaderProfileQueryOrderExact\":true,\"ringWrapTailEdgesNohitMaxIDForwardReverse\":true,\"actualFrames\":0}\n",cases);
}
