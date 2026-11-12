#include "../../fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.h"

#include <math.h>
#include <string.h>

#define PI 3.141592653589793238462643383279502884

/* 2 equal-area radial strata x 8 azimuths. Generated from the documented
 * formula, no scene-dependent fitting. 16 x 2 x sizeof(double) = 256 bytes.
 */
static const double disk16[16][2] = {
    { 0.50000000000000000,  0.00000000000000000},
    { 0.35355339059327379,  0.35355339059327373},
    { 0.00000000000000000,  0.50000000000000000},
    {-0.35355339059327373,  0.35355339059327379},
    {-0.50000000000000000,  0.00000000000000000},
    {-0.35355339059327384, -0.35355339059327373},
    { 0.00000000000000000, -0.50000000000000000},
    { 0.35355339059327368, -0.35355339059327384},
    { 0.80010314519126557,  0.33141357403559180},
    { 0.33141357403559185,  0.80010314519126546},
    {-0.33141357403559174,  0.80010314519126557},
    {-0.80010314519126546,  0.33141357403559191},
    {-0.80010314519126557, -0.33141357403559168},
    {-0.33141357403559224, -0.80010314519126524},
    { 0.33141357403559196, -0.80010314519126546},
    { 0.80010314519126524, -0.33141357403559230}
};

static int finite3(const double a[3]) {
    return isfinite(a[0]) && isfinite(a[1]) && isfinite(a[2]);
}
static double dot3(const double a[3], const double b[3]) {
    return a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
}
static int nonnegative3(const double a[3]) {
    return finite3(a) && a[0]>=0 && a[1]>=0 && a[2]>=0;
}
static int unit3(const double a[3]) {
    return finite3(a) && fabs(dot3(a,a)-1.0) <= 1e-10;
}
static int normalize3(const double a[3], double out[3]) {
    double scale, length;
    unsigned k;
    if (!finite3(a)) return 0;
    scale = fmax(fabs(a[0]), fmax(fabs(a[1]), fabs(a[2])));
    if (!(scale > 0)) return 0;
    for (k=0;k<3;k++) out[k]=a[k]/scale;
    length = sqrt(dot3(out,out));
    for (k=0;k<3;k++) out[k]/=length;
    return finite3(out);
}

FoxDiskStatus fox_disk_scene_validate(const FoxDiskScene *scene) {
    unsigned j;
    if (!scene) return FOX_DISK_BAD_ARGUMENT;
    if (!nonnegative3(scene->world_radiance)) return FOX_DISK_INVALID_INPUT;
    for (j=0;j<FOX_DISK_LIGHT_COUNT;j++) {
        const FoxDiskLight *l=&scene->lights[j];
        if (!finite3(l->center) || !unit3(l->normal) || !unit3(l->axis_u) ||
            !unit3(l->axis_v) || fabs(dot3(l->normal,l->axis_u))>1e-10 ||
            fabs(dot3(l->normal,l->axis_v))>1e-10 ||
            fabs(dot3(l->axis_u,l->axis_v))>1e-10 ||
            !nonnegative3(l->power_rgb_over_pi_squared) ||
            !isfinite(l->radius) || !(l->radius>0))
            return FOX_DISK_INVALID_INPUT;
    }
    return FOX_DISK_OK;
}

