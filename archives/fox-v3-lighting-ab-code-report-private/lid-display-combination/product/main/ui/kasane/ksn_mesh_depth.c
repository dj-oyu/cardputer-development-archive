#include "ksn_mesh_depth.h"
#include "ayatsuri/ayatsuri_shade.h"
#include <float.h>
#include <math.h>
#include <string.h>
#include <limits.h>
/* Host diagnostic only: one process, one frame. Static zero background. */
static double fox_combined_observer[135*240*3];
const double *fox_combined_observer_data(void){return fox_combined_observer;}
static bool mesh_span_valid(const void *p,size_t n){return p&&n<=UINTPTR_MAX-(uintptr_t)p;}
static bool mesh_overlap(const void *a,size_t an,const void *b,size_t bn){
    uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
    return an&&bn&&(x<=y?y-x<an:x-y<bn);
}
bool ksn_mesh_sided_run(const ksn_proc_gouraud_patch *source,const uint16_t *colors,
        const uint8_t bits[8],unsigned *cursor,ksn_proc_gouraud_patch *out){
    if(!source||!colors||!bits||!cursor||!out||source->header.vertices<3||source->header.vertices>32||
       !source->header.triangles||source->header.triangles>64||source->header.holes>2)return false;
    const size_t colors_bytes=4u*source->header.vertices;
    if(mesh_overlap(out,sizeof *out,source,sizeof *source)||mesh_overlap(out,sizeof *out,colors,colors_bytes)||
       mesh_overlap(out,sizeof *out,bits,8)||mesh_overlap(out,sizeof *out,cursor,sizeof *cursor)||
       mesh_overlap(cursor,sizeof *cursor,source,sizeof *source)||mesh_overlap(cursor,sizeof *cursor,colors,colors_bytes)||
       mesh_overlap(cursor,sizeof *cursor,bits,8)||*cursor>=source->header.triangles)return false;
    const unsigned first=*cursor;const bool back=(bits[first/8]>>(first%8))&1u;unsigned end=first+1;
    while(end<source->header.triangles&&(((bits[end/8]>>(end%8))&1u)!=0)==back)++end;
    *out=*source;out->header.triangles=(uint8_t)(end-first);
    memset(out->indices,0,sizeof out->indices);
    memcpy(out->indices,source->indices+3*first,3*(end-first)*sizeof out->indices[0]);
    if(back)for(unsigned j=0;j<source->header.vertices;j++){
        out->vertices[j].color_a=colors[2*j];out->vertices[j].color_b=colors[2*j+1];
    }
    *cursor=end;return true;
}
bool ksn_mesh_append(ksn_mesh_snapshot *s,const ksn_proc_gouraud_patch *p,const float *depth,uint16_t node){
    int l,t,r,b;unsigned cost;
    if(!s||!s->enabled||!p||!depth||p->header.holes||
       !ksn_proc_gouraud_bounds(p,&l,&t,&r,&b,&cost)||
       s->work>s->work_limit||cost>s->work_limit-s->work)return false;
    co_vertex vertices[CO_MAX_VERTICES];
    for(unsigned j=0;j<p->header.vertices;j++){
        const ksn_proc_gouraud_vertex *v=p->vertices+j;
        vertices[j]=(co_vertex){v->x,v->y,v->mask,depth[j],v->color_a,v->color_b};
    }
    co_input in={vertices,p->indices,node,p->header.vertices,p->header.triangles};
    if(!co_append(&s->packets,&in))return false;
    s->work+=cost;return true;
}
bool ksn_mesh_append_sided(ksn_mesh_snapshot *s,const ksn_proc_gouraud_patch *p,const float *depth,
        const uint16_t *colors,const uint8_t bits[8],uint16_t node){
    int l,t,r,b;unsigned cost;
    if(!s||!s->enabled||!p||!depth||!colors||!bits||p->header.holes||
       !ksn_proc_gouraud_bounds(p,&l,&t,&r,&b,&cost)||s->work>s->work_limit||cost>s->work_limit-s->work)return false;
    co_vertex vertices[CO_MAX_VERTICES];
    for(unsigned j=0;j<p->header.vertices;j++){
        const ksn_proc_gouraud_vertex *v=p->vertices+j;
        vertices[j]=(co_vertex){v->x,v->y,v->mask,depth[j],v->color_a,v->color_b};
    }
    co_sided_input in={{vertices,p->indices,node,p->header.vertices,p->header.triangles},colors,bits};
    if(!co_append_sided(&s->packets,&in))return false;
    s->work+=cost;return true;
}
_Static_assert(sizeof(FoxDiskScene)==408 && sizeof(double)==8,"pixel scene ABI");
static const uint8_t pixel_magic[8]={'K','S','P','X',1,0,0,0};
static void pixel_wd(uint8_t *p,double x){uint64_t u;memcpy(&u,&x,8);for(unsigned j=0;j<8;j++)p[j]=(uint8_t)(u>>(8*j));}
static double pixel_rd(const uint8_t *p){uint64_t u=0;for(unsigned j=0;j<8;j++)u|=(uint64_t)p[j]<<(8*j);double x;memcpy(&x,&u,8);return x;}
static bool pixel_scene(const ksn_mesh_pixel_snapshot *s,FoxDiskScene *out){
 if(!mesh_span_valid(s,sizeof *s)||!s->storage||s->capacity<416||s->capacity>65536||!mesh_span_valid(s->storage,s->capacity)||s->mesh.packets.packets>CO_MAX_PACKETS||!s->mesh.enabled||s->mesh.packets.data!=s->storage+416||s->mesh.packets.capacity!=s->capacity-416||s->mesh.packets.size>s->mesh.packets.capacity||s->mesh.work>s->mesh.work_limit||s->mesh.work_limit>8000000||mesh_overlap(s,sizeof *s,s->storage,s->capacity)||memcmp(s->storage,pixel_magic,8))return false;
 double d[51];for(unsigned j=0;j<51;j++)d[j]=pixel_rd(s->storage+8+8*j);memcpy(out,d,sizeof *out);return fox_disk_scene_validate(out)==FOX_DISK_OK;
}
bool ksn_mesh_pixel_begin(ksn_mesh_pixel_snapshot *out,void *storage,size_t capacity,const FoxDiskScene *scene,uint32_t work_limit){
 if(!mesh_span_valid(out,sizeof *out)||!storage||capacity<416||capacity>65536||!mesh_span_valid(storage,capacity)||!mesh_span_valid(scene,sizeof *scene)||!work_limit||work_limit>8000000||fox_disk_scene_validate(scene)!=FOX_DISK_OK||mesh_overlap(out,sizeof *out,storage,capacity)||mesh_overlap(scene,sizeof *scene,storage,capacity)||mesh_overlap(out,sizeof *out,scene,sizeof *scene))return false;
 /* Public contract: snapshot control, storage and input scene are disjoint. */
 uint8_t header[416];memcpy(header,pixel_magic,8);double d[51];memcpy(d,scene,sizeof d);for(unsigned j=0;j<51;j++)pixel_wd(header+8+8*j,d[j]);
 ksn_mesh_pixel_snapshot value={.mesh={.packets={.data=(uint8_t *)storage+416,.capacity=capacity-416},.work_limit=work_limit,.enabled=true},.storage=storage,.capacity=capacity};
 memcpy(storage,header,sizeof header);*out=value;return true;
}
static bool pixel_append(ksn_mesh_pixel_snapshot *s,const ksn_proc_gouraud_patch *p,const co_pixel_vertex *vertices,const uint8_t bits[8],uint16_t node,bool normal_pair){
 FoxDiskScene scene;int l,t,r,b;unsigned cost;
 if(!s||!mesh_span_valid(p,sizeof *p)||!vertices||!mesh_span_valid(bits,8)||!pixel_scene(s,&scene)||p->header.holes||!ksn_proc_gouraud_bounds(p,&l,&t,&r,&b,&cost)||s->mesh.work>s->mesh.work_limit||cost>(s->mesh.work_limit-s->mesh.work)/49u)return false;
 if(mesh_overlap(vertices,p->header.vertices*sizeof *vertices,s,sizeof *s)||mesh_overlap(p,sizeof *p,s,sizeof *s)||mesh_overlap(bits,8,s,sizeof *s)||mesh_overlap(vertices,p->header.vertices*sizeof *vertices,s->storage,s->capacity)||mesh_overlap(p,sizeof *p,s->storage,s->capacity)||mesh_overlap(bits,8,s->storage,s->capacity))return false;
 if(!mesh_span_valid(vertices,p->header.vertices*sizeof *vertices)||mesh_overlap(p,sizeof *p,vertices,p->header.vertices*sizeof *vertices)||mesh_overlap(p,sizeof *p,bits,8)||mesh_overlap(vertices,p->header.vertices*sizeof *vertices,bits,8))return false;
 for(unsigned j=0;j<p->header.vertices;j++)if(p->vertices[j].x!=vertices[j].front.x||p->vertices[j].y!=vertices[j].front.y||p->vertices[j].mask!=vertices[j].front.mask)return false;
 co_pixel_input in={vertices,p->indices,bits,node,p->header.vertices,p->header.triangles};
 if(!(normal_pair?co_append_pixel_normal_pair(&s->mesh.packets,&in):co_append_pixel(&s->mesh.packets,&in)))return false;
 s->mesh.work+=cost*49u;return true;
}
bool ksn_mesh_pixel_append(ksn_mesh_pixel_snapshot *s,const ksn_proc_gouraud_patch *p,const co_pixel_vertex *v,const uint8_t bits[8],uint16_t node){return pixel_append(s,p,v,bits,node,false);}
bool ksn_mesh_pixel_append_normal_pair(ksn_mesh_pixel_snapshot *s,const ksn_proc_gouraud_patch *p,const co_pixel_vertex *v,const uint8_t bits[8],uint16_t node){return pixel_append(s,p,v,bits,node,true);}
typedef struct {double a,b,c;int sign;bool closed;} gouraud_edge;
static gouraud_edge gouraud_make_edge(const co_vertex *a,const co_vertex *b){
    const double dx=(double)b->x-a->x,dy=(double)b->y-a->y;
    gouraud_edge edge={.sign=1,.closed=dy<0||(dy==0&&dx>0)};
    /* Both triangles evaluate a shared edge in the same canonical direction.
     * Reversing it only negates the result, including exact zero at ties. */
    if(a->x>b->x||(a->x==b->x&&a->y>b->y)){
        const co_vertex *swap=a;a=b;b=swap;edge.sign=-1;
    }
    edge.a=(double)a->y-b->y;edge.b=(double)b->x-a->x;
    edge.c=((double)b->y-a->y)*a->x-((double)b->x-a->x)*a->y;return edge;
}
static double gouraud_edge_value(const gouraud_edge *e,int x,int y){return e->sign*(e->a*x+e->b*y+e->c);}

