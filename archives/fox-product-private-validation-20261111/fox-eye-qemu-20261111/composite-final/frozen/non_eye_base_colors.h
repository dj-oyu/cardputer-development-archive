#ifndef FOX_NON_EYE_BASE_COLORS_H
#define FOX_NON_EYE_BASE_COLORS_H
#include <string.h>
/* Exact source scene-linear RGBA constants. Unlit diagnostic, no BSDF. */
typedef struct {const char *name;float rgba[4];} FoxNonEyeBaseColor;
static const FoxNonEyeBaseColor fox_non_eye_base_colors[]={
 {"Coat • burnt tangerine",{0.62000000476837158f,0.11999999731779099f,0.014000000432133675f,1.0f}},
 {"Coat • warm brow",{0.72000002861022949f,0.17000000178813934f,0.02500000037252903f,1.0f}},
 {"Deep cocoa • socks and ear rims",{0.028000000864267349f,0.008999999612569809f,0.0030000000260770321f,1.0f}},
 {"Ear interior • warm coral",{0.6600000262260437f,0.22499999403953552f,0.14000000059604645f,1.0f}},
 {"Ivory • muzzle chest tail",{0.95999997854232788f,0.82999998331069946f,0.62999999523162842f,1.0f}},
 {"Pupil and nose",{0.012000000104308128f,0.0070000002160668373f,0.0040000001899898052f,1.0f}},
};
static inline const float *fox_non_eye_base_color(const char *name){
 unsigned i;for(i=0;i<sizeof(fox_non_eye_base_colors)/sizeof(fox_non_eye_base_colors[0]);i++)if(strcmp(name,fox_non_eye_base_colors[i].name)==0)return fox_non_eye_base_colors[i].rgba;
 return 0;
}
#endif
