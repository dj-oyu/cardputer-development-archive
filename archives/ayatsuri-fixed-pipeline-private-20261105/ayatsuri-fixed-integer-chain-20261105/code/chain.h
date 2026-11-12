#ifndef INTEGER_CHAIN_H
#define INTEGER_CHAIN_H
#include "../../ayatsuri-fixed-integer-light-20261105/integer_light.h"
#include "../../ayatsuri-fixed-integer-output-20261105/code/private_adapter_api.h"
typedef struct {uint64_t hdr24[3];uint32_t hdr19[3];uint16_t pixel;int status;} chain_result;
/* count 1/2/4/8, scene validated at batch boundary. Status:0 OK,1 profile
 * clamp; 10+IL status lighting fallback;20 HDR19 overflow;30+profile error.
 * Failure lanes carry zeroed fields. Input/cache/output storage nonoverlapping. */
bool chain_block(const il_scene*, const il_pixel*,unsigned,agx_block_cache*,chain_result[8]);
/* Raw interpolated SNORM-scale normals are normalized with integer sqrt/divide.
 * New fallback statuses:41 near-zero normal,42 normal range. */
bool chain_block_raw_normals(const il_scene*,const il_pixel*,unsigned,agx_block_cache*,chain_result[8]);

#endif
