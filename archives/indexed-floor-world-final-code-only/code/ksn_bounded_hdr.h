#ifndef KSN_BOUNDED_HDR_H
#define KSN_BOUNDED_HDR_H
#include "ksn_scene_composition.h"
typedef int (*KsnBandProfile)(const float[3],float[3]);
enum { RH_CLEAR,RH_STORE,RH_COPY,RH_ROWS,RH_SCHEDULE,RH_PROFILE,RH_INPUT,RH_OUTPUT,RH_PACK,RH_GUARDS,RH_ADMISSION,RH_COUNT };
typedef struct { uint64_t used[RH_COUNT],clamped; bool complete; } KsnBandHDRReport;
/* Private candidates only. All inputs immutable/live through return. Profile must
 * be the caller-pinned unchanged u16 profile. No observer or full-frame HDR.
 * Failure consumes work and leaves candidates partial; publish only true. */
bool ksn_mesh_pixel_render_bounded_hdr_experimental(
 const ksn_mesh_pixel_snapshot *,uint16_t *,size_t,float *,size_t,
 ksn_aa_workspace *,size_t,const ksn_aa_identity *,const ksn_aa_ledger *,
 FoxPixelShader,void *,size_t,const KsnSceneBinding *,const KsnSceneLedger *,
 KsnSceneReport *,KsnBandProfile,KsnBandHDRReport *);
#endif
