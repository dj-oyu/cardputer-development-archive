#include <stdint.h>
#include <stddef.h>
#include <math.h>
#include "compact_opaque.h"
#include "ayatsuri_shade.h"
#include "ksn_aa_rho_affine.h"
#include "fixed_kernel.h"
#include "edge_extract.h"
static double aa_edge_value(const gouraud_edge*e,double x,double y){return e->sign*(e->a*x+e->b*y+e->c);}
/* output: bary,P,Ns,rho,oldNormalKernel,oldRhoKernel,sourceNormalKernel (21 doubles).
 * Return 2 means baseline reconstruction succeeded but weights require fallback.
 * No renderer, geometry queries, light calls or visibility callbacks. */
int replay(const uint8_t *data,size_t bytes,unsigned off,unsigned face,unsigned sample,unsigned x,unsigned y,const int16_t *source_normals,double out[21]){
 co_view v; if(bytes<416||off>bytes-416||!co_read(data+416+off,bytes-416-off,&v))return -1;
 uint8_t ix[3];co_vertex q[3];co_pixel_vertex fields[3];bool back;
 if(!co_triangle_at(&v,face,ix)||!co_triangle_side(&v,face,&back)||sample>3)return -2;
 for(unsigned j=0;j<3;j++)if(!co_vertex_at_side(&v,ix[j],back,q+j)||!co_pixel_vertex_at(&v,ix[j],fields+j))return -3;
 const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
 double area=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x),inverse=1/area;
 const gouraud_edge edge[3]={gouraud_make_edge(q+1,q+2),gouraud_make_edge(q+2,q),gouraud_make_edge(q,q+1)};
 double bary[3];for(unsigned k=0;k<3;k++)out[k]=bary[k]=aa_edge_value(edge+k,x+dx[sample],y+dy[sample])*inverse;
 bool second=bary[0]*q[0].mask+bary[1]*q[1].mask+bary[2]*q[2].mask>=0;
 double world[3]={0},normal[3]={0},rho[3]={0};float decoded[3][3];
 for(unsigned j=0;j<3;j++){
  uint16_t code=second?q[j].color_b:q[j].color_a;const int16_t*n=back?fields[j].normal_back:fields[j].normal_front;
  decoded[j][0]=ayatsuri_srgb_decode((code>>11)/31.0f);decoded[j][1]=ayatsuri_srgb_decode(((code>>5)&63)/63.0f);decoded[j][2]=ayatsuri_srgb_decode((code&31)/31.0f);
  for(unsigned k=0;k<3;k++){world[k]+=bary[j]*fields[j].world[k];normal[k]+=bary[j]*(n[k]/32767.0);}
 }
 if(!ksn_aa_rho_affine(decoded,bary,rho))return -4;
 out[3]=world[0]/38;out[4]=-world[2]/38;out[5]=-world[1]/38;out[6]=normal[0];out[7]=-normal[2];out[8]=-normal[1];for(int k=0;k<3;k++)out[9+k]=rho[k];
 int16_t w[3];if(!fk_weights(bary,w))return 2;
 for(int k=0;k<3;k++){
  int16_t n[3],r[3],s[3],nn,rr,ss;
  for(int j=0;j<3;j++){n[j]=(back?fields[j].normal_back:fields[j].normal_front)[k];if(!fk_encode(decoded[j][k],32767,r+j))return -5;s[j]=source_normals?source_normals[3*j+k]:n[j];if(source_normals&&back)s[j]=-s[j];}
  if(!fk_scalar(w,n,&nn)||!fk_scalar(w,r,&rr)||!fk_scalar(w,s,&ss))return -6;
  int nk=k==0?0:k==1?2:1;out[12+nk]=(k==0?1:-1)*nn/32767.;out[15+k]=rr/32767.;out[18+nk]=(k==0?1:-1)*ss/32767.;
 }
 return 1;
}
int source_rho(const double bary[3],const int16_t material[3],double out[3]){
 int16_t w[3];if(!fk_weights(bary,w))return 0;
 for(int k=0;k<3;k++){int16_t a[3]={material[k],material[k],material[k]},q;if(!fk_scalar(w,a,&q))return 0;out[k]=q/32767.;}return 1;
}
