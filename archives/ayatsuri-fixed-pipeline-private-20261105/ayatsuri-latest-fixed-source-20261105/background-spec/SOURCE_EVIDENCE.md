# Exact selected source excerpts; read-only audit


## background/background.c
SHA256 d6e3983c3bb244a281e85c28d586bd1bfb7278bc879c13638c2b19458bc6961d

69:  for(unsigned k=0;k<9;k++)if(!isfinite(i->camera[k]))return FOX_BG_INVALID;if(!(i->camera[6]>0)||!finite3(i->source_origin)||!finite3(i->source_view)||fabs(dot(i->source_view,i->source_view)-1)>1e-12||!isfinite(i->clip[0])||!isfinite(i->clip[1])||!(i->clip[0]>0)||!(i->clip[1]>i->clip[0]))return FOX_BG_INVALID;
70:  for(unsigned a=0;a<4;a++)for(unsigned k=0;k<3;k++)if(!isfinite(i->floor[a][k])||fabs(i->floor[a][k])>1e50)return FOX_BG_INVALID;for(unsigned k=0;k<6;k++)if(i->indices[k]>=4)return FOX_BG_INVALID;
71:  for(unsigned a=0;a<2;a++){double e1[3],e2[3],n0[3];for(unsigned k=0;k<3;k++){e1[k]=i->floor[i->indices[a*3+1]][k]-i->floor[i->indices[a*3]][k];e2[k]=i->floor[i->indices[a*3+2]][k]-i->floor[i->indices[a*3]][k];}cross(e1,e2,n0);double l=hypot(hypot(n0[0],n0[1]),n0[2]);if(!isfinite(l)||!(l>0))return FOX_BG_INVALID;}
72:  for(unsigned k=0;k<3;k++)if(!isfinite(i->rho[k])||i->rho[k]<0||i->rho[k]>1||!isfinite(i->le[k])||i->le[k]<0)return FOX_BG_INVALID;if(fox_disk_scene_validate(&i->lights)!=FOX_DISK_OK)return FOX_BG_INVALID;
73:  fox_bg_scene*s=calloc(1,sizeof*s);if(!s)return FOX_BG_ALLOC;s->refs=1;s->bytes=sizeof*s;s->in=*i;memcpy(s->world,i->lights.world_radiance,sizeof s->world);memset(s->in.lights.world_radiance,0,sizeof s->in.lights.world_radiance);
74:  st=camera_prepare(s);if(st){free(s);return st;}if(vis_binding_set(&s->shadow,geometry,i->generation.visibility)!=VIS_OK){free(s);return FOX_BG_VISIBILITY;}fox_bg_scene*old=*slot;*slot=s;fox_bg_scene_release(old);return FOX_BG_OK;
100: static fox_bg_status resolve_impl(fox_bg_context*c,const KsnSceneQuery*q,fox_bg_result*out,KsnSceneResult*compact){
101:  if(!c||!q||(!out&&!compact)||!c->binding.scene||!c->work||!c->shadow_budget)return FOX_BG_INVALID;fox_bg_scene*s=c->binding.scene;
102:  const void*p[5]={c,q,out,c->work,c->shadow_budget};size_t n[5]={sizeof*c,sizeof*q,sizeof*out,sizeof*c->work,sizeof*c->shadow_budget};for(unsigned i=0;i<5;i++){if(fox_bg_scene_overlaps(s,p[i],n[i]))return FOX_BG_INVALID;for(unsigned j=i+1;j<5;j++)if(overlap(p[i],n[i],p[j],n[j]))return FOX_BG_INVALID;}
103:  if(compact){if(fox_bg_scene_overlaps(s,compact,sizeof*compact))return FOX_BG_INVALID;for(unsigned i=0;i<5;i++)if(overlap(compact,sizeof*compact,p[i],n[i]))return FOX_BG_INVALID;}
104:  if(!work_valid(c->work)||!c->work->used[BGW_FRAME]||!shadow_valid(c->shadow_budget))return FOX_BG_INVALID;fox_bg_status st=pay(c->work,slot_fee,1);if(st)return st;
105:  if(!geq(c->binding.expected,s->in.generation)||!veq(c->binding.expected.visibility,vis_scene_generation(s->shadow.scene)))return FOX_BG_GENERATION;
106:  if((c->mode!=KSN_SCENE_COMPOSITE&&c->mode!=KSN_SCENE_BACKGROUND_ONLY)||q->x>=240||q->y>=135||(q->sample!=UINT32_MAX&&q->sample>3)||q->character_hit>1||q->mode!=c->mode||(q->character_hit?!isfinite(q->character_depth):(q->character_depth!=0||signbit(q->character_depth))))return FOX_BG_INVALID;
107:  fox_bg_result r={0};r.x=q->x;r.y=q->y;r.sample=q->sample;r.character_depth=q->character_depth;r.snapshot_fingerprint=s->in.snapshot_fingerprint;r.identity_fingerprint=s->in.identity_fingerprint;
108:  const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};double x=q->x,y=q->y;if(q->sample!=UINT32_MAX){x+=dx[q->sample];y+=dy[q->sample];}st=floor_intersection(s,x,y,&r);if(st)return st;
109:  int hit=r.miss_reason==FOX_BG_FLOOR_HIT;int keep=c->mode==KSN_SCENE_COMPOSITE&&q->character_hit&&(!hit||r.floor_depth<=q->character_depth);
110:  if(keep)r.action=0;
111:  else if(!hit){uint64_t fee[BGW_COUNT]={0};fee[BGW_WORLD]=64;st=pay(c->work,fee,3);if(st)return st;r.action=2;for(unsigned k=0;k<3;k++)r.world[k]=r.combined[k]=s->world[k];}
112:  else{st=pay(c->work,floor_fee,2);if(st)return st;r.action=1;shadow_context z={c,&r,FOX_BG_OK};FoxDiskStatus fs=fox_disk_eval16_visible(&s->in.lights,r.position,r.normal,s->in.rho,visible,&z,r.direct);if(fs!=FOX_DISK_OK)return z.failure?z.failure:FOX_BG_LIGHTING;for(unsigned k=0;k<3;k++){r.world[k]=s->in.rho[k]*s->world[k];r.emission[k]=s->in.le[k];r.combined[k]=r.direct[k]+r.world[k]+r.emission[k];if(!isfinite(r.combined[k])||r.combined[k]<0)return FOX_BG_NUMERIC;}}
113:  fox_bg_counters sum=c->counters;
114: #define ADD(f,v) do{uint64_t a=(v);if(sum.f>UINT64_MAX-a)return FOX_BG_BUDGET;sum.f+=a;}while(0)
115:  ADD(slots,1);ADD(keep,r.action==0);ADD(floor,r.action==1);ADD(world,r.action==2);ADD(parallel,r.action==2&&r.miss_reason==FOX_BG_PARALLEL);ADD(negative_t,r.action==2&&r.miss_reason==FOX_BG_NEGATIVE_T);ADD(outside,r.action==2&&r.miss_reason==FOX_BG_OUTSIDE);ADD(clip,r.action==2&&r.miss_reason==FOX_BG_CLIP);ADD(positive_queries,r.positive_queries);ADD(blocked_queries,r.blocked_queries);
116: #undef ADD
117:  if(compact){KsnSceneResult k={0};k.action=r.action;k.floor_classification=hit?1:2;k.floor_native_depth=hit?(double)r.floor_depth:0;memcpy(k.linear_rgb,r.combined,sizeof k.linear_rgb);*compact=k;}
118:  if(out)*out=r;c->last_result=r;c->counters=sum;return FOX_BG_OK;

