#include "ayatsuri/ayatsuri_shade.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
int main(int argc,char **argv){putchar('[');for(int i=1;i<argc;i++){char *end;errno=0;unsigned long q=strtoul(argv[i],&end,10);if(errno||*end||q>65535)return 2;float r=ayatsuri_srgb_decode((q>>11)/31.0f),g=ayatsuri_srgb_decode(((q>>5)&63)/63.0f),b=ayatsuri_srgb_decode((q&31)/31.0f);printf("%s{\"code\":%lu,\"rho\":[%.17g,%.17g,%.17g]}",i>1?",":"",q,(double)r,(double)g,(double)b);}puts("]");return 0;}
