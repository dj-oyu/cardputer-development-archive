#include "fox_idle.h"
#include "ayatsuri/ayatsuri_transform.h"
#include "breath_data.h"
#include <math.h>
#include <string.h>

static const uint32_t unused_colors[FOX_MODEL_NODES];
static const double unused_opacity[FOX_MODEL_NODES];
static const char *const mark_mesh_names[] = {
    "sticker-mesh:sweat:0", "sticker-mesh:sweat:1", "sticker-mesh:sweat:2",
    "sticker-mesh:confusion:3", "sticker-mesh:confusion:4", "sticker-mesh:confusion:5",
    "sticker-mesh:confusion:6", "sticker-mesh:confusion:7", "sticker-mesh:anger:8",
    "sticker-mesh:anger:9", "sticker-mesh:anger:10", "sticker-mesh:anger:11"};
static const char *const names[FOX_CONTROLLED] = {
    "obj:10 nose landmark", "obj:31 ear -1", "obj:31 ear 1",
    "obj:head87 clean base", "obj:R99 eye -1", "obj:R99 upper lid -1", "obj:R99 brow -1",
    "obj:R99 eye 1", "obj:R99 upper lid 1", "obj:R99 brow 1", "obj:R99 smile",
    "sticker:sweat", "sticker:confusion", "sticker:anger",
    "obj:Mass R01 chest", "obj:Mass R02 fore upper L", "obj:Mass R02 fore upper R"
};

static float smooth(float v) { return v*v*(3.f-2.f*v); }
fox_idle_values fox_idle_sample(uint64_t time_ms, int anchor_deg) {
    const uint32_t breathing = time_ms % 4000u, cycle = time_ms % 12000u;
    const uint32_t frame = (breathing*12u)/1000u;
    const float mix = (float)((breathing*12u)%1000u)/1000.f;
    float gaze = 0;
    /* 7.2 s idle, 650 ms in, 650 ms dwell, 850 ms out, 2.65 s idle. */
    if(cycle >= 7200u && cycle < 7850u) gaze=smooth((cycle-7200u)/650.f);
    else if(cycle >= 7850u && cycle < 8500u) gaze=1.f;
    else if(cycle >= 8500u && cycle < 9350u) gaze=1.f-smooth((cycle-8500u)/850.f);
    return (fox_idle_values){
        fox_breath_envelope[frame]+mix*(fox_breath_envelope[frame+1]-fox_breath_envelope[frame]),
        gaze*(float)anchor_deg*0.01745329251994329577f};
}

static ayatsuri_model_status read_named(ayatsuri_model_instance *i,const void *owner,uint32_t gen,
                                        const char *name,uint16_t *id,float out[9]){
    ayatsuri_model_status v=ayatsuri_model_find_node(i->model,name,strlen(name),id);
    return v==AYATSURI_MODEL_OK?ayatsuri_model_instance_read_pose(i,owner,gen,*id,out):v;
}
static bool matrix(const float p[9],const ayatsuri_transform *parent,ayatsuri_transform *o){
    ayatsuri_pose pose;
    memcpy(&pose,p,sizeof pose);
    return ayatsuri_transform_evaluate(&pose,parent,o)==AYATSURI_OK;
}
ayatsuri_model_status fox_idle_bind(fox_idle *s,ayatsuri_model_instance *i,
                                   const void *owner,uint32_t gen){
    if(!s || !i || !i->model || i->model->node_count!=FOX_MODEL_NODES)return AYATSURI_MODEL_INVALID;
    memset(s,0,sizeof *s);
    for(unsigned k=0;k<FOX_CONTROLLED;++k){
        ayatsuri_model_status v=read_named(i,owner,gen,names[k],&s->ids[k],s->base[k]);
        if(v!=AYATSURI_MODEL_OK)return v;
    }
    for(unsigned k=0;k<12;++k){
        ayatsuri_model_status v=ayatsuri_model_find_node(i->model,mark_mesh_names[k],
            strlen(mark_mesh_names[k]),&s->mark_mesh[k]);
        if(v!=AYATSURI_MODEL_OK)return v;
    }
    const char *path[]={"root","bone:trunk_hip_shoulder","bone:lumbar","bone:thorax","bone:neck_base_head"};
    ayatsuri_transform m[2];
    float p[9];uint16_t id;
    for(unsigned k=0;k<5;++k){
        ayatsuri_model_status v=read_named(i,owner,gen,path[k],&id,p);
        if(v!=AYATSURI_MODEL_OK)return v;
        if(!matrix(p,k?&m[(k-1)%2]:NULL,&m[k%2]))return AYATSURI_MODEL_INVALID;
    }
    /* v5 root basis is identity. Parent neck rotation is rigid (unit scale). */
    for(unsigned r=0;r<3;++r){
        s->pivot[r]=m[0].m[4*r+3];
        for(unsigned c=0;c<3;++c)s->neck_rotation[3*r+c]=m[0].m[4*r+c];
    }
    s->actor=i;s->owner=owner;s->generation=gen;
    s->count=i->model->node_count;
    return AYATSURI_MODEL_OK;
}