## background/background.h
SHA256 b758eeffe6e4e7f2de708386b8eb7a80bcd0dd28ab6b1ba7d3bc7027e5a1c301

21: typedef struct {
22:  fox_bg_generation generation;
23:  uint64_t snapshot_fingerprint,identity_fingerprint;
24:  float camera[9];
25:  double source_origin[3],source_view[3],clip[2];
26:  double floor[4][3]; uint32_t indices[6];
27:  double rho[3],le[3]; FoxDiskScene lights;
28: } fox_bg_input;
41: typedef enum { FOX_BG_FLOOR_HIT=0, FOX_BG_PARALLEL=1, FOX_BG_NEGATIVE_T=2,
42:  FOX_BG_OUTSIDE=3, FOX_BG_CLIP=4 } fox_bg_miss;
43: typedef struct {
44:  uint32_t x,y,sample,action,miss_reason,triangle;
45:  float character_depth,floor_depth;
46:  double position[3],normal[3],direct[3],world[3],emission[3],combined[3];
47:  uint64_t snapshot_fingerprint,identity_fingerprint,positive_queries,blocked_queries;
48: } fox_bg_result;
49: typedef struct {
50:  uint64_t slots,keep,floor,world,parallel,negative_t,outside,clip,
51:  positive_queries,blocked_queries;
52: } fox_bg_counters;
53: typedef struct {
54:  fox_bg_binding binding; fox_bg_work *work; vis_budget *shadow_budget;
55:  fox_bg_counters counters; fox_bg_result last_result; uint32_t mode,reserved;
76: /* Once-per-frame admission retains scene/copies input identities; snapshot and
77:  * identity buffers may be released after success. Work and shadow-budget
78:  * controls remain caller-owned and must stay live throughout the frame.
79:  * The dedicated shadow budget starts at zero and stays cumulative.
80:  * Current snapshot prepared lights and world must exactly match descriptor.
81:  * Current snapshot and identity bytes are hashed once, not per query.
82:  * Failed output/context mutations are atomic; accepted work remains consumed.
83:  * A later failed query invalidates the entire private/unpublished frame. */
84: fox_bg_status fox_bg_context_begin(fox_bg_context *,fox_bg_scene *,fox_bg_generation,
85:  uint32_t mode,fox_bg_work *,vis_budget *,const void *snapshot,size_t snapshot_bytes,
86:  const void *identity,size_t identity_bytes);
87: void fox_bg_context_clear(fox_bg_context *);
88: /* Read-only completeness/fee/counter gate, prepaid by frameAdmission. */
89: fox_bg_status fox_bg_context_finish(const fox_bg_context *);
90: bool fox_bg_context_overlaps(void *,const void *,size_t);
91: size_t fox_bg_context_owned_bytes(const fox_bg_context *);
92: /* Only retained final slots. sample UINT32_MAX=center; 0..3=quarter offsets.
93:  * Canonical no-character depth is zero. KEEP returns zero RGB. Exact native
94:  * float floor depth controls precedence, never an analytic-depth tolerance.
95:  * Work/VIS counters survive failure; result and aggregate counters do not. */
96: fox_bg_status fox_bg_resolve(fox_bg_context *,const KsnSceneQuery *,fox_bg_result *);
97: bool fox_bg_compose(void *,const KsnSceneQuery *,KsnSceneResult *);
98: const char *fox_bg_status_string(fox_bg_status);

## background/REPORT.md
SHA256 522f617d5c5dc70edab3dbe6968415142d89cc6259d5b327e4b319268bb5f5db

1: # Private camera-background module, synthetic verification
2: 
3: This module is a separate explicit host experiment in the new root. No actual physical frame, shadow traversal over actual source geometry, image/reference comparison, public/model/device change, or original-root edit was performed by this implementation task. The original direct1M and AA8M failures remain failures of those original budgets. Background shadows use their separately approved2M/200M/100M budget; transport and original character budgets remain unchanged.
4: 
5: ## API and ownership
6: 
7: `background.h` owns the input/scene/work/context/result contracts. `fox_bg_scene_build` copies752B input, prepares exact native Q32/t32 and its inverse, and retains the existing BVH. The976B scene owns all camera/floor/rho/Le/illumination values. Native camera and source axial clip remain distinct. Illumination has an independent generation token; old `vis_generation.light` is not modified. Field-group changes require their corresponding generation; all tokens nonzero/monotonic. Identity fingerprint changes require a geometry/pose change, and snapshot changes require a relevant scene/material/illumination/camera token, not merely an emission-token change.
8: 
9: `fox_bg_context_begin` validates snapshot/identity byte fingerprints and all51 prepared lighting doubles once. Snapshot/identity/input buffers may subsequently be destroyed; the work and dedicated shadow-budget controls remain live caller-owned controls. The new background budget starts at zero and is cumulative. `fox_bg_compose` adapts the full private result to the core24B query/40B result. It does not allocate a redundant208B wrapper result: `ctx.last_result` receives the complete successful private result. Both public APIs have failure-atomic outputs. Accepted work and traversal consumption are not rolled back. KEEP RGB is zero; missing character depth and SCENE_MISS floor depth are canonical positive zero; other sample tags/modes reject.
10: 
11: `fox_bg_context_finish` is the frame-end gate prepaid at frame entry: exact Q completion, KEEP+FLOOR+WORLD=Q, WORLD miss-reason sum, successful evaluator/world counts equal the work ledger, positive queries equal consumed shadow rays, and valid current generations/limits. Failed/partial work cannot pass this gate. No image rollback is promised by the surrounding renderer; failed private partial frames must not be published.
12: 
13: Two finite-floor triangles use the exact existing geometry preflight convention, inclusive boundaries and first-ordinal equal-distance tie. Floor depths are exact float32 native projections; no epsilon-based precedence. Only floor selected in final slots receives DISK16 direct + rho*source_world + Le, with Le once. A true camera floor miss receives source world radiance. Character geometry remains in the retained shadow BVH. The unchanged segment uses its existing1e-5 endpoint exclusion, no normal offset; emitting-disk admission separately keeps1e-9.
41: ## Evidence scope
42: 
43: `BYTE_PROOF.json` checks32 inherited physical/visibility/transport production files against frozen A2 source hashes, all identical. `SOURCE_FREEZE.json` is the formal background-module freeze fragment with root-relative production/evidence paths for merging into the whole-root freeze. The core worker owns separately changed composition files and whole-root verification. Original source and all earlier preflight/diagnostic freezes remain unchanged.

## CORE_REPORT.md
SHA256 a28ec22aade1be270fb6156138f66d23d5d8bde7d3c882a246fd07cb83174a52

1: # Host scene-composition core: source freeze
2: 
3: This is a private opt-in host experiment. No actual character frame or physical frame has been rendered by these core tests. The original A2 public APIs remain unchanged. The new API with a NULL composition binding directly calls A2. All70 inherited files are byte-identical except ksn_mesh_depth.c, whose entire original byte prefix is retained and followed by one include. The inherited physical, visibility and transport files are byte-identical. Parent integration supplies its separately reviewed transport bridge.
4: 
5: ## Semantics
6: 
7: The new composition API retains original center character shading, target selection, four quarter positions, geometry, final character shading, old character observer, counters and center-depth output. The resolver receives all selected quarters and only non-target centers. A valid KEEP preserves the original HDR operand or encoded center without re-encoding. A strictly closer floor may replace only visible radiance. Character work/depth/support remain separate. Background-only uses a separately geometry-bound mask, copied into the existing workspace, and does no character shading.
8: 
9: Query24B and result40B are statically asserted. No-hit depth and scene-miss depth are canonical+0. Successful KEEP RGB must be canonical+0, although the original character RGB remains the selected operand. All compact result bytes start zero before every callback. Unknown action/classification, invalid precedence, nonfinite/negative RGB, inexact promoted floor float, and invalid canonical fields reject. A false callback can modify only its local result; it cannot commit that result into HDR/output. A frame can already contain partial earlier outputs and must remain unpublished on false.
10: 
11: Invalid admission intentionally preserves caller outputs, including a reused report whose prior complete flag is true. The boolean return is authoritative. After admitted work starts, the report records partial work and is not complete on failure. Hidden/intermediate character shader errors retain A2's explicit final-visible-only error contract: the old-equivalence fixture remains FAIL, not a successful legacy-equivalence claim.
19: All RGB arithmetic uses the existing four-sample mean and encoder. No new full-frame HDR buffer exists. Background-only records no legacy geometry work. Original character budgets and transport budgets remain unchanged; background shadow limits are separately bounded2M/200M/100M. The core checks limit/used fields, while the resolver and parent bridge own full cumulative routing/no-borrowing validation.
27: ## Evidence and limitations
28: 
29: Run `sh tests/run.sh`. O2 and O1 AddressSanitizer+UndefinedBehaviorSanitizer pass83 negative cases, exact NULL/KEEP bytes/depth/old report/observer tests, floor override work preservation, poisoned/freed source array ownership, full-span overlap cases, invalid result and cumulative budget cases, all active category exhaustion, exact control totals, and HDR averaging. Original A2 geometry/error-contract fixtures also pass their expected outcomes.
30: 
31: LeakSanitizer cannot run in this ptrace execution environment and is explicitly disabled; this is not an LSan pass. O1 sanitizer tests exercise safety, while O2 provides the stack-size admission evidence. No timing/benchmark/actual-image quality conclusion is made. Further actual runs require the independent parent review and combined source freeze.

## CORE_SOURCE_FREEZE.json
SHA256 5b0e787226a8de30c647ac8dbf356984ec5566134c34dd6d4e3f922aa7fdf390

1: {
2:   "status": "CORE_SOURCE_FROZEN_FOR_INDEPENDENT_REVIEW",
3:   "scope": "core product hook and shared API only; background module and evaluation bridge separately owned/frozen",
4:   "actualFramesRendered": 0,
5:   "production": {
6:     "product/main/ui/kasane/ksn_scene_composition.h": "a6c8a646b314efd9429a8b3d60d8bf5c3dd381fc0a929a99054b39ad647e52b9",
7:     "product/main/ui/kasane/ksn_scene_composition_impl.inc": "048aa007d936ca839e7c1e644f8df3bdf30f6654c915af30dce90c9d9b4444bd",
8:     "product/main/ui/kasane/ksn_mesh_depth.c": "1e7bed3e2e0d028c24bf9f21bef5ab62f01699f12018b6e795eadc397a0c7f38"
9:   },
27:   "legacySourcePreservation": "70 inherited files exact except original depth source exact prefix plus new include",
28:   "coreWorkCap": 1680000,
29:   "coreCategoryCount": 20,
30:   "descriptorHashExecution": false,
31:   "sanitizers": {
32:     "O2": "PASS",
33:     "O1-ASan-UBSan": "PASS",
34:     "LSan": "UNAVAILABLE_PTRACE_DISABLED_NOT_PASS"
35:   },

## product/main/ui/kasane/ksn_scene_composition.h
SHA256 a6c8a646b314efd9429a8b3d60d8bf5c3dd381fc0a929a99054b39ad647e52b9

4: /* Explicit host experiment. Original A2 entry points remain unchanged. */
5: enum { KSN_SCENE_COMPOSITE=0, KSN_SCENE_BACKGROUND_ONLY=1 };
6: enum { KSN_SCENE_KEEP_CHARACTER=0, KSN_SCENE_REPLACE_FLOOR=1, KSN_SCENE_REPLACE_WORLD=2 };
7: enum { KSN_SCENE_CLASS_UNKNOWN=0, KSN_SCENE_FLOOR_HIT=1, KSN_SCENE_SCENE_MISS=2 };
8: enum { KSN_SCENE_CORE_CAP=1680000, KSN_SCENE_OWNED_CAP=16384, KSN_SCENE_NEW_STACK_CAP=4096 };
9: typedef struct {
10:  uint32_t x,y,sample,character_hit;
11:  float character_depth; /* canonical0 when !character_hit */
12:  uint32_t mode;
13: } KsnSceneQuery; /*24B; UINT32_MAX center,0..3 fixed quarter offsets */
14: typedef struct {
15:  uint32_t action,floor_classification;
16:  double floor_native_depth; /* exact compared float promoted;0 on SCENE_MISS */
17:  double linear_rgb[3];
18: } KsnSceneResult; /*40B; entire object zeroed; successful KEEP RGB is canonical+0 */
50: /* Background binding NULL directly dispatches to frozen A2. Caller initializes
51:  * RGB black. False leaves partial outputs private; no image rollback promise.
52:  * Source/geometry target masks, character depth and old A2 report stay separate.
53:  * Explicit byte lengths cover shader/observer contexts, not one-byte checks.
54:  * Invalid admission preserves caller outputs, including a prior complete report.
55:  * Always check the boolean return before interpreting report.complete. */
56: bool ksn_mesh_pixel_render_scene_composition_experimental(
57:  const ksn_mesh_pixel_snapshot *,uint16_t *,float *,ksn_aa_workspace *,
58:  const ksn_aa_identity *,const ksn_aa_ledger *,FoxPixelShader,void *,size_t,
59:  KsnAASampleObserver,void *,size_t,
60:  const KsnSceneBinding *,const KsnSceneLedger *,KsnSceneReport *);
61: /* Separate camera-hidden control. Mask is geometry-bound and copied into
62:  * workspace.targets; no camera character shading or character-depth output.
63:  * Resolver frame admission must already bind snapshot/identity/camera/scene.
64:  * Mask input stays live for this synchronous call; caller includes its4050B
65:  * construction storage in the separately approved new-owned peak. */
66: bool ksn_mesh_pixel_render_background_control_experimental(
67:  uint16_t *,ksn_aa_workspace *,const uint8_t *,size_t,
68:  const KsnSceneBinding *,const KsnSceneLedger *,KsnSceneReport *);

## product/main/ui/kasane/ksn_scene_composition_impl.inc
SHA256 048aa007d936ca839e7c1e644f8df3bdf30f6654c915af30dce90c9d9b4444bd

42: static bool sc_resolve(const KsnSceneBinding*b,KsnSceneReport*r,unsigned x,unsigned y,unsigned sample,bool hit,float depth,KsnSceneResult*out){
43:  if(x>=240||y>=135||(sample>3&&sample!=UINT32_MAX)||(hit&&!isfinite(depth)))return false;
44:  if(!sc_charge(r,SC_QUERY,6)||!sc_charge(r,SC_RESULT_ZERO,5)||!sc_charge(r,SC_DISPATCH,1)||!sc_charge(r,SC_RGB_VALIDATE,3)||!sc_charge(r,SC_DECISION_VALIDATE,3)||!sc_charge(r,SC_EVENTS,2))return false;
45:  KsnSceneQuery q={x,y,sample,hit?1u:0u,hit?depth:0.0f,b->mode};
46:  memset(out,0,sizeof*out);r->queries++;if(sample==UINT32_MAX)r->centers++;else r->quarters++;
47:  if(!b->compose(b->context,&q,out))return false;
48:  for(unsigned k=0;k<3;k++)if(!isfinite(out->linear_rgb[k])||out->linear_rgb[k]<0)return false;
49:  if(out->floor_classification==KSN_SCENE_FLOOR_HIT){if(!isfinite(out->floor_native_depth)||!isfinite((float)out->floor_native_depth)||(double)(float)out->floor_native_depth!=out->floor_native_depth)return false;}
50:  else if(out->floor_classification==KSN_SCENE_SCENE_MISS){if(out->floor_native_depth!=0||signbit(out->floor_native_depth))return false;}
51:  else return false;
52:  if(out->action==KSN_SCENE_KEEP_CHARACTER){if(out->linear_rgb[0]!=0||signbit(out->linear_rgb[0])||out->linear_rgb[1]!=0||signbit(out->linear_rgb[1])||out->linear_rgb[2]!=0||signbit(out->linear_rgb[2])||!hit||(out->floor_classification==KSN_SCENE_FLOOR_HIT&&out->floor_native_depth>depth))return false;r->kept++;}
53:  else if(out->action==KSN_SCENE_REPLACE_FLOOR){if(out->floor_classification!=KSN_SCENE_FLOOR_HIT||(hit&&!(out->floor_native_depth>depth)))return false;r->floor++;if(hit)r->occluded_character++;}
54:  else if(out->action==KSN_SCENE_REPLACE_WORLD){if(hit||out->floor_classification!=KSN_SCENE_SCENE_MISS)return false;r->world++;}
55:  else return false;
56:  return true;
57: }
58: static uint16_t sc_encode(const double rgb[3]){
59:  unsigned q[3];for(unsigned k=0;k<3;k++){float v=ayatsuri_srgb_encode((float)fmin(1,rgb[k]));q[k]=(unsigned)lroundf(v*(k==1?63:31));}return (uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
66: static bool sc_shade_final(const ksn_mesh_pixel_snapshot*s,ksn_aa_workspace*w,const FoxDiskScene*scene,unsigned y,unsigned rows,unsigned sample,double dx,double dy,FoxPixelShader shader,void*context,KsnAASampleObserver observer,void*observer_context,const KsnSceneBinding*binding,KsnSceneReport*report){
67:  unsigned n=rows*240;if(!aa_guard(w,AA_FINAL_SCAN,n))return false;
68:  for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_SCAN]++;w->report.observed_total++;
69:   unsigned p=y*240+at;if(!aa_target(w,p))continue;
70:   if(w->winner_record[at]==65535){w->report.sample_nohits[sample]++;
71:    if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.record_offset=65535,.node=65535,.source_id=65535,.face=255,.depth=-INFINITY};if(!observer(observer_context,&event))return false;}
72:    KsnSceneResult result;if(!sc_resolve(binding,report,at%240,y+at/240,sample,false,0,&result)||!sc_charge(report,SC_REPLACEMENT_COPY,3)||!sc_charge(report,SC_ORIGINAL_MISS_ACCUM,6))return false;
73:    double chosen[3];memcpy(chosen,result.linear_rgb,sizeof chosen);for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=chosen[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}continue;}
74:   if(!aa_charge(w,AA_FINAL_SHADE,76))return false;
83:   bool second=bary[0]*q[0].mask+bary[1]*q[1].mask+bary[2]*q[2].mask>=0;
84:   double world[3]={0},normal[3]={0},rho[3]={0};float decoded[3][3];
85:   for(unsigned j=0;j<3;j++){
86:    uint16_t code=second?q[j].color_b:q[j].color_a;const int16_t*normal_code=back?fields[j].normal_back:fields[j].normal_front;
87:    decoded[j][0]=ayatsuri_srgb_decode((code>>11)/31.0f);decoded[j][1]=ayatsuri_srgb_decode(((code>>5)&63)/63.0f);decoded[j][2]=ayatsuri_srgb_decode((code&31)/31.0f);
88:    for(unsigned k=0;k<3;k++){world[k]+=bary[j]*fields[j].world[k];normal[k]+=bary[j]*(normal_code[k]/32767.0);}
89:   }
90:   if(!ksn_aa_rho_affine(decoded,bary,rho))return false;
91:   const double position[3]={world[0]/38,-world[2]/38,-world[1]/38},nn[3]={normal[0],-normal[2],-normal[1]};double rgb[3];
92:   if(shader){if(!shader(context,scene,position,nn,rho,rgb))return false;}else if(fox_disk_eval16(scene,position,nn,rho,rgb)!=FOX_DISK_OK)return false;
93:   for(unsigned k=0;k<3;k++)if(!isfinite(rgb[k])||rgb[k]<0)return false;
94:   w->report.sample_hits[sample]++;w->report.sample_shades++;
95:   if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.hit=true,.record_offset=(uint16_t)off,.node=(uint16_t)node,.source_id=w->source[node][face],.face=(uint8_t)face,.back=back,.depth=w->winner_depth[at]};memcpy(event.position,position,sizeof position);memcpy(event.normal,nn,sizeof nn);memcpy(event.rho,rho,sizeof rho);memcpy(event.linear_rgb,rgb,sizeof rgb);if(!observer(observer_context,&event))return false;}
96:   KsnSceneResult result;if(!sc_resolve(binding,report,at%240,y+at/240,sample,true,w->winner_depth[at],&result))return false;
97:   if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(report,SC_REPLACEMENT_COPY,3))return false;memcpy(rgb,result.linear_rgb,sizeof rgb);}
98:   /* Exactly the original one addition per covered character sample, performed
99:    * after choosing its camera-visible radiance. KEEP operand is untouched. */
100:   for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=rgb[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}
114: bool ksn_mesh_pixel_render_scene_composition_experimental(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,float*depth,ksn_aa_workspace*w,const ksn_aa_identity*t,const ksn_aa_ledger*limits,FoxPixelShader shader,void*context,size_t context_bytes,KsnAASampleObserver observer,void*observer_context,size_t observer_bytes,const KsnSceneBinding*binding,const KsnSceneLedger*new_limits,KsnSceneReport*new_report){
115:  if(!binding)return ksn_mesh_pixel_render_boundary_experimental(s,rgb,depth,w,t,limits,shader,context,observer,observer_context);
116:  if(!sc_composite_admission(s,rgb,depth,w,t,limits,context,context_bytes,observer_context,observer_bytes,binding,new_limits,new_report))return false;
117:  memset(&w->report,0,sizeof w->report);w->report.failed_category=AA_CATEGORY_COUNT;w->report.reserved=*limits;
118:  for(unsigned k=0;k<AA_CATEGORY_COUNT;k++){if(limits->value[k]>8000000-w->report.reserved_total)return false;w->report.reserved_total+=limits->value[k];}
119:  FoxDiskScene scene;if(!aa_charge(w,AA_CONTROL,128)||!pixel_scene(s,&scene)||!aa_bind(s,w,t)||!aa_charge(w,AA_LEGACY_CENTER,s->mesh.work)||!aa_charge(w,AA_CENTER_ID_INIT,KSN_AA_PIXELS))return false;
120:  memset(w->center_id,0xff,sizeof w->center_id);ksn_mesh_pixel_stats stats={0};
121:  for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;if(!aa_charge(w,AA_CONTROL,1))return false;bool center_ok=aa_center_strip(&s->mesh,rgb+y*240,y,rows,depth+y*240,&scene,&stats,NULL,NULL,shader,context,w);w->report.center_shades=stats.shade_updates;if(!center_ok)return false;}
122:  if(!aa_select(w)||w->report.targets!=binding->expected_targets||!sc_mask(binding,w,new_report))return false;
123:  if(new_limits->value[SC_CENTER_STATE]<2u*(KSN_AA_PIXELS-binding->expected_targets)){new_report->failed_category=SC_CENTER_STATE;return false;}
124:  static const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
125:  for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned n=rows*240;if(!aa_charge(w,AA_CONTROL,1)||!aa_charge(w,AA_HDR_CLEAR,3*n))return false;memset(w->reuse.hdr,0,n*3*sizeof(double));
126:   for(unsigned sample=0;sample<4;sample++)if(!aa_charge(w,AA_CONTROL,1)||!aa_geometry(s,w,y,rows,dx[sample],dy[sample])||!sc_shade_final(s,w,&scene,y,rows,sample,dx[sample],dy[sample],shader,context,observer,observer_context,binding,new_report))return false;
127:   if(!aa_guard(w,AA_FINAL_OUTPUT_SCAN,n))return false;
128:   if(!sc_guard(new_report,SC_CENTER_STATE,0))return false;
129:   for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_OUTPUT_SCAN]++;w->report.observed_total++;if(aa_target(w,y*240+at)){
130:    if(!aa_charge(w,AA_FINAL_ENCODE,8))return false;unsigned q[3];for(unsigned k=0;k<3;k++){double mean=w->reuse.hdr[at][k]/4;float value=ayatsuri_srgb_encode((float)fmin(1,mean));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
131:    rgb[y*240+at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
132:   }else{
133:    new_report->observed.value[SC_CENTER_STATE]+=2;new_report->observed_total+=2;
134:    bool hit=w->center_id[y*240+at]!=KSN_AA_NOHIT;KsnSceneResult result;
135:    if(!sc_resolve(binding,new_report,at%240,y+at/240,UINT32_MAX,hit,hit?depth[y*240+at]:0,&result))return false;
136:    if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(new_report,SC_CENTER_ENCODE,8))return false;rgb[y*240+at]=sc_encode(result.linear_rgb);}
137:   }}
138:  }
139:  if(!sc_complete(binding,new_report))return false;w->report.complete=true;return true;
142: bool ksn_mesh_pixel_render_background_control_experimental(uint16_t*rgb,ksn_aa_workspace*w,const uint8_t*mask,size_t mask_bytes,const KsnSceneBinding*b,const KsnSceneLedger*l,KsnSceneReport*r){
143:  if(!rgb||!w||!mask||mask_bytes!=sizeof w->targets)return false;
144:  const void*p[]={rgb,w,mask};const size_t n[]={64800,sizeof*w,mask_bytes};
145:  if(!sc_binding_spans(b,l,r,p,n,3,KSN_SCENE_BACKGROUND_ONLY)||b->resolver_owned_bytes+sizeof*b+sizeof*l+sizeof*r+mask_bytes>KSN_SCENE_OWNED_CAP||!sc_begin(r,l)||!sc_charge(r,SC_MASK_COPY,mask_bytes))return false;
146:  memcpy(w->targets,mask,mask_bytes);if(!sc_mask(b,w,r))return false;
147:  memset(&w->report,0,sizeof w->report); /* no legacy character work is claimed */
148:  for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned count=240*rows;
149:   if(!sc_charge(r,SC_HDR_CLEAR,3*count))return false;memset(w->reuse.hdr,0,count*3*sizeof(double));
150:   for(unsigned sample=0;sample<4;sample++){
151:    if(!sc_guard(r,SC_SAMPLE_SCAN,count))return false;
152:    for(unsigned at=0;at<count;at++){r->observed.value[SC_SAMPLE_SCAN]++;r->observed_total++;if(!aa_target(w,y*240+at))continue;
153:     KsnSceneResult result;if(!sc_resolve(b,r,at%240,y+at/240,sample,false,0,&result)||!sc_charge(r,SC_CONTROL_ACCUM,6))return false;
154:     for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=result.linear_rgb[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}
155:    }
156:   }
157:   if(!sc_guard(r,SC_OUTPUT_SCAN,count))return false;
158:   for(unsigned at=0;at<count;at++){r->observed.value[SC_OUTPUT_SCAN]++;r->observed_total++;
159:    if(aa_target(w,y*240+at)){if(!sc_charge(r,SC_CONTROL_ENCODE,8))return false;double mean[3];for(unsigned k=0;k<3;k++)mean[k]=w->reuse.hdr[at][k]/4;rgb[y*240+at]=sc_encode(mean);}
160:    else{KsnSceneResult result;if(!sc_resolve(b,r,at%240,y+at/240,UINT32_MAX,false,0,&result)||!sc_charge(r,SC_CONTROL_ENCODE,8))return false;rgb[y*240+at]=sc_encode(result.linear_rgb);}
161:   }
162:  }
163:  return sc_complete(b,r);

