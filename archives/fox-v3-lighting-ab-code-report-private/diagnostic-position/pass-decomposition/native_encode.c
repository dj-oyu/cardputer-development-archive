#include <math.h>
#include <stddef.h>
#include "ayatsuri/ayatsuri_shade.h"
int native_encode(const float *raw,float *encoded,size_t count){for(size_t i=0;i<count;i++)if(!isfinite(raw[i])||raw[i]<0)return 0;for(size_t i=0;i<count;i++)encoded[i]=ayatsuri_srgb_encode(fminf(1.0f,raw[i]));return 1;}
