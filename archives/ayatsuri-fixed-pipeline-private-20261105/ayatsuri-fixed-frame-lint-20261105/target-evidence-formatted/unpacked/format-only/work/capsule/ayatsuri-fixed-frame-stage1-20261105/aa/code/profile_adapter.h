#ifndef INTEGER_AA_PROFILE_ADAPTER_H
#define INTEGER_AA_PROFILE_ADAPTER_H
#include "integer_aa.h"
#include "../../../ayatsuri-fixed-integer-output-20261105/code/private_adapter_api.h"
/* Pass as aa_encoder with an initialized agx_block_cache context. */
int aa_private_profile(void*,const uint32_t[3],uint16_t*);
#endif
