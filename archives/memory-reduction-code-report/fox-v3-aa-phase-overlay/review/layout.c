#include <stdio.h>
#include <stddef.h>
#include "ksn_bounded_ring.h"
int main(void){printf("{\"size\":%zu,\"alignment\":%zu,\"delayed\":%zu,\"ids\":%zu,\"winnerRecord\":%zu,\"winnerDepth\":%zu,\"source\":%zu}\n",sizeof(ksn_bounded_ring_workspace),_Alignof(ksn_bounded_ring_workspace),offsetof(ksn_bounded_ring_workspace,delayed_center_hdr),offsetof(ksn_bounded_ring_workspace,center_id),offsetof(ksn_bounded_ring_workspace,winner_record),offsetof(ksn_bounded_ring_workspace,winner_depth),offsetof(ksn_bounded_ring_workspace,source));}
