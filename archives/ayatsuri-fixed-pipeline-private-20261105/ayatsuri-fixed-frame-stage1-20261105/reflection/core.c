#include "integer_reflection.h"
hr_status hemisphere_integer_arithmetic(const int16_t n[3],int16_t out[16][3],unsigned *axis){return hr_directions16(n,out,axis);}
bool reflection_integer_reduction(const hr_fixed_sample s[16],const uint16_t rho[3],uint64_t out[3]){return hr_reduce16(s,rho,out);}
