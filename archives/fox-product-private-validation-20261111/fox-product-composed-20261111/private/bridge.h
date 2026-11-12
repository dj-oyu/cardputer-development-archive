#ifndef FOX_CONTROL_BRIDGE_H
#define FOX_CONTROL_BRIDGE_H
#include "quickjs.h"
#include "../../fox-eye-runtime-20261111/eye_runtime.h"
bool fox_composed_commit(const FoxEyeControls*,uint32_t*);
unsigned fox_composed_hidden(void);
unsigned fox_composed_mode(int);
void fox_composed_finish(void);
int fox_bridge_install(JSContext *);
int fox_bridge_eval(JSContext *,const char *source,size_t length,const char *name);
#endif
