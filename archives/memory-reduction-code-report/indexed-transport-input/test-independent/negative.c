#include "../private-build/transport/bounce.c"
#include <stdio.h>
#include <assert.h>
static unsigned checks, evals, failcases;
size_t test_vis_refs(vis_scene *,size_t);
#define CK(x) do { ++checks; if(!(x)){fprintf(stderr,"FAIL line %d: %s\n",__LINE__,#x);abort();}}while(0)
void *__real_calloc(size_t,size_t);
static size_t alloc_calls, fail_at, live;
static void *tracked[1024];
void __real_free(void *);
void *__wrap_calloc(size_t n,size_t z){if(++alloc_calls==fail_at)return NULL;void *p=__real_calloc(n,z);if(p){size_t i=0;while(i<1024&&tracked[i])i++;if(i==1024)abort();tracked[i]=p;live++;}return p;}
void __wrap_free(void *p){if(p)for(size_t i=0;i<1024;i++)if(tracked[i]==p){tracked[i]=NULL;live--;break;}__real_free(p);}
static bounce_generation gen={{1,1,1},1,0};
static bounce_triangle attr(void){bounce_triangle a={0};a.double_sided=1;for(int j=0;j<3;j++){a.v[j].front[2]=32767;a.v[j].back[2]=-32767;a.v[j].a565=0xf800;a.v[j].b565=0x8410;}return a;}
static FoxDiskScene lights(void){FoxDiskLightInput in[3]={0};FoxDiskScene s;for(int i=0;i<3;i++){in[i].shape=FOX_DISK_SHAPE_DISK;in[i].center[0]=i*2;in[i].center[2]=5;in[i].diameter=.2;in[i].power=1;}double w[]={.25,.5,1};CK(fox_disk_scene_init(&s,in,w,1)==FOX_DISK_OK);return s;}
static vis_scene *geometry(size_t count,double z){double xyz[]={-100,-100,z,100,-100,z,100,100,z,-100,100,z};uint32_t *idx=malloc(count*3*sizeof(*idx));CK(idx);for(size_t i=0;i<count;i++){idx[3*i]=0;idx[3*i+1]=i%2?2:1;idx[3*i+2]=i%2?3:2;}vis_scene *s=NULL;CK(vis_scene_build(&s,xyz,4,idx,count,gen.visibility,(vis_limits){2048,4095,524288})==VIS_OK);free(idx);return s;}
static bounce_result evaluate(bounce_scene *s,bounce_generation g,int mode,int samples,vis_counters *used){bounce_binding b={0};CK(bounce_binding_set(&b,s,g)==BOUNCE_OK);double p[]={0,0,0},n[]={0,0,1},rho[]={.3,.6,.9};vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};bounce_result r={0};CK(bounce_eval(&b,g,p,n,rho,(bounce_mode)mode,samples,16,&db,&tb,&r)==BOUNCE_OK);used[0]=db.used;used[1]=tb.used;bounce_binding_clear(&b);evals++;return r;}
static void parity(bounce_scene *a,bounce_scene *b,bounce_generation g){for(int m=0;m<3;m++)for(int n=16;n<=64;n*=4){vis_counters au[2],bu[2];bounce_result ar=evaluate(a,g,m,n,au),br=evaluate(b,g,m,n,bu);CK(!memcmp(&ar,&br,sizeof ar));CK(!memcmp(au,bu,sizeof au));}}
static bounce_status build(bounce_scene **s,vis_scene *v,const bounce_vertex *p,size_t pn,const bounce_indexed_triangle *r,size_t rn,const FoxDiskScene *l,bounce_generation g,size_t cap,const bounce_ground *gr){return bounce_scene_build_ground_indexed(s,v,p,pn,r,rn,l,1,g,cap,gr);}
static void reject(bounce_scene **s,vis_scene *v,const bounce_vertex *p,size_t pn,const bounce_indexed_triangle *r,size_t rn,const FoxDiskScene *l,bounce_generation g,bounce_status want){bounce_scene *old=*s;size_t before=live;CK(build(s,v,p,pn,r,rn,l,g,262144,NULL)==want);CK(*s==old);CK(live==before);failcases++;}
static uint64_t fingerprint(const void *p,size_t n){const unsigned char *b=p;uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*b++;h*=UINT64_C(1099511628211);}return h;}
static void expand(bounce_triangle *a,const bounce_vertex *p,const bounce_indexed_triangle *r,size_t n){for(size_t i=0;i<n;i++){memset(a+i,0,sizeof(*a));a[i].double_sided=r[i].double_sided;for(int j=0;j<3;j++)a[i].v[j]=p[r[i].index[j]];}}
int main(void){
 FoxDiskScene l=lights();bounce_vertex p[7];for(int i=0;i<7;i++)p[i]=attr().v[0];bounce_indexed_triangle r[2]={{{0,1,2},1,0},{{3,4,5},1,0}};bounce_triangle a[2];expand(a,p,r,2);vis_scene *v=geometry(2,1);bounce_scene *s=NULL;
 CK(sizeof(bounce_vertex)==20);CK(sizeof(bounce_indexed_triangle)==8);size_t need=bounce_scene_indexed_required_bytes(p,7,r,2);CK(need==sizeof(bounce_scene)+16+20);
 CK(!bounce_scene_indexed_required_bytes(NULL,7,r,2));CK(!bounce_scene_indexed_required_bytes(p,7,NULL,2));CK(!bounce_scene_indexed_required_bytes(p,0,r,2));CK(!bounce_scene_indexed_required_bytes(p,6145,r,2));CK(!bounce_scene_indexed_required_bytes(p,7,r,0));CK(!bounce_scene_indexed_required_bytes(p,7,r,2049));CK(!bounce_scene_indexed_required_bytes(p,SIZE_MAX,r,2));CK(!bounce_scene_indexed_required_bytes(p,7,r,SIZE_MAX));
 CK(build(&s,v,p,7,r,2,&l,gen,need-1,NULL)==BOUNCE_INVALID);CK(!s);CK(build(&s,v,p,7,r,2,&l,gen,need,NULL)==BOUNCE_OK);CK(s->bytes==need);bounce_generation next=gen;next.material++;
 for(int t=0;t<2;t++)for(int c=0;c<3;c++)for(int bad=0;bad<2;bad++){uint16_t old=r[t].index[c];r[t].index[c]=bad?UINT16_MAX:7;CK(!bounce_scene_indexed_required_bytes(p,7,r,2));reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);r[t].index[c]=old;}
 for(int t=0;t<2;t++){r[t].padding=1;reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);r[t].padding=0;r[t].double_sided=2;reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);r[t].double_sided=1;}
 for(int vertex=0;vertex<7;vertex++){float bad[]={NAN,INFINITY,-INFINITY};for(int k=0;k<3;k++){p[vertex].mask=bad[k];CK(!bounce_scene_indexed_required_bytes(p,7,r,2));reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);}p[vertex]=attr().v[0];for(int side=0;side<2;side++){for(int k=0;k<3;k++){(side?p[vertex].back:p[vertex].front)[k]=INT16_MIN;reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);p[vertex]=attr().v[0];}memset(side?p[vertex].back:p[vertex].front,0,6);reject(&s,v,p,7,r,2,&l,next,BOUNCE_INVALID);p[vertex]=attr().v[0];}}
 _Alignas(bounce_vertex) unsigned char pu[sizeof p+8];_Alignas(bounce_indexed_triangle) unsigned char ru[sizeof r+8];memcpy(pu+1,p,sizeof p);memcpy(ru+1,r,sizeof r);
 reject(&s,v,(void*)(pu+1),7,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,(void*)(ru+1),2,&l,next,BOUNCE_INVALID);
 const bounce_vertex *farv=(const bounce_vertex*)(UINTPTR_MAX-3);const bounce_indexed_triangle *farr=(const bounce_indexed_triangle*)(UINTPTR_MAX-1);CK(!bounce_scene_indexed_required_bytes(farv,7,r,2));CK(!bounce_scene_indexed_required_bytes(p,7,farr,2));reject(&s,v,farv,7,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,farr,2,&l,next,BOUNCE_INVALID);
 /* Complete spans must reject aliases before reading attribute payloads. */
 reject(&s,v,p,7,(void*)p,2,&l,next,BOUNCE_INVALID);reject(&s,v,(void*)r,1,r,2,&l,next,BOUNCE_INVALID);
 reject(&s,v,(void*)&s,1,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,(void*)&s,2,&l,next,BOUNCE_INVALID);
 reject(&s,v,(void*)s,1,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,(void*)s,2,&l,next,BOUNCE_INVALID);
 reject(&s,v,(void*)v,1,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,(void*)v,2,&l,next,BOUNCE_INVALID);
 reject(&s,v,(void*)&l,1,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,(void*)&l,2,&l,next,BOUNCE_INVALID);
 bounce_ground gr={0};CK(build(&s,v,(void*)&gr,1,r,2,&l,next,262144,&gr)==BOUNCE_INVALID);CK(build(&s,v,p,7,(void*)&gr,2,&l,next,262144,&gr)==BOUNCE_INVALID);
 CK(build(NULL,v,p,7,r,2,&l,next,262144,NULL)==BOUNCE_INVALID);reject(&s,NULL,p,7,r,2,&l,next,BOUNCE_INVALID);reject(&s,v,p,7,r,2,NULL,next,BOUNCE_INVALID);
 reject(&s,v,p,7,r,2,&l,gen,BOUNCE_GENERATION);bounce_generation badgen=next;badgen.visibility.pose++;reject(&s,v,p,7,r,2,&l,badgen,BOUNCE_GENERATION);badgen=next;badgen.material=0;reject(&s,v,p,7,r,2,&l,badgen,BOUNCE_INVALID);

 _Alignas(bounce_scene *) unsigned char sbuf[sizeof(bounce_scene *)+8];memcpy(sbuf+1,&s,sizeof s);CK(build((void*)(sbuf+1),v,p,7,r,2,&l,next,262144,NULL)==BOUNCE_INVALID);
 _Alignas(FoxDiskScene) unsigned char lbuf[sizeof l+8];memcpy(lbuf+1,&l,sizeof l);reject(&s,v,p,7,r,2,(void*)(lbuf+1),next,BOUNCE_INVALID);
 _Alignas(bounce_ground) unsigned char gbuf[sizeof gr+8];memcpy(gbuf+1,&gr,sizeof gr);CK(build(&s,v,p,7,r,2,&l,next,262144,(void*)(gbuf+1))==BOUNCE_INVALID);
 unsigned char saved[sizeof s];memcpy(saved,&s->ground.le[0],sizeof saved);memcpy(&s->ground.le[0],&s,sizeof s);bounce_scene **ownedslot=(void*)&s->ground.le[0];CK(build(ownedslot,v,p,7,r,2,&l,next,262144,NULL)==BOUNCE_INVALID);CK(*ownedslot==s);memcpy(&s->ground.le[0],saved,sizeof saved);
 size_t refs=test_vis_refs(v,SIZE_MAX);reject(&s,v,p,7,r,2,&l,next,BOUNCE_VISIBILITY);CK(test_vis_refs(v,refs)==SIZE_MAX);
 size_t br=s->refs;s->refs=SIZE_MAX;bounce_binding b={0};CK(bounce_binding_set(&b,s,gen)==BOUNCE_INVALID);CK(!b.scene);s->refs=br;
 bounce_binding retained={0};CK(bounce_binding_set(&retained,s,gen)==BOUNCE_OK);alloc_calls=0;fail_at=1;reject(&s,v,p,7,r,2,&l,next,BOUNCE_ALLOC);CK(alloc_calls==1);fail_at=0;vis_counters used[2];CK(evaluate(retained.scene,gen,2,16,used).counters.primary_hits==16);
 /* Every API replaces each other while old binding remains independently valid. */
 for(int kind=0;kind<6;kind++){next.material++;bounce_scene *old=s;bounce_binding keep={0};CK(bounce_binding_set(&keep,s,s->generation)==BOUNCE_OK);bounce_status st=kind%3==0?bounce_scene_build(&s,v,a,2,&l,1,next,262144):kind%3==1?bounce_scene_build_ground_compact(&s,v,a,2,&l,1,next,262144,NULL):build(&s,v,p,7,r,2,&l,next,262144,NULL);CK(st==BOUNCE_OK);CK(s!=old);CK(evaluate(keep.scene,keep.generation,2,16,used).counters.primary_hits==16);bounce_binding_clear(&keep);}
 bounce_binding_clear(&retained);bounce_scene_release(s);vis_scene_release(v);
 /* Full-bit interning, including signed zero, each normal and RGB565 field. */
 for(int field=0;field<9;field++){for(int i=0;i<7;i++)p[i]=attr().v[0];if(field<3)p[1].front[field]+=(field==2?-1:1);else if(field<6)p[1].back[field-3]++;else if(field==6)p[1].mask=-0.0f;else if(field==7)p[1].a565++;else p[1].b565++;CK(bounce_scene_indexed_required_bytes(p,7,r,2)==sizeof(bounce_scene)+16+40);}
 /* Same source vertex at every index; unused distinct vertices do not inflate. */
 for(int i=0;i<7;i++){p[i]=attr().v[0];p[i].a565=(uint16_t)i;}for(int t=0;t<2;t++)for(int j=0;j<3;j++)r[t].index[j]=4;CK(bounce_scene_indexed_required_bytes(p,7,r,2)==need);
 /* Synthetic position is identical for both triangles; distinct full attributes survive. */
 for(int t=0;t<2;t++)for(int j=0;j<3;j++)r[t].index[j]=(uint16_t)(t*3+j);
 for(int variant=0;variant<12;variant++){for(int i=0;i<7;i++){p[i]=attr().v[0];p[i].a565=(uint16_t)(i*13);p[i].b565=(uint16_t)(0x8000+i*31);p[i].mask=variant%3-1;if(variant==3)p[i].mask=i%2?-0.0f:0.0f;}v=geometry(2,variant==0?-1:1);expand(a,p,r,2);uint64_t expected=fingerprint(a,sizeof a);bounce_scene *sc[3]={0};CK(bounce_scene_build(&sc[0],v,a,2,&l,1,gen,262144)==BOUNCE_OK);CK(bounce_scene_build_ground_compact(&sc[1],v,a,2,&l,1,gen,262144,NULL)==BOUNCE_OK);CK(build(&sc[2],v,p,7,r,2,&l,gen,262144,NULL)==BOUNCE_OK);CK(sc[1]->bytes==sc[2]->bytes);CK(!memcmp(sc[1]->attrs,sc[2]->attrs,sc[1]->bytes-sizeof(bounce_scene)));bounce_triangle reconstructed[2]={0};for(int t=0;t<2;t++){reconstructed[t].double_sided=(uint8_t)material_double_sided(sc[2],t);for(int j=0;j<3;j++)reconstructed[t].v[j]=*material_vertex(sc[2],t,j);}CK(!memcmp(a,reconstructed,sizeof a));CK(fingerprint(reconstructed,sizeof reconstructed)==expected);memset(a,0xa5,sizeof a);memset(p,0xa5,sizeof p);memset(r,0xa5,sizeof r);vis_scene_release(v);parity(sc[0],sc[2],gen);parity(sc[1],sc[2],gen);for(int i=0;i<3;i++)bounce_scene_release(sc[i]);r[0]=(bounce_indexed_triangle){{0,1,2},1,0};r[1]=(bounce_indexed_triangle){{3,4,5},1,0};}
 /* Ground descriptor ownership and mode 3 exact shading/work ledger parity. */
 for(int groundmode=1;groundmode<=3;groundmode++){
  v=geometry(2,1);a[0]=a[1]=attr();for(int i=0;i<7;i++)p[i]=attr().v[0];bounce_ground ground={0};ground.mode=(bounce_ground_mode)groundmode;ground.object_id=7;ground.triangle_count=2;ground.le[0]=.2;ground.le[1]=.4;ground.le[2]=.8;if(groundmode==3){ground.rho[0]=.3;ground.rho[1]=.5;ground.rho[2]=.7;}bounce_generation gg=gen;gg.emission=1;
  bounce_scene *ss[2]={0};CK(bounce_scene_build_ground(&ss[0],v,a,2,&l,1,gg,262144,&ground)==BOUNCE_OK);CK(build(&ss[1],v,p,7,r,2,&l,gg,262144,&ground)==BOUNCE_OK);memset(&ground,0xa5,sizeof ground);memset(a,0xa5,sizeof a);memset(p,0xa5,sizeof p);vis_scene_release(v);
  if(groundmode<3)parity(ss[0],ss[1],gg);
  else {bounce_result rr[2];bounce_floor_world_result wr[2];bounce_floor_work fw[2];bounce_floor_world_work ww[2];vis_counters consumed[2][2];for(int x=0;x<2;x++){bounce_binding b={0};CK(bounce_binding_set(&b,ss[x],gg)==BOUNCE_OK);double p[]={0,0,0},nn[]={0,0,1},rho[]={.3,.6,.9};vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};CK(bounce_floor_work_init(&fw[x],1,16)==BOUNCE_OK);CK(bounce_floor_world_work_init(&ww[x],1,16)==BOUNCE_OK);CK(bounce_eval_floor_world_experimental(&b,gg,p,nn,rho,BOUNCE_ONE,16,16,&db,&tb,&fw[x],&ww[x],&rr[x],&wr[x])==BOUNCE_OK);consumed[x][0]=db.used;consumed[x][1]=tb.used;bounce_binding_clear(&b);evals++;}CK(!memcmp(rr,rr+1,sizeof rr[0]));CK(!memcmp(wr,wr+1,sizeof wr[0]));CK(!memcmp(fw,fw+1,sizeof fw[0]));CK(!memcmp(ww,ww+1,sizeof ww[0]));CK(!memcmp(consumed,consumed+1,sizeof consumed[0]));CK(rr[0].counters.primary_ground_hits==16);}
  bounce_scene_release(ss[0]);bounce_scene_release(ss[1]);
 }
 size_t n=2048,vn=6144;bounce_vertex *mp=malloc(vn*sizeof *mp);bounce_indexed_triangle *mr=calloc(n,sizeof *mr);CK(mp&&mr);for(size_t i=0;i<vn;i++){mp[i]=attr().v[0];mp[i].a565=(uint16_t)i;}for(size_t i=0;i<n;i++){mr[i].double_sided=1;for(int j=0;j<3;j++)mr[i].index[j]=(uint16_t)(3*i+j);}need=bounce_scene_indexed_required_bytes(mp,vn,mr,n);CK(need==139848);v=geometry(n,1);s=NULL;CK(build(&s,v,mp,vn,mr,n,&l,gen,need-1,NULL)==BOUNCE_INVALID);CK(!s);CK(build(&s,v,mp,vn,mr,n,&l,gen,need,NULL)==BOUNCE_OK);CK(s->bytes==need);CK(!memcmp(material_vertex(s,2047,2),mp+6143,20));bounce_scene_release(s);vis_scene_release(v);free(mp);free(mr);CK(live==0);
 printf("PASS checks=%u evaluations=%u rejected_cases=%u scene_calloc_failure_sites=1 synthetic_variants=15 parity_pairs=157 maximum_vertices=6144 maximum_triangles=2048 maximum_owned_bytes=139848 calloc_live=0\n",checks,evals,failcases);return 0;
}
