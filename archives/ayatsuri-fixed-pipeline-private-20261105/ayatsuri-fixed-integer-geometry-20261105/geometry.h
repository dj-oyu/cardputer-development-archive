#ifndef AYATSURI_INTEGER_GEOMETRY_EXPERIMENT_H
#define AYATSURI_INTEGER_GEOMETRY_EXPERIMENT_H
#include <stdint.h>
/* Compile geometry.c with SUBPIX=8 or 10. ABI identical; use matching prepared offsets. */
typedef struct { int32_t m[9], offset[3]; int32_t frac, width, height; } Camera;
typedef struct { int32_t x,y,z; } Point;
/* m: row-major 3x3 signed Q20, offset/output: signed Q(SUBPIX).
 * Input: three signed32 metre coordinates with frac=16 or20.
 * Return0 success, -1 rejected; output unchanged on rejection. */
int project(const Camera *,const int32_t p[3],Point *out);
/* n=0..32, lanes=1,2,4,8. p AoS3*n; out AoS n. Transactional output. */
int project_batch(const Camera *,const int32_t *p,Point *out,int n,int lanes);
/* Triangle array order defines weight order. Sample coordinates Q(SUBPIX).
 * Return1 covered, 0 outside/zero-area, -1 rejected. weights written only on1.
 * Covered weights: signed16, nonnegative, <=16384, exact sum16384; feed directly
 * to signed16 Q2.14 barycentric normal/color interpolation. Do NOT renormalize. */
int sample(const Point triangle[3],int32_t x,int32_t y,int16_t weights[3]);
/* xy AoS2*n, covered n int8, weights AoS3*n int16. Outside weights zero.
 * Return0 successful batch, -1 rejected and all outputs unchanged. */
int sample_batch(const Point triangle[3],const int32_t *xy,int n,int lanes,int8_t *covered,int16_t *weights);
#endif
