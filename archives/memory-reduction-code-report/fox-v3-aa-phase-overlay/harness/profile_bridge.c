/* Include the pinned validated65 u16 implementation without changing it. */
#include "../../fox-v3-profile-integration-feasibility/build-private/agx_profile.c"
#include <stddef.h>
const void *row_profile_storage(size_t *bytes){*bytes=sizeof agx_lut;return agx_lut;}
