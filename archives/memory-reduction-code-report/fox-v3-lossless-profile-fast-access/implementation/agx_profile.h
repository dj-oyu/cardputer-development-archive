#ifndef AGX_PROFILE_H
#define AGX_PROFILE_H
/* Private generated profile. Negative/nonfinite input rejected atomically.
   Nonnegative finite input above AGX_PROFILE_DOMAIN_MAX is clamped and flagged. */
#define AGX_PROFILE_DOMAIN_MAX 5898.240000132513
#define AGX_PROFILE_OK 0
#define AGX_PROFILE_CLAMP_HIGH 1
#define AGX_PROFILE_INVALID 2
int agx_profile_eval(const float scene_linear_rgb[3], float display_rgb[3]);
#endif
