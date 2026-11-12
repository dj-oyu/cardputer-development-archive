#include "ayatsuri/ayatsuri_shade.h"
#include <string.h>
__attribute__((noinline)) void shade_pair(const int16_t normal[3],const uint16_t albedo[2],uint8_t thickness,
        const float light[9],const float m[8],const ayatsuri_shade_basis *basis,uint16_t out[2]){
#if SHARED
    const ayatsuri_shade_terms terms=ayatsuri_shade_terms_prepare(normal,thickness,m,basis);
    const uint16_t colors[2]={ayatsuri_shade_from_terms(albedo[0],light,m,&terms),
                            ayatsuri_shade_from_terms(albedo[1],light,m,&terms)};
#if TYPED_STORES
    out[0]=colors[0];out[1]=colors[1];
#else
    memcpy(out,colors,sizeof colors);
#endif
#else
    out[0]=ayatsuri_shade_sample(normal,albedo[0],thickness,light,m,basis);
    out[1]=ayatsuri_shade_sample(normal,albedo[1],thickness,light,m,basis);
#endif
}
