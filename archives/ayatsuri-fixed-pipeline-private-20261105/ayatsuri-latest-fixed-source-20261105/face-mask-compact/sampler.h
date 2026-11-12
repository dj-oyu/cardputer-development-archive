#ifndef FACE_SAMPLER_H
#define FACE_SAMPLER_H
#include <stdint.h>
#include <stddef.h>
typedef struct { int32_t x,y,z; uint8_t mask,mode,frac; } FaceQuery;
/* mode: 1 lossless span nearest, 2 lossless span Q16 bilinear.
   Coordinates: projection-local millionths if frac=0; signed Q16/Q20/Q24 otherwise.
   Fixed schema-bound 7963-byte embedded blob, no external untrusted loader. */
int face_scalar(const FaceQuery *q,uint8_t *out);
int face_block(const FaceQuery *q,size_t n,uint8_t *out);
#endif
