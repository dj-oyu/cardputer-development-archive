#include <stdio.h>
#include "pixel_transport.h"
int main(void){printf("context=%zu ground=%zu gen=%zu binding=%zu counter=%zu result=%zu scene1166=%zu scene1168=%zu\n",sizeof(fox_transport_context),sizeof(bounce_ground),sizeof(bounce_generation),sizeof(bounce_binding),sizeof(bounce_counters),sizeof(bounce_result),bounce_scene_required_bytes(1166),bounce_scene_required_bytes(1168));}
