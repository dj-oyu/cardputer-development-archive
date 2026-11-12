extern unsigned long budget_triangles,budget_batches;
#include "scene.h"
#include "alpha_raster.h"
#include <assert.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include "/workspace/scratch/6d8dcdbcdc54/fox-transfer-20261111/audit-extracted/fox-private-target-source/fox-rig-repair-private-20261107/integrated/scene.inc"
#include "/workspace/scratch/6d8dcdbcdc54/fox-transfer-20261111/audit-extracted/fox-private-target-source/fox-rig-repair-private-20261107/rig/native_rig.h"
#include "/workspace/scratch/6d8dcdbcdc54/fox-transfer-20261111/audit-extracted/fox-private-target-source/fox-rig-repair-private-20261107/rig/rig_mapping.h"
static const float controls[8][2]={{0,0},{-1,-.5},{-1,.5},{1,-.5},{1,.5},{0,1},{0,-1},{.4,.3}};
bool stream_accumulate(const ksn_mesh_prepared*,uint16_t*,unsigned,unsigned,float*);
static bool overlaps(const void*a,size_t an,const void*b,size_t bn){uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;return an&&bn&&(x<=y?y-x<an:x-y<bn);}
static double ms(clock_t t){return 1000.*(clock()-t)/CLOCKS_PER_SEC;}
static double area(const scene_frame*f,unsigned i){const scene_triangle*t=source_triangles+i;const float*a=f->projected[t->v[0]],*b=f->projected[t->v[1]],*c=f->projected[t->v[2]];return ((double)b[0]-a[0])*((double)c[1]-a[1])-((double)b[1]-a[1])*((double)c[0]-a[0]);}
static void tri(const scene_frame*f,unsigned i,co_vertex out[3]){const scene_triangle*t=source_triangles+i;for(unsigned k=0;k<3;k++){const float*p=f->projected[t->v[k]];uint16_t c=diagnostic_colors[t->material];out[k]=(co_vertex){p[0],p[1],1,p[2],c,c};}if(area(f,i)<0){co_vertex v=out[1];out[1]=out[2];out[2]=v;}}
bool fox_scene_prepare_local(const scene_frame*ready,scene_frame*p,scene_workspace*w,int pose,unsigned cam,int fail,scene_times*timing,const float (*evaluated_local)[3]){
 if(!p||!w||!timing||pose< -1||pose>=8||cam>3||overlaps(timing,sizeof *timing,p,sizeof *p)||overlaps(timing,sizeof *timing,w,sizeof *w)||(ready&&overlaps(timing,sizeof *timing,ready,sizeof *ready))||overlaps(p,sizeof *p,w,sizeof *w)||(ready&&(overlaps(ready,sizeof *ready,p,sizeof *p)||overlaps(ready,sizeof *ready,w,sizeof *w))))return false;
 *timing=(scene_times){0};float delta[12];clock_t t=clock();if(pose>=0){if(!native_rig(controls[pose][0],controls[pose][1],w->rig.palette,delta)||ayatsuri_skin_evaluate_method(AYATSURI_SKIN_METHOD_RIGID_DQ,w->rig.palette,2,unique_skin,229,w->rig.temp.dq)!=AYATSURI_OK)return false;for(unsigned i=0;i<229;i++)memcpy(w->rig.pos[i],w->rig.temp.dq[i].position,12);if(ayatsuri_recompute_smooth_normals(AYATSURI_NORMAL_ALL_SMOOTH_TRIANGLES,w->rig.pos,229,body_topology,454,w->rig.temp.sum,w->rig.normals)!=AYATSURI_OK)return false;}timing->rig_ms=ms(t);t=clock();
 memset(p,0,sizeof *p);p->pose=pose;p->camera=cam;
 for(unsigned i=0;i<SCENE_VERTICES;i++){if(fail>=0&&i==(unsigned)fail)return false;const scene_vertex*v=source_vertices+i;float local[3]={v->x,v->y,v->z};if(evaluated_local)memcpy(local,evaluated_local[i],12);if(pose>=0&&i<229)memcpy(local,w->rig.pos[i],12);const float*m=source_world[v->object];float X=(float)((double)m[0]*local[0]+(double)m[1]*local[1]+(double)m[2]*local[2]+m[3]),Y=(float)((double)m[4]*local[0]+(double)m[5]*local[1]+(double)m[6]*local[2]+m[7]),Z=(float)((double)m[8]*local[0]+(double)m[9]*local[1]+(double)m[10]*local[2]+m[11]);if(pose>=0&&head_object[v->object]){float in[3]={X,Y,Z},out[3];native_apply(delta,in,out);X=out[0];Y=out[1];Z=out[2];}float sx=(cam==0||cam==3)?X:cam==1?(float)((X+Y)*.7071067811865475244):Y;float d=(cam==0||cam==3)?-Y:cam==1?(float)((X-Y)*.7071067811865475244):X;p->projected[i][0]=cam==3?120+90*sx:120+25*sx;p->projected[i][1]=cam==3?67.5f-90*(Z-2.6f):108-25*Z;p->projected[i][2]=d;for(unsigned k=0;k<3;k++)if(!isfinite(p->projected[i][k])||fabsf(p->projected[i][k])>4096)return false;
 }timing->project_ms=ms(t);t=clock();
 for(unsigned i=0;i<SCENE_TRIANGLES;i++){double a=area(p,i);if(a==0){p->zero_area++;continue;}if(fabs(a)<=1e-5){p->tiny_area++;continue;}const scene_triangle*q=source_triangles+i;const float*a0=p->projected[q->v[0]],*a1=p->projected[q->v[1]],*a2=p->projected[q->v[2]];int x0=(int)ceil(fmin(a0[0],fmin(a1[0],a2[0]))),x1=(int)floor(fmax(a0[0],fmax(a1[0],a2[0]))),y0=(int)ceil(fmin(a0[1],fmin(a1[1],a2[1]))),y1=(int)floor(fmax(a0[1],fmax(a1[1],a2[1])));if(x1<0||x0>239||y1<0||y0>134||x0>x1||y0>y1)continue;if(y0<0)y0=0;if(y1>134)y1=134;for(unsigned b=(unsigned)y0/4;b<=(unsigned)y1/4;b++)p->bins[b][i/64]|=UINT64_C(1)<<(i%64);p->active++;
 }timing->index_ms=ms(t);p->valid=true;return true;
}
typedef struct { const scene_frame *frame; const unsigned *ids; fox_fragment_fn callback; void *user; const float (*local)[3]; } mask_context;
static double shade_fragment(void *opaque,unsigned face,const double weight[3],int x,int y,float depth) {
 mask_context *ctx=opaque; unsigned id=ctx->ids[face]; const scene_triangle *t=source_triangles+id;
 unsigned ix[3]={t->v[0],t->v[1],t->v[2]};
 if(area(ctx->frame,id)<0){unsigned tmp=ix[1];ix[1]=ix[2];ix[2]=tmp;}
 fox_fragment f={.triangle=id,.material=t->material,.object=source_vertices[ix[0]].object,.x=x,.y=y,.depth=depth};
 for(unsigned k=0;k<3;k++) {const scene_vertex *v=source_vertices+ix[k];
  if(v->object!=f.object)return NAN;
  f.local[0]+=weight[k]*(ctx->local?ctx->local[ix[k]][0]:v->x); f.local[1]+=weight[k]*(ctx->local?ctx->local[ix[k]][1]:v->y); f.local[2]+=weight[k]*(ctx->local?ctx->local[ix[k]][2]:v->z);
 }
 /* Object coordinates for rigid attached eye meshes: head transform affects both
    mesh and object world, so inverse evaluated world recovers these local values.
    This is NOT a general deformed-body Object-coordinate evaluator. */
 return ctx->callback(ctx->user,&f);
}
static bool flush(scene_workspace*w,ksn_mesh_snapshot*s,unsigned y,unsigned rows,int fail,unsigned *batch,mask_context *ctx){if(!s->packets.packets)return true;if(fail>=0&&(*batch)==(unsigned)fail)return false;ksn_mesh_prepared*p=(void*)w->raster.prep;if(!ksn_mesh_prepare(s,p,sizeof w->raster.prep)||!fox_accumulate_samples(p,w->raster.pixels,y,rows,w->raster.depth,ctx->callback?shade_fragment:NULL,ctx))return false;budget_batches++;(*batch)++;s->packets.size=0;s->packets.packets=0;return true;}
bool fox_scene_band_local(const scene_frame*f,uint16_t*out,unsigned y,unsigned rows,unsigned limit,scene_workspace*w,int fail,fox_fragment_fn callback,void *user,const float (*evaluated_local)[3]){
 if(!f||!f->valid||!out||!w||!rows||rows>4||y>135||y%4||rows>135-y||limit<10||limit>30||limit%10||overlaps(f,sizeof *f,w,sizeof *w)||overlaps(f,sizeof *f,out,rows*240*2)||overlaps(w,sizeof *w,out,rows*240*2))return false;
 memcpy(w->raster.pixels,out,rows*240*2);for(unsigned i=0;i<rows*240;i++)w->raster.depth[i]=-INFINITY;ksn_mesh_snapshot s={.packets={.data=w->raster.packets,.capacity=sizeof w->raster.packets},.enabled=true};unsigned vertices=0,tris=0,batches=0, ids[30], id_count=0; mask_context ctx={f,ids,callback,user,evaluated_local};
 for(unsigned word=0;word<SCENE_WORDS;word++){uint64_t bits=f->bins[y/4][word];while(bits){unsigned b=(unsigned)__builtin_ctzll(bits);bits&=bits-1;unsigned id=word*64+b;if(id>=SCENE_TRIANGLES)return false;budget_triangles++;ids[id_count++]=id;tri(f,id,w->raster.vertices+vertices);vertices+=3;for(unsigned j=vertices-3;j<vertices;j++)w->raster.indices[j]=(uint16_t)j;if(vertices==30){co_input in={w->raster.vertices,w->raster.indices,0,30,10};if(!co_append(&s.packets,&in))return false;vertices=0;tris+=10;if(tris==limit){if(!flush(w,&s,y,rows,fail,&batches,&ctx))return false;tris=0;id_count=0;}}}}
 if(vertices){co_input in={w->raster.vertices,w->raster.indices,0,(uint8_t)vertices,(uint8_t)(vertices/3)};if(!co_append(&s.packets,&in))return false;}if(!flush(w,&s,y,rows,fail,&batches,&ctx))return false;memcpy(out,w->raster.pixels,rows*240*2);return true;
}
bool scene_reference(const scene_frame*f,ksn_mesh_snapshot*s){co_vertex v[30];uint16_t ix[30];unsigned n=0;for(unsigned i=0;i<SCENE_TRIANGLES;i++){if(fabs(area(f,i))<=1e-5)continue;tri(f,i,v+n);for(unsigned k=n;k<n+3;k++)ix[k]=(uint16_t)k;n+=3;if(n==30){co_input in={v,ix,0,30,10};if(!co_append(&s->packets,&in))return false;n=0;}}if(n){co_input in={v,ix,0,(uint8_t)n,(uint8_t)(n/3)};if(!co_append(&s->packets,&in))return false;}return true;}
size_t scene_constant_bytes(void){return sizeof source_vertices+sizeof source_triangles+sizeof source_world+sizeof diagnostic_colors+sizeof unique_skin+sizeof body_topology+sizeof head_object;}
size_t scene_pose_fixture_bytes(void){return sizeof controls;}

bool scene_band(const scene_frame*f,uint16_t*out,unsigned y,unsigned rows,unsigned limit,scene_workspace*w,int fail){return fox_scene_band(f,out,y,rows,limit,w,fail,NULL,NULL);}

bool scene_prepare(const scene_frame*r,scene_frame*p,scene_workspace*w,int pose,unsigned cam,int fail,scene_times*t){return fox_scene_prepare_local(r,p,w,pose,cam,fail,t,NULL);}
bool fox_scene_band(const scene_frame*f,uint16_t*out,unsigned y,unsigned rows,unsigned limit,scene_workspace*w,int fail,fox_fragment_fn cb,void*u){return fox_scene_band_local(f,out,y,rows,limit,w,fail,cb,u,NULL);}
