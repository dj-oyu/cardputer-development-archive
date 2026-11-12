/* Test-only visibility refcount fault injection, never a production API. */
#include "../private-build/visibility/visibility.c"
size_t test_vis_refs(vis_scene *s,size_t replacement){size_t old=s->refs;s->refs=replacement;return old;}
