#include "ayatsuri/ayatsuri_model.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifndef N
#define N 5
#endif
#define CAP 8192
static unsigned checks;
#define CHECK(x) do { checks++; if(!(x)){fprintf(stderr,"FAIL line %d: %s\n",__LINE__,#x);abort();} }while(0)
static void w16(void *v,unsigned n){unsigned char*p=v;p[0]=n;p[1]=n>>8;}
static void w32(void *v,unsigned n){unsigned char*p=v;for(unsigned k=0;k<4;k++)p[k]=n>>(8*k);}
static void wf(void *p,float f){memcpy(p,&f,4);} static void wd(void*p,double d){memcpy(p,&d,8);}
typedef struct { _Alignas(8) unsigned char cold[N*128+1024],meta[CAP],slot[N][CAP],legacy[CAP*N]; ayatsuri_model m; ayatsuri_model_node_storage s[N]; ayatsuri_model_instance i,j; unsigned owner; } fixture;
static void make(fixture *f,int mixed){
 memset(f,0,sizeof *f); unsigned ids[]={1,2,3,4,5,6,7,9,10,11,12,13,8}; unsigned strides[]={16,36,12,24,72,8,1,32,28,6,12,4,32}; unsigned counts[]={N,N,1,1,2,N,2*N,1,3,1,0,2,1}; unsigned sections=mixed?13:12;unsigned off[14]={0},at=32+20*sections;
 memcpy(f->cold,"AYNM",4);w16(f->cold+4,1);w16(f->cold+6,32);w32(f->cold+12,sections);w32(f->cold+16,32);w32(f->cold+20,20);
 for(unsigned x=0;x<sections;x++){at=(at+7)&~7u;off[ids[x]]=at;unsigned char*d=f->cold+32+20*x;w16(d,ids[x]);w16(d+2,1);w32(d+4,at);w32(d+8,strides[x]*counts[x]);w32(d+12,counts[x]);w32(d+16,strides[x]);at+=strides[x]*counts[x];}
 w32(f->cold+8,at);
 for(unsigned n=0;n<N;n++){unsigned kind=n==0?0:n<3?(mixed?n:0):3;unsigned char*d=f->cold+off[1]+16*n;w16(d,n?0:65535);d[2]=kind;d[3]=1;w16(d+4,kind?0:65535);w16(d+6,kind==2?1:0);w16(d+8,kind?(n==4?1:0):65535);w16(d+10,n);wf(d+12,kind==2?1:0);d=f->cold+off[2]+36*n;wf(d, n==3?-2:n==4?2:0);for(unsigned k=6;k<9;k++)wf(d+4*k,1);d=f->cold+off[6]+8*n;w16(d,n);w16(d+2,2);w32(d+4,2*n);f->cold[off[7]+2*n]='a'+n/26;f->cold[off[7]+2*n+1]='a'+n%26;}
 for(unsigned k=0;k<3;k++){wf(f->cold+off[3]+k*4,1);wf(f->cold+off[4]+12+k*4,1);}
 for(unsigned n=0;n<2;n++){unsigned char*d=f->cold+off[5]+72*n;wf(d,.1f);wf(d+4,.8f);wf(d+12,8);w32(d+44,0x9364b2);wd(d+48,1);wd(d+56,1);}
 unsigned char*d=f->cold+off[9];w16(d+2,3);w16(d+6,1);w16(d+14,0xf800);w16(d+16,0x07e0);d[18]=255;
 const float xyz[3][3]={{-1,-1,0},{1,-1,0},{0,1,0}};for(unsigned v=0;v<3;v++){d=f->cold+off[10]+28*v;for(unsigned k=0;k<3;k++)wf(d+4*k,xyz[v][k]);wf(d+20,1);wf(d+24,.5f);}
 w16(f->cold+off[11]+2,1);w16(f->cold+off[11]+4,2);f->cold[off[13]+4]=1;
 if(mixed){d=f->cold+off[8];w16(d,2);d[2]=5;wf(d+12,1);w32(d+24,0x123456);}
 CHECK(ayatsuri_model_open(f->cold,at,&f->m)==AYATSURI_MODEL_OK);if(mixed)CHECK(ayatsuri_model_instance_node_bytes(&f->m,2)==448);CHECK(f->m.node_count==N);
 for(unsigned n=0;n<N;n++)f->s[n]=(ayatsuri_model_node_storage){f->slot[n],CAP}; f->owner=123;
}
static void init(fixture*f){memset(&f->i,0xa5,sizeof f->i);memset(&f->j,0xa5,sizeof f->j);CHECK(ayatsuri_model_instance_init(&f->m,f->legacy,sizeof f->legacy,&f->owner,7,&f->j)==0);CHECK(!f->j.segmented);CHECK(ayatsuri_model_instance_init_segmented(&f->m,f->meta,CAP,f->s,N,&f->owner,7,&f->i)==0);CHECK(f->i.segmented);CHECK(f->i.arena_bytes==ayatsuri_model_instance_metadata_bytes(&f->m));}
static void compare(fixture*f){
 CHECK(f->i.mutation_epoch==f->j.mutation_epoch);CHECK(!memcmp(&f->i.stats,&f->j.stats,sizeof f->i.stats));
 for(unsigned n=0;n<N;n++){float a[9],b[9];uint8_t ka=255,kb=255;CHECK(ayatsuri_model_instance_read_pose(&f->i,&f->owner,7,n,a)==0);CHECK(ayatsuri_model_instance_read_pose(&f->j,&f->owner,7,n,b)==0);CHECK(!memcmp(a,b,sizeof a));CHECK(ayatsuri_model_instance_node_kind(&f->i,&f->owner,7,n,&ka)==0);CHECK(ayatsuri_model_instance_node_kind(&f->j,&f->owner,7,n,&kb)==0);CHECK(ka==kb);}
 if(!f->i.evaluated)return;
 uint32_t a=0,b=0;ayatsuri_model_packet pa,pb;for(;;){int sa=ayatsuri_model_instance_next(&f->i,&f->owner,7,&a,&pa),sb=ayatsuri_model_instance_next(&f->j,&f->owner,7,&b,&pb);CHECK(sa==sb&&a==b);if(sa==AYATSURI_MODEL_DONE)break;CHECK(sa==0);CHECK(pa.kind==pb.kind&&pa.node_id==pb.node_id&&pa.bytes==pb.bytes&&pa.lobe_count==pb.lobe_count);CHECK(!memcmp(pa.storage,pb.storage,pa.bytes));CHECK(!memcmp(pa.lighting,pb.lighting,9*sizeof(float)));}
 for(unsigned n=3;n<N;n++){ayatsuri_model_world_mesh_view wa,wb;ayatsuri_model_pixel_mesh_view va,vb;CHECK(ayatsuri_model_instance_world_mesh_view(&f->i,&f->owner,7,n,f->i.mutation_epoch,&wa)==0);CHECK(ayatsuri_model_instance_world_mesh_view(&f->j,&f->owner,7,n,f->j.mutation_epoch,&wb)==0);CHECK(!memcmp(&wa,&wb,sizeof wa));CHECK(ayatsuri_model_instance_pixel_mesh_view(&f->i,&f->owner,7,n,f->i.mutation_epoch,&va)==0);CHECK(ayatsuri_model_instance_pixel_mesh_view(&f->j,&f->owner,7,n,f->j.mutation_epoch,&vb)==0);CHECK(!memcmp(va.patch,vb.patch,sizeof *va.patch));CHECK(!memcmp(va.depth,vb.depth,3*sizeof(float)));CHECK(!memcmp(va.vertices,vb.vertices,sizeof va.vertices));CHECK(!memcmp(va.back_faces,vb.back_faces,sizeof va.back_faces));}
}
static void parity(int mixed){fixture*f=malloc(sizeof *f);CHECK(f);make(f,mixed);init(f);CHECK(f->i.stats.init_copy_bytes==36*N+(mixed?76:0));compare(f);memset(f->s,0xff,sizeof f->s); /* descriptors are dead, saved node addresses remain owned by fixture */
 float cam[9]={0,0,400,0,0,0,1,0,0},light[6]={0,0,1,1,1,1};
 for(unsigned pass=0;pass<8;pass++){if(pass==2)cam[7]=3;if(pass==3)light[3]=.5f;if(pass==4)cam[0]=NAN;if(pass==5)cam[0]=0;
 ayatsuri_model_stats prior=f->i.stats;unsigned epoch=f->i.mutation_epoch;int a=ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light),b=ayatsuri_model_instance_evaluate(&f->j,&f->owner,7,cam,light);CHECK(a==b);CHECK(a==(pass==4?AYATSURI_MODEL_INVALID:AYATSURI_MODEL_OK));CHECK(f->i.mutation_epoch==epoch);CHECK(f->i.stats.eval_calls==prior.eval_calls+1);unsigned recompute=(pass==0||pass==2||pass==3||pass==5);CHECK(f->i.stats.geometry_updates==prior.geometry_updates+(recompute?N:0));CHECK(f->i.stats.projection_updates==prior.projection_updates+(recompute?(mixed?N-1:N-3):0));CHECK(f->i.stats.shade_updates==prior.shade_updates+(recompute?(mixed?N-1:N-3):0));compare(f);
 if(a==0){ayatsuri_model_mesh_view view;ayatsuri_model_sided_mesh_view side;CHECK(ayatsuri_model_instance_mesh_view(&f->i,&f->owner,7,3,&view)==0);ksn_proc_gouraud_patch saved=*(const ksn_proc_gouraud_patch*)view.patch;float depth[3];memcpy(depth,view.depth,sizeof depth);const void*p=view.patch;CHECK(ayatsuri_model_instance_sided_mesh_view(&f->i,&f->owner,7,4,&side)==0);compare(f);CHECK(view.patch==p&&side.patch!=p&&!memcmp(p,&saved,sizeof saved)&&!memcmp(view.depth,depth,sizeof depth));}
 }
 uint8_t dirty[N]={0};float pose[N*9];uint32_t color[N]={0};double opacity[N]={1,1,1,1,1};for(unsigned n=0;n<N;n++)CHECK(ayatsuri_model_instance_read_pose(&f->i,&f->owner,7,n,pose+9*n)==0);ayatsuri_model_targets t={dirty,pose,color,opacity,N};
 for(unsigned pass=0;pass<4;pass++){if(pass==1){dirty[3]=AYATSURI_TARGET_POSITION;pose[27]+=1;}if(pass==2){dirty[N-1]=AYATSURI_TARGET_SCALE;pose[9*(N-1)+6]=0;}if(pass==3){dirty[N-1]=0;dirty[3]=0;if(mixed){dirty[1]=AYATSURI_TARGET_COLOR|AYATSURI_TARGET_OPACITY;color[1]=0x382910;opacity[1]=.6;}}unsigned epoch=f->i.mutation_epoch;int a=ayatsuri_model_instance_targets(&f->i,&f->owner,7,&t),b=ayatsuri_model_instance_targets(&f->j,&f->owner,7,&t);CHECK(a==b);CHECK(a==(pass==2?AYATSURI_MODEL_INVALID:0));CHECK(f->i.mutation_epoch==epoch+((pass==1||(pass==3&&mixed))?1:0));compare(f);CHECK(ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light)==0);CHECK(ayatsuri_model_instance_evaluate(&f->j,&f->owner,7,cam,light)==0);compare(f);}
 if(!mixed){for(unsigned mode=0;mode<2;mode++){CHECK(ayatsuri_model_instance_linear_light(&f->i,&f->owner,7,mode)==0);CHECK(ayatsuri_model_instance_linear_light(&f->j,&f->owner,7,mode)==0);CHECK(ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light)==0);CHECK(ayatsuri_model_instance_evaluate(&f->j,&f->owner,7,cam,light)==0);compare(f);}}

 FoxDiskLightInput inputs[3]={0};for(unsigned k=0;k<3;k++){inputs[k].shape=FOX_DISK_SHAPE_DISK;inputs[k].center[2]=10+k;inputs[k].power=1;inputs[k].diameter=1;for(unsigned c=0;c<3;c++)inputs[k].color[c]=1;}FoxDiskScene scene;double world[3]={.1,.2,.3};CHECK(fox_disk_scene_init(&scene,inputs,world,.2)==FOX_DISK_OK);
 for(unsigned mode=0;mode<3;mode++){const FoxDiskScene*sp=mode<2?&scene:NULL;unsigned epoch=f->i.mutation_epoch;int a=ayatsuri_model_instance_disk_scene(&f->i,&f->owner,7,sp),b=ayatsuri_model_instance_disk_scene(&f->j,&f->owner,7,sp);CHECK(a==b&&a==((mixed&&sp)?AYATSURI_MODEL_INVALID:0));CHECK(f->i.mutation_epoch==epoch+((!mixed&&mode!=1)?1:0));CHECK(ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light)==0);CHECK(ayatsuri_model_instance_evaluate(&f->j,&f->owner,7,cam,light)==0);compare(f);}
 CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,8)==AYATSURI_MODEL_STATE);CHECK(ayatsuri_model_instance_dispose(&f->i,&f->j,7)==AYATSURI_MODEL_STATE);f->i.busy=true;CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,7)==AYATSURI_MODEL_BUSY);f->i.busy=false;CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,7)==0);CHECK(ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light)==AYATSURI_MODEL_STATE);CHECK(ayatsuri_model_instance_dispose(&f->j,&f->owner,7)==0);
 for(unsigned n=0;n<N;n++)f->s[n]=(ayatsuri_model_node_storage){f->slot[n],CAP};CHECK(ayatsuri_model_instance_init_segmented(&f->m,f->meta,CAP,f->s,N,&f->owner,8,&f->i)==0);uint8_t kind=255;CHECK(ayatsuri_model_instance_node_kind(&f->i,&f->owner,7,0,&kind)==AYATSURI_MODEL_STATE&&kind==255);CHECK(ayatsuri_model_instance_node_kind(&f->i,&f->owner,8,0,&kind)==0&&kind==0);CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,8)==0);free(f);
}
static void negative(void){
 for(unsigned caseid=0;caseid<40;caseid++){fixture*f=malloc(sizeof *f),*saved=malloc(sizeof *saved);CHECK(f&&saved);make(f,1);memset(f->meta,0xcc,CAP);memset(f->slot,0xdd,sizeof f->slot);memset(&f->i,0xa5,sizeof f->i);void*meta=f->meta;size_t mb=CAP,count=N;const ayatsuri_model_node_storage*slots=f->s;ayatsuri_model_instance*out=&f->i;const ayatsuri_model*m=&f->m;const void*owner=&f->owner;unsigned gen=7;
 switch(caseid){case 0:meta=NULL;break;case 1:meta=f->meta+1;break;case 2:mb=ayatsuri_model_instance_metadata_bytes(m)-1;break;case 3:count=N-1;break;case 4:count=N+1;break;case 5:slots=NULL;break;case 6:slots=(void*)((char*)f->s+1);break;case 7:out=NULL;break;case 8:owner=NULL;break;case 9:gen=0;break;case 10:f->s[N-1].bytes=ayatsuri_model_instance_node_bytes(m,N-1)-1;break;case 11:f->s[0].bytes=83;break;case 12:f->s[N-1].data=f->slot[N-1]+1;break;case 13:f->s[N-1].data=NULL;break;case 14:f->s[N-1].data=(void*)(UINTPTR_MAX-7);break;case 15:meta=(void*)(UINTPTR_MAX-7);break;case 16:out=(void*)(UINTPTR_MAX-7);break;case 17:slots=(void*)(UINTPTR_MAX-7);break;case 18:f->s[N-1].data=f->slot[0];break;case 19:f->s[N-1].data=f->slot[0]+80;break;case 20:f->s[N-1].data=f->meta;break;case 21:f->s[N-1].data=&f->m;break;case 22:f->s[N-1].data=f->cold;break;case 23:f->s[N-1].data=&f->i;break;case 24:f->s[N-1].data=f->s;break;case 25:meta=&f->m;break;case 26:meta=f->cold;break;case 27:meta=&f->i;break;case 28:meta=f->s;break;case 29:out=(void*)&f->m;break;case 30:out=(void*)f->cold;break;case 31:out=(void*)f->s;break;case 32:out=(void*)f->slot[0];break;case 33:out=(void*)f->slot[N-1];break;case 34:f->m.node_count=0;break;case 35:f->m.node_count=257;break;case 36:f->m.data=(void*)(UINTPTR_MAX-7);break;case 37:out=(void*)((char*)&f->i+1);break;case 38:f->s[0].data=f->slot[N-1]+8;break;case 39:count=SIZE_MAX;break;}
 memcpy(saved,f,sizeof *f);CHECK(ayatsuri_model_instance_init_segmented(m,meta,mb,slots,count,owner,gen,out)==AYATSURI_MODEL_INVALID);CHECK(!memcmp(saved,f,sizeof *f));free(saved);free(f);
 }
}
static void guards(void){fixture*f=malloc(sizeof*f);CHECK(f);make(f,1);init(f);float cam[9]={0,0,400,0,0,0,1,0,0},light[6]={0,0,1,1,1,1};CHECK(ayatsuri_model_instance_evaluate(&f->i,&f->owner,7,cam,light)==0);
 for(unsigned which=0;which<4;which++){unsigned char before[CAP];void*p=which==3?(void*)(f->meta+ayatsuri_model_instance_metadata_bytes(&f->m)-sizeof(void*)):which==2?(void*)f->meta:(void*)f->slot[which?N-1:0];size_t keepbytes=which==3?sizeof(void*):CAP;memcpy(before,p,keepbytes);uint32_t cursor=0;ayatsuri_model_packet packet;CHECK(ayatsuri_model_instance_node_kind(&f->i,&f->owner,7,0,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_read_pose(&f->i,&f->owner,7,0,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_stats(&f->i,&f->owner,7,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_next(&f->i,&f->owner,7,&cursor,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_next(&f->i,&f->owner,7,p,&packet)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_mesh_view(&f->i,&f->owner,7,3,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_sided_mesh_view(&f->i,&f->owner,7,4,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_world_mesh_view(&f->i,&f->owner,7,3,0,p)==AYATSURI_MODEL_INVALID);CHECK(ayatsuri_model_instance_pixel_mesh_view(&f->i,&f->owner,7,3,0,p)==AYATSURI_MODEL_INVALID);CHECK(!memcmp(before,p,keepbytes));
 uint8_t dirty[N]={0};float pose[N*9]={0};uint32_t color[N]={0};double opacity[N]={0};ayatsuri_model_targets t={dirty,pose,color,opacity,N};ayatsuri_model_instance keep;memcpy(&keep,&f->i,sizeof keep);
 for(unsigned src=0;src<4;src++){ayatsuri_model_targets bad=t;if(src==0)bad.dirty=p;if(src==1)bad.pose=p;if(src==2)bad.color=p;if(src==3)bad.opacity=p;CHECK(ayatsuri_model_instance_targets(&f->i,&f->owner,7,&bad)==AYATSURI_MODEL_INVALID);CHECK(!memcmp(&keep,&f->i,sizeof keep));CHECK(!memcmp(before,p,keepbytes));}
 }
 CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,7)==0);CHECK(ayatsuri_model_instance_dispose(&f->j,&f->owner,7)==0);free(f);}

static void all_slot_rejections(void){
 if(N>55)return;
 fixture*f=malloc(sizeof*f),*saved=malloc(sizeof*saved);CHECK(f&&saved);
 for(unsigned n=0;n<N;n++)for(unsigned type=0;type<9;type++){
 make(f,1);memset(f->meta,0xcc,CAP);memset(f->slot,0xdd,sizeof f->slot);memset(&f->i,0xa5,sizeof f->i);
 switch(type){case 0:f->s[n].bytes=ayatsuri_model_instance_node_bytes(&f->m,n)-1;break;case 1:f->s[n].data=f->slot[n]+1;break;case 2:f->s[n].data=f->meta;break;case 3:f->s[n].data=&f->m;break;case 4:f->s[n].data=f->cold;break;case 5:f->s[n].data=&f->i;break;case 6:f->s[n].data=f->s;break;case 7:f->s[n].data=f->slot[(n+1)%N];break;case 8:f->s[n].data=(void*)(UINTPTR_MAX-7);break;}
 memcpy(saved,f,sizeof*f);CHECK(ayatsuri_model_instance_init_segmented(&f->m,f->meta,CAP,f->s,N,&f->owner,7,&f->i)==AYATSURI_MODEL_INVALID);CHECK(!memcmp(saved,f,sizeof*f));}
 /* Excess capacity is intentionally irrelevant: only used spans are protected. */
 make(f,1);for(unsigned n=0;n<N;n++)f->s[n].bytes=SIZE_MAX;CHECK(ayatsuri_model_instance_init_segmented(&f->m,f->meta,SIZE_MAX,f->s,N,&f->owner,7,&f->i)==0);CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,7)==0);free(saved);free(f);
}

#include "../harness/model_arena_owner.h"
static size_t alloc_calls,fail_call,live,free_calls,requested;
static void *owned_ptrs[N+2];
static void *test_alloc(size_t bytes){alloc_calls++;requested+=bytes;if(alloc_calls==fail_call)return NULL;void*p=malloc(bytes);CHECK(p);memset(p,0xab,bytes);CHECK(live<N+2);owned_ptrs[live++]=p;return p;}
static void test_free(void*p){size_t k=0;while(k<live&&owned_ptrs[k]!=p)k++;CHECK(k<live);owned_ptrs[k]=owned_ptrs[--live];free_calls++;free(p);}
static void allocator(void){fixture*f=malloc(sizeof*f),*snapshot=malloc(sizeof*snapshot);CHECK(f&&snapshot);make(f,1);init(f);memcpy(snapshot,f,sizeof*f);
 for(unsigned failure=1;failure<=N+2;failure++){ayatsuri_model_instance output,before;memset(&output,0x35,sizeof output);memcpy(&before,&output,sizeof output);alloc_calls=free_calls=requested=0;fail_call=failure;CHECK(live==0);model_arena_owner*o=model_arena_owner_create(&f->m,&f->owner,7,&output,test_alloc,test_free);CHECK(!o&&alloc_calls==failure&&free_calls==failure-1&&live==0);CHECK(!memcmp(&output,&before,sizeof output));CHECK(!memcmp(f,snapshot,sizeof*f));}
 for(unsigned invalid=0;invalid<2;invalid++){ayatsuri_model_instance output,before;memset(&output,0x35,sizeof output);memcpy(&before,&output,sizeof output);alloc_calls=free_calls=requested=fail_call=0;model_arena_owner*o=model_arena_owner_create(&f->m,invalid?NULL:&f->owner,invalid?7:0,&output,test_alloc,test_free);CHECK(!o&&live==0&&alloc_calls==N+2&&free_calls==N+2);CHECK(!memcmp(&output,&before,sizeof output));CHECK(!memcmp(f,snapshot,sizeof*f));}
 ayatsuri_model_instance output;alloc_calls=free_calls=requested=fail_call=0;model_arena_owner*o=model_arena_owner_create(&f->m,&f->owner,7,&output,test_alloc,test_free);CHECK(o&&alloc_calls==N+2&&live==N+2);CHECK(requested==sizeof(model_arena_owner)+N*sizeof(ayatsuri_model_node_storage)+o->payload_bytes);CHECK(ayatsuri_model_instance_dispose(&output,&f->owner,7)==0);memset(o->metadata,0xff,o->metadata_bytes); /* release does not walk copied instance table */
 model_arena_owner_release(&o,test_free);CHECK(!o&&live==0&&free_calls==N+2);model_arena_owner_release(&o,test_free);CHECK(free_calls==N+2);CHECK(!memcmp(f,snapshot,sizeof*f));CHECK(ayatsuri_model_instance_dispose(&f->i,&f->owner,7)==0);CHECK(ayatsuri_model_instance_dispose(&f->j,&f->owner,7)==0);free(snapshot);free(f);
}
int main(void){negative();all_slot_rejections();parity(1);parity(0);guards();allocator();printf("SEGMENTED_INDEPENDENT_PASS nodes=%u checks=%u rejection_cases=%u allocation_failure_points=%u mixed_and_mesh_only=2\n",N,checks,40+(N<=55?9*N:0),N+2);}

