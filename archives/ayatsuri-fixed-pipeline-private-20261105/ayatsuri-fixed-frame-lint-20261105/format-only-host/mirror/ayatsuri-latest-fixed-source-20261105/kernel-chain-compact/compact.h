#ifndef KC_COMPACT_H
#define KC_COMPACT_H
#include "../kernel-chain-prototype/chain.h"
/* Same input/frame/scene and rejection semantics as kc_block; distinct final-only
 * output ABI. Disjoint buffers; cache may warm before atomic-output rejection. */
int kcc_block(const mc_frame*,const il_scene*,const kc_input*,unsigned,agx_block_cache*,aa_result*);
#endif
