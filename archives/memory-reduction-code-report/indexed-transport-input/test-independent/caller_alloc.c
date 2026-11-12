#include "../private-build/transport/bounce.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
static int calls,fail_at,live;static const char *failure;
static void *fault_calloc(size_t n,size_t z){if(++calls==fail_at)return NULL;void *p=calloc(n,z);if(p)live++;return p;}
static void fault_free(void *p){if(p)live--;free(p);}
static int fail(const char *why){failure=why;return -1;}
static int extracted_allocation(int transportmode,size_t occluder_vertices,size_t occluder_triangles,size_t *out){size_t transport_temp=0;
#define calloc fault_calloc
#define free fault_free
#include "caller_alloc_exact.inc"
#undef calloc
#undef free
 *out=transport_temp;fault_free(attributes);fault_free(attribute_triangles);return 0;}
int main(void){size_t out;
 for(int site=1;site<=2;site++){calls=0;fail_at=site;failure=NULL;out=12345;assert(extracted_allocation(1,1167,1566,&out)==-1);assert(calls==site);assert(live==0);assert(out==12345);assert(!strcmp(failure,site==1?"attribute-vertex-memory":"attribute-triangle-memory"));}
 calls=0;fail_at=0;assert(!extracted_allocation(1,1167,1566,&out));assert(out==35868);assert(calls==2);assert(!live);
 calls=0;assert(!extracted_allocation(0,1167,1566,&out));assert(out==0);assert(calls==0);assert(!live);
 puts("PASS exact_extracted_caller_allocation_sites=2 failure_rollback=2 success_bytes=35868 off_calls=0 live=0");return 0;}
