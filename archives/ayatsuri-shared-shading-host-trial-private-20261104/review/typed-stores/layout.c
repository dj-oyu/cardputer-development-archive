#include "ui/kasane/ksn_procedural.h"
#include <stdio.h>
#include <stddef.h>
int main(void) {
 printf("vertex_size=%zu vertex_align=%zu patch_size=%zu patch_align=%zu colors=%zu,%zu vertices_offset=%zu uint16_align=%zu\n", sizeof(ksn_proc_gouraud_vertex), _Alignof(ksn_proc_gouraud_vertex), sizeof(ksn_proc_gouraud_patch), _Alignof(ksn_proc_gouraud_patch),offsetof(ksn_proc_gouraud_vertex,color_a),offsetof(ksn_proc_gouraud_vertex,color_b),offsetof(ksn_proc_gouraud_patch,vertices),_Alignof(uint16_t));
}