static void mul(const float a[9],const float b[9],float c[9]){
    for(unsigned r=0;r<3;++r)for(unsigned j=0;j<3;++j)
        c[3*r+j]=a[3*r]*b[j]+a[3*r+1]*b[j+3]+a[3*r+2]*b[j+6];
}
static void transpose(const float a[9],float out[9]){
    for(unsigned r=0;r<3;++r)for(unsigned c=0;c<3;++c)out[3*r+c]=a[3*c+r];
}
static void vector(const float a[9],const float p[3],float out[3]){
    for(unsigned r=0;r<3;++r)out[r]=a[3*r]*p[0]+a[3*r+1]*p[1]+a[3*r+2]*p[2];
}
static bool rotate_pose(float p[9],const float base[9],const float spin[9],const float pivot[3]){
    float d[3]={base[0]-pivot[0],base[1]-pivot[1],base[2]-pivot[2]}, rotated[3];
    ayatsuri_transform m;
    if(!matrix(base,NULL,&m))return false;
    float old[9], now[9];
    for(unsigned r=0;r<3;++r)for(unsigned c=0;c<3;++c)old[3*r+c]=m.m[4*r+c]/base[6+c];
    mul(spin,old,now);
    vector(spin,d,rotated);
    for(unsigned k=0;k<3;++k)p[k]=pivot[k]+rotated[k];
    const float sy=fminf(1.f,fmaxf(-1.f,-now[6]));
    p[4]=asinf(sy);
    if(fabsf(sy)>.999999f){p[3]=atan2f(-now[5],now[4]);p[5]=0;}
    else {p[3]=atan2f(now[7],now[8]);p[5]=atan2f(now[3],now[0]);}
    return true;
}

ayatsuri_model_status fox_idle_apply(fox_idle *s,ayatsuri_model_instance *i,
                                    const void *owner,uint32_t gen,uint64_t time_ms,int anchor_deg){
    if(!s||!i||!i->model||!s->count||i->model->node_count!=s->count||
       i!=s->actor||owner!=s->owner||gen!=s->generation||
       (anchor_deg!=35&&anchor_deg!=-35))return AYATSURI_MODEL_INVALID;
    fox_idle_values a=fox_idle_sample(time_ms,anchor_deg);
    /* Model +X camera yaw and the nose +Z use opposite handedness to Y-up coordinates. */
    const float cs=cosf(a.yaw_rad),sn=sinf(a.yaw_rad);
    float spin[9]={cs,0,sn,0,1,0,-sn,0,cs};
    float nt[9], temp[9], mark_spin[9], origin[3]={0};
    transpose(s->neck_rotation,nt);mul(spin,s->neck_rotation,temp);mul(nt,temp,mark_spin);
    static const float *const fit[]={fox_breath_chest,fox_breath_fore_left,fox_breath_fore_right};
    for(unsigned n=0;n<FOX_CONTROLLED;++n){
        const uint16_t id=s->ids[n];
        float *p=s->pose[id];const float *b=s->base[n];
        memcpy(p,b,9*sizeof(float));
        if(n<FOX_HEAD_GROUPS+FOX_MARKS){
            s->dirty[id]=AYATSURI_TARGET_POSITION|AYATSURI_TARGET_ROTATION;
            if(a.yaw_rad && !rotate_pose(p,b,n<FOX_HEAD_GROUPS?spin:mark_spin,n<FOX_HEAD_GROUPS?s->pivot:origin))
                return AYATSURI_MODEL_INVALID;
        }else{
            s->dirty[id]=AYATSURI_TARGET_POSITION|AYATSURI_TARGET_SCALE;
            const float *f=fit[n-FOX_HEAD_GROUPS-FOX_MARKS];
            if(a.breath){
                ayatsuri_transform m;
                if(!matrix(b,NULL,&m))return AYATSURI_MODEL_INVALID;
                for(unsigned r=0;r<3;++r)
                    p[r]+=a.breath*(m.m[4*r]*f[3]+m.m[4*r+1]*f[4]+m.m[4*r+2]*f[5]);
                for(unsigned k=0;k<3;++k)p[6+k]*=1.f+a.breath*f[k];
            }
        }
    }
    const ayatsuri_model_targets t={.dirty=s->dirty,.pose=&s->pose[0][0],.count=s->count,.color=unused_colors,.opacity=unused_opacity};
    return ayatsuri_model_instance_targets(i,owner,gen,&t);
}

ayatsuri_model_status fox_idle_mark(const fox_idle *s, ayatsuri_model_instance *i,
                                   const void *owner, uint32_t gen, int selection){
    if(!s||!i||!s->count||i!=s->actor||owner!=s->owner||gen!=s->generation||
       selection < -1||selection >= FOX_MARKS)return AYATSURI_MODEL_INVALID;
    uint8_t dirty[FOX_MODEL_NODES]={0};
    for(unsigned n=0;n<FOX_MARKS;++n)
        dirty[s->ids[FOX_HEAD_GROUPS+n]]=selection==(int)n?AYATSURI_TARGET_VISIBLE:AYATSURI_TARGET_HIDDEN;
    for(unsigned n=0;n<12;++n){
        const int m=n<3?0:n<8?1:2;
        dirty[s->mark_mesh[n]]=selection==m?AYATSURI_TARGET_VISIBLE:AYATSURI_TARGET_HIDDEN;
    }
    const ayatsuri_model_targets t={.dirty=dirty,.pose=&s->pose[0][0],.count=s->count,
                                    .color=unused_colors,.opacity=unused_opacity};
    return ayatsuri_model_instance_targets(i,owner,gen,&t);
}
