#define main boundary_fixture_main
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#define shade fixture_shade
#include "../capture/tests/test_boundary_aa.c"
#undef shade
#undef main
#pragma GCC diagnostic pop
#include PIXEL_SOURCE
extern double fox_center_hdr[135u*240u*3u];
extern uint64_t fox_center_capture_updates;
#ifdef TEST_WORLD_ON
extern double fox_center_floor_world[135u*240u*3u];
extern const double *fox_floor_world_sample;
extern uint64_t fox_floor_world_capture_updates;
#endif
static bool capture(void*opaque,const ksn_aa_sample*s){
 FILE*f=opaque;const unsigned fields[]={s->x,s->y,s->sample,s->hit,s->record_offset,s->node,s->face,s->back,s->source_id};
 assert(fwrite(fields,sizeof fields,1,f)==1);assert(fwrite(&s->depth,sizeof s->depth,1,f)==1);assert(fwrite(s->linear_rgb,sizeof(double),3,f)==3);return true;
}
int main(int argc,char**argv){assert(argc==2);fixture f;init(&f);append(&f,1,1,0,0,1);table(&f,1,1);ksn_aa_ledger l=limits();
 double xyz[]={1,-100,-100,1,100,-100,1,100,100,1,-100,100};uint32_t ix[]={0,1,2,0,2,3};vis_scene*v=NULL;bounce_generation g={.visibility={1,1,1},.material=1,.emission=1};assert(vis_scene_build(&v,xyz,4,ix,2,g.visibility,(vis_limits){2048,4095,524288})==VIS_OK);
 bounce_triangle a[2]={0};for(unsigned i=0;i<2;i++)for(unsigned j=0;j<3;j++){a[i].double_sided=1;a[i].v[j].front[0]=32767;a[i].v[j].back[0]=-32767;}
 FoxDiskScene light=lights();bounce_ground ground={.mode=BOUNCE_GROUND_PRIMARY_LE_DIRECT,.object_id=1,.triangle_count=2,.rho={.8,.7,.6},.le={.2,.3,.4}};bounce_scene*s=NULL;assert(bounce_scene_build_ground(&s,v,a,2,&light,1,g,262144,&ground)==BOUNCE_OK);
 vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};bounce_floor_work fw;assert(bounce_floor_work_init(&fw,1000,16000)==BOUNCE_OK);fox_pixel_binding pb={0};assert(fox_pixel_bind(&pb,v,g.visibility,&f.s)==VIS_OK);
 fox_transport_context tx={.snapshot_binding=&pb,.expected=g,.ground=ground,.mode=BOUNCE_ONE,.outer=16,.inner=16,.direct_budget=&db,.transport_budget=&tb,.floor_work=&fw};assert(bounce_binding_set(&tx.binding,s,g)==BOUNCE_OK);

#ifdef TEST_WORLD_ON
 bounce_floor_world_work ww;assert(bounce_floor_world_work_init(&ww,1000,16000)==BOUNCE_OK);tx.floor_world_work=&ww;fox_floor_world_sample=tx.last_floor_world.reflected_world;
#endif
 FILE*out=fopen(argv[1],"wb");assert(out);assert(fox_transport_render_boundary_experimental(&tx,&f.s,f.rgb,f.depth,f.w,&f.id,&l,capture,out));
 assert(f.w->report.complete);assert(tx.counters.primary_ground_reflection_hits>0);assert(fwrite(f.rgb,64800,1,out)==1);assert(fwrite(f.depth,129600,1,out)==1);assert(fwrite(fox_center_hdr,sizeof(double),135*240*3,out)==135*240*3);assert(fwrite(&fox_center_capture_updates,sizeof fox_center_capture_updates,1,out)==1);assert(fwrite(&tx.counters,sizeof tx.counters,1,out)==1);assert(fwrite(&tx.last_result,sizeof tx.last_result,1,out)==1);assert(fwrite(&db,sizeof db,1,out)==1);assert(fwrite(&tb,sizeof tb,1,out)==1);assert(fwrite(&fw,sizeof fw,1,out)==1);assert(fclose(out)==0);

#ifdef TEST_WORLD_ON
 assert(ww.queries==16*tx.counters.primary_ground_reflection_hits);assert(ww.misses==ww.queries);assert(fox_floor_world_capture_updates==fox_center_capture_updates);
 for(unsigned k=0;k<135*240;k++)for(unsigned c=0;c<3;c++){double want=isfinite(f.depth[k])?ground.rho[c]*.1:0;assert(fabs(fox_center_floor_world[3*k+c]-want)<1e-15);}
 fox_floor_world_sample=NULL;
#endif
 printf("OFF_PARITY_FIXTURE_PASS updates=%llu floorhits=%llu\n",(unsigned long long)fox_center_capture_updates,(unsigned long long)tx.counters.primary_ground_reflection_hits);
 bounce_binding_clear(&tx.binding);fox_pixel_unbind(&pb);bounce_scene_release(s);vis_scene_release(v);done(&f);return 0;
}
