#include "fixed_kernel.h"
#include <fenv.h>
#include <stdio.h>
int main(void) {
 if(fesetround(FE_TONEAREST)!=0||fegetround()!=FE_TONEAREST)return 2;
 double x,scale;while(scanf("%la %la",&x,&scale)==2){int16_t q=0;bool ok=fk_encode(x,scale,&q);printf("%d %d\n",(int)ok,(int)q);}return ferror(stdin)?3:0;
}
