/* Link/section inspection only. No timing or transport claim. */
#include "frame_harness.h"
static fh_owner owner;
static uint64_t tick(void*x){(void)x;return 0;}
static bool send(void*x,unsigned y,unsigned r,const uint16_t*p){(void)x;(void)y;(void)r;(void)p;return true;}
static bool finish(void*x){(void)x;return true;}
int main(void){fh_port p={0,tick,send,finish};fh_times t;return fh_frame(&owner,&p,0,0,-1,&t)!=FH_OK;}
