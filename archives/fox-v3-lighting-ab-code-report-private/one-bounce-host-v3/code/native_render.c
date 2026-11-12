#define _POSIX_C_SOURCE 200809L
/* Host adapter only: production model evaluator, owned snapshot and raster unchanged. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>
static unsigned long long ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (unsigned long long)t.tv_sec*1000000000ull+t.tv_nsec;}
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include "pixel_binding.h"
#include "pixel_transport.h"
static uint64_t digest_bytes(uint64_t h,const void *p,size_t n){const uint8_t *b=p;for(size_t i=0;i<n;i++){h^=b[i];h*=UINT64_C(1099511628211);}return h;}
static int fail(const char *s){fprintf(stderr,"NATIVE_GATE:%s\n",s);return 2;}
static int load_disk(const char *path,FoxDiskScene *out){
 FILE *f=fopen(path,"r");if(!f)return 0;char magic[10]={0};FoxDiskLightInput lights[3];memset(lights,0,sizeof lights);double world[3],strength;int ok=fscanf(f,"%9s",magic)==1&&!strcmp(magic,"FOXDISK1");
 for(unsigned j=0;ok&&j<3;j++){lights[j].shape=FOX_DISK_SHAPE_DISK;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].center[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].rotation_xyz[k])==1;for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",&lights[j].color[k])==1;if(ok)ok=fscanf(f,"%lf %lf",&lights[j].power,&lights[j].diameter)==2;}
 for(unsigned k=0;ok&&k<3;k++)ok=fscanf(f,"%lf",world+k)==1;if(ok)ok=fscanf(f,"%lf",&strength)==1;char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=0;fclose(f);return ok&&fox_disk_scene_init(out,lights,world,strength)==FOX_DISK_OK;
}
int main(int argc,char **argv){
 if(argc!=19)return fail("arguments: model color depth reverse camera9 light6");
 float cam[9],light[6];for(int i=0;i<9;i++)cam[i]=strtof(argv[4+i],NULL);for(int i=0;i<6;i++)light[i]=strtof(argv[13+i],NULL);
 FILE *f=fopen(argv[1],"rb");if(!f)return fail("input");fseek(f,0,SEEK_END);long bytes=ftell(f);rewind(f);if(bytes<1||bytes>1048576)return fail("size");
 uint8_t *data=malloc((size_t)bytes);if(!data||fread(data,1,(size_t)bytes,f)!=(size_t)bytes)return fail("read");fclose(f);
 ayatsuri_model m;if(ayatsuri_model_open(data,(size_t)bytes,&m))return fail("model");
 size_t ab=ayatsuri_model_instance_bytes(&m);void *arena=malloc(ab);int owner=0;ayatsuri_model_instance ins;
 unsigned long long eval_start=ns();
 const char *mode=getenv("HONE_LINEAR_LIGHT");unsigned enabled=mode&&strcmp(mode,"1")==0;
 if(mode&&strcmp(mode,"0")&&strcmp(mode,"1"))return fail("linear-mode");
 const char *tm=getenv("HONE_TRANSPORT_MODE");unsigned transportmode=tm?(unsigned)strtoul(tm,NULL,10):0;if(tm&&strcmp(tm,"0")&&strcmp(tm,"1")&&strcmp(tm,"2"))return fail("transport-mode");
 unsigned outer=16,inner=16;const char *os=getenv("HONE_OUTER_SAMPLES");if(os){if(strcmp(os,"16")&&strcmp(os,"64"))return fail("outer-samples");outer=(unsigned)atoi(os);}
 const char *vm=getenv("HONE_PIXEL_VISIBILITY");bool visibility=vm&&!strcmp(vm,"1");if(vm&&strcmp(vm,"0")&&strcmp(vm,"1"))return fail("visibility-mode");
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

 vis_scene *occluders=NULL;fox_pixel_binding binding={0};vis_generation generation={1,1,1};
 vis_budget budget={.limit={1000000,100000000,50000000}},transport_budget={.limit={20000000,800000000,300000000}};bounce_scene *transport_scene=NULL;bounce_generation tgen={generation,1};fox_transport_context tx={0};size_t transport_bytes=0,transport_temp=0;unsigned long long transport_build_ns=0;uint64_t material_digest=0;
 uint64_t geometry_digest=0;size_t occluder_vertices=0,occluder_triangles=0,temporary_bytes=0;unsigned long long build_ns=0;
 if(visibility){
  unsigned long long begin=ns();
  for(unsigned id=0;id<m.node_count;id++){const uint8_t *node=m.data+m.section[0].offset+id*16;if(node[2]!=3)continue;
   ayatsuri_model_world_mesh_view v;if(ayatsuri_model_instance_world_mesh_view(&ins,&owner,1,id,epoch,&v))return fail("world-view");occluder_vertices+=v.vertex_count;occluder_triangles+=v.triangle_count;}
  if(occluder_triangles!=1166||occluder_vertices>4096)return fail("whole-geometry-count");
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
  geometry_digest=digest_bytes(UINT64_C(14695981039346656037),xyz,nv*3*sizeof(double));geometry_digest=digest_bytes(geometry_digest,tri,nt*3*sizeof(uint32_t));
  vis_status status=vis_scene_build(&occluders,xyz,nv,tri,nt,generation,(vis_limits){2048,4095,524288});memset(xyz,0xa5,nv*3*sizeof(double));memset(tri,0xa5,nt*3*sizeof(uint32_t));free(xyz);free(tri);if(status!=VIS_OK)return fail("bvh-build");build_ns=ns()-begin;
  if(transportmode){unsigned long long bt=ns();material_digest=digest_bytes(UINT64_C(14695981039346656037),attributes,nt*sizeof *attributes);if(bounce_scene_build(&transport_scene,occluders,attributes,nt,&disks,-1,tgen,262144)!=BOUNCE_OK)return fail("transport-build");transport_bytes=bounce_scene_bytes(transport_scene);memset(attributes,0xa5,nt*sizeof *attributes);free(attributes);transport_build_ns=ns()-bt;}
 }
 int reverse=atoi(argv[3]);
 for(unsigned at=0;at<count;at++){
  unsigned index=reverse?count-1-at:at;ayatsuri_model_pixel_mesh_view raw;ksn_proc_gouraud_patch patch;const float *depth;const uint16_t *back=NULL;uint8_t bits[8]={0};
  if(pixel){if(ayatsuri_model_instance_pixel_mesh_view(&ins,&owner,1,ids[index],epoch,&raw))return fail("pixel-view");memcpy(&patch,raw.patch,sizeof patch);depth=raw.depth;memcpy(bits,raw.back_faces,8);}
  else if(kinds[index]==5){ayatsuri_model_sided_mesh_view v;if(ayatsuri_model_instance_sided_mesh_view(&ins,&owner,1,ids[index],&v))return fail("sided-view");memcpy(&patch,v.patch,sizeof patch);depth=v.depth;back=v.back_colors;memcpy(bits,v.back_faces,8);}
  else{ayatsuri_model_mesh_view v;if(ayatsuri_model_instance_mesh_view(&ins,&owner,1,ids[index],&v))return fail("view");memcpy(&patch,v.patch,sizeof patch);depth=v.depth;}
  if(reverse){uint8_t rb[8]={0};for(unsigned t=0;t<patch.header.triangles;t++)if(bits[t/8]&(1u<<(t%8))){unsigned q=patch.header.triangles-1-t;rb[q/8]|=1u<<(q%8);}memcpy(bits,rb,8);for(unsigned a=0,b=patch.header.triangles?patch.header.triangles-1:0;a<b;a++,b--)for(unsigned k=0;k<3;k++){uint16_t q=patch.indices[3*a+k];patch.indices[3*a+k]=patch.indices[3*b+k];patch.indices[3*b+k]=q;}}
  bool ok=pixel?ksn_mesh_pixel_append(&px,&patch,raw.vertices,bits,ids[index]):back?ksn_mesh_append_sided(s,&patch,depth,back,bits,ids[index]):ksn_mesh_append(s,&patch,depth,ids[index]);if(!ok)return fail("append");
 }
 if(visibility&&fox_pixel_bind(&binding,occluders,generation,&px)!=VIS_OK)return fail("visibility-bind");
 if(transportmode){tx.snapshot_binding=&binding;tx.expected=tgen;tx.mode=(bounce_mode)transportmode;tx.outer=outer;tx.inner=inner;tx.direct_budget=&budget;tx.transport_budget=&transport_budget;if(bounce_binding_set(&tx.binding,transport_scene,tgen)!=BOUNCE_OK)return fail("transport-bind");bounce_scene_release(transport_scene);transport_scene=NULL;}
 size_t scene_bytes=vis_scene_bytes(occluders),scene_nodes=vis_scene_node_count(occluders);if(occluders){vis_scene_release(occluders);occluders=NULL;}
 unsigned long long append_ns=ns()-append_start;
 if(ayatsuri_model_instance_dispose(&ins,&owner,1))return fail("dispose");memset(arena,0xa5,ab);memset(data,0xa5,(size_t)bytes);free(arena);free(data);memset(&disks,0xa5,sizeof disks);
 char path[4096];snprintf(path,sizeof path,"%s.u16le",argv[2]);FILE *c=fopen(path,"wb");snprintf(path,sizeof path,"%s.f32le",argv[2]);FILE *d=fopen(path,"wb");if(!c||!d)return fail("output");
 uint16_t color[240*8];float z[240*8];unsigned long long render_ns=0;ksn_mesh_pixel_stats stats={0};
 for(unsigned y=0;y<135;y+=8){unsigned h=135-y<8?135-y:8;memset(color,0,sizeof color);unsigned long long begin=ns();if(!(transportmode?fox_transport_render(&tx,&px,color,y,h,z,8,&stats):visibility?fox_pixel_render_bound(&binding,generation,&px,color,y,h,z,8,&stats,&budget):pixel?ksn_mesh_pixel_render(&px,color,y,h,z,8,&stats):ksn_mesh_render(s,color,y,h,z,8)))return fail("render");render_ns+=ns()-begin;for(unsigned j=0;j<240*h;j++)if(isnan(z[j])||z[j]==INFINITY)return fail("nonfinite-depth");if(fwrite(color,2,240*h,c)!=240*h||fwrite(z,4,240*h,d)!=240*h)return fail("write");}fclose(c);fclose(d);
 printf("{\"transportMode\":%u,\"transportComplete\":true,\"outerSamples\":%u,\"innerSamples\":%u,\"materialGeneration\":%u,\"materialFingerprint\":\"%016llx\",\"transportSceneBytes\":%zu,\"transportTemporaryBytes\":%zu,\"transportContextBytes\":%zu,\"transportBudgetBytes\":%zu,\"transportBuildNs\":%llu,\"transportRays\":%llu,\"transportNodeVisits\":%llu,\"transportTriangleTests\":%llu,\"transportRayLimit\":20000000,\"transportNodeLimit\":800000000,\"transportTriangleLimit\":300000000,\"transportSceneLimit\":262144,",transportmode,outer,inner,transportmode?1:0,(unsigned long long)material_digest,transport_bytes,transport_temp,sizeof tx,sizeof transport_budget,transport_build_ns,(unsigned long long)transport_budget.used.rays,(unsigned long long)transport_budget.used.node_visits,(unsigned long long)transport_budget.used.triangle_tests);
#define COUNT(name) printf("\"" #name "\":%llu,",(unsigned long long)tx.counters.name);
 COUNT(primary_rays) COUNT(primary_hits) COUNT(primary_misses) COUNT(secondary_world_rays) COUNT(primary_direct_queries) COUNT(secondary_direct_queries) COUNT(zero_reflection_ns_v) COUNT(back_single_discard) COUNT(grazing_ng_v)
#undef COUNT
 bounce_binding_clear(&tx.binding);
 printf("\"visibilityGeneration\":[%u,%u,%u],\"visibilityGeometryFingerprint\":\"%016llx\",\"visibilitySnapshotFingerprint\":\"%016llx\",\"visibilityBindingBytes\":%zu,\"visibilityBudgetBytes\":%zu,",visibility?1:0,visibility?1:0,visibility?1:0,(unsigned long long)geometry_digest,(unsigned long long)binding.snapshot_hash,sizeof binding,sizeof budget);
 printf("\"visibilityEnabled\":%s,\"visibilityComplete\":true,\"visibilitySceneBytes\":%zu,\"visibilitySceneNodes\":%zu,\"visibilityTriangles\":%zu,\"visibilityVertices\":%zu,\"visibilityBuildNs\":%llu,\"visibilityTemporaryBytes\":%zu,\"visibilityRays\":%llu,\"visibilityNodeVisits\":%llu,\"visibilityTriangleTests\":%llu,\"visibilityRayLimit\":1000000,\"visibilityNodeLimit\":100000000,\"visibilityTriangleLimit\":50000000,\"visibilitySceneLimit\":524288,",visibility?"true":"false",scene_bytes,scene_nodes,occluder_triangles,occluder_vertices,build_ns,temporary_bytes,(unsigned long long)budget.used.rays,(unsigned long long)budget.used.node_visits,(unsigned long long)budget.used.triangle_tests);fox_pixel_unbind(&binding);
 printf("\"pixelLightEnabled\":%s,\"agxProfileEnabled\":false,\"shadeUpdates\":%llu,\"diskSamples\":%llu,\"snapshotControlBytes\":%zu,\"rawFieldScratchBytes\":%zu,\"appendNs\":%llu,",pixel?"true":"false",(unsigned long long)stats.shade_updates,(unsigned long long)stats.disk_samples,pixel?sizeof px:sizeof legacy,sizeof(ayatsuri_model_pixel_mesh_view),append_ns);
 printf("\"physicalDiskEnabled\":%s,\"linearLightEnabled\":%s,\"instanceControlBytes\":%zu,\"records\":%u,\"logicalMeshes\":%u,\"evaluateNs\":%llu,\"camera\":[",physical?"true":"false",enabled?"true":"false",sizeof ins,s->packets.packets,count,eval_ns);for(int i=0;i<9;i++)printf("%s%.9g",i?",":"",cam[i]);printf("],\"light\":[");for(int i=0;i<6;i++)printf("%s%.9g",i?",":"",light[i]);printf("],\"coldBytes\":%ld,\"arenaBytes64bit\":%zu,\"snapshotBytes\":%zu,\"work\":%u,\"hostRenderNsFirstFrame\":%llu,\"depthScratchBytes\":7680,\"colorBandBytes\":3840,\"snapshotCapacity\":65536,\"disposedBeforeRender\":true,\"reverse\":%s}\n",bytes,ab,s->packets.size+(pixel?416:0),s->work,render_ns,reverse?"true":"false");return 0;
}
