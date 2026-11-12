#include "bridge.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void load(JSContext *ctx,const char *path){
 FILE*f=fopen(path,"rb");if(!f){perror(path);exit(1);}fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);char *s=malloc(n+1);if(!s||fread(s,1,n,f)!=(size_t)n)abort();fclose(f);s[n]=0;
 JSValue value=JS_Eval(ctx,s,n,path,JS_EVAL_TYPE_GLOBAL);free(s);
 if(JS_IsException(value)){JSValue e=JS_GetException(ctx);const char*msg=JS_ToCString(ctx,e);fprintf(stderr,"%s: %s\n",path,msg);JS_FreeCString(ctx,msg);JSValue st=JS_GetPropertyStr(ctx,e,"stack");msg=JS_ToCString(ctx,st);fprintf(stderr,"%s\n",msg);exit(1);}JS_FreeValue(ctx,value);
}
int main(int argc,char **argv){if(argc!=5)return 2;JSRuntime*rt=JS_NewRuntime();JSContext*ctx=JS_NewContext(rt);if(!ctx||JS_PocketHarden(ctx)<0||fox_bridge_install(ctx)<0)return 2;
 for(int i=1;i<5;i++){load(ctx,argv[i]);size_t used,limit;JS_GetMemoryCounters(rt,&used,&limit);printf("FOX_CONTROL_HOST_VM phase=%d used=%zu limit=%zu\n",i,used,limit);}fox_composed_finish();JS_FreeContext(ctx);JS_FreeRuntime(rt);return 0;}
