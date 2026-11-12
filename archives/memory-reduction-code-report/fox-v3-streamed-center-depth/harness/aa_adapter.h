#include "ksn_bounded_ring.h"
/* Host-only adapter, diagnostic sample I/O is separate from renderer work. */
#include "ui/kasane/ksn_boundary_aa.h"
#include "identity.h"
#include "preflight.h"
typedef struct {FILE *file;uint64_t samples,hits;fox_transport_context *transport;} aa_observer_context;
static bool aa_observe(void *opaque,const ksn_aa_sample *s){
 aa_observer_context *c=opaque;if(!c||!c->file||!s)return false;
 if(fprintf(c->file,"{\"x\":%u,\"y\":%u,\"sample\":%u,\"hit\":%s,\"recordOffset\":%u,\"node\":%u,\"face\":%u,\"back\":%s,\"sourceId\":%u,\"depth\":",s->x,s->y,s->sample,s->hit?"true":"false",s->record_offset,s->node,s->face,s->back?"true":"false",s->source_id)<0)return false;
 if(s->hit){if(fprintf(c->file,"%.9g",s->depth)<0)return false;}else if(fputs("null",c->file)==EOF)return false;
 const double *a[]={s->position,s->normal,s->rho,s->linear_rgb};const char *names[]={"P","Ns","rho","linearRGB"};
 for(unsigned j=0;j<4;j++)if(fprintf(c->file,",\"%s\":[%.17g,%.17g,%.17g]",names[j],a[j][0],a[j][1],a[j][2])<0)return false;
 if(s->hit&&c->transport){const bounce_result *b=&c->transport->last_result;const double *v[]={b->direct,b->world,b->bounce,b->ground,b->ground_reflected};const char *names[]={"directRGB","worldRGB","bounceRGB","groundLeRGB","floorReflectedRGB"};for(unsigned j=0;j<5;j++)if(fprintf(c->file,",\"%s\":[%.17g,%.17g,%.17g]",names[j],v[j][0],v[j][1],v[j][2])<0)return false;}
 if(fputs("}\n",c->file)==EOF)return false;c->samples++;if(s->hit)c->hits++;return true;
}
static bool aa_read_ledger(const char *path,ksn_aa_ledger *out){
 if(!path||!out)return false;FILE*f=fopen(path,"r");if(!f)return false;bool ok=true;for(unsigned i=0;i<AA_CATEGORY_COUNT;i++){unsigned long long x;if(fscanf(f,"%llu",&x)!=1){ok=false;break;}out->value[i]=x;}char extra;if(ok&&fscanf(f," %c",&extra)!=EOF)ok=false;if(fclose(f))ok=false;return ok;
}
static bool aa_write_report(const char *prefix,const ksn_bounded_ring_workspace *w,const aa_observer_context *obs,bool complete,size_t retained_output_bytes){
 char path[4096];snprintf(path,sizeof path,"%s.aa.json",prefix);FILE*f=fopen(path,"w");if(!f)return false;const ksn_aa_report*r=&w->report;
 fprintf(f,"{\"version\":\"host-final-visible-rho-affine-preflight-v1\",\"complete\":%s,\"reservedTotal\":%llu,\"observedTotal\":%llu,\"targets\":%llu,\"coveredTargets\":%llu,\"nohitTargets\":%llu,\"centerShades\":%llu,\"sampleShades\":%llu,\"workspaceBytes\":%zu,\"newStackReserve\":%u,\"retainedOutputBytes\":%zu,\"identityBytes\":7930,\"identityFNV\":\"%016llx\",\"observerSamples\":%llu,\"observerHits\":%llu,\"failedCategory\":%u,\"categories\":{",complete?"true":"false",(unsigned long long)r->reserved_total,(unsigned long long)r->observed_total,(unsigned long long)r->targets,(unsigned long long)r->covered_targets,(unsigned long long)r->nohit_targets,(unsigned long long)r->center_shades,(unsigned long long)r->sample_shades,sizeof *w,KSN_AA_NEW_STACK_RESERVE,retained_output_bytes,(unsigned long long)r->source_fingerprint,(unsigned long long)obs->samples,(unsigned long long)obs->hits,r->failed_category);
 for(unsigned i=0;i<AA_CATEGORY_COUNT;i++)fprintf(f,"%s\"%s\":{\"reserved\":%llu,\"observed\":%llu}",i?",":"",ksn_aa_category_name(i),(unsigned long long)r->reserved.value[i],(unsigned long long)r->observed.value[i]);fputs("},\"sampleHits\":[",f);for(unsigned i=0;i<4;i++)fprintf(f,"%s%llu",i?",":"",(unsigned long long)r->sample_hits[i]);fputs("],\"sampleNohits\":[",f);for(unsigned i=0;i<4;i++)fprintf(f,"%s%llu",i?",":"",(unsigned long long)r->sample_nohits[i]);const aa_preflight_entry *pf=aa_preflight_lookup(r->snapshot_fingerprint);fprintf(f,"],\"preflightMatch\":%s,\"preflightROBytes\":%zu,\"preflightSnapshotFNV\":\"%016llx\",\"preflightExpectedHits\":[",aa_preflight_actual_matches(pf,r->sample_hits,r->targets)?"true":"false",sizeof aa_preflight_rows+sizeof aa_preflight_targets,(unsigned long long)r->snapshot_fingerprint);for(unsigned j=0;j<4;j++)fprintf(f,"%s%u",j?",":"",pf?pf->hits[j]:0);fputs("]}\n",f);return fclose(f)==0;
}
