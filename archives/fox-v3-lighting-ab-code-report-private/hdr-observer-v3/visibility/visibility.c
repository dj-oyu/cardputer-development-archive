#include "visibility.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

typedef struct { double p[3][3], lo[3], hi[3], center[3]; uint32_t ordinal; } triangle;
typedef struct { double lo[3], hi[3]; uint32_t left,right,start,count; } node;
struct vis_scene { size_t refs, bytes, triangles, nodes, node_capacity;
                   vis_generation generation; triangle *tri; node *tree; };
static int equal(vis_generation a,vis_generation b) {
 return a.geometry==b.geometry && a.pose==b.pose && a.light==b.light;
}
static int valid_generation(vis_generation g) { return g.geometry && g.pose && g.light; }
size_t vis_scene_required_bytes(size_t n) {
 if(!n || n>VIS_MAX_TRIANGLES) return 0;
 return sizeof(vis_scene)+n*sizeof(triangle)+(2*n-1)*sizeof(node);
}
static int spans_overlap(const void *a,size_t an,const void *b,size_t bn){
 if(!a || !b || !an || !bn)return 0;
 uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;
 /* Subtraction avoids wrapping the end pointer. Invalid wrapping spans are
  * conservatively overlapping, so adapters reject them. */
 if(an-1>UINTPTR_MAX-x || bn-1>UINTPTR_MAX-y)return 1;
 return x<=y ? y-x<an : x-y<bn;
}
int vis_scene_overlaps(const vis_scene *s,const void *p,size_t n){
 return s && (spans_overlap(s,sizeof(*s),p,n) ||
  spans_overlap(s->tri,s->triangles*sizeof(triangle),p,n) ||
  spans_overlap(s->tree,s->node_capacity*sizeof(node),p,n));
}
size_t vis_scene_bytes(const vis_scene *s){return s?s->bytes:0;}
size_t vis_scene_triangle_count(const vis_scene *s){return s?s->triangles:0;}
size_t vis_scene_node_count(const vis_scene *s){return s?s->nodes:0;}
vis_generation vis_scene_generation(const vis_scene *s){vis_generation z={0,0,0};return s?s->generation:z;}
vis_status vis_scene_retain(vis_scene *s){if(!s)return VIS_INVALID;if(s->refs==SIZE_MAX)return VIS_CAPACITY;s->refs++;return VIS_OK;}
void vis_scene_release(vis_scene *s){if(s && --s->refs==0){free(s->tri);free(s->tree);free(s);}}
/* Stable in-place insertion sort avoids hidden allocator/global comparator state.
 * Bounded n<=2048; median split guarantees a small, bounded traversal stack. */
