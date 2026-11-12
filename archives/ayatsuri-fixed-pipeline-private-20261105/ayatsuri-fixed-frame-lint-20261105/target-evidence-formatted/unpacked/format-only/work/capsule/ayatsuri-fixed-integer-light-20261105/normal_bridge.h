#ifndef INTEGER_NORMAL_BRIDGE_H
#define INTEGER_NORMAL_BRIDGE_H
#include "integer_light.h"
typedef enum {IL_NORMAL_OK=0,IL_NORMAL_NEAR_ZERO=1,IL_NORMAL_RANGE=2} il_normal_status;
/* Input: interpolated signed16 components with a common scale (normally /32767).
 * Allows -32768. Reject magnitude<512 codes. Output: /32767 unit-normal codes.
 * No float arithmetic; output unchanged on failure; in/out may alias. */
static il_normal_status il_normalize_interpolated(const int16_t in[3],int16_t out[3]){
 uint64_t sq=0;for(unsigned k=0;k<3;k++)sq+=(int64_t)in[k]*in[k];
 if(sq<UINT64_C(512)*512)return IL_NORMAL_NEAR_ZERO;
 uint64_t length=il_sqrt(sq<<16),result_sq=0;int16_t result[3];
 for(unsigned k=0;k<3;k++){
  int64_t v=il_signed_round((int64_t)in[k]*INT64_C(8388352),length);
  if(v < -32767||v>32767)return IL_NORMAL_RANGE;
  result[k]=(int16_t)v;result_sq+=(uint64_t)(v*v);
 }
 if(result_sq<UINT64_C(32762)*32762||result_sq>UINT64_C(32772)*32772)return IL_NORMAL_RANGE;
 for(unsigned k=0;k<3;k++)out[k]=result[k];
 return IL_NORMAL_OK;
}
#endif