FoxDiskStatus fox_disk_scene_init(FoxDiskScene *out,
    const FoxDiskLightInput inputs[FOX_DISK_LIGHT_COUNT],
    const double world_rgb[3], double world_strength) {
    FoxDiskScene tmp;
    unsigned j,k;
    if (!out || !inputs || !world_rgb) return FOX_DISK_BAD_ARGUMENT;
    if (!nonnegative3(world_rgb) || !isfinite(world_strength) || world_strength<0)
        return FOX_DISK_INVALID_INPUT;
    memset(&tmp,0,sizeof(tmp));
    for (k=0;k<3;k++) {
        tmp.world_radiance[k]=world_rgb[k]*world_strength;
        if (!isfinite(tmp.world_radiance[k])) return FOX_DISK_NUMERIC_RANGE;
    }
    for (j=0;j<FOX_DISK_LIGHT_COUNT;j++) {
        const FoxDiskLightInput *in=&inputs[j];
        FoxDiskLight *l=&tmp.lights[j];
        double sx,cx,sy,cy,sz,cz;
        if (in->shape!=FOX_DISK_SHAPE_DISK) return FOX_DISK_UNSUPPORTED_SHAPE;
        if (!finite3(in->center) || !finite3(in->rotation_xyz) ||
            !nonnegative3(in->color) || !isfinite(in->power) || in->power<=0 ||
            !isfinite(in->diameter) || in->diameter<=0)
            return FOX_DISK_INVALID_INPUT;
        l->radius=0.5*in->diameter;
        if (!(l->radius>0)) return FOX_DISK_NUMERIC_RANGE;
        sx=sin(in->rotation_xyz[0]); cx=cos(in->rotation_xyz[0]);
        sy=sin(in->rotation_xyz[1]); cy=cos(in->rotation_xyz[1]);
        sz=sin(in->rotation_xyz[2]); cz=cos(in->rotation_xyz[2]);
        /* Explicit matrix columns, emitted normal = R * (0,0,-1).
         * axis_u cross axis_v = -normal for this local source convention.
         */
        l->axis_u[0]=cz*cy; l->axis_u[1]=sz*cy; l->axis_u[2]=-sy;
        l->axis_v[0]=cz*sy*sx-sz*cx;
        l->axis_v[1]=sz*sy*sx+cz*cx; l->axis_v[2]=cy*sx;
        l->normal[0]=-(cz*sy*cx+sz*sx);
        l->normal[1]=-(sz*sy*cx-cz*sx); l->normal[2]=-cy*cx;
        for (k=0;k<3;k++) {
            l->center[k]=in->center[k];
            l->power_rgb_over_pi_squared[k]=(in->power/(PI*PI))*in->color[k];
            if (!isfinite(l->power_rgb_over_pi_squared[k]))
                return FOX_DISK_NUMERIC_RANGE;
        }
    }
    if (fox_disk_scene_validate(&tmp)!=FOX_DISK_OK) return FOX_DISK_INVALID_INPUT;
    *out=tmp;
    return FOX_DISK_OK;
}


#include <fenv.h>
/* Explicit flat fields, independent of serialized struct padding/layout. */
int prepare_reference(const double in[37],double fields[51],double samples[144]){
 if(fegetround()!=FE_TONEAREST)return 99;
 FoxDiskLightInput light[3]={0};FoxDiskScene scene;
 for(unsigned l=0;l<3;l++){light[l].shape=FOX_DISK_SHAPE_DISK;
  for(unsigned k=0;k<3;k++){light[l].center[k]=in[l*11+k];light[l].rotation_xyz[k]=in[l*11+3+k];light[l].color[k]=in[l*11+6+k];}
  light[l].power=in[l*11+9];light[l].diameter=in[l*11+10];}
 int status=fox_disk_scene_init(&scene,light,in+33,in[36]);if(status)return status;
 for(unsigned l=0;l<3;l++){FoxDiskLight *p=scene.lights+l;
  for(unsigned k=0;k<3;k++){fields[l*16+k]=p->center[k];fields[l*16+3+k]=p->normal[k];fields[l*16+6+k]=p->axis_u[k];fields[l*16+9+k]=p->axis_v[k];fields[l*16+12+k]=p->power_rgb_over_pi_squared[k];}
  fields[l*16+15]=p->radius;
  for(unsigned j=0;j<16;j++)for(unsigned k=0;k<3;k++)samples[(l*16+j)*3+k]=p->center[k]+p->radius*(disk16[j][0]*p->axis_u[k]+disk16[j][1]*p->axis_v[k]);}
 for(unsigned k=0;k<3;k++)fields[48+k]=scene.world_radiance[k];return 0;
}
