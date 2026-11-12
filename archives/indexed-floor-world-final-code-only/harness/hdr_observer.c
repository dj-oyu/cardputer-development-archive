#include "hdr_observer.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
static struct { uint16_t *pixels; double *hdr; uint64_t writes; } observation;
bool row_hdr_observer_begin(uint16_t *pixels){
 if(!pixels||observation.hdr)return false;
 double *hdr=malloc(32400u*3u*sizeof(double));if(!hdr)return false;
 for(unsigned p=0;p<32400;p++)hdr[p*3]=NAN;
 observation.pixels=pixels;observation.hdr=hdr;observation.writes=0;return true;
}
bool row_hdr_observe(const double rgb[3],const uint16_t *pixel){
 if(!observation.hdr)return true; /* Synthetic tests may leave observation disabled. */
 uintptr_t p=(uintptr_t)pixel,b=(uintptr_t)observation.pixels;
 if(!rgb||p<b||p-b>=64800||(p-b)%sizeof(uint16_t))return false;
 size_t index=(p-b)/sizeof(uint16_t);double*out=observation.hdr+index*3;
 if(!isnan(out[0]))return false;
 for(unsigned k=0;k<3;k++)if(!isfinite(rgb[k])||rgb[k]<0)return false;
 memcpy(out,rgb,3*sizeof(double));observation.writes++;return true;
}
bool row_hdr_observer_write(const char *prefix){
 if(!prefix||!observation.hdr||observation.writes!=32400)return false;
 char path[4096];if(snprintf(path,sizeof path,"%s.hdr.f64le",prefix)>=(int)sizeof path)return false;
 FILE*f=fopen(path,"wbx");if(!f)return false;bool ok=fwrite(observation.hdr,sizeof(double),97200,f)==97200;if(fclose(f))ok=false;if(!ok)return false;
 if(snprintf(path,sizeof path,"%s.hdr-observer.json",prefix)>=(int)sizeof path)return false;f=fopen(path,"wx");if(!f)return false;
 int n=fprintf(f,"{\"enabled\":true,\"complete\":true,\"diagnosticOnly\":true,\"bufferBytes\":777600,\"controlBytes\":%zu,\"initializationWriteBytes\":259200,\"sampleWrites\":%llu,\"captureWriteBytes\":%llu,\"dumpBytes\":777600,\"shadingFeedback\":false}\n",sizeof observation,(unsigned long long)observation.writes,(unsigned long long)(24*observation.writes));return fclose(f)==0&&n>0;
}
void row_hdr_observer_clear(void){free(observation.hdr);memset(&observation,0,sizeof observation);}
