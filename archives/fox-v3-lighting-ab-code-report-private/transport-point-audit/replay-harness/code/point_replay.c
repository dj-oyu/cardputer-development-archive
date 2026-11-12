#include "point_observer.h"
#include "pixel_transport.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
static void d3(FILE *f,const double v[3]){fprintf(f,"[%.17g,%.17g,%.17g]",v[0],v[1],v[2]);}
static void counters(FILE *f,vis_counters v){fprintf(f,"[%llu,%llu,%llu]",(unsigned long long)v.rays,(unsigned long long)v.node_visits,(unsigned long long)v.triangle_tests);}
static vis_counters delta(vis_counters a,vis_counters b){return (vis_counters){a.rays-b.rays,a.node_visits-b.node_visits,a.triangle_tests-b.triangle_tests};}
static int result_equal(const bounce_result *a,const bounce_result *b){return !memcmp(a->direct,b->direct,3*sizeof(double))&&!memcmp(a->world,b->world,3*sizeof(double))&&!memcmp(a->bounce,b->bounce,3*sizeof(double))&&!memcmp(a->ground,b->ground,3*sizeof(double))&&!memcmp(a->combined,b->combined,3*sizeof(double))&&!memcmp(&a->counters,&b->counters,sizeof a->counters);}
static vis_budget direct_budget(void){return (vis_budget){.limit={1000000,100000000,50000000}};}
static vis_budget transport_budget(void){return (vis_budget){.limit={20000000,800000000,300000000}};}
bool point_replay(const char *prefix,fox_transport_context *tx){
 const char *file=getenv("HONE_DIAGNOSTIC_POINTS");if(!file||!file[0])return false;FILE *f=fopen(file,"r");if(!f)return false;unsigned n,x[56],y[56];if(fscanf(f,"%u",&n)!=1||n>56){fclose(f);return false;}
 for(unsigned i=0;i<n;i++){if(fscanf(f,"%u %u",x+i,y+i)!=2||x[i]>=240||y[i]>=135){fclose(f);return false;}for(unsigned j=0;j<i;j++)if(x[i]==x[j]&&y[i]==y[j]){fclose(f);return false;}if(!point_queries[y[i]*240+x[i]].covered){fclose(f);return false;}}
 char extra;if(fscanf(f," %c",&extra)!=EOF){fclose(f);return false;}fclose(f);
 char path[4096];snprintf(path,sizeof path,"%s-preflight.json",prefix);f=fopen(path,"w");if(!f)return false;vis_budget pd=direct_budget(),pt=transport_budget();fprintf(f,"{\"phase\":\"original16/16-all-points-preflight\",\"points\":%u,\"rows\":[",n);bool preflight=true;
 for(unsigned i=0;i<n;i++){point_query *q=point_queries+y[i]*240+x[i];bounce_result r;vis_counters d=pd.used,t=pt.used;bounce_status s=bounce_eval(&tx->binding,tx->expected,q->position,q->normal,q->rho,BOUNCE_ONE,16,16,&pd,&pt,&r);vis_counters dd=delta(pd.used,d),tt=delta(pt.used,t);bool exact=s==BOUNCE_OK&&result_equal(&r,&q->result)&&!memcmp(&dd,&q->direct,sizeof dd)&&!memcmp(&tt,&q->transport,sizeof tt);fprintf(f,"%s{\"index\":%u,\"x\":%u,\"y\":%u,\"status\":\"%s\",\"exact\":%s}",i?",":"",i,x[i],y[i],bounce_status_string(s),exact?"true":"false");if(!exact){preflight=false;break;}}
 fprintf(f,"],\"complete\":%s,\"directUsed\":",preflight?"true":"false");counters(f,pd.used);fputs(",\"transportUsed\":",f);counters(f,pt.used);fputs("}",f);if(fclose(f)||!preflight)return false;
 /* Frame budgets remain untouched. One distinct cumulative diagnostic pair per case. */
 vis_budget d=direct_budget(),t=transport_budget();const unsigned outer[5]={16,64,64,256,256},inner[5]={16,16,64,64,64};const double op[5]={0,0,0,0,.38196601125},ip[5]={0,0,0,0,.61803398875};
 snprintf(path,sizeof path,"%s-point-results.json",prefix);f=fopen(path,"w");if(!f)return false;fprintf(f,"{\"points\":%u,\"order\":\"manifest-point-major-arm-0-to-4\",\"directLimits\":",n);counters(f,d.limit);fputs(",\"transportLimits\":",f);counters(f,t.limit);fputs(",\"rows\":[",f);bool stopped=false;unsigned complete=0,failed=0,unattempted=0;
 for(unsigned i=0;i<n;i++)for(unsigned a=0;a<5;a++){
  fprintf(f,"%s{\"pointIndex\":%u,\"x\":%u,\"y\":%u,\"arm\":%u,\"outer\":%u,\"inner\":%u,\"outerPhaseTurns\":%.17g,\"innerPhaseTurns\":%.17g,",i||a?",":"",i,x[i],y[i],a,outer[a],inner[a],op[a],ip[a]);
  if(stopped){unattempted++;fputs("\"status\":\"unattempted-after-case-failure\"}",f);continue;}
  point_query *q=point_queries+y[i]*240+x[i];bounce_result r,sentinel;memset(&r,0xa5,sizeof r);memcpy(&sentinel,&r,sizeof r);vis_counters db=d.used,tb=t.used;bounce_status status=bounce_eval_diagnostic(&tx->binding,tx->expected,q->position,q->normal,q->rho,BOUNCE_ONE,outer[a],inner[a],op[a],ip[a],&d,&t,&r);fprintf(f,"\"status\":\"%s\",\"directWork\":",bounce_status_string(status));counters(f,delta(d.used,db));fputs(",\"transportWork\":",f);counters(f,delta(t.used,tb));fputs(",\"cumulativeDirect\":",f);counters(f,d.used);fputs(",\"cumulativeTransport\":",f);counters(f,t.used);
  if(status!=BOUNCE_OK){if(memcmp(&r,&sentinel,sizeof r)){fclose(f);return false;}failed++;stopped=true;fputs(",\"failureAtomic\":true}",f);continue;}
  if(a==0&&!result_equal(&r,&q->result)){fclose(f);return false;}complete++;fputs(",\"direct\":",f);d3(f,r.direct);fputs(",\"world\":",f);d3(f,r.world);fputs(",\"bounce\":",f);d3(f,r.bounce);fputs(",\"ground\":",f);d3(f,r.ground);fputs(",\"combined\":",f);d3(f,r.combined);fputs(",\"counters\":[",f);uint64_t c[sizeof r.counters/sizeof(uint64_t)];memcpy(c,&r.counters,sizeof c);for(unsigned j=0;j<sizeof c/sizeof c[0];j++)fprintf(f,"%s%llu",j?",":"",(unsigned long long)c[j]);fputs("]}",f);
 }
 fprintf(f,"],\"completeQueries\":%u,\"failedQueries\":%u,\"unattemptedQueries\":%u,\"complete\":%s,\"directUsed\":",complete,failed,unattempted,stopped?"false":"true");counters(f,d.used);fputs(",\"transportUsed\":",f);counters(f,t.used);fputs("}",f);return fclose(f)==0;
}