## product/main/ui/kasane/ksn_mesh_depth.c
SHA256 1e7bed3e2e0d028c24bf9f21bef5ab62f01699f12018b6e795eadc397a0c7f38

130:                 const float depth=(float)(w[0]*v[0].depth+w[1]*v[1].depth+w[2]*v[2].depth);
131:                 if(!isfinite(depth))return false;
132:                 const unsigned at=(unsigned)(yy-(int)y)*KSN_PROC_W+(unsigned)x;
133:                 if(depth<=z[at])continue;
134:                 z[at]=depth;
135:                 const bool second=w[0]*v[0].mask+w[1]*v[1].mask+w[2]*v[2].mask>=0;
136:                 const uint16_t a=second?v[0].color_b:v[0].color_a,b=second?v[1].color_b:v[1].color_a,c=second?v[2].color_b:v[2].color_a;
137:                 if(scene){
138:                     double world[3]={0,0,0},normal[3]={0,0,0},rho[3]={0,0,0};const uint16_t codes[3]={a,b,c};
139:                     for(unsigned j=0;j<3;j++){
140:                         const int16_t *n=back?fields[j].normal_back:fields[j].normal_front;
141:                         const float decoded[3]={ayatsuri_srgb_decode((codes[j]>>11)/31.0f),ayatsuri_srgb_decode(((codes[j]>>5)&63)/63.0f),ayatsuri_srgb_decode((codes[j]&31)/31.0f)};
142:                         for(unsigned k=0;k<3;k++){world[k]+=w[j]*fields[j].world[k];normal[k]+=w[j]*(n[k]/32767.0);rho[k]+=w[j]*decoded[k];}
143:                     }
144:                     for(unsigned k=0;k<3;k++){if(!isfinite(rho[k])||rho[k]<-64*DBL_EPSILON||rho[k]>1+64*DBL_EPSILON)return false;rho[k]=fmax(0,fmin(1,rho[k]));}
145:                     const double position[3]={world[0]/38,-world[2]/38,-world[1]/38},nn[3]={normal[0],-normal[2],-normal[1]};double rgb[3];
146:                     if(shader){if(!shader(shader_context,scene,position,nn,rho,rgb))return false;}else if((visibility?fox_disk_eval16_visible(scene,position,nn,rho,visibility,visibility_context,rgb):fox_disk_eval16(scene,position,nn,rho,rgb))!=FOX_DISK_OK)return false;
147:                     unsigned q[3];for(unsigned k=0;k<3;k++){float value=ayatsuri_srgb_encode((float)fmin(1,rgb[k]));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
148:                     if(stats->shade_updates==UINT64_MAX||stats->disk_samples>UINT64_MAX-48)return false;
149:                     pixels[at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);stats->shade_updates++;stats->disk_samples+=48;continue;
150:                 }
151:                 const float cw[3]={(float)w[0],(float)w[1],(float)w[2]};
152:                 const unsigned red=(unsigned)lroundf(fmaxf(0,fminf(31,cw[0]*(a>>11)+cw[1]*(b>>11)+cw[2]*(c>>11)))),
153:                     green=(unsigned)lroundf(fmaxf(0,fminf(63,cw[0]*((a>>5)&63)+cw[1]*((b>>5)&63)+cw[2]*((c>>5)&63)))),
181: 
182: /* Explicit host experiment; all preceding legacy function bodies unchanged. */
183: #include "ksn_boundary_aa_impl.inc"
184: 
185: /* Separate full-scene camera composition; frozen A2 above remains intact. */
186: #include "ksn_scene_composition_impl.inc"

## product/main/ui/kasane/ksn_boundary_aa.h
SHA256 4680b99560f17bedf633b548e81178cf7fda3cba927252919f1b7f5f1e30036d

35: typedef struct {
36:  uint16_t center_id[KSN_AA_PIXELS];
37:  uint8_t targets[(KSN_AA_PIXELS+7)/8];
38:  union { double hdr[KSN_AA_BAND_PIXELS][3]; uint16_t identity_key[4960]; } reuse;
39:  uint16_t winner_record[KSN_AA_BAND_PIXELS];
40:  uint8_t winner_face[KSN_AA_BAND_PIXELS];
41:  float winner_depth[KSN_AA_BAND_PIXELS];
42:  uint16_t source[KSN_AA_MAX_RECORDS+1][64];
43:  uint16_t offsets[KSN_AA_MAX_RECORDS+1];
44:  co_view records[KSN_AA_MAX_RECORDS];
45:  unsigned record_count;
46:  ksn_aa_report report;
47: } ksn_aa_workspace;
48: typedef struct {
49:  unsigned x,y,sample; bool hit;
50:  uint16_t record_offset,node,source_id; uint8_t face; bool back; float depth;
51:  double position[3],normal[3],rho[3],linear_rgb[3];
52: } ksn_aa_sample;
57: /* Immutable identity layout: (records+1) little-endian uint16 offsets followed
58:  * by faces*(original ordered local vertex indices[3],sourceID little-endian16).
59:  * Nodes are pinned 1..records. Each node maps a unique unordered triangle key;
60:  * actual winding parity relative to original must equal physical_back.
61:  * RGB must be initialized black by caller, as in the legacy adapter.
62:  * Full frame RGB and center depth are caller-owned (194400B separately).
63:  * Workspace, outputs, identity, snapshot and shader-owned state must be disjoint.
64:  * Caller provides conservative per-category reservations; total must <=8M.
65:  * Only owned snapshot data is read after caller model disposal. */

## product/main/ui/kasane/ksn_boundary_aa_impl.inc
SHA256 9a5ebadefc4558d389da47b4a929ac1842de82cc374fce843549e4c2ab008058

76: static bool aa_target(const ksn_aa_workspace*w,unsigned p){return (w->targets[p>>3]>>(p&7))&1u;}
77: static bool aa_select(ksn_aa_workspace*w){
78:  if(!aa_charge(w,AA_MASK_CLEAR,sizeof w->targets)||!aa_charge(w,AA_NEIGHBOR_COMPARE,4*KSN_AA_PIXELS))return false;
79:  memset(w->targets,0,sizeof w->targets);
80:  for(unsigned y=0;y<135;y++)for(unsigned x=0;x<240;x++){
81:   unsigned p=y*240+x;uint16_t c=w->center_id[p],u=y?w->center_id[p-240]:65535,l=x?w->center_id[p-1]:65535,r=x<239?w->center_id[p+1]:65535,d=y<134?w->center_id[p+240]:65535;
82:   if(c!=u||c!=l||c!=r||c!=d){w->targets[p>>3]|=(uint8_t)(1u<<(p&7));w->report.targets++;if(c==65535)w->report.nohit_targets++;else w->report.covered_targets++;}
83:  }
84:  return true;
85: }
116: static bool aa_shade_final(const ksn_mesh_pixel_snapshot*s,ksn_aa_workspace*w,const FoxDiskScene*scene,unsigned y,unsigned rows,unsigned sample,double dx,double dy,FoxPixelShader shader,void*context,KsnAASampleObserver observer,void*observer_context){
117:  unsigned n=rows*240;if(!aa_guard(w,AA_FINAL_SCAN,n))return false;
118:  for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_SCAN]++;w->report.observed_total++;
119:   unsigned p=y*240+at;if(!aa_target(w,p))continue;
120:   if(w->winner_record[at]==65535){w->report.sample_nohits[sample]++;
121:    if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.record_offset=65535,.node=65535,.source_id=65535,.face=255,.depth=-INFINITY};if(!observer(observer_context,&event))return false;}continue;}
122:   if(!aa_charge(w,AA_FINAL_SHADE,76))return false;
158:  if(!aa_select(w))return false;
159:  static const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
160:  for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned n=rows*240;if(!aa_charge(w,AA_CONTROL,1)||!aa_charge(w,AA_HDR_CLEAR,3*n))return false;memset(w->reuse.hdr,0,n*3*sizeof(double));
161:   for(unsigned sample=0;sample<4;sample++)if(!aa_charge(w,AA_CONTROL,1)||!aa_geometry(s,w,y,rows,dx[sample],dy[sample])||!aa_shade_final(s,w,&scene,y,rows,sample,dx[sample],dy[sample],shader,context,observer,observer_context))return false;
162:   if(!aa_guard(w,AA_FINAL_OUTPUT_SCAN,n))return false;
163:   for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_OUTPUT_SCAN]++;w->report.observed_total++;if(aa_target(w,y*240+at)){
164:    if(!aa_charge(w,AA_FINAL_ENCODE,8))return false;unsigned q[3];for(unsigned k=0;k<3;k++){double mean=w->reuse.hdr[at][k]/4;float value=ayatsuri_srgb_encode((float)fmin(1,mean));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
165:    rgb[y*240+at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
166:   }}
167:  }