static void sort_axis(triangle *t,size_t n,int axis){
 for(size_t i=1;i<n;i++){triangle x=t[i];size_t j=i;
  while(j && (t[j-1].center[axis]>x.center[axis] ||
   (t[j-1].center[axis]==x.center[axis] && t[j-1].ordinal>x.ordinal))){t[j]=t[j-1];j--;}
  t[j]=x;
 }
}
static uint32_t build_node(vis_scene *s,size_t start,size_t count){
 uint32_t id=(uint32_t)s->nodes++;node *b=&s->tree[id];
 b->start=(uint32_t)start;b->count=(uint32_t)count;b->left=b->right=UINT32_MAX;
 for(int k=0;k<3;k++){b->lo[k]=s->tri[start].lo[k];b->hi[k]=s->tri[start].hi[k];}
 for(size_t i=start+1;i<start+count;i++)for(int k=0;k<3;k++){
  b->lo[k]=fmin(b->lo[k],s->tri[i].lo[k]);b->hi[k]=fmax(b->hi[k],s->tri[i].hi[k]);}
 if(count>4){int axis=0;for(int k=1;k<3;k++)if(b->hi[k]-b->lo[k]>b->hi[axis]-b->lo[axis])axis=k;
  sort_axis(s->tri+start,count,axis);size_t half=count/2;
  b->left=build_node(s,start,half);b->right=build_node(s,start+half,count-half);b->count=0;
 }return id;
}
vis_status vis_scene_build(vis_scene **slot,const double *xyz,size_t vertices,
 const uint32_t *indices,size_t n,vis_generation g,vis_limits lim){
 if(!slot || !xyz || !indices || !vertices || vertices>VIS_MAX_VERTICES || !n || !valid_generation(g))return VIS_INVALID;
 size_t bytes=vis_scene_required_bytes(n);
 if(!bytes || n>lim.max_triangles || 2*n-1>lim.max_nodes || 2*n-1>VIS_MAX_NODES || bytes>lim.max_bytes)return VIS_CAPACITY;
 if(spans_overlap(slot,sizeof(*slot),xyz,vertices*3*sizeof(*xyz)) ||
    spans_overlap(slot,sizeof(*slot),indices,n*3*sizeof(*indices)))return VIS_INVALID;
 if(*slot && vis_scene_overlaps(*slot,slot,sizeof(*slot)))return VIS_INVALID;
 if(*slot){vis_generation old=(*slot)->generation;
  if(g.geometry<old.geometry || g.pose<old.pose || g.light<old.light || equal(g,old))return VIS_GENERATION;}
 /* Restrict enormous coordinates to ensure finite arithmetic for ray/triangle
  * operations; this is far beyond useful Blender-world modeling magnitudes. */
 for(size_t i=0;i<vertices*3;i++)if(!isfinite(xyz[i]) || fabs(xyz[i])>1e50)return VIS_INVALID;
 for(size_t i=0;i<n*3;i++)if(indices[i]>=vertices)return VIS_INVALID;
 vis_scene *s=calloc(1,sizeof(*s));if(!s)return VIS_ALLOC;
 s->refs=1;s->bytes=bytes;s->triangles=n;s->node_capacity=2*n-1;s->generation=g;
 s->tri=malloc(n*sizeof(triangle));s->tree=malloc(s->node_capacity*sizeof(node));
 if(!s->tri || !s->tree){vis_scene_release(s);return VIS_ALLOC;}
 for(size_t i=0;i<n;i++){triangle *t=&s->tri[i];t->ordinal=(uint32_t)i;
  for(int j=0;j<3;j++)memcpy(t->p[j],xyz+3*(size_t)indices[3*i+j],3*sizeof(double));
  for(int k=0;k<3;k++){t->lo[k]=fmin(t->p[0][k],fmin(t->p[1][k],t->p[2][k]));t->hi[k]=fmax(t->p[0][k],fmax(t->p[1][k],t->p[2][k]));t->center[k]=(t->lo[k]+t->hi[k])*0.5;}
  double a[3],b[3],c[3];for(int k=0;k<3;k++){a[k]=t->p[1][k]-t->p[0][k];b[k]=t->p[2][k]-t->p[0][k];}
  c[0]=a[1]*b[2]-a[2]*b[1];c[1]=a[2]*b[0]-a[0]*b[2];c[2]=a[0]*b[1]-a[1]*b[0];
  if(c[0]==0 && c[1]==0 && c[2]==0){vis_scene_release(s);return VIS_INVALID;}
 }
 build_node(s,0,n);vis_scene *old=*slot;*slot=s;vis_scene_release(old);return VIS_OK;
}
vis_status vis_binding_set(vis_binding *b,vis_scene *s,vis_generation expected){
 if(!b || !s)return VIS_INVALID;
 /* Reject new-scene overlap before reading any binding fields. A binding
  * must otherwise be initialized and contain a valid retained scene or NULL. */
 if(vis_scene_overlaps(s,b,sizeof(*b)))return VIS_INVALID;
 if(b->scene && vis_scene_overlaps(b->scene,b,sizeof(*b)))return VIS_INVALID;
 if(!equal(s->generation,expected))return VIS_GENERATION;
 vis_status r=vis_scene_retain(s);if(r!=VIS_OK)return r;vis_scene *old=b->scene;b->scene=s;b->generation=expected;vis_scene_release(old);return VIS_OK;
}
void vis_binding_clear(vis_binding *b){
 if(b){
  if(b->scene && vis_scene_overlaps(b->scene,b,sizeof(*b)))return;
  vis_scene_release(b->scene);memset(b,0,sizeof(*b));
 }
}
static int consume(uint64_t *used,uint64_t cap){if(*used>=cap)return 0;(*used)++;return 1;}
static int box_hit(const node *b,const double o[3],const double d[3],double lo,double hi){
 for(int k=0;k<3;k++){if(d[k]==0){if(o[k]<b->lo[k] || o[k]>b->hi[k])return 0;}else{
  double a=(b->lo[k]-o[k])/d[k],z=(b->hi[k]-o[k])/d[k];if(a>z){double tmp=a;a=z;z=tmp;}lo=fmax(lo,a);hi=fmin(hi,z);if(lo>hi)return 0;}}
 return 1;
}
/* Watertight projected edge tests, inclusive edges, two-sided. */
static int tri_hit(const triangle *t,const double o[3],const double d[3],double lo,double hi){
 int kz=0;for(int k=1;k<3;k++)if(fabs(d[k])>fabs(d[kz]))kz=k;
 int kx=(kz+1)%3,ky=(kx+1)%3;if(d[kz]<0){int tmp=kx;kx=ky;ky=tmp;}
 double sx=d[kx]/d[kz],sy=d[ky]/d[kz],sz=1/d[kz],x[3],y[3],z[3];
 for(int j=0;j<3;j++){double pz=t->p[j][kz]-o[kz];x[j]=t->p[j][kx]-o[kx]-sx*pz;y[j]=t->p[j][ky]-o[ky]-sy*pz;z[j]=pz*sz;}
 double u=x[2]*y[1]-y[2]*x[1],v=x[0]*y[2]-y[0]*x[2],w=x[1]*y[0]-y[1]*x[0];
 if((u<0 || v<0 || w<0) && (u>0 || v>0 || w>0))return 0;
 double det=u+v+w;if(det==0)return 0;
 double distance=(u*z[0]+v*z[1]+w*z[2])/det;return distance>lo && distance<hi;
}
vis_status vis_segment_occluded(const vis_binding *b,vis_generation expected,const double from[3],const double to[3],vis_budget *budget,int *out){
 if(!b || !b->scene || !from || !to || !budget || !out)return VIS_INVALID;
 if(vis_scene_overlaps(b->scene,budget,sizeof(*budget)) ||
    vis_scene_overlaps(b->scene,out,sizeof(*out)) ||
    spans_overlap(budget,sizeof(*budget),out,sizeof(*out)) ||
    spans_overlap(budget,sizeof(*budget),b,sizeof(*b)) ||
    spans_overlap(out,sizeof(*out),b,sizeof(*b)) ||
    spans_overlap(budget,sizeof(*budget),from,3*sizeof(double)) ||
    spans_overlap(budget,sizeof(*budget),to,3*sizeof(double)))return VIS_INVALID;
 if(!equal(b->generation,expected) || !equal(b->scene->generation,expected))return VIS_GENERATION;
 double d[3];for(int k=0;k<3;k++){if(!isfinite(from[k]) || !isfinite(to[k]) || fabs(from[k])>1e50 || fabs(to[k])>1e50)return VIS_INVALID;d[k]=to[k]-from[k];}
 double length=hypot(hypot(d[0],d[1]),d[2]);if(length<=2*VIS_SEGMENT_EPSILON)return VIS_INVALID;
 for(int k=0;k<3;k++)d[k]/=length;
 if(!consume(&budget->used.rays,budget->limit.rays))return VIS_BUDGET;
 uint32_t stack[32];size_t count=1;stack[0]=0;
 while(count){if(!consume(&budget->used.node_visits,budget->limit.node_visits))return VIS_BUDGET;
  const node *n=&b->scene->tree[stack[--count]];
  if(!box_hit(n,from,d,VIS_SEGMENT_EPSILON,length-VIS_SEGMENT_EPSILON))continue;
  if(n->count){for(uint32_t i=0;i<n->count;i++){
   if(!consume(&budget->used.triangle_tests,budget->limit.triangle_tests))return VIS_BUDGET;
   if(tri_hit(&b->scene->tri[n->start+i],from,d,VIS_SEGMENT_EPSILON,length-VIS_SEGMENT_EPSILON)){*out=1;return VIS_OK;}
  }}else{if(count+2>sizeof(stack)/sizeof(stack[0]))return VIS_CAPACITY;stack[count++]=n->right;stack[count++]=n->left;}
 }*out=0;return VIS_OK;
}
