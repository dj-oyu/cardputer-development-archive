#ifndef ROW_TRANSPORT_BRIDGE_H
#define ROW_TRANSPORT_BRIDGE_H
#include "pixel_transport.h"
#include "ksn_bounded_hdr.h"
#include "background.h"
/* Constructor-owned aligned live objects only; forged pointers are not supported. */
typedef struct { uint64_t limit,used; } RowHostVerification;
typedef struct {
 fox_transport_context *tx; const ksn_mesh_pixel_snapshot *snapshot;
 uint16_t *pixels; float *depth; ksn_aa_workspace *workspace;
 const ksn_aa_identity *identity; const ksn_aa_ledger *limits;
 const KsnSceneBinding *composition; const KsnSceneLedger *composition_limits;
 KsnSceneReport *composition_report; KsnBandHDRReport *hdr_report;
 fox_bg_work *background_work; RowHostVerification *verification;
} RowRender;
bool row_transport_render(const RowRender *);
#endif