## product/main/ayatsuri/ayatsuri_shade.h
SHA256 8e83a2573fbe17a3bb74589ed3713554cdfe2078790962d68a525b86dbab977e

45: /* Explicit sRGB transfer functions; no fitted gains or per-image normalization. */
46: static inline float ayatsuri_srgb_decode(float x){return x<=.04045f?x/12.92f:powf((x+.055f)/1.055f,2.4f);}
47: static inline float ayatsuri_srgb_encode(float x){return x<=.0031308f?12.92f*x:1.055f*powf(x,1.0f/2.4f)-.055f;}
48: static inline unsigned ayatsuri_shade_linear_channel(float encoded,float light,float tint,float front,float spec,float back,float thin,const float *m,unsigned max){
49:     float v=ayatsuri_srgb_decode(encoded)*(m[0]+m[1]*front*light)+light*(m[2]*spec+m[4]*thin*back*tint);
50:     if(v<0)v=0;if(v>1)v=1;
51:     return (unsigned)lroundf(ayatsuri_srgb_encode(v)*(float)max);

## product/tools/ayatsuri/asset/import_glb.cjs
SHA256 c038e9e4f27605cbdf54be461c78602d937450a8093e96fa138dd6ef47a17bee

82:   keys(g,['asset','scene','scenes','nodes','meshes','buffers','bufferViews','accessors','materials','skins','animations','cameras','images','textures','samplers','extensionsUsed','extensionsRequired','extensions','extras'],'root');extensions(g,'root');
83:   for(const k of ['extensionsUsed','extensionsRequired','skins','animations','cameras','images','textures','samplers'])if(own(g,k))check(Array.isArray(g[k])&&g[k].length===0,k,'unsupported content','UNSUPPORTED');
125:   const materials=mats.map((m,i)=>{const p=`materials/${i}`;keys(m,['name','pbrMetallicRoughness','normalTexture','occlusionTexture','emissiveTexture','emissiveFactor','alphaMode','alphaCutoff','doubleSided','extensions','extras'],p);extensions(m,p);
126:     for(const k of ['normalTexture','occlusionTexture','emissiveTexture','alphaCutoff'])check(!own(m,k),p+'/'+k,'unsupported material feature','UNSUPPORTED');
127:     check(m.alphaMode===undefined||m.alphaMode==='OPAQUE',p+'/alphaMode','alpha unsupported','UNSUPPORTED');check(m.doubleSided===undefined||typeof m.doubleSided==='boolean',p+'/doubleSided','boolean required');
128:     if(m.emissiveFactor!==undefined)check(vector(m.emissiveFactor,3,p+'/emissiveFactor').every(x=>x===0),p+'/emissiveFactor','emission unsupported','UNSUPPORTED');
129:     const pb=m.pbrMetallicRoughness===undefined?{}:m.pbrMetallicRoughness;keys(pb,['baseColorFactor','metallicFactor','roughnessFactor','baseColorTexture','metallicRoughnessTexture','extensions','extras'],p+'/pbrMetallicRoughness');extensions(pb,p+'/pbrMetallicRoughness');
130:     check(!own(pb,'baseColorTexture')&&!own(pb,'metallicRoughnessTexture'),p,'textures unsupported','UNSUPPORTED');const color=vector(pb.baseColorFactor===undefined?[1,1,1,1]:pb.baseColorFactor,4,p+'/baseColorFactor').slice();
131:     check(color.every(x=>x>=0&&x<=1)&&color[3]===1,p+'/baseColorFactor','opaque unit color required','UNSUPPORTED');
132:     const metallic=finite(pb.metallicFactor===undefined?1:pb.metallicFactor,p+'/metallicFactor'),roughness=finite(pb.roughnessFactor===undefined?1:pb.roughnessFactor,p+'/roughnessFactor');check(metallic>=0&&metallic<=1&&roughness>=0&&roughness<=1,p,'PBR factor range');
133:     return {stableId:`material/${i}`,name:name(m,p,limits),baseColor:color,sourceProperties:{metallicFactor:metallic,roughnessFactor:roughness},extras:m.extras??null,...(m.doubleSided===true?{sidedness:'double'}:{})};});
176:   return canonicalZeros({schema:sided?'hone-scene-ir-v2':'hone-scene-ir-v1',source:{format:'glb2',sha256:createHash('sha256').update(bytes).digest('hex'),byteLength:bytes.length,basis:[1,0,0,0,-1,0,0,0,1],units:'metres',generator:g.asset.generator??null},nodes,surfaces,materials,
177:     diagnostics:[],limits,counts:{vertices:totalV,triangles:totalT,surfaces:surfaceCount,decodedNumericBytes:decoded},defaultMaterial:{baseColor:[1,1,1,1],metallicFactor:1,roughnessFactor:1,...(sided?{sidedness:'single'}:{})}});

## product/tools/ayatsuri/asset/compile_static.cjs
SHA256 543adbb7b7eb9c1170865592e6768b66319c53db2c6968dd28227b1f79a43212

24:   const m=materials?.[p.materialId];
25:   if(!m||!Array.isArray(m.hone)||m.hone.length!==11||!Number.isInteger(m.albedo565)||m.albedo565<0||m.albedo565>65535)throw Error('MATERIAL_MAPPING_REQUIRED');
26:   return {...root,index:i+1,name:'part-'+i,parent:0,kind:'gouraudMesh',materialSidedness:p.materialSidedness,
27:    material:m.hone.slice(),color:0xffffff,thickness:1,opacity:1,edgeSoftness:0,
28:    mesh:{vertices:p.positions.flat().map(v=>v*scale),normals:p.normals.flat(),indices:p.triangles.flat(),mask:p.positions.map(()=>-1),holes:[],order:'authored',albedoA:m.albedo565,albedoB:m.albedo565,thickness:255}};

## background/BYTE_PROOF.json
SHA256 63ecbfd786cc1ea9b819f48f1a522abea1e0840fb67d2f695997f23140573300

1: {
2:   "base": "fox-v3-boundary-rho-affine-core-A/SOURCE_FREEZE.json",
3:   "unchangedProductionFiles": {
