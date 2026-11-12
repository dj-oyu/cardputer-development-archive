#include "ui/kasane/ksn_mesh_depth.h"
#include <stddef.h>
#include <stdio.h>
#define TYPE(T) printf("type %s %zu %zu\n",#T,sizeof(T),_Alignof(T))
#define FIELD(T,F) printf("field %s.%s %zu %zu\n",#T,#F,offsetof(T,F),sizeof(((T*)0)->F))
int main(void){
 TYPE(co_vertex);FIELD(co_vertex,x);FIELD(co_vertex,y);FIELD(co_vertex,mask);FIELD(co_vertex,depth);FIELD(co_vertex,color_a);FIELD(co_vertex,color_b);
 TYPE(co_input);FIELD(co_input,vertices);FIELD(co_input,indices);FIELD(co_input,node);FIELD(co_input,vertex_count);FIELD(co_input,triangle_count);
 TYPE(co_sided_input);FIELD(co_sided_input,front);FIELD(co_sided_input,back_colors);FIELD(co_sided_input,back_faces);
 TYPE(co_pixel_vertex);FIELD(co_pixel_vertex,front);FIELD(co_pixel_vertex,world);FIELD(co_pixel_vertex,normal_front);FIELD(co_pixel_vertex,normal_back);
 TYPE(co_pixel_input);FIELD(co_pixel_input,vertices);FIELD(co_pixel_input,indices);FIELD(co_pixel_input,back_faces);FIELD(co_pixel_input,node);FIELD(co_pixel_input,vertex_count);FIELD(co_pixel_input,triangle_count);
 TYPE(co_buffer);FIELD(co_buffer,data);FIELD(co_buffer,capacity);FIELD(co_buffer,size);FIELD(co_buffer,packets);
 TYPE(co_view);FIELD(co_view,data);FIELD(co_view,size);FIELD(co_view,node);FIELD(co_view,color);FIELD(co_view,vertex_count);FIELD(co_view,triangle_count);FIELD(co_view,mode);
 TYPE(ksn_mesh_snapshot);FIELD(ksn_mesh_snapshot,packets);FIELD(ksn_mesh_snapshot,work);FIELD(ksn_mesh_snapshot,work_limit);FIELD(ksn_mesh_snapshot,enabled);
 TYPE(ksn_mesh_pixel_snapshot);FIELD(ksn_mesh_pixel_snapshot,mesh);FIELD(ksn_mesh_pixel_snapshot,storage);FIELD(ksn_mesh_pixel_snapshot,capacity);
 TYPE(ksn_mesh_pixel_stats);FIELD(ksn_mesh_pixel_stats,shade_updates);FIELD(ksn_mesh_pixel_stats,disk_samples);
 printf("constant KSN_PIXEL_HEADER_BYTES %d\n",KSN_PIXEL_HEADER_BYTES);printf("constant KSN_PIXEL_MAX_STORAGE %d\n",KSN_PIXEL_MAX_STORAGE);return 0;
}
