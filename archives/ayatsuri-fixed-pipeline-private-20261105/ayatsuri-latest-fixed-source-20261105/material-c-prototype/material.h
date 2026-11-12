#ifndef MATERIAL_C_H
#define MATERIAL_C_H
#include <stdint.h>
/* Build with MBITS16/20/24. All color/mask/params returned in that Q format. */
#define MC_CAPACITY 256
typedef struct {int64_t values[MC_CAPACITY];int32_t params[3];int side;unsigned tag;} mc_frame;
typedef struct {int64_t color[3],mix,transparent,params[3];} mc_output;
int mc_prepare(const int32_t controls[9],int side,int diagnostic_style,mc_frame *out);
int mc_eval(const mc_frame*,const int32_t xz[2],mc_output*);
int mc_block(const mc_frame*,const int32_t *xz,unsigned width,mc_output*);
unsigned mc_bits(void);
#endif
