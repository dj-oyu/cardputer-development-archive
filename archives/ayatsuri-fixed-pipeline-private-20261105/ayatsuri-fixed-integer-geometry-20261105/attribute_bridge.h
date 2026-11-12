#ifndef AYATSURI_INTEGER_ATTRIBUTE_BRIDGE_H
#define AYATSURI_INTEGER_ATTRIBUTE_BRIDGE_H
#include "../ayatsuri-fixed-integer-light-20261105/integer_light.h"
typedef struct {
 int32_t native_position[3]; /* metres Qfrac, frac16 or20, <=128m */
 int32_t depth_q10;          /* projected depth metres Q10, <=4096m */
 int16_t native_normal[3];   /* unit normal /32767, no -32768 */
 int16_t rho[3];             /* linear albedo /32767, 0..32767 */
} ab_vertex;
typedef struct {
 il_pixel pixel;             /* world P Q16, unit world normal /32767, rho, visibility */
 int32_t native_position[3]; /* retained interpolation rounded at source Qfrac */
 int32_t depth_q10;          /* rounded interpolated original vertex depth */
} ab_hit;
typedef enum {AB_OK=0,AB_INVALID=1,AB_LIGHT_RANGE=2,AB_NORMAL_FALLBACK=3} ab_status;
/* Weights signed16 Q14, nonnegative exact sum16384. Explicit visibility masks.
 * Input source/native basis -> world x,-z,-y. backface must0/1; flips all world
 * normal components after basis change, before integer normalization.
 * Exact interpolated P must be in +/-8m for current light API. Single rounding
 * from raw weighted source position to lightingQ16. No floats. Output unchanged
 * unless AB_OK. No ray/visibility/depth winner policy inferred. */
ab_status ab_prepare(const ab_vertex vertices[3],const int16_t weights[3],int frac,int backface,const uint16_t visible[3],ab_hit *out);
/* count1/2/4/8, independent triangles; arrays must contain count elements.
 * Each failure leaves that lane's output unchanged; writes status for each lane. */
bool ab_block(const ab_vertex vertices[][3],const int16_t weights[][3],int frac,const int backface[],const uint16_t visible[][3],unsigned count,ab_hit out[],ab_status status[]);
#endif
