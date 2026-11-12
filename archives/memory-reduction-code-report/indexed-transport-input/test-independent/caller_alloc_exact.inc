  bounce_vertex *attributes=transportmode?calloc(occluder_vertices,sizeof *attributes):NULL;
  if(transportmode&&!attributes)return fail("attribute-vertex-memory");
  bounce_indexed_triangle *attribute_triangles=transportmode?calloc(occluder_triangles,sizeof *attribute_triangles):NULL;
  if(transportmode&&!attribute_triangles){free(attributes);return fail("attribute-triangle-memory");}
  transport_temp=transportmode?occluder_vertices*sizeof *attributes+occluder_triangles*sizeof *attribute_triangles:0;