static bool strip(const ksn_mesh_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *z,const FoxDiskScene *scene,ksn_mesh_pixel_stats *stats,FoxDiskVisibilityCallback visibility,void *visibility_context,FoxPixelShader shader,void *shader_context){
    for(unsigned j=0;j<height*KSN_PROC_W;j++)z[j]=-INFINITY;
    size_t offset=0;unsigned records=0;
    while(offset<s->packets.size){
        co_view view;if(!co_read(s->packets.data+offset,s->packets.size-offset,&view))return false;
        const bool pixel=view.mode==CO_MODE_PIXEL||view.mode==CO_MODE_PIXEL_NORMAL_PAIR;
        if((scene&&!pixel)||(!scene&&pixel))return false;
        if(scene&&++records>s->packets.packets)return false;
        for(unsigned face=0;face<view.triangle_count;face++){
            uint8_t indices[3];co_vertex v[3];co_pixel_vertex fields[3];
            if(!co_triangle_at(&view,face,indices))return false;
            bool back;if(!co_triangle_side(&view,face,&back))return false;
            for(unsigned j=0;j<3;j++){if(!co_vertex_at_side(&view,indices[j],back,v+j))return false;if(scene&&!co_pixel_vertex_at(&view,indices[j],fields+j))return false;}
            double area=((double)v[1].x-v[0].x)*((double)v[2].y-v[0].y)-((double)v[1].y-v[0].y)*((double)v[2].x-v[0].x);
            if(!(area>1e-5))return false;
            /* Match painter arithmetic exactly: division per weight can flip
             * the authored mask sign at a material boundary. */
            const double inverse=1/area;
            int left=(int)ceil(fmin(v[0].x,fmin(v[1].x,v[2].x))),right=(int)floor(fmax(v[0].x,fmax(v[1].x,v[2].x)));
            int top=(int)ceil(fmin(v[0].y,fmin(v[1].y,v[2].y))),bottom=(int)floor(fmax(v[0].y,fmax(v[1].y,v[2].y)));
            if(left<0)left=0;
            if(right>=KSN_PROC_W)right=KSN_PROC_W-1;
            if(top<(int)y)top=(int)y;
            if(bottom>=(int)(y+height))bottom=(int)(y+height)-1;
            const gouraud_edge edge[3]={gouraud_make_edge(v+1,v+2),gouraud_make_edge(v+2,v),gouraud_make_edge(v,v+1)};
            for(int yy=top;yy<=bottom;yy++)for(int x=left;x<=right;x++){
                double w[3];bool inside=true;
                for(unsigned k=0;k<3;k++){w[k]=gouraud_edge_value(edge+k,x,yy);if(w[k]<0||(w[k]==0&&!edge[k].closed))inside=false;}
                if(!inside)continue;
                for(unsigned k=0;k<3;k++)w[k]*=inverse;
                const float depth=(float)(w[0]*v[0].depth+w[1]*v[1].depth+w[2]*v[2].depth);
                if(!isfinite(depth))return false;
                const unsigned at=(unsigned)(yy-(int)y)*KSN_PROC_W+(unsigned)x;
                if(depth<=z[at])continue;
                z[at]=depth;
                const bool second=w[0]*v[0].mask+w[1]*v[1].mask+w[2]*v[2].mask>=0;
                const uint16_t a=second?v[0].color_b:v[0].color_a,b=second?v[1].color_b:v[1].color_a,c=second?v[2].color_b:v[2].color_a;
                if(scene){
                    double world[3]={0,0,0},normal[3]={0,0,0},rho[3]={0,0,0};const uint16_t codes[3]={a,b,c};
                    for(unsigned j=0;j<3;j++){
                        const int16_t *n=back?fields[j].normal_back:fields[j].normal_front;
                        const float decoded[3]={ayatsuri_srgb_decode((codes[j]>>11)/31.0f),ayatsuri_srgb_decode(((codes[j]>>5)&63)/63.0f),ayatsuri_srgb_decode((codes[j]&31)/31.0f)};
                        for(unsigned k=0;k<3;k++){world[k]+=w[j]*fields[j].world[k];normal[k]+=w[j]*(n[k]/32767.0);rho[k]+=w[j]*decoded[k];}
                    }
                    for(unsigned k=0;k<3;k++){if(!isfinite(rho[k])||rho[k]<-64*DBL_EPSILON||rho[k]>1+64*DBL_EPSILON)return false;rho[k]=fmax(0,fmin(1,rho[k]));}
                    const double position[3]={world[0]/38,-world[2]/38,-world[1]/38},nn[3]={normal[0],-normal[2],-normal[1]};double rgb[3];
                    if(shader){if(!shader(shader_context,scene,position,nn,rho,rgb))return false;}else if((visibility?fox_disk_eval16_visible(scene,position,nn,rho,visibility,visibility_context,rgb):fox_disk_eval16(scene,position,nn,rho,rgb))!=FOX_DISK_OK)return false;
                    /* Capture actual preclamp shader result; nearer winners overwrite. */
                    if(shader)for(unsigned k=0;k<3;k++)fox_combined_observer[((unsigned)yy*240+(unsigned)x)*3+k]=rgb[k];
                    unsigned q[3];for(unsigned k=0;k<3;k++){float value=ayatsuri_srgb_encode((float)fmin(1,rgb[k]));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
                    if(stats->shade_updates==UINT64_MAX||stats->disk_samples>UINT64_MAX-48)return false;
                    pixels[at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);stats->shade_updates++;stats->disk_samples+=48;continue;
                }
                const float cw[3]={(float)w[0],(float)w[1],(float)w[2]};
                const unsigned red=(unsigned)lroundf(fmaxf(0,fminf(31,cw[0]*(a>>11)+cw[1]*(b>>11)+cw[2]*(c>>11)))),
                    green=(unsigned)lroundf(fmaxf(0,fminf(63,cw[0]*((a>>5)&63)+cw[1]*((b>>5)&63)+cw[2]*((c>>5)&63)))),
                    blue=(unsigned)lroundf(fmaxf(0,fminf(31,cw[0]*(a&31)+cw[1]*(b&31)+cw[2]*(c&31))));
                pixels[at]=(uint16_t)((red<<11)|(green<<5)|blue);
            }
        }
        offset+=view.size;
    }
    return !scene||records==s->packets.packets;
}
bool ksn_mesh_render(const ksn_mesh_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows){
    if(!s||!s->enabled||!pixels||!scratch||(rows!=1&&rows!=8)||y>KSN_PROC_H||height>KSN_PROC_H-y)return false;
    for(unsigned at=0;at<height;at+=rows){unsigned n=height-at;if(n>rows)n=rows;
        if(!strip(s,pixels+at*KSN_PROC_W,y+at,n,scratch,NULL,NULL,NULL,NULL,NULL,NULL))return false;}
    return true;
}

static bool pixel_render_extended(const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats,FoxDiskVisibilityCallback visibility,void *visibility_context,FoxPixelShader shader,void *shader_context){
 FoxDiskScene scene;if(!s||!pixels||!scratch||!stats||(rows!=1&&rows!=8)||y>KSN_PROC_H||height>KSN_PROC_H-y||!pixel_scene(s,&scene))return false;
 if(mesh_overlap(pixels,(size_t)height*KSN_PROC_W*2,s->storage,s->capacity)||mesh_overlap(scratch,(size_t)rows*KSN_PROC_W*4,s->storage,s->capacity)||mesh_overlap(stats,sizeof *stats,s->storage,s->capacity)||mesh_overlap(pixels,(size_t)height*KSN_PROC_W*2,scratch,(size_t)rows*KSN_PROC_W*4)||mesh_overlap(pixels,(size_t)height*KSN_PROC_W*2,s,sizeof *s)||mesh_overlap(scratch,(size_t)rows*KSN_PROC_W*4,s,sizeof *s)||mesh_overlap(stats,sizeof *stats,s,sizeof *s)||mesh_overlap(stats,sizeof *stats,pixels,(size_t)height*KSN_PROC_W*2)||mesh_overlap(stats,sizeof *stats,scratch,(size_t)rows*KSN_PROC_W*4))return false;
 ksn_mesh_pixel_stats value=*stats;
 for(unsigned at=0;at<height;at+=rows){unsigned n=height-at;if(n>rows)n=rows;if(!strip(&s->mesh,pixels+at*KSN_PROC_W,y+at,n,scratch,&scene,&value,visibility,visibility_context,shader,shader_context))return false;}
 *stats=value;return true;
}

bool ksn_mesh_pixel_render(const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats){return ksn_mesh_pixel_render_visible(s,pixels,y,height,scratch,rows,stats,NULL,NULL);}

bool ksn_mesh_pixel_render_visible(const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats,FoxDiskVisibilityCallback visibility,void *context){return pixel_render_extended(s,pixels,y,height,scratch,rows,stats,visibility,context,NULL,NULL);}
bool ksn_mesh_pixel_render_shaded(const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats,FoxPixelShader shader,void *context){if(!shader)return false;return pixel_render_extended(s,pixels,y,height,scratch,rows,stats,NULL,NULL,shader,context);}
