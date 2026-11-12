#include "integer_reflection.h"
#include "historical_impl.h"
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <string.h>
int main(int argc,char**argv){assert(argc==2);FILE*f=fopen(argv[1],"rb");assert(f);double x[9];unsigned count=0,changed=0,axes=0,flags=0;while(fread(x,sizeof(double),9,f)==9){int16_t n[3],a[16][3],b[16][3];for(unsigned k=0;k<3;k++)n[k]=(int16_t)nearbyint(x[k+3]*32767);unsigned aa,ab;hr_status sa=hr_directions16(n,a,&aa);old_hr_status sb=old_hr_directions16(n,b,&ab);assert((sa==HR_OK||sa==HR_BASIS_AMBIGUOUS)&&(sb==OLD_HR_OK||sb==OLD_HR_BASIS_AMBIGUOUS));count++;changed+=memcmp(a,b,sizeof a)!=0;axes+=aa!=ab;flags+=(int)sa!=(int)sb;}assert(feof(f));fclose(f);printf("actual old_normalized_vs_new_raw count=%u integer_direction_changes=%u basis_changes=%u flag_changes=%u\n",count,changed,axes,flags);
 const int16_t n[][3]={{32767,32766,32765},{30000,30001,30002},{-32768,-32767,-32766},{512,513,514},{8192,8193,8194}};for(unsigned i=0;i<sizeof n/sizeof*n;i++){int16_t a[16][3],b[16][3];unsigned aa=99,ab=99;hr_status sa=hr_directions16(n[i],a,&aa);old_hr_status sb=old_hr_directions16(n[i],b,&ab);printf("raw_boundary%u new_basis=%u old_basis=%u new_status=%d old_status=%d directions_changed=%d\n",i,aa,ab,sa,sb,memcmp(a,b,sizeof a)!=0);}return 0;}
