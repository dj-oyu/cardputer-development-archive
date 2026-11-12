#ifndef FOX_GROUND_INPUT_H
#define FOX_GROUND_INPUT_H
/* Strict private host-only source-floor loader. No product/model dependency. */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
typedef struct {double world[4][3];uint32_t indices[6];double le[3];uint64_t fingerprint;} fox_ground_input;
static int ground_token(const char **cursor,const char *end,char token[128]){
 const char *p=*cursor;while(p<end&&isspace((unsigned char)*p))p++;size_t n=0;
 while(p<end&&!isspace((unsigned char)*p)){if(n==127||!*p)return 0;token[n++]=*p++;}
 token[n]=0;*cursor=p;return n!=0;
}
static int ground_double(const char **cursor,const char *end,double *value){
 char token[128],*tail;if(!ground_token(cursor,end,token))return 0;
 for(size_t i=0;token[i];i++)if(!((token[i]>='0'&&token[i]<='9')||token[i]=='+'||token[i]=='-'||token[i]=='.'||token[i]=='e'||token[i]=='E'))return 0;
 errno=0;
 double x=strtod(token,&tail);if(errno||!*token||*tail||!isfinite(x))return 0;*value=x;return 1;
}
static int fox_ground_parse(const char *data,size_t size,fox_ground_input *out){
 if(!data||!out||!size||size>4096||memchr(data,0,size))return 0;
 fox_ground_input v;memset(&v,0,sizeof(v));const char *p=data,*end=data+size;char token[128];
 if(!ground_token(&p,end,token)||strcmp(token,"FOXGROUND1"))return 0;
 for(unsigned i=0;i<4;i++)for(unsigned k=0;k<3;k++)if(!ground_double(&p,end,&v.world[i][k])||fabs(v.world[i][k])>1e50)return 0;
 const uint32_t expected[6]={0,1,3,0,3,2};
 for(unsigned i=0;i<6;i++){
  if(!ground_token(&p,end,token))return 0;
  /* Canonical single decimal digit: no signs, fractions or unknown ordering. */
  if(strlen(token)!=1||token[0]<'0'||token[0]>'3')return 0;
  v.indices[i]=(uint32_t)(token[0]-'0');if(v.indices[i]!=expected[i])return 0;
 }
 for(unsigned k=0;k<3;k++)if(!ground_double(&p,end,&v.le[k])||v.le[k]<0)return 0;
 while(p<end&&isspace((unsigned char)*p))p++;if(p!=end)return 0;
 for(unsigned t=0;t<2;t++){
  double a[3],b[3],c[3];for(unsigned k=0;k<3;k++){a[k]=v.world[v.indices[3*t+1]][k]-v.world[v.indices[3*t]][k];b[k]=v.world[v.indices[3*t+2]][k]-v.world[v.indices[3*t]][k];}
  c[0]=a[1]*b[2]-a[2]*b[1];c[1]=a[2]*b[0]-a[0]*b[2];c[2]=a[0]*b[1]-a[1]*b[0];
  if(!isfinite(c[0])||!isfinite(c[1])||!isfinite(c[2])||(c[0]==0&&c[1]==0&&c[2]==0))return 0;
 }
 v.fingerprint=UINT64_C(14695981039346656037);for(size_t i=0;i<size;i++){v.fingerprint^=(unsigned char)data[i];v.fingerprint*=UINT64_C(1099511628211);}
 *out=v;return 1;
}
static int fox_ground_load(const char *path,fox_ground_input *out){
 if(!path||!path[0]||!out)return 0;FILE *f=fopen(path,"rb");if(!f)return 0;
 char data[4097];size_t n=fread(data,1,sizeof(data),f);int ok=!ferror(f)&&n<=4096&&feof(f);fclose(f);
 if(ok)ok=fox_ground_parse(data,n,out);memset(data,0xa5,sizeof(data));return ok;
}
#endif
