#include "bridge.h"
#include <math.h>
#include <string.h>
#include <stdio.h>
/* Private synchronous JS result contract, with explicitly leased mock transport. */

static uint32_t committed_hash;
static bool entered;
static JSValue commit(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){
 (void)self;
 if(entered)return JS_ThrowTypeError(ctx,"private fox native bridge busy");
 if(argc!=1||JS_GetTypedArrayType(argv[0])!=JS_TYPED_ARRAY_FLOAT64)
  return JS_ThrowTypeError(ctx,"expected Float64Array[9]");
 size_t offset=0,bytes=0,per=0,size=0;
 JSValue ab=JS_GetTypedArrayBuffer(ctx,argv[0],&offset,&bytes,&per);
 if(JS_IsException(ab))return ab;
 uint8_t *raw=JS_IsArrayBuffer(ab)?JS_GetArrayBuffer(ctx,&size,ab):NULL;
 double v[9];
 bool valid=raw&&bytes==sizeof v&&offset<=size&&bytes<=size-offset;
 if(valid)memcpy(v,raw+offset,sizeof v);
 JS_FreeValue(ctx,ab);
 if(!valid)return JS_ThrowTypeError(ctx,"expected attached Float64Array[9]");
 const double lo[9]={0,0,0,-1,-1,0,0,0,-1},hi[9]={1,1,1,1,1,2,1,1,1};
 for(unsigned i=0;i<9;i++)if(!isfinite(v[i])||v[i]<lo[i]||v[i]>hi[i]||((i==5||i==6)&&v[i]!=floor(v[i])))
  return JS_ThrowRangeError(ctx,"source control outside supported domain");
 FoxEyeControls c={(float)v[0],(float)v[1],(float)v[2],(float)v[3],(float)v[4],(float)v[5],(float)v[6],(float)v[7],(float)v[8]};
 entered=true;uint32_t hash=0;
 bool ok=fox_composed_commit(&c,&hash);
 if(ok){committed_hash=hash;}
 entered=false;
 if(!ok)return JS_ThrowInternalError(ctx,"snapshot/render rejected; previous frame retained");
 printf("FOX_CONTROL_COMMIT blink=%g neg=%g pos=%g gaze_x=%g gaze_up=%g style=%g hash=%08x\n",v[0],v[1],v[2],v[3],v[4],v[5],hash);
 return JS_NewUint32(ctx,hash);
}
static JSValue hash(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){(void)self;(void)argc;(void)argv;return JS_NewUint32(ctx,committed_hash);}
static JSValue hidden(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){(void)self;(void)argc;(void)argv;unsigned n=fox_composed_hidden();return JS_NewUint32(ctx,n);}
static JSValue testmode(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){(void)self;int32_t mode=0;if(argc!=1||JS_ToInt32(ctx,&mode,argv[0]))return JS_EXCEPTION;return JS_NewUint32(ctx,fox_composed_mode(mode));}
static JSValue print(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){(void)self;for(int i=0;i<argc;i++){const char*s=JS_ToCString(ctx,argv[i]);if(!s)return JS_EXCEPTION;puts(s);JS_FreeCString(ctx,s);}return JS_UNDEFINED;}
int fox_bridge_install(JSContext *ctx){
 JSValue g=JS_GetGlobalObject(ctx), backend=JS_NewObject(ctx);
static const JSCFunctionListEntry methods[]={JS_CFUNC_DEF("commit",1,commit),JS_CFUNC_DEF("hash",0,hash),JS_CFUNC_DEF("hidden",0,hidden),JS_CFUNC_DEF("testmode",1,testmode)};
 int result=JS_SetPropertyFunctionList(ctx,backend,methods,4);
 if(result>=0) result=JS_SetPropertyStr(ctx,g,"privateModelBackend",backend); else JS_FreeValue(ctx,backend);
 JS_SetPropertyStr(ctx,g,"print",JS_NewCFunction(ctx,print,"print",1));
 JS_FreeValue(ctx,g);return result;
}
int fox_bridge_eval(JSContext *ctx,const char *source,size_t length,const char *name){
 JSValue v=JS_Eval(ctx,source,length,name,JS_EVAL_TYPE_GLOBAL);
 if(JS_IsException(v)){
  JSValue e=JS_GetException(ctx);const char *text=JS_ToCString(ctx,e);
  fprintf(stderr,"FOX_CONTROL_JS_ERROR %s: %s\n",name,text?text:"exception");
  if(text)JS_FreeCString(ctx,text);JS_FreeValue(ctx,e);return -1;
 }
 JS_FreeValue(ctx,v);return 0;
}
