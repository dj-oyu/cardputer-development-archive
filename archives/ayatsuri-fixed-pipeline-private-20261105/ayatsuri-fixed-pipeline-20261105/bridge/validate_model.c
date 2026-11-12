#include <stdio.h>
#include <stdlib.h>
#include "ayatsuri/ayatsuri_model.h"
/* Diagnostic admission only: no instance creation, shader, ray or renderer. */
int main(int argc,char **argv){
 if(argc<2)return 2;
 for(int i=1;i<argc;i++){
  FILE *f=fopen(argv[i],"rb");if(!f)return 3;
  if(fseek(f,0,SEEK_END)){fclose(f);return 4;}
  long n=ftell(f);if(n<32||n>AYATSURI_MODEL_MAX_BYTES){fclose(f);return 5;}
  rewind(f);unsigned char *p=malloc((size_t)n);if(!p){fclose(f);return 6;}
  if(fread(p,1,(size_t)n,f)!=(size_t)n){free(p);fclose(f);return 7;}
  fclose(f);ayatsuri_model model={0};
  ayatsuri_model_status status=ayatsuri_model_open(p,(size_t)n,&model);
  printf("input=%d bytes=%ld status=%d nodes=%u packets=%u\n",i,n,(int)status,(unsigned)model.node_count,(unsigned)model.packet_count);
  free(p);if(status!=AYATSURI_MODEL_OK)return 8;
 }
 return 0;
}
