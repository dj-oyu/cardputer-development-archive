#ifndef CHAIN_INTEGER_ATTRIBUTES_H
#define CHAIN_INTEGER_ATTRIBUTES_H
#include "chain.h"
/* Orthographic synthetic bridge: input vertices Q16 position, SNORM15 normals,
 * rho/32767. Exact-sum Q14 weights from integer sample(). No perspective
 * correction or source ownership/material evaluation is provided here. */
bool chain_attributes(const il_pixel vertices[3],const int16_t weights[3],il_pixel*out);
#endif
