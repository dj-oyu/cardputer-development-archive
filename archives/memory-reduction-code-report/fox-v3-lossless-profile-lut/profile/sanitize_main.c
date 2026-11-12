/* Generic standalone replay runner. Separate renamed control and candidate. */
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
int old_profile_eval(const float*,float*);
int agx_profile_eval(const float*,float*);
static uint16_t pack(const float*v){return(uint16_t)(((unsigned)lroundf(v[0]*31)<<11)|((unsigned)lroundf(v[1]*63)<<5)|(unsigned)lroundf(v[2]*31));}
int main(int argc,char**argv){
 if(argc!=2)return 2;FILE*f=fopen(argv[1],"rb");if(!f)return 2;
 float in[3];size_t n=0;
 while(fread(in,sizeof in,1,f)==1){
  float a[3]={.123f,.456f,.789f},b[3]={.123f,.456f,.789f};
  int sa=old_profile_eval(in,a),sb=agx_profile_eval(in,b);
  if(sa!=sb||memcmp(a,b,sizeof a)||(sa<2&&pack(a)!=pack(b))){fprintf(stderr,"Mismatch %zu\n",n);return 1;}
  n++;
 }
 if(ferror(f)||fclose(f))return 2;printf("PASS %zu samples\n",n);return 0;
}
