#define pocket_api_lazy compat_unused_lazy
#define main compat_baseline_fixture_main
#include "test_pocket_proc_qjs.c"
#undef main
#undef pocket_api_lazy
void pocket_proc_host_classes_reset(void);
esp_err_t pocket_api_lazy(JSContext *ctx,const char *name,pocket_namespace_fn fn,void *user){
 JSValue root=pocket_api_root(ctx),ns=JS_NewObject(ctx);REQUIRE(!JS_IsException(ns));esp_err_t status=fn(ctx,ns,user);
 if(status==ESP_OK&&JS_SetPropertyStr(ctx,root,name,JS_DupValue(ctx,ns))<0)status=ESP_ERR_NO_MEM;
 JS_FreeValue(ctx,ns);JS_FreeValue(ctx,root);return status;
}
int main(int argc,char **argv){
 REQUIRE(argc>=3);FILE *output=fopen(argv[1],"wb");REQUIRE(output);
 JSRuntime *rt=JS_NewRuntime();REQUIRE(rt);JSContext *ctx=JS_NewContext(rt);REQUIRE(ctx);
 JSValue global=JS_GetGlobalObject(ctx),pocket=JS_NewObject(ctx),kasane=JS_NewObject(ctx);
 REQUIRE(pocket_proc_install(ctx,kasane)==ESP_OK);REQUIRE(JS_SetPropertyStr(ctx,pocket,"kasane",kasane)>=0);
 REQUIRE(JS_SetPropertyStr(ctx,global,"pocket",pocket)>=0);JS_FreeValue(ctx,global);REQUIRE(pocket_shape_install(ctx,NULL)==ESP_OK);
 eval_ok(ctx,"globalThis.P=pocket.kasane.procedural");
 for(int arg=2;arg<argc;arg++){
  FILE *f=fopen(argv[arg],"rb");REQUIRE(f);fseek(f,0,SEEK_END);size_t size=(size_t)ftell(f);rewind(f);uint8_t *b=malloc(size);REQUIRE(b&&fread(b,1,size,f)==size);fclose(f);
  global=JS_GetGlobalObject(ctx);REQUIRE(JS_SetPropertyStr(ctx,global,"input",JS_NewArrayBufferCopy(ctx,b,size))>=0);JS_FreeValue(ctx,global);free(b);
  eval_ok(ctx,"globalThis.M=pocket.ayatsuri.modelOpen(input);globalThis.A=M.instance();input=null");
  for(unsigned view=0;view<4;view++){
   char script[512];snprintf(script,sizeof script,"A.evaluate(new Float32Array([%u,30,400,0,0,0,0.25,120,78]),new Float32Array([0,0,1,%g,%g,%g]));P.beginFrame(17);A.%s;P.commit()",view*40,view&1?.5:1,view&1?.7:1,view&1?.9:1,view&1?"submitClipped(new Uint16Array(0),new Uint8Array(0),new Float32Array(0))":"submit()");
   eval_ok(ctx,script);REQUIRE(pocket_proc_backdrop(NULL,0,135,actual)==KSN_OK);REQUIRE(fwrite(actual,1,sizeof actual,output)==sizeof actual);pocket_proc_present_result(KSN_OK);
  }
  eval_ok(ctx,"A.dispose();M.dispose();A=M=null");pocket_proc_reset();
 }
 fclose(output);pocket_proc_host_classes_reset();JS_FreeContext(ctx);JS_FreeRuntime(rt);puts("SIDED_LEGACY_RENDER_CAPTURE_PASS");return 0;
}
