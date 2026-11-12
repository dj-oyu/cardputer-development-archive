#define _POSIX_C_SOURCE 200809L
#include "ground_input.h"
#include <assert.h>
#include <unistd.h>
static const char valid[]="FOXGROUND1\n-100 -100 0 100 -100 0 -100 100 0 100 100 0\n0 1 3 0 3 2\n0.18 2 4\n";
int main(void){fox_ground_input a,old;memset(&old,0x5a,sizeof(old));a=old;
 assert(fox_ground_parse(valid,strlen(valid),&a));assert(a.world[3][0]==100&&a.indices[2]==3&&a.le[2]==4&&a.fingerprint);
 char text[8192];const char *invalid[]={"", "FOXGROUND2 0", "FOXGROUND1 nan", "FOXGROUND1 inf", "FOXGROUND1 1e999", "FOXGROUND1 0"};
 for(unsigned i=0;i<sizeof(invalid)/sizeof(invalid[0]);i++){a=old;assert(!fox_ground_parse(invalid[i],strlen(invalid[i]),&a));assert(!memcmp(&a,&old,sizeof(a)));}
 snprintf(text,sizeof(text),"%s trailing",valid);a=old;assert(!fox_ground_parse(text,strlen(text),&a)&&!memcmp(&a,&old,sizeof(a)));
 memcpy(text,valid,sizeof(valid));text[15]=0;assert(!fox_ground_parse(text,sizeof(valid)-1,&a));
 const char *suffixes[]={"0 1 4 0 3 2 0.18 2 4", "0 1 3 0 2 3 0.18 2 4", "0 1 3 0 3 2 -1 2 4", "0 1 3 0 3 2 nan 2 4", "0 1 3 0 3 2 0.18 2 4 garbage", "0 1.0 3 0 3 2 0.18 2 4", "4294967296 1 3 0 3 2 0.18 2 4", "-0 1 3 0 3 2 0.18 2 4", "0 1 3 0 3 2 0x1p0 2 4"};
 for(unsigned i=0;i<sizeof(suffixes)/sizeof(suffixes[0]);i++){snprintf(text,sizeof(text),"FOXGROUND1 -100 -100 0 100 -100 0 -100 100 0 100 100 0 %s",suffixes[i]);a=old;assert(!fox_ground_parse(text,strlen(text),&a)&&!memcmp(&a,&old,sizeof(a)));}
 const char *degenerate="FOXGROUND1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 3 0 3 2 1 2 3";assert(!fox_ground_parse(degenerate,strlen(degenerate),&a));
 memset(text,'9',500);memcpy(text,"FOXGROUND1 ",11);text[500]=0;a=old;assert(!fox_ground_parse(text,strlen(text),&a)&&!memcmp(&a,&old,sizeof(a)));
 char path[]="/tmp/fox-ground-loader-XXXXXX";int fd=mkstemp(path);assert(fd>=0);FILE *f=fdopen(fd,"wb");assert(f);assert(fwrite(valid,1,strlen(valid),f)==strlen(valid));fclose(f);assert(fox_ground_load(path,&a));
 f=fopen(path,"wb");assert(f);memset(text,' ',sizeof(text));assert(fwrite(text,1,sizeof(text),f)==sizeof(text));fclose(f);a=old;assert(!fox_ground_load(path,&a)&&!memcmp(&a,&old,sizeof(a)));unlink(path);assert(!fox_ground_load(path,&a));
 puts("ground loader PASS: exact source order, geometry/Le/FNV, invalid/nonfinite/trailing/index/degenerate, bounded file and failure atomicity");return 0;}
