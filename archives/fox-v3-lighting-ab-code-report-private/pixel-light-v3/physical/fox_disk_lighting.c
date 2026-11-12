#include "fox_disk_lighting.h"

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

/* Reject proximity to the complete emitting disk, not just sampled points.
 * This avoids a sample-dependent singular-endpoint admission rule.
 */
static FoxDiskStatus disk_receiver_delta(const FoxDiskLight *l,
    const double p[3], double center_delta[3]) {
    double height, u, v, radial, exterior, nearest;
    unsigned k;
    for (k=0;k<3;k++) center_delta[k]=l->center[k]-p[k];
    if (!finite3(center_delta)) return FOX_DISK_NUMERIC_RANGE;
    height=dot3(center_delta,l->normal);
    u=dot3(center_delta,l->axis_u); v=dot3(center_delta,l->axis_v);
    if (!isfinite(height)||!isfinite(u)||!isfinite(v)) return FOX_DISK_NUMERIC_RANGE;
    radial=hypot(u,v);
    exterior=fmax(0,radial-l->radius);
    nearest=hypot(height,exterior);
    if (!isfinite(nearest)) return FOX_DISK_NUMERIC_RANGE;
    return nearest<=FOX_DISK_ENDPOINT_EPSILON ? FOX_DISK_NEAR_ENDPOINT : FOX_DISK_OK;
}

static FoxDiskStatus sample_kernel(const FoxDiskLight *l,
    const double center_delta[3], const double receiver_normal[3],
    double u, double v, double *kernel) {
    double d[3], wi[3], length, inverse_length, cos_source, cos_receiver;
    unsigned k;
    for (k=0;k<3;k++)
        d[k]=center_delta[k]+l->radius*(u*l->axis_u[k]+v*l->axis_v[k]);
    if (!finite3(d)) return FOX_DISK_NUMERIC_RANGE;
    length=hypot(hypot(d[0],d[1]),d[2]);
    if (!isfinite(length)) return FOX_DISK_NUMERIC_RANGE;
    if (length<=FOX_DISK_ENDPOINT_EPSILON) return FOX_DISK_NEAR_ENDPOINT;
    inverse_length=1.0/length;
    for (k=0;k<3;k++) wi[k]=d[k]*inverse_length;
    cos_source=fmax(0,-dot3(l->normal,wi));
    cos_receiver=fmax(0,dot3(receiver_normal,wi));
    *kernel=cos_source*cos_receiver*inverse_length*inverse_length;
    return isfinite(*kernel) ? FOX_DISK_OK : FOX_DISK_NUMERIC_RANGE;
}

static FoxDiskStatus eval(const FoxDiskScene *scene, const double position[3],
    const double normal[3], const double rho[3], unsigned bands,
    int use_table16, double out_rgb[3]) {
    double n[3], tmp[3];
    unsigned light,k;
    FoxDiskStatus status;
    if (!scene || !position || !normal || !rho || !out_rgb)
        return FOX_DISK_BAD_ARGUMENT;
    if (bands<1 || bands>512) return FOX_DISK_BAD_ARGUMENT;
    status=fox_disk_scene_validate(scene);
    if (status!=FOX_DISK_OK) return status;
    if (!finite3(position)||!normalize3(normal,n)||!nonnegative3(rho)||
        rho[0]>1||rho[1]>1||rho[2]>1) return FOX_DISK_INVALID_INPUT;
    for (k=0;k<3;k++) tmp[k]=scene->world_radiance[k];
    for (light=0;light<FOX_DISK_LIGHT_COUNT;light++) {
        const FoxDiskLight *l=&scene->lights[light];
        double center_delta[3], sum=0, mean;
        const unsigned azimuths=4*bands, count=4*bands*bands;
        unsigned i;
        status=disk_receiver_delta(l,position,center_delta);
        if (status!=FOX_DISK_OK) return status;
        for (i=0;i<count;i++) {
            double u,v,value;
            if (use_table16) { u=disk16[i][0]; v=disk16[i][1]; }
            else {
                unsigned ring=i/azimuths, azimuth=i%azimuths;
                double r=sqrt(((double)ring+0.5)/(double)bands);
                double phi=2*PI*((double)azimuth+0.5*(double)(ring%2))/(double)azimuths;
                u=r*cos(phi); v=r*sin(phi);
            }
            status=sample_kernel(l,center_delta,n,u,v,&value);
            if (status!=FOX_DISK_OK) return status;
            sum+=value;
            if (!isfinite(sum)) return FOX_DISK_NUMERIC_RANGE;
        }
        mean=sum/(double)count;
        for (k=0;k<3;k++) {
            tmp[k]+=l->power_rgb_over_pi_squared[k]*mean;
            if (!isfinite(tmp[k])) return FOX_DISK_NUMERIC_RANGE;
        }
    }
    for (k=0;k<3;k++) {
        tmp[k]*=rho[k];
        if (!isfinite(tmp[k])||tmp[k]<0) return FOX_DISK_NUMERIC_RANGE;
    }
    memcpy(out_rgb,tmp,sizeof(tmp));
    return FOX_DISK_OK;
}

FoxDiskStatus fox_disk_eval16(const FoxDiskScene *scene, const double position[3],
    const double normal[3], const double rho[3], double out_rgb[3]) {
    return eval(scene,position,normal,rho,2,1,out_rgb);
}
FoxDiskStatus fox_disk_eval_diagnostic(const FoxDiskScene *scene,
    const double position[3], const double normal[3], const double rho[3],
    unsigned radial_bands, double out_rgb[3]) {
    return eval(scene,position,normal,rho,radial_bands,0,out_rgb);
}
const char *fox_disk_status_string(FoxDiskStatus status) {
    switch (status) {
    case FOX_DISK_OK: return "ok";
    case FOX_DISK_BAD_ARGUMENT: return "bad argument";
    case FOX_DISK_UNSUPPORTED_SHAPE: return "unsupported shape (DISK required)";
    case FOX_DISK_INVALID_INPUT: return "invalid input";
    case FOX_DISK_NEAR_ENDPOINT: return "receiver within 1e-9 world units of disk";
    case FOX_DISK_NUMERIC_RANGE: return "finite numeric range exceeded";
    default: return "unknown status";
    }
}
