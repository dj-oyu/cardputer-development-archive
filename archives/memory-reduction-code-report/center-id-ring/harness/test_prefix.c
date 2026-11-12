#define main native_adapter_main
#include "native_render_row.c"
#undef main
#include <assert.h>
#include <unistd.h>
int main(void){char dir[]="/tmp/row-prefix-test-XXXXXX";assert(mkdtemp(dir));char prefix[4096],path[4096];snprintf(prefix,sizeof prefix,"%s/prior",dir);snprintf(path,sizeof path,"%s/prior.u16le",dir);FILE*f=fopen(path,"wb");assert(f&&fwrite("OLD",1,3,f)==3&&fclose(f)==0);assert(!reserve_prefix(prefix));f=fopen(path,"rb");char old[4]={0};assert(f&&fread(old,1,3,f)==3&&fclose(f)==0&&!strcmp(old,"OLD"));snprintf(prefix,sizeof prefix,"%s/fresh",dir);assert(reserve_prefix(prefix));assert(!reserve_prefix(prefix));snprintf(path,sizeof path,"%s/fresh.row-reservation",dir);assert(!rmdir(path));snprintf(path,sizeof path,"%s/prior.u16le",dir);assert(!unlink(path)&&!rmdir(dir));puts("{\"prefixPreservation\":\"PASS\",\"negativeCases\":2,\"actualFrames\":0}");}
