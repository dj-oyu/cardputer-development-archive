#define _POSIX_C_SOURCE 200809L
/* Isolated host lifecycle harness. Production/model/raster/lighting code is unchanged.
 * Raw outputs are private diagnostics, never public deliverables. No source geometry
 * is embedded here. A frame owns its snapshot and retained scene bindings; it does
 * not retain any borrowed instance patch/depth pointers. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include "pixel_binding.h"
#include "pixel_transport.h"
#include "ground_input.h"
#include "expected_counts.h"
#define HASH_START UINT64_C(14695981039346656037)
#define SNAPSHOT_CAP 65536u
#define WORK_CAP 8000000u
#define OWNED_RESERVED_CAP (2u*(65536u+524288u+262144u))
static const char *pose_names[4]={"identity","yaw-plus","yaw-minus","return-identity"};
static const char *error_gate="unspecified";
static unsigned long long ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (unsigned long long)t.tv_sec*1000000000ull+t.tv_nsec;}
static uint64_t digest_bytes(uint64_t h,const void *p,size_t n){const uint8_t *b=p;for(size_t i=0;i<n;i++){h^=b[i];h*=UINT64_C(1099511628211);}return h;}
static bool reject(const char *s){error_gate=s;return false;}
#define REQUIRE(x,s) do {if(!(x))return reject(s);}while(0)
static int fail(void){fprintf(stderr,"NATIVE_GATE:%s\n",error_gate);return 2;}
static bool load_disk(const char *path,FoxDiskScene *out){
 FILE *f=path?fopen(path,"r"):NULL;if(!f)return false;char magic[10]={0};FoxDiskLightInput lights[3];memset(lights,0,sizeof lights);double world[3],strength;int ok=fscanf(f,"%9s",magic)==1&&!strcmp(magic,"FOXDISK1");
 for(unsigned j=0;ok&&j<3;j++){lights[j].shape=FOX_DISK_SHAPE_DISK;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].center[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].rotation_xyz[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].color[k])==1;if(ok)ok=fscanf(f,"%lf %lf",&lights[j].power,&lights[j].diameter)==2;}
 for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",world+k)==1;if(ok)ok=fscanf(f,"%lf",&strength)==1;char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=0;fclose(f);return ok&&fox_disk_scene_init(out,lights,world,strength)==FOX_DISK_OK;
}
typedef struct {
 unsigned pose_index;float yaw;uint32_t epoch;vis_generation generation;bounce_generation tgen;
 uint64_t geometry_hash,material_hash,position_hash,normal_hash,index_hash,snapshot_hash;
 size_t snapshot_bytes,scene_bytes,scene_nodes,transport_bytes,temporary_bytes,transport_temp;
 size_t mode4bytes,mode5bytes,canonical_bytes;
 unsigned logical_meshes,records,work,mode4,mode5,eligible_packets,ineligible_packets,eligible_vertices,ineligible_vertices;
 unsigned all_normal_pairs,all_nonpairs;size_t pair_checks;
 double max_height,max_radius,max_pair,max_rotation,max_normal_rotation;
 bool identity_geometry_exact,identity_attributes_exact,identity_normals_exact;
 unsigned long long evaluate_ns,append_ns,build_ns,transport_build_ns;
 ayatsuri_model_stats model_stats;
} frame_meta;
typedef struct {
 uint8_t *payload;ksn_mesh_pixel_snapshot px;fox_pixel_binding binding;fox_transport_context tx;
 vis_budget direct,transport;frame_meta meta;bool owned,ready;
} frame_set;
typedef struct {unsigned phase,pose;uint32_t before,after;ayatsuri_model_stats stats;} evaluation_event;
typedef struct {
 ayatsuri_model model;ayatsuri_model_instance instance;uint8_t *cold;void *arena;size_t cold_bytes,arena_bytes;int owner;
 float camera[9],light[6],yaw[4];bool reverse,admission_only,dump_geometry,disposed;
 const char *prefix,*control_prefix;FoxDiskScene disks;fox_ground_input groundinput;bounce_ground ground;
 double *reference_xyz;uint32_t *reference_tri;bounce_triangle *reference_attr;int16_t *reference_normals;
 size_t nv,nt,comparison_bytes;uint64_t next_token;unsigned owned_sets,peak_owned_sets,builds,releases;
 size_t peak_owned_used,tracked_owned_bytes,peak_tracked_heap;unsigned invalid_batches,stale_before,stale_after,disposed_view_rejections;
 unsigned failed_builds,release_noops,provenance_rejections,lowlevel_rejections,stale_generation_rejections;
 unsigned init_calls,dispose_calls,target_calls,evaluate_calls,phase,event_count;bool admission_complete;
 evaluation_event events[8];
 unsigned frames;vis_counters total_direct,total_transport;uint64_t total_render_ns;
 frame_meta admission[4];
} app;
typedef struct {ksn_mesh_pixel_stats stats;unsigned long long render_ns;uint64_t rgb_hash,depth_hash;bool rendered;} render_result;
static bool env_fixed(const char *name,const char *required){const char *v=getenv(name);return !v||!strcmp(v,required);}
static bool path(char out[4096],const app *a,const char *label,const char *suffix){return snprintf(out,4096,"%s.%s%s",a->prefix,label,suffix)>0&&strlen(out)<4095;}
static bool write_bytes(const char *name,const void *data,size_t n){FILE *f=fopen(name,"wb");if(!f)return false;bool ok=fwrite(data,1,n,f)==n;if(fclose(f))ok=false;return ok;}
static void observe_heap(app *a,size_t construction_scratch){size_t n=a->tracked_owned_bytes+a->comparison_bytes+construction_scratch+(a->cold?a->cold_bytes:0)+(a->arena?a->arena_bytes:0);if(n>a->peak_tracked_heap)a->peak_tracked_heap=n;}
static void frame_release(app *a,frame_set *s){
 if(!s->owned){a->release_noops++;return;}
 bounce_binding_clear(&s->tx.binding);fox_pixel_unbind(&s->binding);
 if(s->payload){memset(s->payload,0xa5,SNAPSHOT_CAP);free(s->payload);}
 a->tracked_owned_bytes-=SNAPSHOT_CAP+s->meta.scene_bytes+s->meta.transport_bytes;memset(s,0,sizeof *s);a->owned_sets--;a->releases++;
}
static size_t owned_used(const frame_set *s){return s->owned?SNAPSHOT_CAP+s->meta.scene_bytes+s->meta.transport_bytes:0;}
static bool packet_ids(app *a,uint16_t ids[256],unsigned *count){
 uint32_t cursor=0;ayatsuri_model_packet p;ayatsuri_model_status rc;*count=0;
 while((rc=ayatsuri_model_instance_next(&a->instance,&a->owner,1,&cursor,&p))==AYATSURI_MODEL_OK){REQUIRE(*count<256&&(p.kind==4||p.kind==5),"mesh-only");ids[(*count)++]=p.node_id;}
 REQUIRE(rc==AYATSURI_MODEL_DONE&&*count,"empty");return true;
}
static bool stale_views(app *a,uint32_t epoch,unsigned *counter){
 ayatsuri_model_world_mesh_view w,ws;ayatsuri_model_pixel_mesh_view p,ps;
 memset(&ws,0xa5,sizeof ws);memset(&ps,0xa5,sizeof ps);w=ws;p=ps;
 ayatsuri_model_instance before=a->instance;
 REQUIRE(ayatsuri_model_instance_world_mesh_view(&a->instance,&a->owner,1,1,epoch,&w)==AYATSURI_MODEL_STATE&&!memcmp(&w,&ws,sizeof w),"stale-world-view-rejection");
 REQUIRE(ayatsuri_model_instance_pixel_mesh_view(&a->instance,&a->owner,1,1,epoch,&p)==AYATSURI_MODEL_STATE&&!memcmp(&p,&ps,sizeof p),"stale-pixel-view-rejection");
 REQUIRE(!memcmp(&before,&a->instance,sizeof before),"stale-view-instance-atomicity");(*counter)++;return true;
}
static bool targets_evaluate(app *a,unsigned pose_index,frame_meta *m){
 uint8_t dirty[256]={0};float poses[256*9]={0};uint32_t color[256]={0};double opacity[256]={0};
 dirty[0]=AYATSURI_TARGET_POSITION|AYATSURI_TARGET_ROTATION|AYATSURI_TARGET_SCALE;
 poses[4]=a->yaw[pose_index];poses[6]=poses[7]=poses[8]=1;
 ayatsuri_model_targets t={dirty,poses,color,opacity,a->model.node_count};uint32_t old=a->instance.mutation_epoch;
 a->target_calls++;unsigned long long begin=ns();REQUIRE(ayatsuri_model_instance_targets(&a->instance,&a->owner,1,&t)==AYATSURI_MODEL_OK,"root-targets");
 bool changed=old!=a->instance.mutation_epoch;if(changed)REQUIRE(stale_views(a,old,&a->stale_before),error_gate);
 a->evaluate_calls++;REQUIRE(ayatsuri_model_instance_evaluate(&a->instance,&a->owner,1,a->camera,a->light)==AYATSURI_MODEL_OK,"evaluate");
 if(changed)REQUIRE(stale_views(a,old,&a->stale_after),error_gate);
 memset(m,0,sizeof *m);m->pose_index=pose_index;m->yaw=a->yaw[pose_index];m->epoch=a->instance.mutation_epoch;m->evaluate_ns=ns()-begin;
 REQUIRE(ayatsuri_model_instance_stats(&a->instance,&a->owner,1,&m->model_stats)==AYATSURI_MODEL_OK,"model-stats");
 REQUIRE(a->event_count<8,"event-cap");a->events[a->event_count++]=(evaluation_event){a->phase,pose_index,old,m->epoch,m->model_stats};
 return true;
}
static bool invalid_target_fixture(app *a){
 uint8_t dirty[256]={0};float poses[256*9]={0};uint32_t color[256]={0};double opacity[256]={0};
 dirty[0]=AYATSURI_TARGET_ROTATION;poses[4]=a->yaw[1];dirty[1]=AYATSURI_TARGET_SCALE; /* Invalid later row must not partly apply root yaw. */
 ayatsuri_model_targets t={dirty,poses,color,opacity,a->model.node_count};
 void *saved=malloc(a->arena_bytes);REQUIRE(saved,"invalid-batch-fixture-memory");memcpy(saved,a->arena,a->arena_bytes);observe_heap(a,a->arena_bytes);ayatsuri_model_instance before=a->instance;
 bool ok=ayatsuri_model_instance_targets(&a->instance,&a->owner,1,&t)==AYATSURI_MODEL_INVALID&&!memcmp(saved,a->arena,a->arena_bytes)&&!memcmp(&before,&a->instance,sizeof before);
 memset(saved,0xa5,a->arena_bytes);free(saved);REQUIRE(ok,"invalid-batch-atomicity");a->invalid_batches++;return true;
}
static bool geometry_metrics(app *a,frame_meta *m,const double *xyz,const uint32_t *tri,const bounce_triangle *attr,const int16_t *normals){
 m->position_hash=digest_bytes(HASH_START,xyz,FOX_EXPECTED_VERTICES*3*sizeof *xyz);
 m->normal_hash=digest_bytes(HASH_START,normals,FOX_EXPECTED_VERTICES*6*sizeof *normals);
 m->index_hash=digest_bytes(HASH_START,tri,FOX_EXPECTED_TRIANGLES*3*sizeof *tri);
 m->geometry_hash=digest_bytes(HASH_START,xyz,a->nv*3*sizeof *xyz);m->geometry_hash=digest_bytes(m->geometry_hash,tri,a->nt*3*sizeof *tri);
 m->material_hash=digest_bytes(HASH_START,attr,a->nt*sizeof *attr);
 if(!a->reference_xyz){
  a->reference_xyz=malloc(a->nv*3*sizeof *xyz);a->reference_tri=malloc(a->nt*3*sizeof *tri);a->reference_attr=malloc(a->nt*sizeof *attr);a->reference_normals=malloc(FOX_EXPECTED_VERTICES*6*sizeof *normals);
  REQUIRE(a->reference_xyz&&a->reference_tri&&a->reference_attr&&a->reference_normals,"comparison-memory");
  memcpy(a->reference_xyz,xyz,a->nv*3*sizeof *xyz);memcpy(a->reference_tri,tri,a->nt*3*sizeof *tri);memcpy(a->reference_attr,attr,a->nt*sizeof *attr);memcpy(a->reference_normals,normals,FOX_EXPECTED_VERTICES*6*sizeof *normals);
  a->comparison_bytes=a->nv*3*sizeof *xyz+a->nt*3*sizeof *tri+a->nt*sizeof *attr+FOX_EXPECTED_VERTICES*6*sizeof *normals;
 }
 REQUIRE(!memcmp(a->reference_tri,tri,a->nt*3*sizeof *tri),"root-indices-changed");
 m->identity_geometry_exact=!memcmp(a->reference_xyz,xyz,a->nv*3*sizeof *xyz);
 m->identity_attributes_exact=!memcmp(a->reference_attr,attr,a->nt*sizeof *attr);
 m->identity_normals_exact=!memcmp(a->reference_normals,normals,FOX_EXPECTED_VERTICES*6*sizeof *normals);
 double c=cos((double)m->yaw),s=sin((double)m->yaw);
 for(size_t i=0;i<FOX_EXPECTED_VERTICES;i++){
  const double *r=a->reference_xyz+3*i,*v=xyz+3*i;
  m->max_height=fmax(m->max_height,fabs(r[2]-v[2]));m->max_radius=fmax(m->max_radius,fabs(hypot(r[0],r[1])-hypot(v[0],v[1])));
  double want[3]={c*r[0]-s*r[1],s*r[0]+c*r[1],r[2]};for(unsigned k=0;k<3;k++)m->max_rotation=fmax(m->max_rotation,fabs(v[k]-want[k]));
  for(unsigned side=0;side<2;side++){const int16_t *rn=a->reference_normals+6*i+3*side,*vn=normals+6*i+3*side;double wn[3]={c*rn[0]-s*rn[1],s*rn[0]+c*rn[1],rn[2]};for(unsigned k=0;k<3;k++)m->max_normal_rotation=fmax(m->max_normal_rotation,fabs(vn[k]-wn[k])/32767.0);}
  for(size_t j=0;j<i;j++){const double *q=a->reference_xyz+3*j,*w=xyz+3*j;double d0=0,d1=0;for(unsigned k=0;k<3;k++){d0+=(r[k]-q[k])*(r[k]-q[k]);d1+=(v[k]-w[k])*(v[k]-w[k]);}m->max_pair=fmax(m->max_pair,fabs(sqrt(d0)-sqrt(d1)));m->pair_checks++;}
 }
 if(m->pose_index==0||m->pose_index==3)REQUIRE(m->identity_geometry_exact&&m->identity_attributes_exact&&m->identity_normals_exact,"identity-return-arrays");
 REQUIRE(!memcmp(xyz+FOX_EXPECTED_VERTICES*3,a->reference_xyz+FOX_EXPECTED_VERTICES*3,4*3*sizeof *xyz),"ground-moved");
 return true;
}
static bool private_geometry(app *a,const frame_meta *m,const double *xyz,const uint32_t *tri,const bounce_triangle *attr,const int16_t *normals){
 if(!a->dump_geometry)return true;char p[4096];const char *label=pose_names[m->pose_index];
 REQUIRE(path(p,a,label,".geometry.f64le")&&write_bytes(p,xyz,a->nv*3*sizeof *xyz),"private-geometry-write");
 REQUIRE(path(p,a,label,".indices.u32le")&&write_bytes(p,tri,a->nt*3*sizeof *tri),"private-indices-write");
 REQUIRE(path(p,a,label,".normals.i16le")&&write_bytes(p,normals,FOX_EXPECTED_VERTICES*6*sizeof *normals),"private-normal-write");
 REQUIRE(path(p,a,label,".attributes.bin")&&write_bytes(p,attr,a->nt*sizeof *attr),"private-attributes-write");return true;
}
static bool frame_build(app *a,frame_set *s,const frame_meta *evaluated,bool inject_failure){
 REQUIRE(!s->owned&&a->owned_sets<2,"owned-set-cap");s->payload=malloc(SNAPSHOT_CAP);REQUIRE(s->payload,"snapshot-memory");s->owned=true;a->owned_sets++;a->tracked_owned_bytes+=SNAPSHOT_CAP;observe_heap(a,0);if(a->owned_sets>a->peak_owned_sets)a->peak_owned_sets=a->owned_sets;s->meta=*evaluated;
 frame_meta *m=&s->meta;uint64_t token=++a->next_token;m->generation=(vis_generation){token+1,token,1};m->tgen=(bounce_generation){.visibility=m->generation,.material=token,.emission=1};
 unsigned long long begin=ns();REQUIRE(ksn_mesh_pixel_begin(&s->px,s->payload,SNAPSHOT_CAP,&a->disks,WORK_CAP),"pixel-begin");
 uint16_t ids[256];unsigned count=0;REQUIRE(packet_ids(a,ids,&count),error_gate);m->logical_meshes=count;
 size_t nv=0,nt=0;for(unsigned id=0;id<a->model.node_count;id++){uint8_t kind;REQUIRE(ayatsuri_model_instance_node_kind(&a->instance,&a->owner,1,id,&kind)==AYATSURI_MODEL_OK,"node-kind");if(kind!=3)continue;ayatsuri_model_world_mesh_view v;REQUIRE(ayatsuri_model_instance_world_mesh_view(&a->instance,&a->owner,1,id,m->epoch,&v)==AYATSURI_MODEL_OK,"world-view-count");nv+=v.vertex_count;nt+=v.triangle_count;}
 REQUIRE(nv==FOX_EXPECTED_VERTICES&&nt==FOX_EXPECTED_TRIANGLES,"whole-geometry-count");a->nv=nv+4;a->nt=nt+2;
 double *xyz=malloc(a->nv*3*sizeof *xyz);uint32_t *tri=malloc(a->nt*3*sizeof *tri);bounce_triangle *attr=calloc(a->nt,sizeof *attr);int16_t *normals=malloc(nv*6*sizeof *normals);
 if(!xyz||!tri||!attr||!normals){free(xyz);free(tri);free(attr);free(normals);return reject("geometry-memory");}
 bool ok=false;vis_scene *geometry=NULL;bounce_scene *transport=NULL;nv=nt=0;
#define BUILD_REQUIRE(x,msg) do {if(!(x)){error_gate=msg;goto cleanup;}}while(0)
 unsigned long long build_start=ns();
 for(unsigned id=0;id<a->model.node_count;id++){
  uint8_t kind;BUILD_REQUIRE(ayatsuri_model_instance_node_kind(&a->instance,&a->owner,1,id,&kind)==AYATSURI_MODEL_OK,"node-kind-fill");if(kind!=3)continue;
  ayatsuri_model_world_mesh_view v;ayatsuri_model_pixel_mesh_view raw;
  BUILD_REQUIRE(ayatsuri_model_instance_world_mesh_view(&a->instance,&a->owner,1,id,m->epoch,&v)==AYATSURI_MODEL_OK&&ayatsuri_model_instance_pixel_mesh_view(&a->instance,&a->owner,1,id,m->epoch,&raw)==AYATSURI_MODEL_OK,"world-view-fill");
  for(unsigned j=0;j<v.vertex_count;j++){
   BUILD_REQUIRE(!memcmp(v.world[j],raw.vertices[j].world,3*sizeof(double)),"world-pixel-parity");
   xyz[3*(nv+j)]=v.world[j][0]/38;xyz[3*(nv+j)+1]=-v.world[j][2]/38;xyz[3*(nv+j)+2]=-v.world[j][1]/38;
   const co_pixel_vertex *p=raw.vertices+j;int16_t *n=normals+6*(nv+j);n[0]=p->normal_front[0];n[1]=-p->normal_front[2];n[2]=-p->normal_front[1];n[3]=p->normal_back[0];n[4]=-p->normal_back[2];n[5]=-p->normal_back[1];
   bool pair=true;for(unsigned k=0;k<3;k++)pair&=(int32_t)p->normal_back[k]==-(int32_t)p->normal_front[k];if(pair)m->all_normal_pairs++;else m->all_nonpairs++;
  }
  for(unsigned j=0;j<3*v.triangle_count;j++)tri[3*nt+j]=(uint32_t)nv+v.indices[j];
  for(unsigned t=0;t<v.triangle_count;t++){bounce_triangle *b=attr+nt+t;b->double_sided=v.double_sided;for(unsigned j=0;j<3;j++){unsigned vi=v.indices[3*t+j];const co_pixel_vertex *f=raw.vertices+vi;bounce_vertex *vtx=b->v+j;vtx->mask=f->front.mask;vtx->a565=f->front.color_a;vtx->b565=f->front.color_b;memcpy(vtx->front,normals+6*(nv+vi),3*sizeof(int16_t));memcpy(vtx->back,normals+6*(nv+vi)+3,3*sizeof(int16_t));}}
  nv+=v.vertex_count;nt+=v.triangle_count;
 }
 BUILD_REQUIRE(nv==FOX_EXPECTED_VERTICES&&nt==FOX_EXPECTED_TRIANGLES,"whole-geometry-filled");
 memcpy(xyz+3*nv,a->groundinput.world,sizeof a->groundinput.world);for(unsigned j=0;j<6;j++)tri[3*nt+j]=(uint32_t)nv+a->groundinput.indices[j];
 for(unsigned t=0;t<2;t++){bounce_triangle *b=attr+nt+t;b->double_sided=1;for(unsigned j=0;j<3;j++){b->v[j].front[2]=32767;b->v[j].back[2]=-32767;}}nv+=4;nt+=2;
 BUILD_REQUIRE(geometry_metrics(a,m,xyz,tri,attr,normals),error_gate);
 BUILD_REQUIRE(vis_scene_build(&geometry,xyz,nv,tri,nt,m->generation,(vis_limits){2048,4095,524288})==VIS_OK,"bvh-build");
 BUILD_REQUIRE(!vis_scene_overlaps(geometry,xyz,nv*3*sizeof *xyz)&&!vis_scene_overlaps(geometry,tri,nt*3*sizeof *tri),"geometry-owned-alias");
 m->scene_bytes=vis_scene_bytes(geometry);a->tracked_owned_bytes+=m->scene_bytes;observe_heap(a,a->nv*3*sizeof(double)+a->nt*3*sizeof(uint32_t)+a->nt*sizeof(bounce_triangle)+FOX_EXPECTED_VERTICES*6*sizeof(int16_t));m->scene_nodes=vis_scene_node_count(geometry);m->build_ns=ns()-build_start;
 m->temporary_bytes=nv*3*sizeof(double)+nt*3*sizeof(uint32_t);m->transport_temp=nt*sizeof(bounce_triangle);
 if(inject_failure){error_gate="injected-current-build-after-visibility";goto cleanup;}
 unsigned long long tb=ns();BUILD_REQUIRE(bounce_scene_build_ground(&transport,geometry,attr,nt,&a->disks,-1,m->tgen,262144,&a->ground)==BOUNCE_OK,"transport-build");
 BUILD_REQUIRE(!bounce_scene_overlaps(transport,attr,nt*sizeof *attr)&&!bounce_scene_overlaps(transport,&a->disks,sizeof a->disks)&&!bounce_scene_overlaps(transport,&a->ground,sizeof a->ground),"transport-owned-alias");
 m->transport_bytes=bounce_scene_bytes(transport);a->tracked_owned_bytes+=m->transport_bytes;observe_heap(a,a->nv*3*sizeof(double)+a->nt*3*sizeof(uint32_t)+a->nt*sizeof(bounce_triangle)+FOX_EXPECTED_VERTICES*6*sizeof(int16_t));m->transport_build_ns=ns()-tb;
 BUILD_REQUIRE(m->transport_bytes==bounce_scene_required_bytes(nt)&&bounce_scene_matches_ground(transport,&a->ground)&&bounce_scene_matches_lights(transport,&a->disks),"transport-owned-inputs");
 for(unsigned at=0;at<count;at++){
  unsigned index=a->reverse?count-1-at:at;ayatsuri_model_pixel_mesh_view raw;ksn_proc_gouraud_patch patch;uint8_t bits[8]={0};
  BUILD_REQUIRE(ayatsuri_model_instance_pixel_mesh_view(&a->instance,&a->owner,1,ids[index],m->epoch,&raw)==AYATSURI_MODEL_OK,"pixel-view");memcpy(&patch,raw.patch,sizeof patch);memcpy(bits,raw.back_faces,8);
  bool used[32]={0};for(unsigned j=0;j<3u*patch.header.triangles;j++)used[patch.indices[j]]=true;bool packet_pair=true;
  for(unsigned j=0;j<patch.header.vertices;j++)if(used[j]){bool pair=true;for(unsigned k=0;k<3;k++)pair&=(int32_t)raw.vertices[j].normal_back[k]==-(int32_t)raw.vertices[j].normal_front[k];if(pair)m->eligible_vertices++;else{m->ineligible_vertices++;packet_pair=false;}}
  if(packet_pair)m->eligible_packets++;else m->ineligible_packets++;
  if(a->reverse){uint8_t rb[8]={0};for(unsigned t=0;t<patch.header.triangles;t++)if(bits[t/8]&(1u<<(t%8))){unsigned q=patch.header.triangles-1-t;rb[q/8]|=1u<<(q%8);}memcpy(bits,rb,8);for(unsigned x=0,y=patch.header.triangles?patch.header.triangles-1:0;x<y;x++,y--)for(unsigned k=0;k<3;k++){uint16_t q=patch.indices[3*x+k];patch.indices[3*x+k]=patch.indices[3*y+k];patch.indices[3*y+k]=q;}}
  BUILD_REQUIRE(ksn_mesh_pixel_append_normal_pair(&s->px,&patch,raw.vertices,bits,ids[index]),"append");
 }
 m->canonical_bytes=416;for(size_t offset=0;offset<s->px.mesh.packets.size;){co_view v;BUILD_REQUIRE(co_read(s->px.mesh.packets.data+offset,s->px.mesh.packets.size-offset,&v),"codec-parse");if(v.mode==4){m->mode4++;m->mode4bytes+=v.size;}else if(v.mode==5){m->mode5++;m->mode5bytes+=v.size;}else BUILD_REQUIRE(false,"codec-mode");m->canonical_bytes+=(12u+56u*v.vertex_count+3u*v.triangle_count+(v.triangle_count+7u)/8u+3u)&~(size_t)3u;offset+=v.size;}
 m->records=s->px.mesh.packets.packets;m->work=s->px.mesh.work;m->snapshot_bytes=416+s->px.mesh.packets.size;m->snapshot_hash=digest_bytes(HASH_START,s->payload,m->snapshot_bytes);
 BUILD_REQUIRE(m->mode5==m->eligible_packets&&m->mode4==m->ineligible_packets,"codec-eligibility-parity");
 /* Correspondence here is established from the same evaluated epoch and copied
  * arrays, then recorded as content fingerprints. Low-level bind is not an
  * authenticator for independently supplied geometry. */
 BUILD_REQUIRE(fox_pixel_bind(&s->binding,geometry,m->generation,&s->px)==VIS_OK,"visibility-bind");
 s->tx.snapshot_binding=&s->binding;s->tx.expected=m->tgen;s->tx.ground=a->ground;s->tx.mode=BOUNCE_ONE;s->tx.outer=s->tx.inner=16;s->tx.direct_budget=&s->direct;s->tx.transport_budget=&s->transport;
 BUILD_REQUIRE(bounce_binding_set(&s->tx.binding,transport,m->tgen)==BOUNCE_OK,"transport-bind");
 BUILD_REQUIRE(s->binding.snapshot_hash==m->snapshot_hash&&s->binding.snapshot_bytes==m->snapshot_bytes,"content-bind");
 BUILD_REQUIRE(private_geometry(a,m,xyz,tri,attr,normals),error_gate);s->ready=true;m->append_ns=ns()-begin;a->builds++;ok=true;
cleanup:
 if(!ok){m->snapshot_bytes=416+s->px.mesh.packets.size;m->work=s->px.mesh.work;m->records=s->px.mesh.packets.packets;}
 if(transport)bounce_scene_release(transport);if(geometry)vis_scene_release(geometry);
 if(!ok){if(!s->binding.scene.scene){a->tracked_owned_bytes-=m->scene_bytes;m->scene_bytes=0;}if(!s->tx.binding.scene){a->tracked_owned_bytes-=m->transport_bytes;m->transport_bytes=0;}}
 memset(xyz,0xa5,a->nv*3*sizeof *xyz);memset(tri,0xa5,a->nt*3*sizeof *tri);memset(attr,0xa5,a->nt*sizeof *attr);memset(normals,0xa5,FOX_EXPECTED_VERTICES*6*sizeof *normals);free(xyz);free(tri);free(attr);free(normals);
#undef BUILD_REQUIRE
 return ok;
}
static bool provenance_matches(const frame_set *context,const frame_set *source){
 /* This adapter rejects old provenance even when identity-return bytes happen to
  * equal old bytes. The renderer itself authenticates neither origin nor epoch. */
 return context&&source&&context->ready&&source->ready&&context->meta.generation.geometry==source->meta.generation.geometry&&context->meta.generation.pose==source->meta.generation.pose&&context->meta.generation.light==source->meta.generation.light&&context->meta.tgen.material==source->meta.tgen.material&&context->meta.tgen.emission==source->meta.tgen.emission&&context->meta.geometry_hash==source->meta.geometry_hash&&context->meta.material_hash==source->meta.material_hash&&context->meta.snapshot_hash==source->meta.snapshot_hash&&fox_pixel_binding_matches(&context->binding,context->meta.generation,&source->px);
}
static void reset_frame(frame_set *s){s->direct=(vis_budget){.limit={1000000,100000000,50000000}};s->transport=(vis_budget){.limit={20000000,800000000,300000000}};memset(&s->tx.counters,0,sizeof s->tx.counters);}
static bool mismatch_fixture(app *a,frame_set *current,frame_set *initial){
 REQUIRE(provenance_matches(current,current)&&provenance_matches(initial,initial),"own-provenance");REQUIRE(!provenance_matches(current,initial),"old-provenance-not-rejected");a->provenance_rejections++;
 if(current->meta.snapshot_hash!=initial->meta.snapshot_hash){
  reset_frame(current);uint16_t color[240*8],saved_color[240*8];float depth[240*8],saved_depth[240*8];ksn_mesh_pixel_stats stats,saved_stats;memset(color,0xa5,sizeof color);memcpy(saved_color,color,sizeof color);memset(depth,0xa5,sizeof depth);memcpy(saved_depth,depth,sizeof depth);memset(&stats,0xa5,sizeof stats);saved_stats=stats;fox_transport_context tx=current->tx;vis_budget direct=current->direct,transport=current->transport;
  REQUIRE(!fox_transport_render(&current->tx,&initial->px,color,0,1,depth,8,&stats),"old-snapshot-bound-render-not-rejected");
  REQUIRE(!memcmp(color,saved_color,sizeof color)&&!memcmp(depth,saved_depth,sizeof depth)&&!memcmp(&stats,&saved_stats,sizeof stats)&&!memcmp(&tx,&current->tx,sizeof tx)&&!memcmp(&direct,&current->direct,sizeof direct)&&!memcmp(&transport,&current->transport,sizeof transport),"mismatch-published-state");a->lowlevel_rejections++;
 }
 {
  reset_frame(current);uint16_t color[240*8],saved_color[240*8];float depth[240*8],saved_depth[240*8];ksn_mesh_pixel_stats stats,saved_stats;memset(color,0xa5,sizeof color);memcpy(saved_color,color,sizeof color);memset(depth,0xa5,sizeof depth);memcpy(saved_depth,depth,sizeof depth);memset(&stats,0xa5,sizeof stats);saved_stats=stats;fox_transport_context stale=current->tx;stale.expected=initial->meta.tgen;fox_transport_context before=stale;vis_budget direct=current->direct,transport=current->transport;
  REQUIRE(!fox_transport_render(&stale,&current->px,color,0,1,depth,8,&stats),"stale-generation-render-not-rejected");
  REQUIRE(!memcmp(color,saved_color,sizeof color)&&!memcmp(depth,saved_depth,sizeof depth)&&!memcmp(&stats,&saved_stats,sizeof stats)&&!memcmp(&before,&stale,sizeof stale)&&!memcmp(&direct,&current->direct,sizeof direct)&&!memcmp(&transport,&current->transport,sizeof transport),"stale-generation-published-state");a->stale_generation_rejections++;
 }
 return true;
}
static bool same_admission(const frame_meta *a,const frame_meta *b){return a->geometry_hash==b->geometry_hash&&a->material_hash==b->material_hash&&a->position_hash==b->position_hash&&a->normal_hash==b->normal_hash&&a->snapshot_hash==b->snapshot_hash&&a->snapshot_bytes==b->snapshot_bytes&&a->work==b->work;}
static void json_meta(FILE *f,const app *a,const frame_set *set,const frame_meta *m,const render_result *r){
 const bool rendered=r&&r->rendered;const vis_budget zero={0};const bounce_counters counters={0};const vis_budget *d=set?&set->direct:&zero,*t=set?&set->transport:&zero;const bounce_counters *c=set?&set->tx.counters:&counters;
 fprintf(f,"{\"pose\":\"%s\",\"poseIndex\":%u,\"yawRadiansFloat\":%.17g,\"mutationEpoch\":%u,\"rendered\":%s,\"sourceMaterialConstantsUnchanged\":true,\"worldNormalAttributesRegenerated\":true,\"aaEnabled\":false,",pose_names[m->pose_index],m->pose_index,(double)m->yaw,m->epoch,rendered?"true":"false");
 fprintf(f,"\"normalPairCodecEnabled\":true,\"normalPairMode4Records\":%u,\"normalPairMode5Records\":%u,\"normalPairMode4Bytes\":%zu,\"normalPairMode5Bytes\":%zu,\"normalPairFallbackMode4Records\":%u,\"normalPairFallbackMode4Bytes\":%zu,\"normalPairSavedBytes\":%zu,\"normalPairEligiblePackets\":%u,\"normalPairIneligiblePackets\":%u,\"normalPairEligibleUsedVertices\":%u,\"normalPairIneligibleUsedVertices\":%u,\"allWorldNormalPairVertices\":%u,\"allWorldNonPairVertices\":%u,",m->mode4,m->mode5,m->mode4bytes,m->mode5bytes,m->mode4,m->mode4bytes,m->canonical_bytes-m->snapshot_bytes,m->eligible_packets,m->ineligible_packets,m->eligible_vertices,m->ineligible_vertices,m->all_normal_pairs,m->all_nonpairs);
 fprintf(f,"\"sourceWorldPositionFingerprint\":\"%016llx\",\"sourceNormalFingerprint\":\"%016llx\",\"sourceIndexFingerprint\":\"%016llx\",\"sourceVertexCount\":%u,\"sourceTriangleCount\":%u,\"residualCoordinateUnits\":\"source units after inverse native B / 38\",\"normalResidualUnits\":\"SNORM / 32767\",\"maxSourceHeightDelta\":%.17g,\"maxRootRadiusDelta\":%.17g,\"maxPairDistanceDelta\":%.17g,\"maxRootRotationResidual\":%.17g,\"maxNormalRotationResidual\":%.17g,\"pairDistancesChecked\":%zu,\"identityGeometryExact\":%s,\"identityAttributesExact\":%s,\"identityNormalsExact\":%s,",(unsigned long long)m->position_hash,(unsigned long long)m->normal_hash,(unsigned long long)m->index_hash,FOX_EXPECTED_VERTICES,FOX_EXPECTED_TRIANGLES,m->max_height,m->max_radius,m->max_pair,m->max_rotation,m->max_normal_rotation,m->pair_checks,m->identity_geometry_exact?"true":"false",m->identity_attributes_exact?"true":"false",m->identity_normals_exact?"true":"false");
 fprintf(f,"\"transportMode\":2,\"transportComplete\":%s,\"outerSamples\":16,\"innerSamples\":16,\"materialGeneration\":%llu,\"materialFingerprint\":\"%016llx\",\"transportSceneBytes\":%zu,\"transportTemporaryBytes\":%zu,\"transportContextBytes\":%zu,\"transportBudgetBytes\":%zu,\"transportBuildNs\":%llu,\"transportRays\":%llu,\"transportNodeVisits\":%llu,\"transportTriangleTests\":%llu,\"transportRayLimit\":20000000,\"transportNodeLimit\":800000000,\"transportTriangleLimit\":300000000,\"transportSceneLimit\":262144,",rendered?"true":"false",(unsigned long long)m->tgen.material,(unsigned long long)m->material_hash,m->transport_bytes,m->transport_temp,sizeof(fox_transport_context),sizeof(vis_budget),m->transport_build_ns,(unsigned long long)t->used.rays,(unsigned long long)t->used.node_visits,(unsigned long long)t->used.triangle_tests);
#define COUNT(name) fprintf(f,"\"" #name "\":%llu,",(unsigned long long)c->name);
 COUNT(primary_ground_hits) COUNT(primary_ground_emission_hits) COUNT(secondary_ground_hits) COUNT(primary_rays) COUNT(primary_hits) COUNT(primary_misses) COUNT(secondary_world_rays) COUNT(primary_direct_queries) COUNT(secondary_direct_queries) COUNT(zero_reflection_ns_v) COUNT(back_single_discard) COUNT(grazing_ng_v)
#undef COUNT
 fprintf(f,"\"groundMode\":2,\"groundObjectId\":1,\"groundFirstTriangle\":%u,\"groundTriangleCount\":2,\"emissionGeneration\":1,\"groundLe\":[%.17g,%.17g,%.17g],\"groundInputFingerprint\":\"%016llx\",",FOX_EXPECTED_TRIANGLES,a->ground.le[0],a->ground.le[1],a->ground.le[2],(unsigned long long)a->groundinput.fingerprint);
 fprintf(f,"\"visibilityGeneration\":[%llu,%llu,%llu],\"visibilityGeometryFingerprint\":\"%016llx\",\"visibilitySnapshotFingerprint\":\"%016llx\",\"visibilityBindingBytes\":%zu,\"visibilityBudgetBytes\":%zu,\"visibilityEnabled\":true,\"visibilityComplete\":%s,\"visibilitySceneBytes\":%zu,\"visibilitySceneNodes\":%zu,\"visibilityTriangles\":%zu,\"visibilityVertices\":%zu,\"visibilityBuildNs\":%llu,\"visibilityTemporaryBytes\":%zu,\"visibilityRays\":%llu,\"visibilityNodeVisits\":%llu,\"visibilityTriangleTests\":%llu,\"visibilityRayLimit\":1000000,\"visibilityNodeLimit\":100000000,\"visibilityTriangleLimit\":50000000,\"visibilitySceneLimit\":524288,",(unsigned long long)m->generation.geometry,(unsigned long long)m->generation.pose,(unsigned long long)m->generation.light,(unsigned long long)m->geometry_hash,(unsigned long long)m->snapshot_hash,sizeof(fox_pixel_binding),sizeof(vis_budget),rendered?"true":"false",m->scene_bytes,m->scene_nodes,a->nt,a->nv,m->build_ns,m->temporary_bytes,(unsigned long long)d->used.rays,(unsigned long long)d->used.node_visits,(unsigned long long)d->used.triangle_tests);
 fprintf(f,"\"pixelLightEnabled\":true,\"agxProfileEnabled\":false,\"shadeUpdates\":%llu,\"diskSamples\":%llu,\"snapshotControlBytes\":%zu,\"rawFieldScratchBytes\":%zu,\"appendNs\":%llu,\"physicalDiskEnabled\":true,\"linearLightEnabled\":true,\"instanceControlBytes\":%zu,\"records\":%u,\"logicalMeshes\":%u,\"evaluateNs\":%llu,\"camera\":[",(unsigned long long)(r?r->stats.shade_updates:0),(unsigned long long)(r?r->stats.disk_samples:0),sizeof(ksn_mesh_pixel_snapshot),sizeof(ayatsuri_model_pixel_mesh_view),m->append_ns,sizeof(ayatsuri_model_instance),m->records,m->logical_meshes,m->evaluate_ns);
 for(unsigned i=0;i<9;i++)fprintf(f,"%s%.9g",i?",":"",a->camera[i]);fprintf(f,"],\"light\":[");for(unsigned i=0;i<6;i++)fprintf(f,"%s%.9g",i?",":"",a->light[i]);
 fprintf(f,"],\"coldBytes\":%zu,\"arenaBytes64bit\":%zu,\"snapshotBytes\":%zu,\"work\":%u,\"workLimit\":8000000,\"hostRenderNsFirstFrame\":%llu,\"depthScratchBytes\":7680,\"colorBandBytes\":3840,\"snapshotCapacity\":65536,\"disposedBeforeRender\":%s,\"reverse\":%s,\"rgbFingerprint\":\"%016llx\",\"depthFingerprint\":\"%016llx\",\"modelStats\":{\"eval_calls\":%u,\"geometry_updates\":%u,\"projection_updates\":%u,\"shade_updates\":%u,\"target_changed\":%u,\"init_copy_bytes\":%u,\"target_copy_bytes\":%u}}",a->cold_bytes,a->arena_bytes,m->snapshot_bytes,m->work,r?r->render_ns:0,a->disposed?"true":"false",a->reverse?"true":"false",(unsigned long long)(r?r->rgb_hash:0),(unsigned long long)(r?r->depth_hash:0),m->model_stats.eval_calls,m->model_stats.geometry_updates,m->model_stats.projection_updates,m->model_stats.shade_updates,m->model_stats.target_changed,m->model_stats.init_copy_bytes,m->model_stats.target_copy_bytes);
}
static bool files_equal(const char *a,const char *b){FILE *f=fopen(a,"rb"),*g=fopen(b,"rb");if(!f||!g){if(f)fclose(f);if(g)fclose(g);return false;}uint8_t x[4096],y[4096];bool ok=true;for(;;){size_t n=fread(x,1,sizeof x,f),m=fread(y,1,sizeof y,g);if(n!=m||memcmp(x,y,n)){ok=false;break;}if(n<sizeof x){if(ferror(f)||ferror(g))ok=false;break;}}fclose(f);fclose(g);return ok;}
static bool compare_frame_files(const app *a,const char *left,const char *right){const char *suffix[]={".u16le",".f32le",".snapshot"};char p[4096],q[4096];for(unsigned k=0;k<3;k++)REQUIRE(path(p,a,left,suffix[k])&&path(q,a,right,suffix[k])&&files_equal(p,q),"identity-return-or-replay-file-mismatch");return true;}
static bool compare_frozen_control(const app *a){
 const char *suffix[]={".u16le",".f32le",".snapshot"};char p[4096],q[4096];for(unsigned k=0;k<3;k++){int n=snprintf(q,sizeof q,"%s%s",a->control_prefix,suffix[k]);REQUIRE(n>0&&(size_t)n<sizeof q&&path(p,a,"identity",suffix[k])&&files_equal(p,q),"initial-frozen-control-mismatch-before-rotated-render");}return true;
}
static bool render_frame(app *a,frame_set *s,const char *label,render_result *r){
 REQUIRE(provenance_matches(s,s),"render-provenance");reset_frame(s);memset(r,0,sizeof *r);r->rgb_hash=r->depth_hash=HASH_START;
 char colorpath[4096],depthpath[4096],colortmp[4096],depthtmp[4096],snapshot[4096],metapath[4096];
 REQUIRE(path(colorpath,a,label,".u16le")&&path(depthpath,a,label,".f32le")&&path(colortmp,a,label,".u16le.partial")&&path(depthtmp,a,label,".f32le.partial")&&path(snapshot,a,label,".snapshot")&&path(metapath,a,label,".json"),"output-path");
 FILE *c=fopen(colortmp,"wb"),*d=fopen(depthtmp,"wb");if(!c||!d){if(c)fclose(c);if(d)fclose(d);remove(colortmp);remove(depthtmp);return reject("output");}
 bool ok=true;uint16_t color[240*8];float z[240*8];
 for(unsigned y=0;ok&&y<135;y+=8){unsigned h=135-y<8?135-y:8;memset(color,0,sizeof color);unsigned long long begin=ns();if(!fox_transport_render(&s->tx,&s->px,color,y,h,z,8,&r->stats)){error_gate="render";ok=false;break;}r->render_ns+=ns()-begin;for(unsigned j=0;j<240*h;j++)if(isnan(z[j])||z[j]==INFINITY){error_gate="nonfinite-depth";ok=false;break;}if(!ok)break;r->rgb_hash=digest_bytes(r->rgb_hash,color,240*h*sizeof *color);r->depth_hash=digest_bytes(r->depth_hash,z,240*h*sizeof *z);if(fwrite(color,2,240*h,c)!=240*h||fwrite(z,4,240*h,d)!=240*h){error_gate="write";ok=false;}}
 int color_close=fclose(c),depth_close=fclose(d);if(color_close||depth_close){error_gate="close";ok=false;}
 if(!ok){remove(colortmp);remove(depthtmp);fprintf(stderr,"NATIVE_USED_COUNTERS:{\"visibilityRays\":%llu,\"visibilityNodeVisits\":%llu,\"visibilityTriangleTests\":%llu,\"transportRays\":%llu,\"transportNodeVisits\":%llu,\"transportTriangleTests\":%llu}\n",(unsigned long long)s->direct.used.rays,(unsigned long long)s->direct.used.node_visits,(unsigned long long)s->direct.used.triangle_tests,(unsigned long long)s->transport.used.rays,(unsigned long long)s->transport.used.node_visits,(unsigned long long)s->transport.used.triangle_tests);return false;}
 REQUIRE(write_bytes(snapshot,s->payload,s->meta.snapshot_bytes),"snapshot-write");REQUIRE(!rename(colortmp,colorpath)&&!rename(depthtmp,depthpath),"publish-frame");r->rendered=true;
 FILE *meta=fopen(metapath,"w");REQUIRE(meta,"metadata-open");json_meta(meta,a,s,&s->meta,r);fputc('\n',meta);REQUIRE(!fclose(meta),"metadata-close");
 a->frames++;a->total_render_ns+=r->render_ns;
#define ADD_TOTAL(group,field) a->total_##group.field+=s->group.used.field
 ADD_TOTAL(direct,rays);ADD_TOTAL(direct,node_visits);ADD_TOTAL(direct,triangle_tests);ADD_TOTAL(transport,rays);ADD_TOTAL(transport,node_visits);ADD_TOTAL(transport,triangle_tests);
#undef ADD_TOTAL
 return true;
}
static void json_summary(FILE *f,const app *a,bool complete){
 fprintf(f,"{\"admissionComplete\":true,\"chainComplete\":%s,\"renderedFrames\":%u,\"singlePersistentInstance\":true,\"preflightUsesSameInstance\":true,\"fixedYawDegrees\":[0,15,-15,0],\"coordinatePivot\":\"world/source origin\",\"ownedSetLimit\":2,\"peakOwnedSets\":%u,\"ownedReservedLimitBytes\":%u,\"peakOwnedReservedBytes\":%u,\"peakOwnedUsedBytes\":%zu,\"peakTrackedHeapBytes\":%zu,\"trackedHeapExcludes\":\"allocator overhead, stack, FILE runtime buffers\",\"baselineComparisonScratchBytes\":%zu,\"normalCaptureScratchBytes\":%zu,\"frameSetControlBytes\":%zu,\"twoFrameSetControlBytes\":%zu,\"modelColdBytes\":%zu,\"modelArenaBytes\":%zu,\"invalidBatchFixtureScratchBytes\":%zu,\"invalidBatchAtomicityChecks\":%u,\"staleEpochBeforeEvaluateChecks\":%u,\"staleEpochAfterEvaluateChecks\":%u,\"disposedViewRejections\":%u,\"injectedCurrentBuildFailures\":%u,\"idempotentReleaseNoops\":%u,\"ownedBuilds\":%u,\"ownedReleases\":%u,\"provenanceMismatchRejections\":%u,\"lowLevelDistinctSnapshotRejections\":%u,\"noStaleBorrowReads\":true,\"initialRetainedAcrossDisposal\":%s,\"initialReplayExact\":%s,\"identityReturnArraysExact\":true,\"identityReturnPixelsExact\":%s,\"privateGeometryDumped\":%s,\"totalRenderNs\":%llu,\"experimentTotalsNotPerFrameBudget\":true,\"totalVisibilityRays\":%llu,\"totalVisibilityNodeVisits\":%llu,\"totalVisibilityTriangleTests\":%llu,\"totalTransportRays\":%llu,\"totalTransportNodeVisits\":%llu,\"totalTransportTriangleTests\":%llu,\"poses\":[",complete?"true":"false",a->frames,a->peak_owned_sets,OWNED_RESERVED_CAP,a->peak_owned_sets*(65536u+524288u+262144u),a->peak_owned_used,a->peak_tracked_heap,a->comparison_bytes,(size_t)FOX_EXPECTED_VERTICES*6*sizeof(int16_t),sizeof(frame_set),2*sizeof(frame_set),a->cold_bytes,a->arena_bytes,a->arena_bytes,a->invalid_batches,a->stale_before,a->stale_after,a->disposed_view_rejections,a->failed_builds,a->release_noops,a->builds,a->releases,a->provenance_rejections,a->lowlevel_rejections,a->disposed?"true":"false",complete?"true":"false",complete?"true":"false",a->dump_geometry?"true":"false",(unsigned long long)a->total_render_ns,(unsigned long long)a->total_direct.rays,(unsigned long long)a->total_direct.node_visits,(unsigned long long)a->total_direct.triangle_tests,(unsigned long long)a->total_transport.rays,(unsigned long long)a->total_transport.node_visits,(unsigned long long)a->total_transport.triangle_tests);
 for(unsigned i=0;i<4;i++){if(i)fputc(',',f);json_meta(f,a,NULL,a->admission+i,NULL);}fprintf(f,"],\"initCount\":%u,\"disposeCount\":%u,\"validTargetCallCount\":%u,\"evaluateCallCount\":%u,\"lowLevelStaleGenerationRejections\":%u,\"evaluationSequence\":[",a->init_calls,a->dispose_calls,a->target_calls,a->evaluate_calls,a->stale_generation_rejections);
 for(unsigned i=0;i<a->event_count;i++){const evaluation_event *e=a->events+i;fprintf(f,"%s{\"phase\":\"%s\",\"pose\":\"%s\",\"epochBeforeTarget\":%u,\"epochAfterEvaluate\":%u,\"evalCalls\":%u,\"geometryUpdates\":%u,\"projectionUpdates\":%u,\"shadeUpdates\":%u,\"targetChanged\":%u,\"targetCopyBytes\":%u}",i?",":"",e->phase?"render":"admission",pose_names[e->pose],e->before,e->after,e->stats.eval_calls,e->stats.geometry_updates,e->stats.projection_updates,e->stats.shade_updates,e->stats.target_changed,e->stats.target_copy_bytes);}fprintf(f,"]}\n");
}
static bool save_summary(const app *a,const char *label,bool complete){char p[4096];REQUIRE(path(p,a,label,".json"),"summary-path");FILE *f=fopen(p,"w");REQUIRE(f,"summary-open");json_summary(f,a,complete);REQUIRE(!fclose(f),"summary-close");return true;}
static bool dispose_input(app *a){REQUIRE(ayatsuri_model_instance_dispose(&a->instance,&a->owner,1)==AYATSURI_MODEL_OK,"dispose");a->dispose_calls++;REQUIRE(stale_views(a,a->instance.mutation_epoch,&a->disposed_view_rejections),error_gate);memset(a->arena,0xa5,a->arena_bytes);memset(a->cold,0xa5,a->cold_bytes);free(a->arena);free(a->cold);a->arena=NULL;a->cold=NULL;memset(&a->model,0xa5,sizeof a->model);a->disposed=true;return true;}
static bool initialize(app *a,int argc,char **argv){
 REQUIRE(argc==19,"arguments: model outputprefix reverse camera9 light6");a->prefix=argv[2];REQUIRE(!strcmp(argv[3],"0")||!strcmp(argv[3],"1"),"reverse-argument");a->reverse=atoi(argv[3]);
 for(unsigned i=0;i<9;i++){char *end;a->camera[i]=strtof(argv[4+i],&end);REQUIRE(!*end&&isfinite(a->camera[i]),"camera-argument");}for(unsigned i=0;i<6;i++){char *end;a->light[i]=strtof(argv[13+i],&end);REQUIRE(!*end&&isfinite(a->light[i]),"light-argument");}
 const char *names[]={"HONE_NORMAL_PAIR_CODEC","HONE_LINEAR_LIGHT","HONE_PIXEL_LIGHT","HONE_PIXEL_VISIBILITY","HONE_PHYSICAL_LIGHT","HONE_GROUND_MODE","HONE_TRANSPORT_MODE","HONE_OUTER_SAMPLES"};const char *values[]={"1","1","1","1","1","2","2","16"};for(unsigned i=0;i<8;i++)REQUIRE(env_fixed(names[i],values[i]),"fixed-policy-env");
 REQUIRE(env_fixed("HONE_AA_MODE","0")&&env_fixed("HONE_AA","0")&&env_fixed("HONE_BOUNDARY_AA","0"),"aa-off-required");
 const char *ad=getenv("HONE_ROOT_ADMISSION_ONLY"),*dump=getenv("HONE_ROOT_DUMP_GEOMETRY");REQUIRE(!ad||!strcmp(ad,"0")||!strcmp(ad,"1"),"admission-mode");REQUIRE(!dump||!strcmp(dump,"0")||!strcmp(dump,"1"),"geometry-dump-mode");a->admission_only=ad&&!strcmp(ad,"1");a->dump_geometry=dump&&!strcmp(dump,"1");a->control_prefix=getenv("HONE_ROOT_CONTROL_PREFIX");REQUIRE(a->admission_only||(a->control_prefix&&a->control_prefix[0]),"render-control-prefix-required");
 REQUIRE(load_disk(getenv("HONE_DISK_FILE"),&a->disks),"disk-input");REQUIRE(fox_ground_load(getenv("HONE_GROUND_FILE"),&a->groundinput),"ground-input");a->ground=(bounce_ground){.mode=BOUNCE_GROUND_PRIMARY_LE,.object_id=1,.first_triangle=FOX_EXPECTED_TRIANGLES,.triangle_count=2};memcpy(a->ground.le,a->groundinput.le,sizeof a->ground.le);
 FILE *f=fopen(argv[1],"rb");REQUIRE(f,"model-input");if(fseek(f,0,SEEK_END)){fclose(f);return reject("model-seek");}long bytes=ftell(f);rewind(f);if(bytes<1||bytes>1048576){fclose(f);return reject("model-size");}a->cold_bytes=(size_t)bytes;a->cold=malloc(a->cold_bytes);if(!a->cold||fread(a->cold,1,a->cold_bytes,f)!=a->cold_bytes){fclose(f);return reject("model-read");}fclose(f);
 REQUIRE(ayatsuri_model_open(a->cold,a->cold_bytes,&a->model)==AYATSURI_MODEL_OK,"model-open");a->arena_bytes=ayatsuri_model_instance_bytes(&a->model);a->arena=malloc(a->arena_bytes);REQUIRE(a->arena,"arena-memory");
 REQUIRE(ayatsuri_model_instance_init(&a->model,a->arena,a->arena_bytes,&a->owner,1,&a->instance)==AYATSURI_MODEL_OK&&ayatsuri_model_instance_linear_light(&a->instance,&a->owner,1,1)==AYATSURI_MODEL_OK&&ayatsuri_model_instance_disk_scene(&a->instance,&a->owner,1,&a->disks)==AYATSURI_MODEL_OK,"instance-init");a->init_calls++;
 uint8_t root_kind;float root_pose[9];REQUIRE(ayatsuri_model_instance_node_kind(&a->instance,&a->owner,1,0,&root_kind)==AYATSURI_MODEL_OK&&root_kind==0&&ayatsuri_model_instance_read_pose(&a->instance,&a->owner,1,0,root_pose)==AYATSURI_MODEL_OK,"root-node");for(unsigned k=0;k<9;k++)REQUIRE(root_pose[k]==(k>=6?1:0),"root-not-initial-identity");
 const double pi=3.14159265358979323846264338327950288;a->yaw[0]=a->yaw[3]=0;a->yaw[1]=(float)(pi/12.0);a->yaw[2]=(float)(-pi/12.0);return true;
}
static bool experiment(app *a,frame_set *initial,frame_set *current){
 frame_meta m;REQUIRE(targets_evaluate(a,0,&m)&&frame_build(a,initial,&m,false),error_gate);a->admission[0]=initial->meta;REQUIRE(invalid_target_fixture(a),error_gate);
 /* Fail a separate candidate after owned visibility allocation. Original set is
  * never used as the replacement slot, and releasing candidate twice is safe. */
 bool built=frame_build(a,current,&m,true);REQUIRE(!built&&!strcmp(error_gate,"injected-current-build-after-visibility"),"failure-injection-did-not-fail");a->failed_builds++;frame_release(a,current);frame_release(a,current);REQUIRE(a->owned_sets==1&&provenance_matches(initial,initial),"retained-initial-after-failed-build");
 for(unsigned pose=1;pose<4;pose++){
  REQUIRE(targets_evaluate(a,pose,&m)&&frame_build(a,current,&m,false),error_gate);a->admission[pose]=current->meta;size_t used=owned_used(initial)+owned_used(current);if(used>a->peak_owned_used)a->peak_owned_used=used;
  REQUIRE(mismatch_fixture(a,current,initial),error_gate);if(pose==3)REQUIRE(initial->meta.snapshot_bytes==current->meta.snapshot_bytes&&!memcmp(initial->payload,current->payload,current->meta.snapshot_bytes),"admission-identity-snapshot");
  frame_release(a,current);
 }
 a->admission_complete=true;REQUIRE(save_summary(a,"admission",false),error_gate);
 if(a->admission_only){REQUIRE(dispose_input(a),error_gate);REQUIRE(provenance_matches(initial,initial)&&bounce_scene_matches_ground(initial->tx.binding.scene,&initial->tx.ground),"admission-owned-after-disposal");frame_release(a,initial);frame_release(a,initial);REQUIRE(a->owned_sets==0,"admission-owned-leak");REQUIRE(save_summary(a,"admission",false),error_gate);json_summary(stdout,a,false);return true;}
 a->phase=1;render_result r;REQUIRE(render_frame(a,initial,"identity",&r),error_gate);REQUIRE(compare_frozen_control(a),error_gate);
 for(unsigned pose=1;pose<4;pose++){
  REQUIRE(targets_evaluate(a,pose,&m)&&frame_build(a,current,&m,false),error_gate);REQUIRE(same_admission(&current->meta,a->admission+pose),"admission-render-content-drift");size_t used=owned_used(initial)+owned_used(current);if(used>a->peak_owned_used)a->peak_owned_used=used;REQUIRE(mismatch_fixture(a,current,initial),error_gate);
  if(pose==3)REQUIRE(initial->meta.snapshot_bytes==current->meta.snapshot_bytes&&!memcmp(initial->payload,current->payload,current->meta.snapshot_bytes),"render-identity-snapshot");
  REQUIRE(render_frame(a,current,pose_names[pose],&r),error_gate);if(pose==3)REQUIRE(compare_frame_files(a,"identity","return-identity"),error_gate);frame_release(a,current);
 }
 REQUIRE(dispose_input(a),error_gate);/* Poison original light/ground inputs too; immutable binding/context copies remain. */
 memset(&a->disks,0xa5,sizeof a->disks);memset(a->groundinput.world,0xa5,sizeof a->groundinput.world);memset(a->groundinput.indices,0xa5,sizeof a->groundinput.indices);
 REQUIRE(provenance_matches(initial,initial)&&bounce_scene_matches_ground(initial->tx.binding.scene,&initial->tx.ground),"owned-after-disposal");REQUIRE(render_frame(a,initial,"old-replay",&r)&&compare_frame_files(a,"identity","old-replay"),error_gate);
 frame_release(a,initial);frame_release(a,initial);REQUIRE(a->owned_sets==0,"owned-leak");REQUIRE(save_summary(a,"chain",true),error_gate);json_summary(stdout,a,true);return true;
}
static void save_failure(const app *a,const frame_set *initial,const frame_set *current){
 if(!a->prefix)return;char p[4096];if(!path(p,a,"failure",".json"))return;FILE *f=fopen(p,"w");if(!f)return;const frame_set *s=current->owned?current:initial;
 fprintf(f,"{\"admissionComplete\":%s,\"chainComplete\":false,\"renderedFrames\":%u,\"gate\":\"%s\",\"attemptedPose\":\"%s\",\"snapshotBytesAtFailure\":%zu,\"workAtFailure\":%u,\"ownedSetsAtFailure\":%u,\"partialFramePublished\":false}\n",a->admission_complete?"true":"false",a->frames,error_gate,pose_names[s->meta.pose_index<4?s->meta.pose_index:0],s->meta.snapshot_bytes,s->meta.work,a->owned_sets);fclose(f);
}
int main(int argc,char **argv){
 app a={0};frame_set initial={0},current={0};bool ok=initialize(&a,argc,argv)&&experiment(&a,&initial,&current);if(!ok)save_failure(&a,&initial,&current);
 if(current.owned)frame_release(&a,&current);if(initial.owned)frame_release(&a,&initial);if(a.instance.alive){ayatsuri_model_status status=ayatsuri_model_instance_dispose(&a.instance,&a.owner,1);if(status!=AYATSURI_MODEL_OK){error_gate="failure-cleanup-dispose";ok=false;}else a.dispose_calls++;}if(a.arena){memset(a.arena,0xa5,a.arena_bytes);free(a.arena);}if(a.cold){memset(a.cold,0xa5,a.cold_bytes);free(a.cold);}free(a.reference_xyz);free(a.reference_tri);free(a.reference_attr);free(a.reference_normals);return ok?0:fail();
}
