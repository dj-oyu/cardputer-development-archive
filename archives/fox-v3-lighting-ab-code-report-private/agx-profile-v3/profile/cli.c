#include <stdio.h>
#include "agx_profile.h"
int main(void){float in[3],out[3];while(fread(in,sizeof(float),3,stdin)==3){int status=agx_profile_eval(in,out);if(status==AGX_PROFILE_INVALID){out[0]=out[1]=out[2]=-1;}fwrite(out,sizeof(float),3,stdout);}return ferror(stdin)||ferror(stdout);}
