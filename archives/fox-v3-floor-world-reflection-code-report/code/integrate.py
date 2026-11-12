from pathlib import Path
R=Path(__file__).resolve().parents[1];D=R/'capture'
p=D/'product/main/ui/kasane/ksn_mesh_depth.c';s=p.read_text().replace('uint64_t fox_center_capture_updates;',r'''uint64_t fox_center_capture_updates;
#ifdef FOX_FLOOR_WORLD_CAPTURE
/* Host-only completed-center component observer, no shading feedback. */
double fox_center_floor_world[135u*240u*3u];
const double *fox_floor_world_sample;
uint64_t fox_floor_world_capture_updates;
#endif''');p.write_text(s)
p=D/'product/main/ui/kasane/ksn_boundary_aa_center.inc';s=p.read_text().replace('fox_center_capture_updates++;continue;',r'''fox_center_capture_updates++;
#ifdef FOX_FLOOR_WORLD_CAPTURE
                    if(fox_floor_world_sample){
                     for(unsigned capture_k=0;capture_k<3;capture_k++)fox_center_floor_world[((unsigned)yy*KSN_PROC_W+(unsigned)x)*3u+capture_k]=fox_floor_world_sample[capture_k];
                     fox_floor_world_capture_updates++;
                    }
#endif
                    continue;''');p.write_text(s)
p=D/'code/aa_adapter.h';s=p.read_text().replace(' if(fputs("}\\n",c->file)==EOF)',r''' if(s->hit&&c->transport&&c->transport->floor_world_work){const double*v=c->transport->last_floor_world.reflected_world;if(fprintf(c->file,",\"floorWorldRGB\":[%.17g,%.17g,%.17g]",v[0],v[1],v[2])<0)return false;}
 if(fputs("}\n",c->file)==EOF)''');p.write_text(s)
p=D/'code/native_render_v2.c';s=p.read_text().replace('#include "floor_adapter.h"','#include "floor_adapter.h"\n#include "floor_world_adapter.h"');s=s.replace('extern uint64_t fox_center_capture_updates;',r'''extern uint64_t fox_center_capture_updates;
extern double fox_center_floor_world[135u*240u*3u];
extern const double *fox_floor_world_sample;
extern uint64_t fox_floor_world_capture_updates;''')
s=s.replace(' const char *fc=getenv("HONE_FLOOR_CASE");',r''' const char *world_mode=getenv("HONE_FLOOR_WORLD");if(!world_mode||(strcmp(world_mode,"off")&&strcmp(world_mode,"on")))return fail("floor-world-mode");bool world_enabled=!strcmp(world_mode,"on");bounce_floor_world_work world_work={0};
 if(!floor_enabled||floor_zero)return fail("floor-world-fixed-floor-direct-on");
 const char *fc=getenv("HONE_FLOOR_CASE");''')
s=s.replace(' if(transportmode){tx.floor_work=',r''' if(world_enabled&&bounce_floor_world_work_init(&world_work,floor_prediction->shaders,floor_prediction->hits)!=BOUNCE_OK)return fail("floor-world-work-init");
 tx.floor_world_work=world_enabled?&world_work:NULL;fox_floor_world_sample=world_enabled?tx.last_floor_world.reflected_world:NULL;
 if(transportmode){tx.floor_work=''')
s=s.replace('  if(!complete||!observer_ok)return fail_render',r'''  if(!floor_world_write_report(argv[2],&world_work,world_enabled,complete&&observer_ok))return fail("floor-world-report");
  if(!complete||!observer_ok)return fail_render''')
s=s.replace(' bounce_binding_clear(&tx.binding);',' fox_floor_world_sample=NULL;bounce_binding_clear(&tx.binding);')
needle=' printf("\\\"physicalDiskEnabled';assert s.count(needle)==1;s=s.replace(needle,r''' snprintf(path,sizeof path,"%s.world-center.f64le",argv[2]);capture_file=fopen(path,"wb");if(!capture_file)return fail("world-center-open");if(fwrite(fox_center_floor_world,sizeof(double),135u*240u*3u,capture_file)!=135u*240u*3u||fclose(capture_file))return fail("world-center-write");
 snprintf(path,sizeof path,"%s.world-observer.json",argv[2]);capture_file=fopen(path,"w");if(!capture_file)return fail("world-observer-open");if(fprintf(capture_file,"{\"enabled\":%s,\"centerUpdates\":%llu,\"arrayBytes\":777600,\"pointerBytes\":%zu,\"counterBytes\":8,\"centerWriteBytes\":%llu,\"dumpBytes\":777600,\"oneFrameProcess\":true}\n",world_enabled?"true":"false",(unsigned long long)fox_floor_world_capture_updates,sizeof fox_floor_world_sample,(unsigned long long)(24u*fox_floor_world_capture_updates))<0||fclose(capture_file))return fail("world-observer-write");
'''+needle);p.write_text(s)
