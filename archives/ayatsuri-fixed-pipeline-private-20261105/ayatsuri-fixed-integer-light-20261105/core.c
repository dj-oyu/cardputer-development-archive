#include "integer_light.h"
/* Dedicated integer-only translation unit for inspection/linking. */
bool integer_light_validate(const il_scene *s){return il_scene_valid(s);}
il_status integer_light_evaluate(const il_scene*s,const il_pixel*p,uint64_t out[3]){return il_eval(s,p,out);}
bool integer_light_to_hdr19(const uint64_t in[3],uint32_t out[3]){return il_hdr19(in,out);}
