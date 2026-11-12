#ifndef AYATSURI_SMOOTH_NORMALS_H
#define AYATSURI_SMOOTH_NORMALS_H
#include "ayatsuri_skin.h"
/* Isolated all-smooth triangle-mesh normal reconstruction. No custom normals,
 * sharp edges/faces, n-gons, smoothing islands or Blender normal modifiers.
 * Importer must verify this domain. Vertex IDs encode source connectivity;
 * do not weld duplicate vertices or use partitioned IDs as source topology.
 * Caller supplies 3*vertex_count doubles scratch; scratch may change on failure,
 * output is transactional. Inputs/scratch/output must be valid aligned immutable
 * nonoverlapping spans (scratch is mutable workspace). No heap allocation.
 * Finite zero-area triangles and zero accumulated normals reject, never delete.
 */
typedef enum {AYATSURI_NORMAL_ALL_SMOOTH_TRIANGLES=1} ayatsuri_normal_domain;
static inline ayatsuri_status ayatsuri_recompute_smooth_normals(
        ayatsuri_normal_domain domain,const float (*positions)[3],size_t vertices,
        const uint32_t (*triangles)[3],size_t triangle_count,double (*scratch)[3],float (*out)[3]){
    if(domain!=AYATSURI_NORMAL_ALL_SMOOTH_TRIANGLES||
       !ayatsuri_skin_disjoint(scratch,vertices,sizeof *scratch,positions,vertices,sizeof *positions)||
       !ayatsuri_skin_disjoint(scratch,vertices,sizeof *scratch,triangles,triangle_count,sizeof *triangles)||
       !ayatsuri_skin_disjoint(out,vertices,sizeof *out,positions,vertices,sizeof *positions)||
       !ayatsuri_skin_disjoint(out,vertices,sizeof *out,triangles,triangle_count,sizeof *triangles)||
       !ayatsuri_skin_disjoint(out,vertices,sizeof *out,scratch,vertices,sizeof *scratch))return AYATSURI_INVALID;
    for(size_t v=0;v<vertices;v++)for(unsigned k=0;k<3;k++)if(!isfinite(positions[v][k]))return AYATSURI_INVALID;
    memset(scratch,0,vertices*sizeof *scratch);
    for(size_t t=0;t<triangle_count;t++){
        for(unsigned k=0;k<3;k++)if(triangles[t][k]>=vertices)return AYATSURI_INVALID;
        const float *p[3]={positions[triangles[t][0]],positions[triangles[t][1]],positions[triangles[t][2]]};
        double a[3],b[3],face[3];for(unsigned k=0;k<3;k++){a[k]=(double)p[1][k]-p[0][k];b[k]=(double)p[2][k]-p[0][k];}
        face[0]=a[1]*b[2]-a[2]*b[1];face[1]=a[2]*b[0]-a[0]*b[2];face[2]=a[0]*b[1]-a[1]*b[0];
        double len=hypot(hypot(face[0],face[1]),face[2]);if(!(len>0)||!isfinite(len))return AYATSURI_RANGE;
        for(unsigned k=0;k<3;k++)face[k]/=len;
        for(unsigned corner=0;corner<3;corner++){
            double x[3],y[3],dot=0;
            for(unsigned k=0;k<3;k++){x[k]=(double)p[(corner+1)%3][k]-p[corner][k];y[k]=(double)p[(corner+2)%3][k]-p[corner][k];}
            double lx=hypot(hypot(x[0],x[1]),x[2]),ly=hypot(hypot(y[0],y[1]),y[2]);
            if(!(lx>0)||!(ly>0))return AYATSURI_RANGE;
            for(unsigned k=0;k<3;k++)dot+=(x[k]/lx)*(y[k]/ly);
            /* Reject unresolved near-collinear angles rather than zeroing weight. */
            if(dot>=1||dot<=-1)return AYATSURI_RANGE;
            double angle=acos(dot);
            for(unsigned k=0;k<3;k++)scratch[triangles[t][corner]][k]+=angle*face[k];
        }
    }
    for(size_t v=0;v<vertices;v++){
        double len=hypot(hypot(scratch[v][0],scratch[v][1]),scratch[v][2]);
        if(!(len>0)||!isfinite(len))return AYATSURI_RANGE;
    }
    for(size_t v=0;v<vertices;v++){
        double len=hypot(hypot(scratch[v][0],scratch[v][1]),scratch[v][2]);
        for(unsigned k=0;k<3;k++)out[v][k]=(float)(scratch[v][k]/len);
    }
    return AYATSURI_OK;
}
#endif
