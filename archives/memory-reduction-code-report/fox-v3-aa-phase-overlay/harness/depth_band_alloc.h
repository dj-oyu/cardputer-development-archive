#ifndef DEPTH_BAND_ALLOC_H
#define DEPTH_BAND_ALLOC_H
#include "ksn_bounded_ring.h"
#include <stdlib.h>
/* Host-private candidate only. Call with a fresh empty descriptor. No publication. */
static bool depth_bands_allocate(KsnDepthBands *d,void *(*allocate)(size_t)){
 *d=(KsnDepthBands){0};
 for(unsigned i=0;i<5;i++){
  d->bytes[i]=i<4?30720u:6720u;
  d->band[i]=allocate(d->bytes[i]);
  if(!d->band[i]){for(unsigned j=0;j<i;j++)free(d->band[j]);*d=(KsnDepthBands){0};return false;}
 }
 return true;
}
static void depth_bands_release(KsnDepthBands *d){for(unsigned i=0;i<5;i++)free(d->band[i]);*d=(KsnDepthBands){0};}
#endif
