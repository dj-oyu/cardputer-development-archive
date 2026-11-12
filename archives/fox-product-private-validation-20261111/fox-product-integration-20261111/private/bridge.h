#ifndef FOX_CONTROL_BRIDGE_H
#define FOX_CONTROL_BRIDGE_H
#include "quickjs.h"
#include "../../fox-eye-runtime-20261111/eye_runtime.h"
bool fox_bridge_render(const fox_eye_snapshot*,uint32_t*);
int fox_bridge_install(JSContext *);
int fox_bridge_eval(JSContext *,const char *source,size_t length,const char *name);
#endif
