#ifndef DOT8_CHECKED_H
#define DOT8_CHECKED_H
#include "dot8.h"
#include <stddef.h>
#include <limits.h>
_Static_assert(sizeof(dot8_input)==48 && sizeof(dot8_packed)==64,"object sizes");
_Static_assert(_Alignof(dot8_input)==16 && _Alignof(dot8_packed)==16,"alignment");
_Static_assert(offsetof(dot8_packed,high)==32,"high half offset");
_Static_assert(CHAR_BIT==8 && sizeof(int16_t)==2 && sizeof(int32_t)==4,"integer widths");
_Static_assert(INT16_MIN==-32768 && INT32_MIN==(-2147483647-1),"signed range");
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
#error "Little endian required"
#endif
#if !defined(DOT8_HOST_LOGIC_ONLY)
#include "sdkconfig.h"
#if !defined(CONFIG_IDF_TARGET_ESP32S3) || !defined(__XTENSA__) || !defined(__XTENSA_WINDOWED_ABI__)
#error "ESP32-S3 windowed Xtensa target required"
#endif
#endif
bool dot8_checked(const dot8_input *n,const dot8_input *d,dot8_packed *packed,int32_t out[8]);
#endif
