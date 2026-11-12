#include <math.h>
#include <fenv.h>
#include <stdio.h>
#include <assert.h>
int main(void){assert(fegetround()==FE_TONEAREST);puts("/* Offline generated original16 hemisphere coefficients, signed /32767. */\nstatic const int16_t hemisphere16[16][3]={");for(unsigned i=0;i<16;i++){unsigned az=i%8,ring=i/8;double r=sqrt((ring+.5)/2),phi=6.283185307179586476925286766559*(az+.5*(ring%2))/8;printf(" {%ld,%ld,%ld},\n",lrint(r*cos(phi)*32767),lrint(r*sin(phi)*32767),lrint(sqrt(1-r*r)*32767));}puts("};");}
