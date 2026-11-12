#define _POSIX_C_SOURCE 200809L
/* Host adapter only: production model evaluator, owned snapshot and raster unchanged. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <sys/stat.h>
#include <errno.h>
static unsigned long long ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (unsigned long long)t.tv_sec*1000000000ull+t.tv_nsec;}
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include "pixel_binding.h"
#include "pixel_transport.h"
#include "ground_input.h"
#include "expected_counts.h"
#include "aa_adapter.h"
#include "floor_input.h"
#include "floor_adapter.h"
#include "floor_world_adapter.h"
#ifdef ROW_HDR_OBSERVER
#include "hdr_observer.h"
#endif
#include "row_transport_bridge.h"
#include "depth_band_alloc.h"
#include "background_input.h"
#include "scene_core_input.h"
static const fox_bg_fixed_input*bg_select_input(const float cam[9],unsigned ci,bool reverse,uint64_t snapshot){
 const fox_bg_fixed_input*found=NULL;for(unsigned i=0;i<20;i++){const fox_bg_fixed_input*r=&fox_bg_inputs[i];if(r->case_index!=ci||r->reverse!=(unsigned)reverse||r->snapshot!=snapshot)continue;bool same=true;for(unsigned k=0;k<9;k++)if((double)cam[k]!=r->camera[k])same=false;if(same){if(found)return NULL;found=r;}}return found;
}

static bool bg_write_report(const char*prefix,unsigned arm,const fox_bg_fixed_input*fixed,const fox_bg_context*context,const fox_bg_work*w,const vis_budget*b,const KsnSceneReport*r,size_t scene_bytes,unsigned long long build_ns,bool complete){
 char path[4096];snprintf(path,sizeof path,"%s.background.json",prefix);FILE*f=fopen(path,"wx");if(!f)return false;const fox_bg_counters*c=&(*context).counters;
 fprintf(f,"{\"version\":\"host-camera-floor-composition-v1\",\"complete\":%s,\"arm\":\"%s\",\"caseIndex\":%u,\"viewIndex\":%u,\"reverse\":%s,\"snapshotFingerprint\":\"%016llx\",\"inputJSONSHA256\":\"%s\",\"oldWork8MCompatible\":false,\"oldDirect1MCompatible\":false,\"characterDepthRetained\":%s,\"sourceGeometryUnchanged\":true,\"backgroundQueries\":%llu,\"backgroundNodeVisits\":%llu,\"backgroundTriangleTests\":%llu,\"backgroundRayLimit\":2000000,\"backgroundNodeLimit\":200000000,\"backgroundTriangleLimit\":100000000,\"backgroundSceneBytes\":%zu,\"backgroundContextBytes\":%zu,\"backgroundWorkBytes\":%zu,\"privateResultBytes\":%zu,\"coreResultBytes\":%zu,\"coreQueryBytes\":%zu,\"coreReportBytes\":%zu,\"backgroundOwnedBytes\":%zu,\"backgroundOwnedLimit\":16384,\"backgroundAdditionalNamedStackLimit\":4096,\"backgroundBuildNs\":%llu,\"observerEvents\":%llu,",complete?"true":"false",arm==2?"background":"on",fixed->case_index,fixed->view_index,fixed->reverse?"true":"false",(unsigned long long)fixed->snapshot,FOX_BG_INPUT_JSON_SHA256,arm==2?"false":"true",(unsigned long long)b->used.rays,(unsigned long long)b->used.node_visits,(unsigned long long)b->used.triangle_tests,scene_bytes,sizeof (*context),sizeof*w,sizeof(fox_bg_result),sizeof(KsnSceneResult),sizeof(KsnSceneQuery),sizeof*r,fox_bg_context_owned_bytes(&(*context))+0,build_ns,(unsigned long long)0);
 fprintf(f,"\"generation\":{\"geometry\":%llu,\"pose\":%llu,\"visibilityLight\":%llu,\"camera\":%llu,\"material\":%llu,\"emission\":%llu,\"illumination\":%llu},",(unsigned long long)(*context).binding.expected.visibility.geometry,(unsigned long long)(*context).binding.expected.visibility.pose,(unsigned long long)(*context).binding.expected.visibility.light,(unsigned long long)(*context).binding.expected.camera,(unsigned long long)(*context).binding.expected.material,(unsigned long long)(*context).binding.expected.emission,(unsigned long long)(*context).binding.expected.illumination);
 fprintf(f,"\"resolver\":{\"limit\":%llu,\"used\":%llu,\"slotLimit\":%llu,\"shadeLimit\":%llu,\"slots\":%llu,\"floorEvaluations\":%llu,\"worldMisses\":%llu,\"categories\":{",(unsigned long long)w->limit_total,(unsigned long long)w->used_total,(unsigned long long)w->slot_limit,(unsigned long long)w->shade_limit,(unsigned long long)w->slots,(unsigned long long)w->floor_evaluations,(unsigned long long)w->world_misses);
 for(unsigned i=0;i<BGW_COUNT;i++)fprintf(f,"%s\"%s\":{\"limit\":%llu,\"used\":%llu}",i?",":"",fox_bg_work_category_name(i),(unsigned long long)w->limit[i],(unsigned long long)w->used[i]);
 fprintf(f,"}},\"classification\":{\"slots\":%llu,\"keep\":%llu,\"floor\":%llu,\"world\":%llu,\"parallel\":%llu,\"negativeT\":%llu,\"outside\":%llu,\"clip\":%llu,\"positiveQueries\":%llu,\"blockedQueries\":%llu},",(unsigned long long)c->slots,(unsigned long long)c->keep,(unsigned long long)c->floor,(unsigned long long)c->world,(unsigned long long)c->parallel,(unsigned long long)c->negative_t,(unsigned long long)c->outside,(unsigned long long)c->clip,(unsigned long long)c->positive_queries,(unsigned long long)c->blocked_queries);
 fprintf(f,"\"core\":{\"complete\":%s,\"reservedTotal\":%llu,\"observedTotal\":%llu,\"hardLimit\":1680000,\"queries\":%llu,\"centers\":%llu,\"quarters\":%llu,\"kept\":%llu,\"floor\":%llu,\"world\":%llu,\"occludedCharacter\":%llu,\"failedCategory\":%u,\"descriptorFingerprintExecuted\":%s,\"categories\":{",r->complete?"true":"false",(unsigned long long)r->reserved_total,(unsigned long long)r->observed_total,(unsigned long long)r->queries,(unsigned long long)r->centers,(unsigned long long)r->quarters,(unsigned long long)r->kept,(unsigned long long)r->floor,(unsigned long long)r->world,(unsigned long long)r->occluded_character,r->failed_category,r->descriptor_fingerprint_executed?"true":"false");
 for(unsigned i=0;i<SC_CATEGORY_COUNT;i++)fprintf(f,"%s\"%s\":{\"reserved\":%llu,\"observed\":%llu}",i?",":"",ksn_scene_category_name(i),(unsigned long long)r->reserved.value[i],(unsigned long long)r->observed.value[i]);
 fputs("}},",f);size_t peak=fox_bg_context_owned_bytes(&(*context))+0+sizeof(KsnSceneBinding)+sizeof(KsnSceneLedger)+sizeof(KsnSceneReport)+sizeof(fox_bg_input)+4050;fprintf(f,"\"backgroundNewOwnedConservativePeakBytes\":%zu,\"maskConstructionBytesReserved\":4050,\"inputConstructionBytesReserved\":%zu,\"wholeFrameBufferAtomic\":false}\n",peak,sizeof(fox_bg_input));bool ok=peak<=16384;return fclose(f)==0&&ok;
}

static uint64_t digest_bytes(uint64_t h,const void *p,size_t n){const uint8_t *b=p;for(size_t i=0;i<n;i++){h^=b[i];h*=UINT64_C(1099511628211);}return h;}
static int fail(const char *s){fprintf(stderr,"NATIVE_GATE:%s\n",s);return 2;}
static int fail_render(const vis_budget *direct,const vis_budget *transport,const bounce_counters *c){
 fprintf(stderr,"NATIVE_USED_COUNTERS:{\"visibilityRays\":%llu,\"visibilityNodeVisits\":%llu,\"visibilityTriangleTests\":%llu,\"transportRays\":%llu,\"transportNodeVisits\":%llu,\"transportTriangleTests\":%llu,\"primary_ground_hits\":%llu,\"primary_ground_emission_hits\":%llu,\"secondary_ground_hits\":%llu}\n",(unsigned long long)direct->used.rays,(unsigned long long)direct->used.node_visits,(unsigned long long)direct->used.triangle_tests,(unsigned long long)transport->used.rays,(unsigned long long)transport->used.node_visits,(unsigned long long)transport->used.triangle_tests,(unsigned long long)c->primary_ground_hits,(unsigned long long)c->primary_ground_emission_hits,(unsigned long long)c->secondary_ground_hits);
 return fail("render");
}
static int load_disk(const char *path,FoxDiskScene *out){
 FILE *f=fopen(path,"r");if(!f)return 0;char magic[10]={0};FoxDiskLightInput lights[3];memset(lights,0,sizeof lights);double world[3],strength;int ok=fscanf(f,"%9s",magic)==1&&!strcmp(magic,"FOXDISK1");
 for(unsigned j=0;ok&&j<3;j++){lights[j].shape=FOX_DISK_SHAPE_DISK;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].center[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].rotation_xyz[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].color[k])==1;if(ok)ok=fscanf(f,"%lf %lf",&lights[j].power,&lights[j].diameter)==2;}
 for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",world+k)==1;if(ok)ok=fscanf(f,"%lf",&strength)==1;char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=0;fclose(f);return ok&&fox_disk_scene_init(out,lights,world,strength)==FOX_DISK_OK;
}
/* A fresh prefix is private staging. Never overwrite prior result artifacts. */
static int reserve_prefix(const char*prefix){
 const char*suffix[]={".snapshot",".u16le",".f32le",".targets.u8",".aa.json",".floor.json",".background.json",".row.json",".json",".floor-world.json",".hdr.f64le",".hdr-observer.json"};char p[4096];struct stat st;
 for(unsigned i=0;i<sizeof suffix/sizeof*suffix;i++){if(snprintf(p,sizeof p,"%s%s",prefix,suffix[i])>=(int)sizeof p)return 0;if(lstat(p,&st)==0||errno!=ENOENT)return 0;}
 if(snprintf(p,sizeof p,"%s.row-reservation",prefix)>=(int)sizeof p)return 0;
 return mkdir(p,0700)==0;
}
int main(int argc,char **argv){
 if(argc!=19)return fail("arguments: model color depth reverse camera9 light6");
 if(!reserve_prefix(argv[2]))return fail("fresh-private-prefix-required");
 float cam[9],light[6];for(int i=0;i<9;i++)cam[i]=strtof(argv[4+i],NULL);for(int i=0;i<6;i++)light[i]=strtof(argv[13+i],NULL);
 FILE *f=fopen(argv[1],"rb");if(!f)return fail("input");fseek(f,0,SEEK_END);long bytes=ftell(f);rewind(f);if(bytes<1||bytes>1048576)return fail("size");
 uint8_t *data=malloc((size_t)bytes);if(!data||fread(data,1,(size_t)bytes,f)!=(size_t)bytes)return fail("read");fclose(f);
 ayatsuri_model m;if(ayatsuri_model_open(data,(size_t)bytes,&m))return fail("model");
 size_t ab=ayatsuri_model_instance_bytes(&m);void *arena=malloc(ab);int owner=0;ayatsuri_model_instance ins;
 unsigned long long eval_start=ns();
 const char *np=getenv("HONE_NORMAL_PAIR_CODEC");bool normal_pair=np&&!strcmp(np,"1");if(np&&strcmp(np,"0")&&strcmp(np,"1"))return fail("normal-pair-mode");
 const char *mode=getenv("HONE_LINEAR_LIGHT");unsigned enabled=mode&&strcmp(mode,"1")==0;
 if(mode&&strcmp(mode,"0")&&strcmp(mode,"1"))return fail("linear-mode");
 const char *tm=getenv("HONE_TRANSPORT_MODE");unsigned transportmode=tm?(unsigned)strtoul(tm,NULL,10):0;if(tm&&strcmp(tm,"0")&&strcmp(tm,"1")&&strcmp(tm,"2"))return fail("transport-mode");
 unsigned outer=16,inner=16;const char *os=getenv("HONE_OUTER_SAMPLES");if(os){if(strcmp(os,"16")&&strcmp(os,"64"))return fail("outer-samples");outer=(unsigned)atoi(os);}
 const char *vm=getenv("HONE_PIXEL_VISIBILITY");bool visibility=vm&&!strcmp(vm,"1");if(vm&&strcmp(vm,"0")&&strcmp(vm,"1"))return fail("visibility-mode");
 const char *gm=getenv("HONE_GROUND_MODE");if(gm&&strcmp(gm,"0")&&strcmp(gm,"1")&&strcmp(gm,"2"))return fail("ground-mode");unsigned groundmode=gm?(unsigned)(gm[0]-'0'):0;
 const char *fr=getenv("HONE_FLOOR_REFLECTION");if(!fr||(strcmp(fr,"off")&&strcmp(fr,"zero")&&strcmp(fr,"on")))return fail("floor-reflection-mode");bool floor_enabled=strcmp(fr,"off")!=0,floor_zero=!strcmp(fr,"zero");if(strcmp(fr,"on"))return fail("row-fixed-floor-on");
 const char *wm=getenv("HONE_FLOOR_WORLD");if(!wm||(strcmp(wm,"off")&&strcmp(wm,"on")))return fail("floor-world-mode");bool world_enabled=!strcmp(wm,"on");bounce_floor_world_work world_work={0};
 const char *fc=getenv("HONE_FLOOR_CASE");if(!fc||strlen(fc)!=1||fc[0]<'0'||fc[0]>'4')return fail("floor-case");unsigned floor_case=(unsigned)(fc[0]-'0');bounce_floor_work floor_work={0};
 if(groundmode!=2||transportmode!=2||outer!=16||inner!=16)return fail("floor-fixed-dependencies");
 const char *groundfile=getenv("HONE_GROUND_FILE");fox_ground_input groundinput={0};bounce_ground ground={0};uint64_t ground_digest=0;
 if(groundmode&&(transportmode!=2||!visibility))return fail("ground-dependency");
 if(groundmode){if(!fox_ground_load(groundfile,&groundinput))return fail("ground-input");ground.mode=(bounce_ground_mode)groundmode;ground.object_id=1;ground.first_triangle=FOX_EXPECTED_TRIANGLES;ground.triangle_count=2;memcpy(ground.le,groundinput.le,sizeof ground.le);ground_digest=groundinput.fingerprint;}
 else if(groundfile&&groundfile[0])return fail("ground-off-input");
 if(floor_enabled){ground.mode=BOUNCE_GROUND_PRIMARY_LE_DIRECT;if(!floor_zero)memcpy(ground.rho,floor_rho[floor_case],sizeof ground.rho);}
 const char *pm=getenv("HONE_PIXEL_LIGHT");bool pixel=pm&&!strcmp(pm,"1");if(pm&&strcmp(pm,"0")&&strcmp(pm,"1"))return fail("pixel-mode");
 const char *diskfile=getenv("HONE_DISK_FILE");bool physical=diskfile&&diskfile[0];FoxDiskScene disks;if(physical&&!load_disk(diskfile,&disks))return fail("disk-input");
 if(transportmode&&!visibility)return fail("transport-dependency");
 if(visibility&&!pixel)return fail("visibility-dependency");
 if(pixel&&(!physical||!enabled))return fail("pixel-dependency");
 if(!arena||ayatsuri_model_instance_init(&m,arena,ab,&owner,1,&ins)||ayatsuri_model_instance_linear_light(&ins,&owner,1,enabled)||ayatsuri_model_instance_disk_scene(&ins,&owner,1,physical?&disks:NULL)||ayatsuri_model_instance_evaluate(&ins,&owner,1,cam,light))return fail("evaluate");
 unsigned long long eval_ns=ns()-eval_start;
 unsigned long long append_start=ns();uint32_t epoch=ins.mutation_epoch;
 uint8_t payload[65536];ksn_mesh_snapshot legacy={.packets={.data=payload,.capacity=sizeof payload},.work_limit=8000000,.enabled=true};
 ksn_mesh_pixel_snapshot px; if(pixel&&!ksn_mesh_pixel_begin(&px,payload,sizeof payload,&disks,8000000))return fail("pixel-begin");ksn_mesh_snapshot *s=pixel?&px.mesh:&legacy;
 uint16_t ids[256];uint8_t kinds[256];unsigned count=0;uint32_t cursor=0;ayatsuri_model_packet p;ayatsuri_model_status rc;
 while((rc=ayatsuri_model_instance_next(&ins,&owner,1,&cursor,&p))==AYATSURI_MODEL_OK){if(count==256||(p.kind!=4&&p.kind!=5))return fail("mesh-only");kinds[count]=p.kind;ids[count++]=p.node_id;}
 if(rc!=AYATSURI_MODEL_DONE||!count)return fail("empty");

 vis_scene *occluders=NULL;fox_pixel_binding binding={0};vis_generation generation={groundmode?2:1,1,1};
 vis_budget budget={.limit={1000000,100000000,50000000}},transport_budget={.limit={20000000,800000000,300000000}};bounce_scene *transport_scene=NULL;bounce_generation tgen={.visibility=generation,.material=floor_enabled?(floor_case==4?3:2):1,.emission=floor_enabled?2:(groundmode?1:0)};fox_transport_context tx={0};size_t transport_bytes=0,transport_temp=0;unsigned long long transport_build_ns=0;uint64_t material_digest=0;
 uint64_t geometry_digest=0;size_t occluder_vertices=0,occluder_triangles=0,temporary_bytes=0;unsigned long long build_ns=0;
 if(visibility){
  unsigned long long begin=ns();
  for(unsigned id=0;id<m.node_count;id++){const uint8_t *node=m.data+m.section[0].offset+id*16;if(node[2]!=3)continue;
   ayatsuri_model_world_mesh_view v;if(ayatsuri_model_instance_world_mesh_view(&ins,&owner,1,id,epoch,&v))return fail("world-view");occluder_vertices+=v.vertex_count;occluder_triangles+=v.triangle_count;}
  if(occluder_triangles!=FOX_EXPECTED_TRIANGLES||occluder_vertices!=FOX_EXPECTED_VERTICES)return fail("whole-geometry-count");
  if(groundmode){occluder_vertices+=4;occluder_triangles+=2;}
  temporary_bytes=occluder_vertices*3*sizeof(double)+occluder_triangles*3*sizeof(uint32_t);
  bounce_triangle *attributes=transportmode?calloc(occluder_triangles,sizeof(bounce_triangle)):NULL;if(transportmode&&!attributes)return fail("attribute-memory");transport_temp=transportmode?occluder_triangles*sizeof(bounce_triangle):0;
  double *xyz=malloc(occluder_vertices*3*sizeof(double));uint32_t *tri=malloc(occluder_triangles*3*sizeof(uint32_t));if(!xyz||!tri)return fail("geometry-memory");size_t nv=0,nt=0;
  for(unsigned id=0;id<m.node_count;id++){const uint8_t *node=m.data+m.section[0].offset+id*16;if(node[2]!=3)continue;
   ayatsuri_model_world_mesh_view v;ayatsuri_model_pixel_mesh_view raw;if(ayatsuri_model_instance_world_mesh_view(&ins,&owner,1,id,epoch,&v)||ayatsuri_model_instance_pixel_mesh_view(&ins,&owner,1,id,epoch,&raw))return fail("world-view-fill");
   for(unsigned j=0;j<v.vertex_count;j++){if(memcmp(v.world[j],raw.vertices[j].world,3*sizeof(double)))return fail("world-pixel-parity");xyz[3*(nv+j)]=v.world[j][0]/38;xyz[3*(nv+j)+1]=-v.world[j][2]/38;xyz[3*(nv+j)+2]=-v.world[j][1]/38;}
   for(unsigned j=0;j<3*v.triangle_count;j++)tri[3*nt+j]=(uint32_t)nv+v.indices[j];
   if(transportmode)for(unsigned t=0;t<v.triangle_count;t++){bounce_triangle *a=attributes+nt+t;a->double_sided=v.double_sided;for(unsigned j=0;j<3;j++){unsigned vi=v.indices[3*t+j];const co_pixel_vertex *f=raw.vertices+vi;bounce_vertex *b=&a->v[j];b->mask=f->front.mask;b->a565=f->front.color_a;b->b565=f->front.color_b;b->front[0]=f->normal_front[0];b->front[1]=-f->normal_front[2];b->front[2]=-f->normal_front[1];b->back[0]=f->normal_back[0];b->back[1]=-f->normal_back[2];b->back[2]=-f->normal_back[1];}}
   nv+=v.vertex_count;nt+=v.triangle_count;
  }
  if(nv!=FOX_EXPECTED_VERTICES||nt!=FOX_EXPECTED_TRIANGLES)return fail("whole-geometry-filled");
  if(groundmode){
   memcpy(xyz+3*nv,groundinput.world,sizeof groundinput.world);
   for(unsigned j=0;j<6;j++)tri[3*nt+j]=(uint32_t)nv+groundinput.indices[j];
   for(unsigned t=0;t<2;t++){bounce_triangle *a=attributes+nt+t;a->double_sided=1;for(unsigned j=0;j<3;j++){a->v[j].front[2]=32767;a->v[j].back[2]=-32767;}}
   nv+=4;nt+=2;
  }
  if(nv!=occluder_vertices||nt!=occluder_triangles)return fail("geometry-count-final");
  geometry_digest=digest_bytes(UINT64_C(14695981039346656037),xyz,nv*3*sizeof(double));geometry_digest=digest_bytes(geometry_digest,tri,nt*3*sizeof(uint32_t));
  vis_status status=vis_scene_build(&occluders,xyz,nv,tri,nt,generation,(vis_limits){2048,4095,524288});memset(xyz,0xa5,nv*3*sizeof(double));memset(tri,0xa5,nt*3*sizeof(uint32_t));free(xyz);free(tri);if(status!=VIS_OK)return fail("bvh-build");build_ns=ns()-begin;
  if(transportmode){unsigned long long bt=ns();material_digest=digest_bytes(UINT64_C(14695981039346656037),attributes,nt*sizeof *attributes);if(bounce_scene_build_ground_compact(&transport_scene,occluders,attributes,nt,&disks,-1,tgen,262144,&ground)!=BOUNCE_OK)return fail("transport-build");transport_bytes=bounce_scene_bytes(transport_scene);if(transport_bytes!=bounce_scene_compact_required_bytes(attributes,nt)||!bounce_scene_matches_ground(transport_scene,&ground)||!bounce_scene_matches_lights(transport_scene,&disks))return fail("transport-owned-inputs");memset(attributes,0xa5,nt*sizeof *attributes);free(attributes);transport_build_ns=ns()-bt;}
 }
 int reverse=atoi(argv[3]);
 for(unsigned at=0;at<count;at++){
  unsigned index=reverse?count-1-at:at;ayatsuri_model_pixel_mesh_view raw;ksn_proc_gouraud_patch patch;const float *depth;const uint16_t *back=NULL;uint8_t bits[8]={0};
  if(pixel){if(ayatsuri_model_instance_pixel_mesh_view(&ins,&owner,1,ids[index],epoch,&raw))return fail("pixel-view");memcpy(&patch,raw.patch,sizeof patch);depth=raw.depth;memcpy(bits,raw.back_faces,8);}
  else if(kinds[index]==5){ayatsuri_model_sided_mesh_view v;if(ayatsuri_model_instance_sided_mesh_view(&ins,&owner,1,ids[index],&v))return fail("sided-view");memcpy(&patch,v.patch,sizeof patch);depth=v.depth;back=v.back_colors;memcpy(bits,v.back_faces,8);}
  else{ayatsuri_model_mesh_view v;if(ayatsuri_model_instance_mesh_view(&ins,&owner,1,ids[index],&v))return fail("view");memcpy(&patch,v.patch,sizeof patch);depth=v.depth;}
  if(reverse){uint8_t rb[8]={0};for(unsigned t=0;t<patch.header.triangles;t++)if(bits[t/8]&(1u<<(t%8))){unsigned q=patch.header.triangles-1-t;rb[q/8]|=1u<<(q%8);}memcpy(bits,rb,8);for(unsigned a=0,b=patch.header.triangles?patch.header.triangles-1:0;a<b;a++,b--)for(unsigned k=0;k<3;k++){uint16_t q=patch.indices[3*a+k];patch.indices[3*a+k]=patch.indices[3*b+k];patch.indices[3*b+k]=q;}}
  bool ok=pixel?(normal_pair?ksn_mesh_pixel_append_normal_pair(&px,&patch,raw.vertices,bits,ids[index]):ksn_mesh_pixel_append(&px,&patch,raw.vertices,bits,ids[index])):back?ksn_mesh_append_sided(s,&patch,depth,back,bits,ids[index]):ksn_mesh_append(s,&patch,depth,ids[index]);if(!ok)return fail("append");
 }
 unsigned codec_mode4=0,codec_mode5=0;size_t canonical_snapshot_bytes=416;
 if(pixel){size_t at=0;while(at<s->packets.size){co_view v;if(!co_read(s->packets.data+at,s->packets.size-at,&v))return fail("codec-snapshot-parse");if(v.mode==4)codec_mode4++;else if(v.mode==5)codec_mode5++;else return fail("codec-snapshot-mode");canonical_snapshot_bytes+=(12u+56u*v.vertex_count+3u*v.triangle_count+(v.triangle_count+7u)/8u+3u)&~(size_t)3u;at+=v.size;}if(at!=s->packets.size)return fail("codec-snapshot-size");}
 if(visibility&&fox_pixel_bind(&binding,occluders,generation,&px)!=VIS_OK)return fail("visibility-bind");
 const floor_input_row *floor_prediction=floor_input_lookup(binding.snapshot_hash);if(!floor_prediction||floor_prediction->case_index!=floor_case)return fail("floor-input-binding");
 if(floor_enabled&&bounce_floor_work_init(&floor_work,floor_prediction->shaders,floor_prediction->hits)!=BOUNCE_OK)return fail("floor-work-init");
 if(world_enabled&&bounce_floor_world_work_init(&world_work,floor_prediction->shaders,floor_prediction->hits)!=BOUNCE_OK)return fail("world-work-init");tx.floor_world_work=world_enabled?&world_work:NULL;
 if(transportmode){tx.floor_work=floor_enabled?&floor_work:NULL;tx.snapshot_binding=&binding;tx.expected=tgen;tx.ground=ground;tx.mode=(bounce_mode)transportmode;tx.outer=outer;tx.inner=inner;tx.direct_budget=&budget;tx.transport_budget=&transport_budget;if(bounce_binding_set(&tx.binding,transport_scene,tgen)!=BOUNCE_OK)return fail("transport-bind");bounce_scene_release(transport_scene);transport_scene=NULL;}
 const fox_bg_fixed_input *bg_fixed=bg_select_input(cam,floor_case,reverse!=0,binding.snapshot_hash);if(!bg_fixed)return fail("background-input-pin");
 fox_bg_scene *bg_scene=NULL;fox_bg_work bg_work={0};fox_bg_context bg_context={0};vis_budget bg_budget={.limit={FOX_BG_SHADOW_RAYS,FOX_BG_SHADOW_NODES,FOX_BG_SHADOW_TRIANGLES}};size_t bg_scene_bytes=0;unsigned long long bg_build_ns=0;
 {
  unsigned long long bt=ns();fox_bg_input in={0};in.generation=(fox_bg_generation){.visibility=generation,.camera=bg_fixed->view_index+1,.material=floor_case==4?2:1,.emission=1,.illumination=floor_case+1};
  in.snapshot_fingerprint=binding.snapshot_hash;in.identity_fingerprint=UINT64_C(0x912ba9aa3cfbfb2c);memcpy(in.camera,cam,sizeof cam);memcpy(in.source_origin,bg_fixed->origin,sizeof in.source_origin);memcpy(in.source_view,bg_fixed->view,sizeof in.source_view);memcpy(in.clip,bg_fixed->clip,sizeof in.clip);memcpy(in.floor,groundinput.world,sizeof in.floor);memcpy(in.indices,groundinput.indices,sizeof in.indices);memcpy(in.rho,bg_fixed->rho,sizeof in.rho);memcpy(in.le,bg_fixed->le,sizeof in.le);in.lights=disks;
  for(unsigned k=0;k<3;k++)if(ground.le[k]!=bg_fixed->le[k]||disks.world_radiance[k]!=bg_fixed->world_rgb[k]*bg_fixed->world_strength)return fail("background-source-fields");
  uint64_t shade_bound=bg_fixed->empty_slots+bg_fixed->overrides;
  if(fox_bg_work_init(&bg_work,bg_fixed->slots,shade_bound)!=FOX_BG_OK||fox_bg_scene_build(&bg_scene,occluders,&in,&bg_work,FOX_BG_OWNED_CAP)!=FOX_BG_OK)return fail("background-owned-build");bg_scene_bytes=fox_bg_scene_bytes(bg_scene);
  if(fox_bg_context_begin(&bg_context,bg_scene,in.generation,KSN_SCENE_COMPOSITE,&bg_work,&bg_budget,px.storage,416+s->packets.size,boundary_identity_bytes,sizeof boundary_identity_bytes)!=FOX_BG_OK)return fail("background-frame-admission");
  fox_bg_scene_release(bg_scene);bg_scene=NULL;memset(&in,0xa5,sizeof in);bg_build_ns=ns()-bt;
 }
 size_t scene_bytes=vis_scene_bytes(occluders),scene_nodes=vis_scene_node_count(occluders);if(occluders){vis_scene_release(occluders);occluders=NULL;}
 unsigned long long append_ns=ns()-append_start;
 if(ayatsuri_model_instance_dispose(&ins,&owner,1))return fail("dispose");memset(arena,0xa5,ab);memset(data,0xa5,(size_t)bytes);free(arena);free(data);memset(&disks,0xa5,sizeof disks);memset(&groundinput,0xa5,sizeof groundinput);memset(&ground,0xa5,sizeof ground);
 if(transportmode&&!bounce_scene_matches_ground(tx.binding.scene,&tx.ground))return fail("ground-owned-after-poison");
 if(pixel){char dump_path[4096];snprintf(dump_path,sizeof dump_path,"%s.snapshot",argv[2]);FILE *df=fopen(dump_path,"wbx");size_t total=416+s->packets.size;if(!df)return fail("codec-snapshot-output");if(fwrite(px.storage,1,total,df)!=total||fclose(df))return fail("codec-snapshot-write");}
 unsigned long long render_ns=0;ksn_mesh_pixel_stats stats={0};
 const char *aa_env=getenv("HONE_BOUNDARY_AA");bool aa_enabled=aa_env&&!strcmp(aa_env,"1");if(!aa_enabled)return fail("floor-aa-must-be-on");
 if(aa_enabled){
  if(!transportmode||!normal_pair)return fail("aa-dependencies");
  ksn_bounded_ring_workspace *aw=calloc(1,sizeof *aw);uint16_t*full=calloc(240*135,sizeof *full);KsnDepthBands center={0};bool depth_ready=depth_bands_allocate(&center,malloc);ksn_aa_ledger ledger={0};
  if(!depth_ready){depth_bands_release(&center);free(aw);free(full);return fail("aa-depth-band-allocation");}
  if(!aw||!full||sizeof *aw+KSN_AA_NEW_STACK_RESERVE>KSN_AA_WORKSPACE_CAP||!aa_read_ledger(getenv("HONE_AA_LEDGER"),&ledger)){depth_bands_release(&center);free(aw);free(full);return fail("aa-allocation-ledger");}
  ksn_aa_identity identity={.bytes=boundary_identity_bytes,.size=sizeof boundary_identity_bytes,.records=54,.faces=1564,.fingerprint=UINT64_C(0x912ba9aa3cfbfb2c),.snapshot_fingerprint=0};
  const aa_preflight_entry*prediction=aa_preflight_lookup(tx.snapshot_binding->snapshot_hash);if(!prediction)return fail("aa-preflight-snapshot");
  uint64_t predicted_total=0;for(unsigned j=0;j<4;j++)predicted_total+=prediction->hits[j];if(ledger.value[AA_FINAL_SHADE]!=76*predicted_total||ledger.value[AA_CONTROL]!=4160)return fail("aa-preflight-ledger");
  KsnSceneLedger scene_limits={0};KsnSceneReport scene_report={0};KsnBandHDRReport hdr_report={0};
  for(unsigned k=0;k<SC_CATEGORY_COUNT;k++)scene_limits.value[k]=fox_scene_limits[bg_fixed->view_index][0][k];
  KsnSceneBinding scene_binding={.compose=fox_bg_compose,.overlaps=fox_bg_context_overlaps,.context=&bg_context,.context_bytes=sizeof bg_context,.descriptor=bg_context.binding.scene,.descriptor_bytes=bg_scene_bytes,.shadow_budget=&bg_budget,.shadow_budget_bytes=sizeof bg_budget,.resolver_owned_bytes=fox_bg_context_owned_bytes(&bg_context),.snapshot_fingerprint=binding.snapshot_hash,.identity_fingerprint=UINT64_C(0x912ba9aa3cfbfb2c),.target_mask_fingerprint=fox_scene_mask_hash[bg_fixed->view_index],.mode=KSN_SCENE_COMPOSITE,.expected_targets=bg_fixed->view_index?2391:2385};
  identity.snapshot_fingerprint=binding.snapshot_hash;
  RowHostVerification verification={73728,0};
  RowRenderBands render={&tx,&px,full,center,aw,&identity,&ledger,&scene_binding,&scene_limits,&scene_report,&hdr_report,&bg_work,&verification};
#ifdef ROW_HDR_OBSERVER
  if(!row_hdr_observer_begin(full))return fail("hdr-observer-begin");
#endif
  unsigned long long begin=ns();bool complete=row_transport_render_bands(&render);render_ns=ns()-begin;
  aa_observer_context observer={0};bool observer_ok=true;
  bool prediction_ok=aa_preflight_actual_matches(prediction,aw->report.sample_hits,aw->report.targets);complete=complete&&prediction_ok;
  complete=complete&&(aw->report.center_shades+aw->report.sample_shades)==floor_prediction->shaders&&tx.counters.primary_ground_hits==floor_prediction->hits;
  if(!aa_write_report(argv[2],aw,&observer,complete&&observer_ok))return fail("aa-report");
  if(!floor_write_report(argv[2],&floor_work,&tx,floor_enabled,floor_zero,floor_case,complete&&observer_ok))return fail("floor-report");
  char rp[4096];snprintf(rp,sizeof rp,"%s.row.json",argv[2]);FILE*rf=fopen(rp,"wx");if(!rf)return fail("row-report");
  fprintf(rf,"{\"complete\":%s,\"profileCalls\":%llu,\"clamped\":%llu,\"backgroundSlots\":%llu,\"floor\":%llu,\"world\":%llu,\"keep\":%llu,\"occludedCharacter\":%llu,\"backgroundBuildNs\":%llu,\"producerUsed\":[",complete?"true":"false",(unsigned long long)hdr_report.used[RH_PROFILE],(unsigned long long)hdr_report.clamped,(unsigned long long)bg_context.counters.slots,(unsigned long long)bg_context.counters.floor,(unsigned long long)bg_context.counters.world,(unsigned long long)bg_context.counters.keep,(unsigned long long)scene_report.occluded_character,bg_build_ns);
  for(unsigned i=0;i<RH_COUNT;i++)fprintf(rf,"%s%llu",i?",":"",(unsigned long long)hdr_report.used[i]);fprintf(rf,"],\"backgroundRays\":%llu,\"backgroundNodes\":%llu,\"backgroundTriangles\":%llu,\"backgroundWorkTotal\":%llu,\"backgroundWorkUsed\":[",(unsigned long long)bg_budget.used.rays,(unsigned long long)bg_budget.used.node_visits,(unsigned long long)bg_budget.used.triangle_tests,(unsigned long long)bg_work.used_total);for(unsigned i=0;i<BGW_COUNT;i++)fprintf(rf,"%s%llu",i?",":"",(unsigned long long)bg_work.used[i]);fprintf(rf,"],\"hostFinishHashLimit\":%llu,\"hostFinishHashBytes\":%llu,\"adapterSpanPairs\":%u,\"adapterGuardUpper\":1024}\n",(unsigned long long)verification.limit,(unsigned long long)verification.used,world_enabled?406u:378u);if(fclose(rf))return fail("row-report-close");
  if(!bg_write_report(argv[2],1,bg_fixed,&bg_context,&bg_work,&bg_budget,&scene_report,bg_scene_bytes,bg_build_ns,complete))return fail("background-report");
  if(!floor_world_write_report(argv[2],&world_work,world_enabled,complete&&observer_ok))return fail("world-report");
  if(!complete||!observer_ok)return fail_render(&budget,&transport_budget,&tx.counters);
#ifdef ROW_HDR_OBSERVER
  if(!row_hdr_observer_write(argv[2]))return fail("hdr-observer-write");row_hdr_observer_clear();
#endif
  stats.shade_updates=aw->report.center_shades+aw->report.sample_shades;stats.disk_samples=48*stats.shade_updates;
  char maskpath[4096];snprintf(maskpath,sizeof maskpath,"%s.targets.u8",argv[2]);FILE*mf=fopen(maskpath,"wb");if(!mf)return fail("aa-target-open");for(unsigned i=0;i<240*135;i++){unsigned char bit=(aw->targets[i/8]>>(i%8))&1;if(fwrite(&bit,1,1,mf)!=1)return fail("aa-target-write");}if(fclose(mf))return fail("aa-target-close");
  for(unsigned b=0;b<5;b++)for(unsigned i=0;i<center.bytes[b]/sizeof(float);i++)if(isnan(center.band[b][i])||center.band[b][i]==INFINITY)return fail("aa-depth");
  char path[4096];snprintf(path,sizeof path,"%s.u16le",argv[2]);FILE*c=fopen(path,"wbx");snprintf(path,sizeof path,"%s.f32le",argv[2]);FILE*d=fopen(path,"wbx");if(!c||!d)return fail("private-output-create");
  if(fwrite(full,2,240*135,c)!=240*135)return fail("aa-write");for(unsigned b=0;b<5;b++)if(fwrite(center.band[b],1,center.bytes[b],d)!=center.bytes[b])return fail("aa-write");int color_close=fclose(c),depth_close=fclose(d);if(color_close||depth_close)return fail("private-output-close");free(aw);free(full);depth_bands_release(&center);
 }
 printf("{\"normalPairCodecEnabled\":%s,\"normalPairMode4Records\":%u,\"normalPairMode5Records\":%u,\"normalPairSavedBytes\":%zu,",normal_pair?"true":"false",codec_mode4,codec_mode5,canonical_snapshot_bytes-(416+s->packets.size));
 printf("\"transportMode\":%u,\"transportComplete\":true,\"outerSamples\":%u,\"innerSamples\":%u,\"materialGeneration\":%u,\"materialFingerprint\":\"%016llx\",\"transportSceneBytes\":%zu,\"transportTemporaryBytes\":%zu,\"transportContextBytes\":%zu,\"transportBudgetBytes\":%zu,\"transportBuildNs\":%llu,\"transportRays\":%llu,\"transportNodeVisits\":%llu,\"transportTriangleTests\":%llu,\"transportRayLimit\":20000000,\"transportNodeLimit\":800000000,\"transportTriangleLimit\":300000000,\"transportSceneLimit\":262144,",transportmode,outer,inner,transportmode?(unsigned)tgen.material:0,(unsigned long long)material_digest,transport_bytes,transport_temp,sizeof tx,sizeof transport_budget,transport_build_ns,(unsigned long long)transport_budget.used.rays,(unsigned long long)transport_budget.used.node_visits,(unsigned long long)transport_budget.used.triangle_tests);
#define COUNT(name) printf("\"" #name "\":%llu,",(unsigned long long)tx.counters.name);
 COUNT(primary_ground_reflection_hits) COUNT(primary_ground_direct_queries)
 COUNT(primary_ground_hits) COUNT(primary_ground_emission_hits) COUNT(secondary_ground_hits)
 COUNT(primary_rays) COUNT(primary_hits) COUNT(primary_misses) COUNT(secondary_world_rays) COUNT(primary_direct_queries) COUNT(secondary_direct_queries) COUNT(zero_reflection_ns_v) COUNT(back_single_discard) COUNT(grazing_ng_v)
#undef COUNT
 printf("\"groundMode\":%u,\"groundObjectId\":%llu,\"groundFirstTriangle\":%u,\"groundTriangleCount\":%u,\"emissionGeneration\":%llu,\"groundLe\":[%.17g,%.17g,%.17g],\"groundInputFingerprint\":\"%016llx\",",(unsigned)tx.ground.mode,(unsigned long long)tx.ground.object_id,tx.ground.first_triangle,tx.ground.triangle_count,(unsigned long long)(groundmode?tgen.emission:0),tx.ground.le[0],tx.ground.le[1],tx.ground.le[2],(unsigned long long)ground_digest);
 printf("\"floorReflectionEnabled\":%s,\"floorZeroControl\":%s,\"floorCase\":%u,\"floorRho\":[%.17g,%.17g,%.17g],",floor_enabled?"true":"false",floor_zero?"true":"false",floor_case,tx.ground.rho[0],tx.ground.rho[1],tx.ground.rho[2]);
 fox_bg_context_clear(&bg_context);
 bounce_binding_clear(&tx.binding);
 printf("\"visibilityGeneration\":[%u,%u,%u],\"visibilityGeometryFingerprint\":\"%016llx\",\"visibilitySnapshotFingerprint\":\"%016llx\",\"visibilityBindingBytes\":%zu,\"visibilityBudgetBytes\":%zu,",visibility?(unsigned)generation.geometry:0,visibility?(unsigned)generation.pose:0,visibility?(unsigned)generation.light:0,(unsigned long long)geometry_digest,(unsigned long long)binding.snapshot_hash,sizeof binding,sizeof budget);
 printf("\"visibilityEnabled\":%s,\"visibilityComplete\":true,\"visibilitySceneBytes\":%zu,\"visibilitySceneNodes\":%zu,\"visibilityTriangles\":%zu,\"visibilityVertices\":%zu,\"visibilityBuildNs\":%llu,\"visibilityTemporaryBytes\":%zu,\"visibilityRays\":%llu,\"visibilityNodeVisits\":%llu,\"visibilityTriangleTests\":%llu,\"visibilityRayLimit\":1000000,\"visibilityNodeLimit\":100000000,\"visibilityTriangleLimit\":50000000,\"visibilitySceneLimit\":524288,",visibility?"true":"false",scene_bytes,scene_nodes,occluder_triangles,occluder_vertices,build_ns,temporary_bytes,(unsigned long long)budget.used.rays,(unsigned long long)budget.used.node_visits,(unsigned long long)budget.used.triangle_tests);fox_pixel_unbind(&binding);
 printf("\"pixelLightEnabled\":%s,\"agxProfileEnabled\":true,\"shadeUpdates\":%llu,\"diskSamples\":%llu,\"snapshotControlBytes\":%zu,\"rawFieldScratchBytes\":%zu,\"appendNs\":%llu,",pixel?"true":"false",(unsigned long long)stats.shade_updates,(unsigned long long)stats.disk_samples,pixel?sizeof px:sizeof legacy,sizeof(ayatsuri_model_pixel_mesh_view),append_ns);
 printf("\"physicalDiskEnabled\":%s,\"linearLightEnabled\":%s,\"instanceControlBytes\":%zu,\"records\":%u,\"logicalMeshes\":%u,\"evaluateNs\":%llu,\"camera\":[",physical?"true":"false",enabled?"true":"false",sizeof ins,s->packets.packets,count,eval_ns);for(int i=0;i<9;i++)printf("%s%.9g",i?",":"",cam[i]);printf("],\"light\":[");for(int i=0;i<6;i++)printf("%s%.9g",i?",":"",light[i]);printf("],\"coldBytes\":%ld,\"arenaBytes64bit\":%zu,\"snapshotBytes\":%zu,\"work\":%u,\"hostRenderNsFirstFrame\":%llu,\"depthScratchBytes\":7680,\"colorBandBytes\":3840,\"snapshotCapacity\":65536,\"disposedBeforeRender\":true,\"reverse\":%s}\n",bytes,ab,s->packets.size+(pixel?416:0),s->work,render_ns,reverse?"true":"false");return 0;
}
