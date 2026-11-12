/* Storage v3 admission, exact requested-heap accounting, and ownership tests.
 * The allocator adds a private 64-byte tail guard, excluded from all reported
 * requested-byte totals. Every freed payload is poisoned before real free.
 * Geometry here is synthetic, including the renderer-count memory fixture.
 */
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct { void *p; size_t n; } allocation;
static allocation live[32];
static size_t live_bytes, live_allocs, peak_bytes, attempts, fail_at;
static size_t largest, requested[8], allocation_total, free_total, poisoned_frees;
static size_t temp_frees, temp_frees_total;
static void *watched_slot, *watched_old, *watched_temp;
static int watching_build;
static int corrupt_tree_for_witness;

static void *tracked(size_t n,int clear){
 attempts++;
 if(watching_build && attempts==6 && corrupt_tree_for_witness){
  int found=0;uint64_t impossible=UINT64_C(0x7ff8000000000000);
  for(size_t k=0;k<32;k++)if(live[k].p && live[k].n==65472){memcpy(live[k].p,&impossible,sizeof(impossible));found++;}
  assert(found==1);
 }
 assert(attempts<=sizeof(requested)/sizeof(requested[0]));
 requested[attempts-1]=n;
 if(n>largest)largest=n;
 if(fail_at && attempts==fail_at)return NULL;
 assert(n && n<=SIZE_MAX-64);
 unsigned char *p=clear?calloc(1,n+64):malloc(n+64);
 assert(p);
 memset(p+n,0xd3,64);
 for(size_t i=0;i<sizeof(live)/sizeof(live[0]);i++)if(!live[i].p){
  live[i]=(allocation){p,n};live_bytes+=n;live_allocs++;allocation_total++;
  if(live_bytes>peak_bytes)peak_bytes=live_bytes;
  if(watching_build && attempts==5)watched_temp=p;
  return p;
 }
 abort();
}
static void *tmalloc(size_t n){return tracked(n,0);}
static void *tcalloc(size_t n,size_t z){assert(!z || n<=SIZE_MAX/z);return tracked(n*z,1);}
static void tfree(void *p){
 if(!p)return;
 for(size_t i=0;i<sizeof(live)/sizeof(live[0]);i++)if(live[i].p==p){
  unsigned char *q=p;
  for(size_t k=0;k<64;k++)assert(q[live[i].n+k]==0xd3);
  if(watching_build && p==watched_temp){
   void *current=NULL;memcpy(&current,watched_slot,sizeof(current));
   assert(current==watched_old); /* Temporary is gone before slot publication. */
   temp_frees++;temp_frees_total++;watched_temp=NULL;
  }
  if(watching_build && p==watched_old){
   void *current=NULL;memcpy(&current,watched_slot,sizeof(current));
   assert(temp_frees==1 && current!=watched_old);
  }
  live_bytes-=live[i].n;live_allocs--;free_total++;
  /* Volatile writes keep poisoning observable even at -O2 before free. */
  volatile unsigned char *poison=p;
  for(size_t k=0;k<live[i].n;k++)poison[k]=0xa5;
  poisoned_frees++;live[i]=(allocation){0};free(p);return;
 }
 abort(); /* Double free or a free of an unowned allocation. */
}
#define malloc tmalloc
#define calloc tcalloc
#define free tfree
#include "../private-build/visibility/visibility.c"
#undef malloc
#undef calloc
#undef free

_Static_assert(sizeof(double)==8 && sizeof(size_t)==8 && sizeof(void *)==8,"64-bit accounting fixture");
_Static_assert(sizeof(triangle)==8 && offsetof(triangle,vertex)==0 && offsetof(triangle,ordinal)==6,"indexed runtime layout");
_Static_assert(sizeof(build_center)==24 && offsetof(build_center,center)==0,"centroid-only build layout");
_Static_assert(sizeof(node)==64 && offsetof(node,lo)==0 && offsetof(node,hi)==24 && offsetof(node,left)==48 && offsetof(node,right)==52 && offsetof(node,start)==56 && offsetof(node,count)==60,"unchanged node layout");
_Static_assert(sizeof(vis_scene)==96 && offsetof(vis_scene,refs)==0 && offsetof(vis_scene,bytes)==8 && offsetof(vis_scene,triangles)==16 && offsetof(vis_scene,nodes)==24 && offsetof(vis_scene,node_capacity)==32 && offsetof(vis_scene,vertices)==40 && offsetof(vis_scene,generation)==48 && offsetof(vis_scene,tri)==72 && offsetof(vis_scene,tree)==80 && offsetof(vis_scene,xyz)==88,"owned indexed scene layout");

