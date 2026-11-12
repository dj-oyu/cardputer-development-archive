#define _POSIX_C_SOURCE 200809L
/* Geometry/count-only preparation. No visibility module, transport, pixels or reference imagery. */
#include "ui/kasane/ksn_boundary_aa.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <sys/resource.h>
#include <inttypes.h>
#define CHECK(x) do{if(!(x)){fprintf(stderr,"preflight failure line %d: %s\n",__LINE__,#x);exit(2);}}while(0)
typedef struct {uint64_t slots,floor,miss[4],kernels,queries;} domain;
typedef struct {
 float cam[9],basis[3][3],projection[12];double inv[9],origin_depth,source_origin[3],source_view[3],near_clip,far_clip;
 double floor[4][3],rho[3];unsigned ix[6];FoxDiskScene lights;
 FILE *samples,*diagnostics;int diag_sample;unsigned diag_node,diag_face,diag_source,diag_record;double diag_p[3];int diag_has_p;domain combined,background;uint64_t ordering_slots,character_hits,floor_front,floor_equal,floor_behind,triangle_tests,evaluator_calls,callbacks,geometry_samples,geometry_shades;
 uint64_t old_rays,old_nodes,old_triangles;double max_reproject_error,max_float_reproject_error,max_sample_position_delta,max_source_native_origin_delta;int failure;
} context;
static uint64_t hash(const uint8_t*p,size_t n){uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*p++;h*=UINT64_C(1099511628211);}return h;}
static size_t load(const char*p,uint8_t*d,size_t cap){FILE*f=fopen(p,"rb");CHECK(f);size_t n=fread(d,1,cap,f);CHECK(!ferror(f));int extra=fgetc(f);CHECK(extra==EOF);CHECK(!fclose(f));return n;}
static double dot(const double a[3],const double b[3]){return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];}
static void cross(const double a[3],const double b[3],double out[3]){out[0]=a[1]*b[2]-a[2]*b[1];out[1]=a[2]*b[0]-a[0]*b[2];out[2]=a[0]*b[1]-a[1]*b[0];}
static int finite3(const double p[3]){return isfinite(p[0])&&isfinite(p[1])&&isfinite(p[2]);}
static double number(FILE*f){double d;CHECK(fscanf(f,"%lf",&d)==1&&isfinite(d));return d;}
static void prepare(context*c,const char*path){
 FILE*f=fopen(path,"r");CHECK(f);char magic[32];CHECK(fscanf(f,"%31s",magic)==1&&!strcmp(magic,"FOXCAMCOUNT1"));
 for(int j=0;j<9;j++){double d=number(f);c->cam[j]=(float)d;CHECK(isfinite(c->cam[j])&&(double)c->cam[j]==d);}CHECK(c->cam[6]>0);
 for(int k=0;k<3;k++)c->source_origin[k]=number(f);for(int k=0;k<3;k++)c->source_view[k]=number(f);CHECK(fabs(dot(c->source_view,c->source_view)-1)<1e-12);
 c->near_clip=number(f);c->far_clip=number(f);CHECK(c->near_clip>0&&c->far_clip>c->near_clip);
 for(int j=0;j<4;j++)for(int k=0;k<3;k++)c->floor[j][k]=number(f);
 for(int j=0;j<6;j++){unsigned i;CHECK(fscanf(f,"%u",&i)==1&&i<4);c->ix[j]=i;}
 for(int k=0;k<3;k++){c->rho[k]=number(f);CHECK(c->rho[k]>=0&&c->rho[k]<=1);}
 CHECK(fscanf(f,"%"SCNu64" %"SCNu64" %"SCNu64,&c->old_rays,&c->old_nodes,&c->old_triangles)==3);CHECK(c->old_rays<=1000000&&c->old_nodes<=100000000&&c->old_triangles<=50000000);char extra;CHECK(fscanf(f," %c",&extra)==EOF);CHECK(!fclose(f));
 /* Exact native generation: double hypot order, then float basis stores. */
 double fx=(double)c->cam[0]-c->cam[3],fy=(double)c->cam[1]-c->cam[4],fz=(double)c->cam[2]-c->cam[5];double len=hypot(hypot(fx,fy),fz);CHECK(isfinite(len)&&len>0);fx/=len;fy/=len;fz/=len;
 double rx=fz,rz=-fx,rl=hypot(rx,rz);if(rl<1e-6){rx=1;rz=0;rl=1;}rx/=rl;rz/=rl;
 float r[3]={(float)rx,0,(float)rz},d[3]={(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)},fw[3]={(float)fx,(float)fy,(float)fz};memcpy(c->basis[0],r,sizeof r);memcpy(c->basis[1],d,sizeof d);memcpy(c->basis[2],fw,sizeof fw);
 const float identity[12]={1,0,0,0,0,1,0,0,0,0,1,0};
 for(unsigned row=0;row<3;row++){
  const float zoom=row<2?c->cam[6]:1;const float *basis=c->basis[row];
  for(unsigned col=0;col<3;col++)c->projection[4*row+col]=zoom*(basis[0]*identity[col]+basis[1]*identity[4+col]+basis[2]*identity[8+col]);
  c->projection[4*row+3]=zoom*(basis[0]*(identity[3]-c->cam[3])+basis[1]*(identity[7]-c->cam[4])+basis[2]*(identity[11]-c->cam[5]));
  if(row<2)c->projection[4*row+3]+=c->cam[7+row];
 }
 double a=c->projection[0],b=c->projection[1],cc=c->projection[2],dd=c->projection[4],e=c->projection[5],ff=c->projection[6],g=c->projection[8],h=c->projection[9],j=c->projection[10];double det=a*(e*j-ff*h)-b*(dd*j-ff*g)+cc*(dd*h-e*g);CHECK(isfinite(det)&&det!=0);
 double iv[9]={(e*j-ff*h)/det,(cc*h-b*j)/det,(b*ff-cc*e)/det,(ff*g-dd*j)/det,(a*j-cc*g)/det,(cc*dd-a*ff)/det,(dd*h-e*g)/det,(b*g-a*h)/det,(a*e-b*dd)/det};memcpy(c->inv,iv,sizeof iv);
 float dc=c->projection[8]*c->cam[0]+c->projection[9]*c->cam[1]+c->projection[10]*c->cam[2]+c->projection[11];c->origin_depth=dc;CHECK(isfinite(c->origin_depth));
 double native_origin_world[3]={c->cam[0]/38.0,-c->cam[2]/38.0,-c->cam[1]/38.0};for(int k=0;k<3;k++)c->max_source_native_origin_delta=fmax(c->max_source_native_origin_delta,fabs(native_origin_world[k]-c->source_origin[k]));
}
static void ray(context*c,double x,double y,double o[3],double v[3]){
 double q[3]={x-c->projection[3],y-c->projection[7],c->origin_depth-c->projection[11]},on[3],vn[3];for(int k=0;k<3;k++){on[k]=c->inv[3*k]*q[0]+c->inv[3*k+1]*q[1]+c->inv[3*k+2]*q[2];vn[k]=-c->inv[3*k+2];}
 o[0]=on[0]/38;o[1]=-on[2]/38;o[2]=-on[1]/38;v[0]=vn[0]/38;v[1]=-vn[2]/38;v[2]=-vn[1]/38;double len=hypot(hypot(v[0],v[1]),v[2]);CHECK(isfinite(len)&&len>0);for(int k=0;k<3;k++)v[k]/=len;CHECK(finite3(o)&&finite3(v));
}
/* result0=floor, 1=parallel,2=negative ray t,3=outside finite floor,4=clip outside. */
static unsigned intersection(context*c,double x,double y,double p[3],double normal[3],float *depth){
 double o[3],d[3];ray(c,x,y,o,d);int found=0,parallel=0,negative=0;double nearest=INFINITY;
 for(unsigned t=0;t<2;t++){
  c->triangle_tests++;const double *v0=c->floor[c->ix[3*t]],*v1=c->floor[c->ix[3*t+1]],*v2=c->floor[c->ix[3*t+2]];double e1[3],e2[3],n[3],dv[3];for(int k=0;k<3;k++){e1[k]=v1[k]-v0[k];e2[k]=v2[k]-v0[k];dv[k]=v0[k]-o[k];}cross(e1,e2,n);double nl=hypot(hypot(n[0],n[1]),n[2]);CHECK(isfinite(nl)&&nl>0);for(int k=0;k<3;k++)n[k]/=nl;double denom=dot(n,d);CHECK(isfinite(denom));if(denom==0){parallel++;continue;}double dist=dot(n,dv)/denom;CHECK(isfinite(dist));if(dist<0){negative++;continue;}
  double point[3],vp[3];for(int k=0;k<3;k++){point[k]=o[k]+dist*d[k];vp[k]=point[k]-v0[k];}CHECK(finite3(point));double d00=dot(e1,e1),d01=dot(e1,e2),d11=dot(e2,e2),d20=dot(vp,e1),d21=dot(vp,e2),den=d00*d11-d01*d01;CHECK(isfinite(den)&&den>0);double b=(d11*d20-d01*d21)/den,cc=(d00*d21-d01*d20)/den;CHECK(isfinite(b)&&isfinite(cc));if(b<0||cc<0||b+cc>1)continue;
  if(!found||dist<nearest){found=1;nearest=dist;memcpy(p,point,sizeof point);for(int k=0;k<3;k++)normal[k]=denom<0?n[k]:-n[k];}
 }
 if(!found)return parallel==2?1:negative?2:3;
 double rel[3];for(int k=0;k<3;k++)rel[k]=p[k]-c->source_origin[k];double axial=dot(rel,c->source_view);CHECK(isfinite(axial));if(axial<c->near_clip||axial>c->far_clip)return 4;
 /* Exact identity-world native Q32/t32 reprojection, no FMA. */
 float q[3]={(float)(38*p[0]),(float)(-38*p[2]),(float)(-38*p[1])};
 float z=c->projection[8]*q[0]+c->projection[9]*q[1]+c->projection[10]*q[2]+c->projection[11];CHECK(isfinite(z));*depth=z;
 for(int k=0;k<2;k++){
  const float *pr=c->projection+4*k;double nd[3]={38*p[0],-38*p[2],-38*p[1]};double projected=(double)pr[0]*nd[0]+(double)pr[1]*nd[1]+(double)pr[2]*nd[2]+pr[3];float projected32=pr[0]*q[0]+pr[1]*q[1]+pr[2]*q[2]+pr[3];
  CHECK(isfinite(projected)&&isfinite(projected32));c->max_reproject_error=fmax(c->max_reproject_error,fabs(projected-(k?y:x)));c->max_float_reproject_error=fmax(c->max_float_reproject_error,fabs((double)projected32-(k?y:x)));
 }
 return 0;
}
static bool count_callback(void*ptr,const double p[3],const double n[3],const double q[3],bool *visible){(void)p;(void)n;(void)q;uint64_t*c=ptr;(*c)++;*visible=false;return true;}
static void domain_add(domain*d,unsigned miss,uint64_t queries){d->slots++;if(miss)d->miss[miss-1]++;else{d->floor++;d->kernels+=48;d->queries+=queries;}}
static void inspect(context*c,double x,double y,int character,float character_depth,int bg,int combined){
 c->ordering_slots++;double p[3],n[3];float depth=0;unsigned miss=intersection(c,x,y,p,n,&depth);uint64_t queries=0;
 if(character){c->character_hits++;if(!miss){if(depth>character_depth){c->floor_front++;if(c->diagnostics){uint64_t diagnostic_queries=0;double discarded[3];CHECK(fox_disk_eval16_visible(&c->lights,p,n,c->rho,count_callback,&diagnostic_queries,discarded)==FOX_DISK_OK);fprintf(c->diagnostics,"{\"x\":%.17g,\"y\":%.17g,\"sample\":%d,\"node\":%u,\"face\":%u,\"sourceId\":%u,\"recordOffset\":%u,\"characterDepth\":%.17g,\"floorDepth\":%.17g,\"depthGapNative\":%.17g,\"floorWorldP\":[%.17g,%.17g,%.17g],\"diagnosticPositiveQueries\":%"PRIu64",\"diagnosticKernelEvaluations\":48,\"characterWorldP\":",x,y,c->diag_sample,c->diag_node,c->diag_face,c->diag_source,c->diag_record,(double)character_depth,(double)depth,(double)depth-character_depth,p[0],p[1],p[2],diagnostic_queries);if(c->diag_has_p)fprintf(c->diagnostics,"[%.17g,%.17g,%.17g],\"characterMinusFloorZ\":%.17g",c->diag_p[0],c->diag_p[1],c->diag_p[2],c->diag_p[2]-p[2]);else fputs("null,\"characterMinusFloorZ\":null",c->diagnostics);fputs("}\n",c->diagnostics);}}else if(depth==character_depth)c->floor_equal++;else c->floor_behind++;}}
 if(bg&&!miss){double ignored[3];CHECK(fox_disk_eval16_visible(&c->lights,p,n,c->rho,count_callback,&queries,ignored)==FOX_DISK_OK);CHECK(queries<=48);c->evaluator_calls++;c->callbacks+=queries;}
 if(bg)domain_add(&c->background,miss,queries);if(combined)domain_add(&c->combined,miss,queries);
}
static bool zero_shader(void*opaque,const FoxDiskScene*s,const double p[3],const double n[3],const double rho[3],double rgb[3]){(void)s;(void)p;(void)n;(void)rho;context*c=opaque;c->geometry_shades++;rgb[0]=rgb[1]=rgb[2]=0;return true;}
static bool observer(void*opaque,const ksn_aa_sample*s){
 context*c=opaque;unsigned x,y,sample,hit,record,node,face,back,source;double depth,p[3],n[3];CHECK(fscanf(c->samples,"%u %u %u %u %u %u %u %u %u %lf %lf %lf %lf %lf %lf %lf",&x,&y,&sample,&hit,&record,&node,&face,&back,&source,&depth,p,p+1,p+2,n,n+1,n+2)==16);
 CHECK(x==s->x&&y==s->y&&sample==s->sample&&hit==(unsigned)s->hit&&record==s->record_offset&&node==s->node&&face==s->face&&back==(unsigned)s->back&&source==s->source_id&&(float)depth==s->depth);for(int k=0;k<3;k++)CHECK(p[k]==s->position[k]&&n[k]==s->normal[k]);
 const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};CHECK(sample<4);if(s->hit){double q[3]={x+dx[sample]-c->projection[3],y+dy[sample]-c->projection[7],(double)s->depth-c->projection[11]},np[3],wp[3];for(int k=0;k<3;k++)np[k]=c->inv[3*k]*q[0]+c->inv[3*k+1]*q[1]+c->inv[3*k+2]*q[2];wp[0]=np[0]/38;wp[1]=-np[2]/38;wp[2]=-np[1]/38;for(int k=0;k<3;k++)c->max_sample_position_delta=fmax(c->max_sample_position_delta,fabs(wp[k]-s->position[k]));}c->diag_sample=(int)sample;c->diag_node=s->node;c->diag_face=s->face;c->diag_source=s->source_id;c->diag_record=s->record_offset;c->diag_has_p=s->hit;memcpy(c->diag_p,s->position,sizeof c->diag_p);c->geometry_samples++;inspect(c,x+dx[sample],y+dy[sample],s->hit,s->depth,1,!s->hit);return true;
}
/* Diagnostic reconstruction of one retained center winner, unchanged edge arithmetic. */
typedef struct {double a,b,c;int sign;bool closed;} diagnostic_edge;
static diagnostic_edge make_edge(const co_vertex*a,const co_vertex*b){double dx=(double)b->x-a->x,dy=(double)b->y-a->y;diagnostic_edge e={.sign=1,.closed=dy<0||(dy==0&&dx>0)};if(a->x>b->x||(a->x==b->x&&a->y>b->y)){const co_vertex*t=a;a=b;b=t;e.sign=-1;}e.a=(double)a->y-b->y;e.b=(double)b->x-a->x;e.c=((double)b->y-a->y)*a->x-((double)b->x-a->x)*a->y;return e;}
static void locate_center(const ksn_mesh_pixel_snapshot*s,const ksn_aa_workspace*w,context*c,unsigned x,unsigned y,float expected){
 size_t offset=0;float nearest=-INFINITY;int found=0;
 while(offset<s->mesh.packets.size){co_view v;CHECK(co_read(s->mesh.packets.data+offset,s->mesh.packets.size-offset,&v));for(unsigned face=0;face<v.triangle_count;face++){uint8_t ix[3];co_vertex q[3];co_pixel_vertex fields[3];bool back;CHECK(co_triangle_at(&v,face,ix)&&co_triangle_side(&v,face,&back));for(int j=0;j<3;j++)CHECK(co_vertex_at_side(&v,ix[j],back,q+j)&&co_pixel_vertex_at(&v,ix[j],fields+j));double area=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x);CHECK(area>1e-5);diagnostic_edge e[3]={make_edge(q+1,q+2),make_edge(q+2,q),make_edge(q,q+1)};double bary[3];int inside=1;for(int k=0;k<3;k++){bary[k]=e[k].sign*(e[k].a*x+e[k].b*y+e[k].c);if(bary[k]<0||(bary[k]==0&&!e[k].closed))inside=0;}if(!inside)continue;for(int k=0;k<3;k++)bary[k]*=1/area;float depth=(float)(bary[0]*q[0].depth+bary[1]*q[1].depth+bary[2]*q[2].depth);CHECK(isfinite(depth));if(depth<=nearest)continue;nearest=depth;found=1;double world[3]={0};for(int j=0;j<3;j++)for(int k=0;k<3;k++)world[k]+=bary[j]*fields[j].world[k];c->diag_node=v.node;c->diag_face=face;c->diag_record=(unsigned)offset;c->diag_source=w->source[v.node][face];c->diag_has_p=1;c->diag_p[0]=world[0]/38;c->diag_p[1]=-world[2]/38;c->diag_p[2]=-world[1]/38;}offset+=v.size;}
 CHECK(found&&!memcmp(&nearest,&expected,sizeof nearest)&&c->diag_source==w->center_id[y*240+x]);
}
static void print_domain(const char*name,const domain*d){printf("\"%s\":{\"slots\":%"PRIu64",\"floorHits\":%"PRIu64",\"parallelMisses\":%"PRIu64",\"negativeTMisses\":%"PRIu64",\"outsideFloorMisses\":%"PRIu64",\"clipMisses\":%"PRIu64",\"diskKernels\":%"PRIu64",\"positiveKernelQueries\":%"PRIu64"}",name,d->slots,d->floor,d->miss[0],d->miss[1],d->miss[2],d->miss[3],d->kernels,d->queries);}
int main(int argc,char**argv){
 CHECK(argc==9);clock_t begin=clock();struct timespec wall0,wall1;CHECK(!clock_gettime(CLOCK_MONOTONIC,&wall0));context c={0};const char*diag=getenv("BACKGROUND_ORDER_DIAGNOSTICS");CHECK(diag&&diag[0]);c.diagnostics=fopen(diag,"wx");CHECK(c.diagnostics);prepare(&c,argv[4]);int oblique=atoi(argv[8]);CHECK(oblique==0||oblique==1);
 uint8_t *snapshot=malloc(65536),*table=malloc(8192);uint16_t *rgb=calloc(32400,2);float *depth=malloc(129600);ksn_aa_workspace*w=malloc(sizeof*w);CHECK(snapshot&&table&&rgb&&depth&&w);size_t bytes=load(argv[1],snapshot,65536),tablebytes=load(argv[2],table,8192);CHECK(bytes>=416&&!memcmp(snapshot,"KSPX\1\0\0\0",8));double lights[51];for(int k=0;k<51;k++){uint64_t u=0;for(int j=0;j<8;j++)u|=(uint64_t)snapshot[8+8*k+j]<<(8*j);memcpy(lights+k,&u,8);}memcpy(&c.lights,lights,sizeof c.lights);CHECK(fox_disk_scene_validate(&c.lights)==FOX_DISK_OK);memset(c.lights.world_radiance,0,sizeof c.lights.world_radiance);
 ksn_mesh_pixel_snapshot s={.mesh={.packets={.data=snapshot+416,.size=bytes-416,.capacity=65536-416,.packets=54},.work=oblique?2641786:2750272,.work_limit=8000000,.enabled=true},.storage=snapshot,.capacity=65536};ksn_aa_identity id={table,tablebytes,54,1564,UINT64_C(0x912ba9aa3cfbfb2c),hash(snapshot,bytes)};ksn_aa_ledger ledger={0};FILE*f=fopen(argv[3],"r");CHECK(f);for(unsigned i=0;i<AA_CATEGORY_COUNT;i++)CHECK(fscanf(f,"%"SCNu64,&ledger.value[i])==1);char extra;CHECK(fscanf(f," %c",&extra)==EOF&&!fclose(f));c.samples=fopen(argv[5],"r");CHECK(c.samples);
 CHECK(ksn_mesh_pixel_render_boundary_experimental(&s,rgb,depth,w,&id,&ledger,zero_shader,&c,observer,&c)&&w->report.complete);CHECK(fscanf(c.samples," %c",&extra)==EOF&&!fclose(c.samples));c.samples=NULL;
 FILE*df=fopen(argv[6],"rb"),*tf=fopen(argv[7],"rb");CHECK(df&&tf);uint64_t center_misses=0;
 for(unsigned p=0;p<32400;p++){float expected;CHECK(fread(&expected,4,1,df)==1&&!memcmp(&expected,depth+p,4));int target=(w->targets[p/8]>>(p%8))&1;CHECK(fgetc(tf)==target);int hit=w->center_id[p]!=65535;CHECK(hit==isfinite(depth[p]));if(!hit)center_misses++;c.diag_sample=-1;c.diag_node=c.diag_face=c.diag_record=65535;c.diag_source=w->center_id[p];c.diag_has_p=0;if(hit&&p%240==145&&p/240==115)locate_center(&s,w,&c,p%240,p/240,depth[p]);inspect(&c,p%240,p/240,hit,depth[p],!target,!target&&!hit);}
 CHECK(fgetc(df)==EOF&&fgetc(tf)==EOF&&!fclose(df)&&!fclose(tf));CHECK(c.background.slots==32400+3*w->report.targets&&c.combined.slots==center_misses-w->report.nohit_targets+w->report.sample_nohits[0]+w->report.sample_nohits[1]+w->report.sample_nohits[2]+w->report.sample_nohits[3]);
 struct rusage usage;CHECK(!getrusage(RUSAGE_SELF,&usage));CHECK(!clock_gettime(CLOCK_MONOTONIC,&wall1));double seconds=(double)(clock()-begin)/CLOCKS_PER_SEC,wall=wall1.tv_sec-wall0.tv_sec+(wall1.tv_nsec-wall0.tv_nsec)*1e-9;
 printf("{\"geometryOnly\":true,\"shadowVisibilityExecuted\":false,\"transportExecuted\":false,\"geometryControlExact\":true,\"cameraDepthArithmetic\":\"float32 multiply-add sequential no FMA\",\"snapshotFNV\":\"%016"PRIx64"\",\"orderingSlots\":%"PRIu64",\"characterHitChecks\":%"PRIu64",\"floorStrictlyInFront\":%"PRIu64",\"floorExactDepthTies\":%"PRIu64",\"floorBehind\":%"PRIu64",\"floorTriangleTests\":%"PRIu64",\"evaluatorCalls\":%"PRIu64",\"callbackQueries\":%"PRIu64",\"oldDirectRays\":%"PRIu64",\"oldDirectNodes\":%"PRIu64",\"oldDirectTriangles\":%"PRIu64",\"combinedDirectRayRequirement\":%"PRIu64",\"combinedDirectRayFits\":%s,\"backgroundOnlyDirectRayFits\":%s,\"floorOrderingFits\":%s,\"geometryShaders\":%"PRIu64",\"geometrySampleChecks\":%"PRIu64",\"centerMisses\":%"PRIu64",\"maxReprojectionError\":%.17g,\"maxFloatReprojectionError\":%.17g,\"maxSampleRayVsRasterPDelta\":%.17g,\"maxNativeSourceOriginDelta\":%.17g,\"requestedHeapBytes\":%zu,\"contextBytes\":%zu,\"peakRSSKiB\":%ld,\"cpuSeconds\":%.9g,\"wallSeconds\":%.9g,",hash(snapshot,bytes),c.ordering_slots,c.character_hits,c.floor_front,c.floor_equal,c.floor_behind,c.triangle_tests,c.evaluator_calls,c.callbacks,c.old_rays,c.old_nodes,c.old_triangles,c.old_rays+c.combined.queries,c.old_rays+c.combined.queries<=1000000?"true":"false",c.background.queries<=1000000?"true":"false",c.floor_front?"false":"true",c.geometry_shades,c.geometry_samples,center_misses,c.max_reproject_error,c.max_float_reproject_error,c.max_sample_position_delta,c.max_source_native_origin_delta,(size_t)(65536+8192+64800+129600)+sizeof*w,sizeof c,usage.ru_maxrss,seconds,wall);print_domain("combinedEmpty",&c.combined);putchar(',');print_domain("backgroundOnly",&c.background);puts("}");
 CHECK(!fclose(c.diagnostics));free(w);free(depth);free(rgb);free(table);free(snapshot);return 0;
}
