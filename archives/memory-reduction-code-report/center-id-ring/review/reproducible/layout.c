#include <stdio.h>
#include <stddef.h>
#include "ksn_bounded_ring.h"
int main(void){
_Static_assert(sizeof(ksn_aa_workspace)==137312,"generic ABI");
_Static_assert(sizeof(ksn_bounded_ring_workspace)==77312,"ring ABI");
_Static_assert(sizeof(((ksn_bounded_ring_workspace*)0)->center_id)==4800,"ring IDs");
_Static_assert(sizeof(ksn_aa_workspace)-sizeof(ksn_bounded_ring_workspace)==60000,"saving");
#define CHECK(field) _Static_assert(offsetof(ksn_aa_workspace,field)-offsetof(ksn_bounded_ring_workspace,field)==60000,"offset " #field)
CHECK(targets);CHECK(reuse);CHECK(winner_record);CHECK(winner_face);CHECK(winner_depth);CHECK(delayed_center_hdr);CHECK(source);CHECK(offsets);CHECK(records);CHECK(record_count);CHECK(report);
printf("{\"status\":\"PASS\",\"genericBytes\":%zu,\"ringBytes\":%zu,\"genericAlign\":%zu,\"ringAlign\":%zu,\"trailingFieldsOffsetsMinus60000\":true}\n",sizeof(ksn_aa_workspace),sizeof(ksn_bounded_ring_workspace),_Alignof(ksn_aa_workspace),_Alignof(ksn_bounded_ring_workspace));
}