static double xyz[VIS_MAX_VERTICES*3];
static _Alignas(void *) uint32_t indices[VIS_MAX_TRIANGLES*3];
static const vis_generation first={1,1,1}, second={2,1,1};
static const double from[3]={0,0,-1}, to[3]={0,0,1}, direction[3]={0,0,1};

static size_t maximum(size_t a,size_t b){return a>b?a:b;}
static size_t oracle_nodes(size_t n){
 /* Breadth-first subdivision is independent of production's recursive count. */
 size_t pending[2048],head=0,tail=1,count=0;pending[0]=n;
 while(head<tail){
  size_t x=pending[head++];count++;
  if(x>4){assert(tail+2<=2048);pending[tail++]=x/2;pending[tail++]=x-x/2;}
 }
 return count;
}
static size_t oracle_bytes(size_t v,size_t n){return 96+24*v+8*n+28*oracle_nodes(n);}
static size_t persistent_largest(size_t v,size_t n){return maximum(maximum(96,24*v),maximum(8*n,28*oracle_nodes(n)));}
static vis_limits exact_limits(size_t v,size_t n){vis_limits l={n,oracle_nodes(n),oracle_bytes(v,n)};return l;}
static vis_budget ample(void){vis_budget b={{10000,1000000,1000000},{0,0,0}};return b;}
static void reset_operation(void){
 assert(!watching_build);attempts=0;peak_bytes=live_bytes;largest=0;
 memset(requested,0,sizeof(requested));temp_frees=0;watched_temp=NULL;
}
static vis_status build(vis_scene **slot,const double *points,size_t vertices,
                        const uint32_t *idx,size_t n,vis_generation g,vis_limits lim){
 reset_operation();watching_build=1;watched_slot=slot;watched_old=slot?*slot:NULL;
 vis_status r=vis_scene_build(slot,points,vertices,idx,n,g,lim);
 watching_build=0;watched_slot=watched_old=watched_temp=NULL;
 return r;
}
static void check_balance(void){assert(live_allocs==allocation_total-free_total && free_total==poisoned_frees);}
static void check_empty(void){check_balance();assert(live_allocs==0 && live_bytes==0);}
static void fill_inputs(size_t v,size_t n){
 assert(v>=3 && v<=VIS_MAX_VERTICES && n && n<=VIS_MAX_TRIANGLES);
 size_t groups=v/3;
 for(size_t k=0;k<v;k++){
  size_t corner=k%3,group=k/3;
  xyz[3*k]=(corner==0?-1.0:corner==1?1.0:(group&1?-0.0:0.0));
  xyz[3*k+1]=corner==2?1.0:-1.0;
  xyz[3*k+2]=group&1?-0.0:0.0;
 }
 /* An unused vertex is still owned and copied, never welded or discarded. */
 if(v%3){xyz[3*(v-1)]=123.25;xyz[3*(v-1)+1]=-456.5;xyz[3*(v-1)+2]=-0.0;}
 for(size_t i=0;i<n;i++)for(size_t j=0;j<3;j++){
  size_t corner=i%4==3?(j+2)%3:j;
  size_t group=i%4==0?0:i%4==1?(i*17)%groups:(i*29+j*7)%groups;
  indices[3*i+j]=(uint32_t)(3*group+corner);
 }
}
static void check_requests(size_t v,size_t n){
 assert(attempts==5 || attempts==6);
 if(attempts==6)assert(requested[5]==28*oracle_nodes(n));
 assert(requested[0]==96 && requested[1]==24*v && requested[2]==8*n && requested[3]==64*oracle_nodes(n) && requested[4]==24*n);
 assert(largest==maximum(maximum(persistent_largest(v,n),24*n),64*oracle_nodes(n)));
}
static void check_identity(const vis_scene *s,const double *points,size_t v,const uint32_t *idx,size_t n){
 unsigned char seen[VIS_MAX_TRIANGLES]={0};
 assert(s->vertices==v && s->triangles==n && s->nodes==oracle_nodes(n) && s->node_capacity==s->nodes && s->bytes==oracle_bytes(v,n));
 assert(s->xyz!=points && !memcmp(s->xyz,points,24*v));
 assert(vis_scene_bytes(s)==s->bytes && vis_scene_triangle_count(s)==n && vis_scene_node_count(s)==s->nodes);
 for(size_t i=0;i<n;i++){
  const triangle *t=&s->tri[i];size_t ordinal=t->ordinal;
  assert(ordinal<n && !seen[ordinal]);seen[ordinal]=1;
  for(size_t k=0;k<3;k++){
   assert(t->vertex[k]==idx[3*ordinal+k]);
   assert(!memcmp(s->xyz+3*t->vertex[k],points+3*idx[3*ordinal+k],3*sizeof(double)));
  }
 }
 for(size_t i=0;i<n;i++)assert(seen[i]);
}
static void query_ok(const vis_binding *b,vis_generation g){
 int hit=77;vis_budget budget=ample();vis_hit nearest;memset(&nearest,0x55,sizeof(nearest));
 assert(vis_segment_occluded(b,g,from,to,&budget,&hit)==VIS_OK && hit==1);
 budget=ample();assert(vis_ray_nearest(b,g,from,direction,&budget,&nearest)==VIS_OK);
 assert(nearest.found==1 && nearest.triangle_ordinal==0 && nearest.distance==1.0);
 assert(nearest.position[0]==0 && nearest.position[1]==0 && nearest.position[2]==0);
 assert(nearest.geometric_normal[2]==1.0);
}
static void still_old(vis_scene *s,vis_scene *old,const vis_binding *b,size_t bytes){
 assert(s==old && b->scene==old && old->refs==2 && live_bytes==bytes && live_allocs==4);
 assert(equal(old->generation,first) && equal(b->generation,first));check_balance();
}

