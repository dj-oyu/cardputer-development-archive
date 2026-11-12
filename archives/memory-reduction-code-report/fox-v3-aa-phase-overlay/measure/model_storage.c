#include "ayatsuri/ayatsuri_model.h"
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
int main(int argc,char **argv){
 if(argc!=2)return 1;FILE *f=fopen(argv[1],"rb");if(!f)return 2;fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);void *data=malloc((size_t)n);if(!data||fread(data,1,(size_t)n,f)!=(size_t)n)return 3;fclose(f);
 ayatsuri_model m;if(ayatsuri_model_open(data,(size_t)n,&m))return 4;
 size_t total=0,min=(size_t)-1,max=0;for(unsigned j=0;j<m.node_count;j++){size_t b=ayatsuri_model_instance_node_bytes(&m,(uint16_t)j);total+=b;if(b<min)min=b;if(b>max)max=b;}
 printf("{\"nodes\":%u,\"nodeLimit\":%u,\"coldBytes\":%ld,\"legacyBytes\":%zu,\"metadataBytes\":%zu,\"nodeTotalBytes\":%zu,\"minNodeBytes\":%zu,\"maxNodeBytes\":%zu,\"instanceBytes\":%zu,\"segmentedFlagOffset\":%zu,\"descriptorBytes\":%zu,\"pointerBytes\":%zu}\n",m.node_count,AYATSURI_MODEL_MAX_NODES,n,ayatsuri_model_instance_bytes(&m),ayatsuri_model_instance_metadata_bytes(&m),total,min,max,sizeof(ayatsuri_model_instance),offsetof(ayatsuri_model_instance,segmented),sizeof(ayatsuri_model_node_storage),sizeof(void *));free(data);return 0;
}
