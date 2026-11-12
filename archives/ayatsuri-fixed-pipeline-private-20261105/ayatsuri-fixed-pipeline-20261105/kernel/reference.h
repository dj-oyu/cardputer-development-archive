#ifndef FROZEN_REFERENCE_H
#define FROZEN_REFERENCE_H
#include <math.h>
#include <stdint.h>
/* Frozen operation order: matches current affine accumulation, not a new
 * shading reference. Inputs remain unquantized double barycentrics. */
static double ref_affine(const double b[3],const double a[3]){double s=0;for(int j=0;j<3;j++)s+=b[j]*a[j];return s;}
/* Frozen rho expression from ksn_aa_rho_affine.h; valid finite convex input. */
static double ref_rho(const double b[3],const double a[3]){const double first=a[0]+b[1]*(a[1]-a[0]);return fmax(0,fmin(1,first+b[2]*(a[2]-a[0])));}
/* Exact source float decoder from ayatsuri_shade.h. */
static float ref_srgb(float x){return x<=.04045f?x/12.92f:powf((x+.055f)/1.055f,2.4f);}
static double ref_color(uint16_t c,unsigned k){return k==0?ref_srgb((c>>11)/31.0f):k==1?ref_srgb(((c>>5)&63)/63.0f):ref_srgb((c&31)/31.0f);}
#endif