static void exhaustive_counts(void){
 const size_t vertex_counts[]={3,VIS_MAX_VERTICES};
 for(size_t vi=0;vi<2;vi++)for(size_t n=1;n<=VIS_MAX_TRIANGLES;n++){
  size_t v=vertex_counts[vi],nodes=oracle_nodes(n),bytes=oracle_bytes(v,n);
  fill_inputs(v,n);
  assert(vis_scene_required_nodes(n)==nodes && vis_scene_required_bytes_v3(v,n)==bytes && vis_scene_build_temporary_bytes_v3(n)==maximum(24*n,28*nodes)+36*nodes);
  vis_limits lim=exact_limits(v,n);vis_scene *s=NULL;
  assert(build(&s,xyz,v,indices,n,first,lim)==VIS_OK);check_requests(v,n);
  assert(s->refs==1 && live_bytes==bytes && peak_bytes==bytes+maximum(24*n,28*nodes)+36*nodes && live_allocs==4 && temp_frees==1);
  check_identity(s,xyz,v,indices,n);
  vis_scene *old=s;vis_binding b={0};assert(vis_binding_set(&b,s,first)==VIS_OK);
  lim.max_triangles=n-1;assert(build(&s,xyz,v,indices,n,second,lim)==VIS_CAPACITY && attempts==0);still_old(s,old,&b,bytes);
  lim.max_triangles=n;lim.max_nodes=nodes-1;assert(build(&s,xyz,v,indices,n,second,lim)==VIS_CAPACITY && attempts==0);still_old(s,old,&b,bytes);
  lim.max_nodes=nodes;lim.max_bytes=bytes-1;assert(build(&s,xyz,v,indices,n,second,lim)==VIS_CAPACITY && attempts==0);still_old(s,old,&b,bytes);
  if(n==1 || n==4 || n==5 || n==511 || n==1025 || n==2048)query_ok(&b,first);
  vis_binding_clear(&b);vis_scene_release(s);check_empty();
 }
}
static void invalid_helpers(void){
 const size_t bad_n[]={0,VIS_MAX_TRIANGLES+1u,SIZE_MAX};
 const size_t bad_v[]={0,VIS_MAX_VERTICES+1u,SIZE_MAX};
 for(size_t i=0;i<3;i++){
  assert(!vis_scene_required_nodes(bad_n[i]));
  assert(!vis_scene_required_bytes_v3(3,bad_n[i]));
  assert(!vis_scene_build_temporary_bytes_v3(bad_n[i]));
  assert(!vis_scene_required_bytes_v3(bad_v[i],1));
 }
 assert(!required_bytes_checked(0,1,1) && !required_bytes_checked(1,0,1) && !required_bytes_checked(1,1,0));
 assert(!required_bytes_checked(SIZE_MAX,1,1) && !required_bytes_checked(1,SIZE_MAX,1) && !required_bytes_checked(1,1,SIZE_MAX));
 assert(!required_bytes_checked(SIZE_MAX/24+1,1,1));
 assert(!required_bytes_checked(1,SIZE_MAX/8+1,1));
 assert(!required_bytes_checked(1,1,SIZE_MAX/28+1));
 size_t safe_nodes=(SIZE_MAX-96-24-8)/28;
 assert(required_bytes_checked(1,1,safe_nodes)==128+28*safe_nodes);
 assert(!required_bytes_checked(1,1,safe_nodes+1));
 assert(vis_scene_required_bytes_v3(1,1)==156); /* Accounting is separate from geometric validity. */
 assert(!vis_scene_bytes(NULL) && !vis_scene_triangle_count(NULL) && !vis_scene_node_count(NULL));
 assert(equal(vis_scene_generation(NULL),(vis_generation){0,0,0}));
 assert(vis_scene_retain(NULL)==VIS_INVALID && !vis_scene_overlaps(NULL,xyz,sizeof(xyz)));
 assert(!spans_overlap(NULL,10,xyz,10) && !spans_overlap(xyz,0,xyz,10));
 assert(spans_overlap((void *)(UINTPTR_MAX-3),8,xyz,1));
 assert(spans_overlap(xyz,1,(void *)(UINTPTR_MAX-3),8));
 vis_scene_release(NULL);vis_binding_clear(NULL);
}

