#ifndef STREAM_DEPTH_ALLOC_H
#define STREAM_DEPTH_ALLOC_H
#include "ksn_stream_depth.h"
#include <stdlib.h>
static void depth_stream_release(KsnStreamDepth*d,void(*release)(void*)){
 release(d->strip);release(d->pending);release(d->capture);*d=(KsnStreamDepth){0};
}
/* Fresh empty descriptor only. Rollback every successful allocation on failure. */
static bool depth_stream_allocate(KsnStreamDepth*d,bool capture,void*(*allocate)(size_t),void(*release)(void*)){
 *d=(KsnStreamDepth){0};d->strip_bytes=7680;d->pending_bytes=960;
 d->strip=allocate(d->strip_bytes);if(!d->strip)goto fail;
 d->pending=allocate(d->pending_bytes);if(!d->pending)goto fail;
 if(capture){d->capture_bytes=129600;d->capture=allocate(d->capture_bytes);if(!d->capture)goto fail;}
 return true;
fail:depth_stream_release(d,release);return false;
}
#endif
