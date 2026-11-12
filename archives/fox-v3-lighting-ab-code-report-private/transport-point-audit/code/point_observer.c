#include "point_observer.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
bounce_result point_last_result;
vis_counters point_last_direct,point_last_transport;
point_query point_queries[240*135];
typedef struct {unsigned used,nv,nt,source_nt;uint16_t indices[192],source_indices[192];double world[96];} point_mapping;
static point_mapping maps[256];
bool point_capture(unsigned x,unsigned y,unsigned node,unsigned face,bool back,bool second,const uint8_t ix[3],const double w[3],const double p[3],const double n[3],const double rho[3],const double rgb[3],const co_pixel_vertex fields[3]){
 if(x>=240||y>=135||node>=256||memcmp(rgb,point_last_result.combined,3*sizeof(double)))return false;
 for(unsigned k=0;k<3;k++)if(!isfinite(p[k])||!isfinite(n[k])||!isfinite(rho[k])||!isfinite(rgb[k]))return false;
 point_query *q=point_queries+y*240+x;*q=(point_query){.covered=1,.node=node,.face=face,.back=back,.second=second,.result=point_last_result,.direct=point_last_direct,.transport=point_last_transport};
 memcpy(q->indices,ix,sizeof q->indices);memcpy(q->weights,w,sizeof q->weights);memcpy(q->position,p,sizeof q->position);memcpy(q->normal,n,sizeof q->normal);memcpy(q->rho,rho,sizeof q->rho);memcpy(q->rgb,rgb,sizeof q->rgb);memcpy(q->vertices,fields,sizeof q->vertices);return true;
}
bool point_map(unsigned node,const ksn_proc_gouraud_patch *p,const ayatsuri_model_world_mesh_view *v){
 if(p->header.vertices!=v->vertex_count)return false;
 if(node>=256||p->header.vertices>32||p->header.triangles>64||v->vertex_count>32||v->triangle_count>64)return false;
 point_mapping *m=maps+node;m->used=1;m->nv=p->header.vertices;m->nt=p->header.triangles;m->source_nt=v->triangle_count;memcpy(m->indices,p->indices,3*m->nt*sizeof(uint16_t));memcpy(m->source_indices,v->indices,3*m->source_nt*sizeof(uint16_t));memcpy(m->world,v->world,3*v->vertex_count*sizeof(double));return true;
}
static void doubles(FILE *f,const double *p,unsigned n){fputc('[',f);for(unsigned k=0;k<n;k++)fprintf(f,"%s%.17g",k?",":"",p[k]);fputc(']',f);}
static void vc(FILE *f,vis_counters c){fprintf(f,"[ %llu,%llu,%llu ]",(unsigned long long)c.rays,(unsigned long long)c.node_visits,(unsigned long long)c.triangle_tests);}
bool point_dump(const char *prefix){
 char path[4096];snprintf(path,sizeof path,"%s-winners.json",prefix);FILE *f=fopen(path,"w");if(!f)return false;
 fprintf(f,"{\"version\":\"actual-final-winner-v1\",\"width\":240,\"height\":135,\"queryStructBytes\":%zu,\"observerStaticBytes\":%zu,\"points\":[",sizeof(point_query),sizeof point_queries+sizeof maps+sizeof point_last_result+sizeof point_last_direct+sizeof point_last_transport);unsigned count=0;
 for(unsigned i=0;i<240*135;i++){point_query *q=point_queries+i;if(!q->covered)continue;fprintf(f,"%s{\"x\":%u,\"y\":%u,\"node\":%u,\"face\":%u,\"back\":%u,\"second\":%u,\"indices\":[%u,%u,%u],\"weights\":",count++?",":"",i%240,i/240,q->node,q->face,q->back,q->second,q->indices[0],q->indices[1],q->indices[2]);doubles(f,q->weights,3);fputs(",\"position\":",f);doubles(f,q->position,3);fputs(",\"normal\":",f);doubles(f,q->normal,3);fputs(",\"rho\":",f);doubles(f,q->rho,3);fputs(",\"rgb\":",f);doubles(f,q->rgb,3);fputs(",\"vertices\":[",f);
  for(unsigned j=0;j<3;j++){co_pixel_vertex *v=q->vertices+j;fprintf(f,"%s{\"world\":",j?",":"");doubles(f,v->world,3);fprintf(f,",\"mask\":%.9g,\"colors\":[%u,%u],\"front\":[%d,%d,%d],\"back\":[%d,%d,%d]}",v->front.mask,v->front.color_a,v->front.color_b,v->normal_front[0],v->normal_front[1],v->normal_front[2],v->normal_back[0],v->normal_back[1],v->normal_back[2]);}fputs("],\"direct\":",f);doubles(f,q->result.direct,3);fputs(",\"world\":",f);doubles(f,q->result.world,3);fputs(",\"bounce\":",f);doubles(f,q->result.bounce,3);fputs(",\"ground\":",f);doubles(f,q->result.ground,3);fputs(",\"counters\":[",f);
  uint64_t c[sizeof q->result.counters/sizeof(uint64_t)];memcpy(c,&q->result.counters,sizeof c);for(unsigned j=0;j<sizeof q->result.counters/sizeof(uint64_t);j++)fprintf(f,"%s%llu",j?",":"",(unsigned long long)c[j]);fputs("],\"directQueryWork\":",f);vc(f,q->direct);fputs(",\"transportQueryWork\":",f);vc(f,q->transport);fputc('}',f);
 }
 fputs("]}",f);if(fclose(f))return false;
 snprintf(path,sizeof path,"%s-mapping.json",prefix);f=fopen(path,"w");if(!f)return false;fputs("[",f);count=0;
 for(unsigned id=0;id<256;id++){point_mapping *m=maps+id;if(!m->used)continue;fprintf(f,"%s{\"node\":%u,\"vertices\":%u,\"triangles\":%u,\"sourceTriangles\":%u,\"patchIndices\":[",count++?",":"",id,m->nv,m->nt,m->source_nt);for(unsigned j=0;j<3*m->nt;j++)fprintf(f,"%s%u",j?",":"",m->indices[j]);fputs("],\"sourceIndices\":[",f);for(unsigned j=0;j<3*m->source_nt;j++)fprintf(f,"%s%u",j?",":"",m->source_indices[j]);fputs("],\"sourceWorld\":",f);doubles(f,m->world,3*m->nv);fputc('}',f);}fputc(']',f);if(fclose(f))return false;
 snprintf(path,sizeof path,"%s-combined.f64le",prefix);f=fopen(path,"wb");if(!f)return false;for(unsigned i=0;i<240*135;i++)if(fwrite(point_queries[i].rgb,sizeof(double),3,f)!=3)return false;return fclose(f)==0;
}