typedef struct {unsigned char *p;size_t n;unsigned char *saved;} span;
static void capture_spans(vis_scene *s,span spans[4]){
 spans[0]=(span){(unsigned char *)s,sizeof(*s),NULL};
 spans[1]=(span){(unsigned char *)s->xyz,s->vertices*3*sizeof(double),NULL};
 spans[2]=(span){(unsigned char *)s->tri,s->triangles*sizeof(triangle),NULL};
 spans[3]=(span){(unsigned char *)s->tree,s->node_capacity*sizeof(compact_node),NULL};
 for(size_t k=0;k<4;k++){spans[k].saved=malloc(spans[k].n);assert(spans[k].saved);memcpy(spans[k].saved,spans[k].p,spans[k].n);}
}
static void assert_spans(const span spans[4]){for(size_t k=0;k<4;k++)assert(!memcmp(spans[k].p,spans[k].saved,spans[k].n));}
static void free_snapshots(span spans[4]){for(size_t k=0;k<4;k++)free(spans[k].saved);}
static void check_aliases(vis_scene *s,vis_binding *binding,size_t v,size_t n){
 span spans[4];capture_spans(s,spans);vis_limits lim=exact_limits(v,n);
 for(size_t k=0;k<4;k++){
  assert(vis_scene_overlaps(s,spans[k].p,1));
  assert(vis_scene_overlaps(s,spans[k].p+spans[k].n-1,1));
  assert(!vis_scene_overlaps(s,spans[k].p+spans[k].n,1));
  assert(!vis_scene_overlaps(s,spans[k].p,0));
  for(size_t edge=0;edge<2;edge++){
   /* Partial end overlaps reject before reading/writing the pointed-to object. */
   unsigned char *p=spans[k].p+(edge?spans[k].n-1:0);
   vis_budget budget=ample(),budget_before=budget;int hit=78;vis_hit out,out_before;
   memset(&out,0x55,sizeof(out));out_before=out;
   assert(vis_binding_set((vis_binding *)(void *)p,s,first)==VIS_INVALID);
   assert(vis_segment_occluded(binding,first,from,to,&budget,(int *)(void *)p)==VIS_INVALID);
   assert(!memcmp(&budget,&budget_before,sizeof(budget)));
   assert(vis_ray_nearest(binding,first,from,direction,&budget,(vis_hit *)(void *)p)==VIS_INVALID);
   assert(!memcmp(&budget,&budget_before,sizeof(budget)));
   assert(vis_segment_occluded(binding,first,from,to,(vis_budget *)(void *)p,&hit)==VIS_INVALID && hit==78);
   assert(vis_ray_nearest(binding,first,from,direction,(vis_budget *)(void *)p,&out)==VIS_INVALID && !memcmp(&out,&out_before,sizeof(out)));
   assert_spans(spans);
  }
  /* A builder slot must be a real aligned pointer object. Exercise the first
   * and final pointer-sized words, rather than dereference a forged end byte. */
  for(size_t edge=0;edge<2;edge++){
   unsigned char *p=spans[k].p+(edge?(spans[k].n-sizeof(s))/_Alignof(vis_scene *)*_Alignof(vis_scene *):0);
   unsigned char saved[sizeof(s)];memcpy(saved,p,sizeof(saved));memcpy(p,&s,sizeof(s));
   unsigned char *snapshot=malloc(spans[k].n);assert(snapshot);memcpy(snapshot,spans[k].p,spans[k].n);
   reset_operation();assert(vis_scene_build((vis_scene **)(void *)p,xyz,v,indices,n,second,lim)==VIS_INVALID && attempts==0);
   assert(!memcmp(snapshot,spans[k].p,spans[k].n));free(snapshot);memcpy(p,saved,sizeof(saved));assert_spans(spans);
  }
  /* Clearing a fabricated binding in an owned span is an atomic no-op. */
  for(size_t edge=0;edge<2;edge++){
   unsigned char *p=spans[k].p+(edge?(spans[k].n-sizeof(vis_binding))/_Alignof(vis_binding)*_Alignof(vis_binding):0);
   unsigned char saved[sizeof(vis_binding)];memcpy(saved,p,sizeof(saved));
   vis_binding fake={s,first};memcpy(p,&fake,sizeof(fake));
   unsigned char *snapshot=malloc(spans[k].n);assert(snapshot);memcpy(snapshot,spans[k].p,spans[k].n);
   vis_binding_clear((vis_binding *)(void *)p);
   assert(!memcmp(snapshot,spans[k].p,spans[k].n));free(snapshot);memcpy(p,saved,sizeof(saved));assert_spans(spans);
  }
 }
 assert(vis_scene_overlaps(s,(void *)(UINTPTR_MAX-3),8));
 for(size_t edge=0;edge<2;edge++){
  unsigned char *p=(unsigned char *)xyz+(edge?24*v-sizeof(s):0);
  reset_operation();assert(vis_scene_build((vis_scene **)(void *)p,xyz,v,indices,n,second,lim)==VIS_INVALID && attempts==0);
  p=(unsigned char *)indices+(edge?12*n-sizeof(s):0);
  assert(vis_scene_build((vis_scene **)(void *)p,xyz,v,indices,n,second,lim)==VIS_INVALID && attempts==0);
 }
 assert_spans(spans);free_snapshots(spans);query_ok(binding,first);
}
static void failure_outputs(vis_binding *b){
 vis_hit out,old;int hit=78;vis_budget budget=ample(),before=budget;
 memset(&out,0x55,sizeof(out));old=out;
 assert(vis_segment_occluded(b,second,from,to,&budget,&hit)==VIS_GENERATION && hit==78);
 assert(vis_ray_nearest(b,second,from,direction,&budget,&out)==VIS_GENERATION && !memcmp(&out,&old,sizeof(out)));
 assert(!memcmp(&budget,&before,sizeof(budget)));
 const double bad[3]={NAN,0,0},zero[3]={0,0,0};
 assert(vis_segment_occluded(b,first,bad,to,&budget,&hit)==VIS_INVALID && hit==78);
 assert(vis_segment_occluded(b,first,from,from,&budget,&hit)==VIS_INVALID && hit==78);
 assert(vis_ray_nearest(b,first,from,zero,&budget,&out)==VIS_INVALID && !memcmp(&out,&old,sizeof(out)));
 assert(vis_ray_nearest(b,first,bad,direction,&budget,&out)==VIS_INVALID && !memcmp(&out,&old,sizeof(out)));
 assert(!memcmp(&budget,&before,sizeof(budget)));
 for(size_t k=0;k<3;k++){
  budget=ample();if(k==0)budget.limit.rays=0;else if(k==1)budget.limit.node_visits=0;else budget.limit.triangle_tests=0;
  assert(vis_segment_occluded(b,first,from,to,&budget,&hit)==VIS_BUDGET && hit==78);
  budget=ample();if(k==0)budget.limit.rays=0;else if(k==1)budget.limit.node_visits=0;else budget.limit.triangle_tests=0;
  assert(vis_ray_nearest(b,first,from,direction,&budget,&out)==VIS_BUDGET && !memcmp(&out,&old,sizeof(out)));
 }
}
static void guard_builder(vis_scene *s,size_t n){
 build_center *work=calloc(n,sizeof(*work));assert(work);
 triangle *tri=malloc(n*sizeof(*tri));assert(tri);
 size_t total=s->nodes;node *guard=malloc((total+2)*sizeof(*guard));assert(guard);
 node *saved=malloc((total+2)*sizeof(*saved));assert(saved);
 const size_t capacities[]={0,1,2,total-1,total};
 for(size_t k=0;k<sizeof(capacities)/sizeof(capacities[0]);k++){
  size_t cap=capacities[k];vis_scene scratch=*s;
  memset(guard,0x55,(total+2)*sizeof(*guard));memcpy(saved,guard,(total+2)*sizeof(*guard));
  scratch.tree=guard+1;scratch.nodes=0;scratch.node_capacity=cap;
  memcpy(tri,s->tri,n*sizeof(*tri));scratch.tri=tri;
  uint32_t root=build_node(&scratch,work,0,n);
  assert(root==(cap==total?0:UINT32_MAX) && scratch.nodes==cap);
  assert(!memcmp(guard,saved,sizeof(*guard)));
  assert(!memcmp(guard+1+cap,saved+1+cap,(total+1-cap)*sizeof(*guard)));
 }
 free(tri);free(saved);free(guard);free(work);
}
static void failures_and_ownership(void){
 const size_t v=1167,n=1566,bytes=69276,temp=74412;
 assert(oracle_nodes(n)==1023 && oracle_bytes(v,n)==bytes);
 fill_inputs(v,n);vis_limits lim=exact_limits(v,n);vis_scene *s=NULL;vis_binding b={0};
 assert(build(&s,xyz,v,indices,n,first,lim)==VIS_OK);check_requests(v,n);
 assert(peak_bytes==143688 && temp_frees==1 && live_bytes==bytes);
 assert(vis_binding_set(&b,s,first)==VIS_OK);vis_scene *old=s;
 span snapshots[4];capture_spans(s,snapshots);
 for(size_t f=1;f<=6;f++){
  fail_at=f;assert(build(&s,xyz,v,indices,n,second,lim)==VIS_ALLOC);
  assert(attempts==(f==1?1:f==6?6:5));
  size_t expected_peak=f==1?bytes:2*bytes+temp-(f==6?0:requested[f-1]);
  assert(peak_bytes==expected_peak);
  assert(temp_frees==((f>1 && f!=5)?1u:0u));
  still_old(s,old,&b,bytes);assert_spans(snapshots);query_ok(&b,first);
 }
 fail_at=0;
 corrupt_tree_for_witness=1;
 assert(build(&s,xyz,v,indices,n,second,lim)==VIS_INVALID);
 assert(attempts==6 && temp_frees==1);
 still_old(s,old,&b,bytes);assert_spans(snapshots);query_ok(&b,first);
 corrupt_tree_for_witness=0;
#define REJECT(EXPR, STATUS) do { reset_operation();assert((EXPR)==(STATUS) && attempts==0);still_old(s,old,&b,bytes);assert_spans(snapshots); } while(0)
 REJECT(vis_scene_build(NULL,xyz,v,indices,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,NULL,v,indices,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,v,NULL,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,0,indices,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,VIS_MAX_VERTICES+1u,indices,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,SIZE_MAX,indices,n,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,v,indices,0,second,lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,v,indices,VIS_MAX_TRIANGLES+1u,second,lim),VIS_CAPACITY);
 REJECT(vis_scene_build(&s,xyz,v,indices,SIZE_MAX,second,lim),VIS_CAPACITY);
 const vis_generation invalid_g[]={{0,1,1},{1,0,1},{1,1,0}};
 for(size_t i=0;i<3;i++)REJECT(vis_scene_build(&s,xyz,v,indices,n,invalid_g[i],lim),VIS_INVALID);
 REJECT(vis_scene_build(&s,xyz,v,indices,n,first,lim),VIS_GENERATION);
 const double invalid_coordinate[]={NAN,INFINITY,-INFINITY,1e51,-1e51};
 for(size_t k=0;k<sizeof(invalid_coordinate)/sizeof(invalid_coordinate[0]);k++){
  double saved=xyz[3*v-1];xyz[3*v-1]=invalid_coordinate[k];
  REJECT(vis_scene_build(&s,xyz,v,indices,n,second,lim),VIS_INVALID);xyz[3*v-1]=saved;
 }
 const uint32_t invalid_index[]={(uint32_t)v,UINT16_MAX,UINT32_MAX};
 for(size_t k=0;k<3;k++){
  uint32_t saved=indices[3*n-1];indices[3*n-1]=invalid_index[k];
  REJECT(vis_scene_build(&s,xyz,v,indices,n,second,lim),VIS_INVALID);indices[3*n-1]=saved;
 }
#undef REJECT
 /* Early and last-record degeneracy occur after all five allocations. */
 for(size_t k=0;k<2;k++){
  size_t t=k?n-1:0;uint32_t saved[3];memcpy(saved,indices+3*t,sizeof(saved));
  indices[3*t]=indices[3*t+1]=indices[3*t+2]=0;
  assert(build(&s,xyz,v,indices,n,second,lim)==VIS_INVALID);check_requests(v,n);
  assert(peak_bytes==2*bytes+temp && temp_frees==1);still_old(s,old,&b,bytes);assert_spans(snapshots);
  memcpy(indices+3*t,saved,sizeof(saved));
 }
 free_snapshots(snapshots);
 check_aliases(s,&b,v,n);failure_outputs(&b);guard_builder(s,n);
 size_t refs=s->refs;s->refs=SIZE_MAX;
 assert(vis_scene_retain(s)==VIS_CAPACITY && s->refs==SIZE_MAX);
 vis_binding before=b;assert(vis_binding_set(&b,s,first)==VIS_CAPACITY && s->refs==SIZE_MAX && !memcmp(&before,&b,sizeof(b)));
 s->refs=refs;
 /* Every persistent field is copied; the replacement may read old owned xyz. */
 assert(build(&s,old->xyz,v,indices,n,second,lim)==VIS_OK);check_requests(v,n);
 assert(s!=old && old->refs==1 && b.scene==old && s->refs==1);
 assert(live_bytes==138552 && live_allocs==8 && peak_bytes==212964 && temp_frees==1 && largest==65472);
 check_identity(s,xyz,v,indices,n);check_identity(old,xyz,v,indices,n);
 vis_binding newer={0};assert(vis_binding_set(&newer,s,second)==VIS_OK);
 memset(xyz,0xff,sizeof(xyz));memset(indices,0xff,sizeof(indices));
 query_ok(&b,first);query_ok(&newer,second);
 before=b;assert(vis_binding_set(&b,s,first)==VIS_GENERATION && !memcmp(&before,&b,sizeof(b)));
 assert(vis_binding_set(&b,s,second)==VIS_OK && live_bytes==bytes && live_allocs==4 && s->refs==3);
 vis_scene_release(s);assert(newer.scene->refs==2);query_ok(&b,second);query_ok(&newer,second);
 vis_binding_clear(&newer);assert(b.scene->refs==1);query_ok(&b,second);vis_binding_clear(&b);
 assert(!b.scene && equal(b.generation,(vis_generation){0,0,0}));check_empty();
}
static void generation_and_unref_replacement(void){
 const vis_generation initial={4,5,6};
 const vis_generation regression[]={{3,6,7},{5,4,7},{5,6,5},{4,5,6}};
 const vis_generation advances[]={{5,5,6},{5,6,6},{5,6,7}};
 fill_inputs(6,9);vis_scene *s=NULL;vis_limits lim=exact_limits(6,9);
 assert(build(&s,xyz,6,indices,9,initial,lim)==VIS_OK);
 for(size_t k=0;k<4;k++){
  vis_scene *old=s;
  assert(build(&s,xyz,6,indices,9,regression[k],lim)==VIS_GENERATION && attempts==0 && s==old && s->refs==1);
 }
 for(size_t k=0;k<3;k++){
  vis_scene *old=s;
  assert(build(&s,s->xyz,6,indices,9,advances[k],lim)==VIS_OK);
  assert(s!=old && s->refs==1 && temp_frees==1 && live_allocs==4 && live_bytes==oracle_bytes(6,9));
  assert(equal(vis_scene_generation(s),advances[k]));
 }
 vis_scene_release(s);check_empty();
}
static void maximum_vertex_identity(void){
 const size_t counts[]={1,VIS_MAX_TRIANGLES};
 for(size_t k=0;k<2;k++){
  size_t n=counts[k];fill_inputs(VIS_MAX_VERTICES,n);
  /* Numerically duplicated coordinates retain distinct IDs, including 4095,
   * and the negative-zero bit of that final original vertex is preserved. */
  memcpy(xyz+3*(VIS_MAX_VERTICES-1),xyz,3*sizeof(double));
  xyz[3*(VIS_MAX_VERTICES-1)+2]=-0.0;
  indices[0]=VIS_MAX_VERTICES-1;
  if(n>1){indices[3]=0;indices[4]=1;indices[5]=2;}
  vis_scene *s=NULL;vis_binding binding={0};
  assert(build(&s,xyz,VIS_MAX_VERTICES,indices,n,first,exact_limits(VIS_MAX_VERTICES,n))==VIS_OK);
  check_requests(VIS_MAX_VERTICES,n);check_identity(s,xyz,VIS_MAX_VERTICES,indices,n);
  assert(signbit(s->xyz[3*(VIS_MAX_VERTICES-1)+2]));
  size_t found=0;for(size_t i=0;i<n;i++)if(s->tri[i].ordinal==0){assert(s->tri[i].vertex[0]==4095);found++;}
  assert(found==1 && vis_binding_set(&binding,s,first)==VIS_OK);query_ok(&binding,first);
  vis_binding_clear(&binding);vis_scene_release(s);check_empty();
 }
}
static void maximum_peaks(void){
 const size_t v=4096,n=2048,bytes=143428,temp=85980;
 fill_inputs(v,n);vis_scene *s=NULL;vis_binding b={0};vis_limits lim=exact_limits(v,n);
 assert(oracle_bytes(v,n)==bytes && vis_scene_build_temporary_bytes_v3(n)==temp);
 assert(build(&s,xyz,v,indices,n,first,lim)==VIS_OK);check_requests(v,n);
 assert(live_bytes==bytes && peak_bytes==229408 && persistent_largest(v,n)==98304 && largest==98304);
 assert(vis_binding_set(&b,s,first)==VIS_OK);
 assert(build(&s,s->xyz,v,indices,n,second,lim)==VIS_OK);check_requests(v,n);
 assert(live_bytes==286856 && peak_bytes==372836 && live_allocs==8 && temp_frees==1);
 query_ok(&b,first);vis_binding newer={0};assert(vis_binding_set(&newer,s,second)==VIS_OK);query_ok(&newer,second);
 vis_binding_clear(&b);vis_binding_clear(&newer);vis_scene_release(s);check_empty();
}
int main(void){failures_and_ownership();check_empty();puts("PASS: six allocation failures plus forced unwitnessable compact bound preserve old scene, counters and allocation balance");return 0;}
