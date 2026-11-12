#ifndef FOX_SCENE_TRANSPORT_BRIDGE_H
#define FOX_SCENE_TRANSPORT_BRIDGE_H
#include "../transport/pixel_transport.h"
#include "ui/kasane/ksn_scene_composition.h"
bool fox_transport_render_scene_composition_experimental(fox_transport_context*,const ksn_mesh_pixel_snapshot*,uint16_t*,float*,ksn_aa_workspace*,const ksn_aa_identity*,const ksn_aa_ledger*,KsnAASampleObserver,void*,size_t,const KsnSceneBinding*,const KsnSceneLedger*,KsnSceneReport*);
#endif
