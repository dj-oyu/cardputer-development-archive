/* The unchanged permitted visibility source is the floating comparator. */
#include "visibility.c"
int reference_segment(const int32_t x[15],int f){double xyz[9],o[3],d[3];for(int i=0;i<9;i++)xyz[i]=ldexp(x[i],-f);for(int k=0;k<3;k++){o[k]=ldexp(x[9+k],-f);d[k]=ldexp((double)x[12+k]-x[9+k],-f);}double length=hypot(hypot(d[0],d[1]),d[2]);if(length<=2*VIS_SEGMENT_EPSILON)return 3;for(int k=0;k<3;k++)d[k]/=length;triangle t={{0,1,2},0};vis_scene s={.xyz=xyz};return tri_hit(&s,&t,o,d,VIS_SEGMENT_EPSILON,length-VIS_SEGMENT_EPSILON);}
