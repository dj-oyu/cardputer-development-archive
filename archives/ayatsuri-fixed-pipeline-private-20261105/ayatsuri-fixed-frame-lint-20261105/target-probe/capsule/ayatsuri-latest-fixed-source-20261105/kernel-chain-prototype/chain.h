#ifndef CHAIN_H
#define CHAIN_H
#include "../material-c-compact/material.h"
#include "../../ayatsuri-fixed-integer-light-20261105/normal_bridge.h"
#include "../../ayatsuri-fixed-frame-stage1-20261105/aa/code/profile_adapter.h"
typedef struct {int32_t local[3][2],world[3][3];int16_t normal[3][3];uint16_t bary[3],visible[3];} kc_slot;
typedef struct {kc_slot slots[4];} kc_input;
typedef struct {mc_output material[4];int32_t local[4][2],world[4][3];int16_t normal[4][3];uint16_t rho[4][3];uint64_t radiance[4][3];aa_result final;} kc_output;
enum {KC_OK,KC_INVALID,KC_MATERIAL,KC_NONOPAQUE,KC_RHO,KC_NORMAL,KC_LIGHT,KC_ACCUMULATE,KC_ENCODE};
int kc_rho(int64_t value,uint16_t *out);
int kc_block(const mc_frame*,const il_scene*,const kc_input*,unsigned,agx_block_cache*,kc_output*);
#endif
