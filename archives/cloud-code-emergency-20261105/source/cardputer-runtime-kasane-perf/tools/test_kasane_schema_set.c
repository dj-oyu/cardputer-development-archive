/* Real QuickJS -> view.set -> schema regression; no fault injection.
 * Build with TEST_SOURCE=tools/test_kasane_schema_set.c and
 * CFLAGS='-O2 -g -fsanitize=address,undefined -DKSN_SCHEMA_DIRTY_COUNT'
 * via tools/build_kasane_test.sh. Keep CACHE/OUT distinct from other jobs. */
#define main kasane_contract_main
#include "test_pocket_kasane.c"
#undef main
#ifndef KSN_SCHEMA_DIRTY_COUNT
#error "This regression requires KSN_SCHEMA_DIRTY_COUNT"
#endif

/* These optional surfaces are unused by mounted-schema tests. */
esp_err_t pocket_grid_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_grid_reset(void){}
bool pocket_grid_pending(void){return false;}
void pocket_grid_present_result(ksn_result r){(void)r;}
void pocket_grid_source_invalidated(uint32_t id){(void)id;}
esp_err_t pocket_video_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_video_reset(void){}
bool pocket_video_pending(void){return false;}
void pocket_video_present_result(ksn_result r){(void)r;}
esp_err_t pocket_pixel_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_pixel_reset(void){}
bool pocket_pixel_pending(void){return false;}
void pocket_pixel_present_result(ksn_result r){(void)r;}

static bool settle(void){
    ksn_render_stats stats;bool blocked=true;
    return present(&stats)==KSN_OK&&
        pocket_kasane_presenter_step(&blocked)==KSN_OK&&!blocked;
}
static void reset_counts(void){
    ksn_schema_descriptor_validations=0;
    ksn_schema_name_comparisons=0;
    ksn_schema_resolved_nodes=0;
}

static void adapter_counts(void){
    pocket_kasane_reset();reset_counts();
    check(run("globalThis.descriptor={version:1,background:0x071425ff,slots:{},nodes:[]};"
              "globalThis.initial={};"
              "for(let i=0;i<24;i++){let key='s'+i,x=4+(i%8)*28,y=4+Math.floor(i/8)*24;"
              "descriptor.slots[key]={type:'color'};initial[key]=0x112233ff;"
              "descriptor.nodes.push({type:'rect',bounds:[x,y,x+20,y+16],color:{slot:key}})}"
              "globalThis.countView=kasane.mount(descriptor,initial);"),
          "24-slot/24-node JS descriptor mounts through the real adapter");
    check(ksn_schema_descriptor_validations>0&&ksn_schema_name_comparisons>=276,
          "mount validates its immutable descriptor including duplicate names");
    check(settle(),"counter fixture initial frame presents and acknowledges");

    reset_counts();
    check(run("countView.set({s0:0xaa5533ff,s23:0x3366bbff})"),
          "two changed slots pass through JS view.set");
    check(ksn_schema_descriptor_validations==0&&ksn_schema_name_comparisons==0,
          "stable JS update does not revalidate the immutable descriptor");
    check(ksn_schema_resolved_nodes==28,
          "JS update still preflights all 24 nodes plus two dirty nodes twice");
    printf("SCHEMA_SET_COUNTER slots=24 nodes=24 changed=2 descriptor_checks=%u name_comparisons=%u resolved_nodes=%u\n",
           (unsigned)ksn_schema_descriptor_validations,
           (unsigned)ksn_schema_name_comparisons,(unsigned)ksn_schema_resolved_nodes);
    check(settle(),"counter fixture PATCH presents and acknowledges");
    memcpy(committed_pixels,panel_pixels,sizeof(panel_pixels));

    reset_counts();
    check(run("countView.set({s0:0xaa5533ff,s23:0x3366bbff})")&&
          !pocket_kasane_has_submission(),"unchanged JS values submit nothing");
    check(!ksn_schema_descriptor_validations&&!ksn_schema_resolved_nodes,
          "unchanged set skips descriptor and draw work");

    check(run("descriptor.slots.s0.type='text';descriptor.slots.s0.capacity=1;"
              "descriptor.nodes[0].bounds[2]=-1;descriptor.nodes.length=0;"
              "Object.defineProperty(descriptor,'slots',{get(){throw Error('reread')}});"
              "countView.set({s0:0x112233ff});countView.set({s0:0xaa5533ff});"),
          "mutating the original JS declaration cannot mutate the owned descriptor");
    /* The second update arrived while the first was submitted. Drain both. */
    for(unsigned i=0;i<3;i++){
        ksn_render_stats stats;bool blocked=false;
        check(present(&stats)==KSN_OK&&
              pocket_kasane_presenter_step(&blocked)==KSN_OK,
              "pending changed values drain after JS declaration mutation");
    }
    check(memcmp(committed_pixels,panel_pixels,sizeof(panel_pixels))==0,
          "owned descriptor preserves every pixel after JS declaration mutation");

    pocket_kasane_reset();
    check(run("globalThis.referenceNodes=[];"
              "for(let i=0;i<24;i++){let x=4+(i%8)*28,y=4+Math.floor(i/8)*24;"
              "referenceNodes.push({type:'rect',bounds:[x,y,x+20,y+16],"
              "color:i===0?0xaa5533ff:i===23?0x3366bbff:0x112233ff})}"
              "globalThis.referenceView=kasane.mount({version:1,background:0x071425ff,"
              "slots:{},nodes:referenceNodes});"),
          "independent literal descriptor supplies a full-render reference");
    bool blocked=false;
    check(pocket_kasane_presenter_step(&blocked)==KSN_OK&&blocked&&settle(),
          "full-render reference presents");
    check(memcmp(committed_pixels,panel_pixels,sizeof(panel_pixels))==0,
          "JS two-slot PATCH matches full rendering for all 32400 pixels");
}

static void candidate_safety(void){
    pocket_kasane_reset();
    check(run("globalThis.safeView=kasane.mount({version:1,backgroundSlot:'bg',"
              "slots:{label:{type:'text',capacity:8},show:{type:'bool'},"
              "page:{type:'u16',maximum:2},reveal:{type:'u16',maximum:8},"
              "extent:{type:'u16'},bg:{type:'color'}},nodes:["
              "{type:'text',bounds:[4,4,80,16],text:{slot:'label'},color:0xffffffff,"
              "visible:{slot:'show'},reveal:{slot:'reveal'}},"
              "{type:'rect',bounds:[8,30,8,34],rectAdd:[null,null,'extent',null],"
              "page:{slot:'page'},pageEquals:1,color:0x78c8ffff}]},"
              "{label:'ABC',show:true,page:0,reveal:3,extent:65535,bg:0x071425ff});"
              "function rejectSet(values){let rejected=false;try{safeView.set(values)}"
              "catch(e){rejected=true}if(!rejected)throw Error('invalid set accepted')}"),
          "hidden geometry remains legal until its page becomes visible");
    check(settle(),"candidate safety initial frame presents");
    memcpy(committed_pixels,panel_pixels,sizeof(panel_pixels));reset_counts();
    check(run("rejectSet({label:'BAD',bg:0x01020380});"
              "rejectSet({label:'BAD',reveal:4});"
              "rejectSet({label:'BAD',reveal:9});"
              "rejectSet({label:'BAD',page:1});"
              "rejectSet({label:'BAD',page:3});"
              "rejectSet({label:'A\\n'});rejectSet({label:'\\ud800'});"
              "rejectSet({label:'123456789'});rejectSet({label:'BAD',unknown:true});"
              "safeView.set({label:'ABC',bg:0x071425ff,reveal:3,page:0});"),
          "alpha, derived geometry/reveal, numeric, UTF-8 and text bounds still reject atomically");
    check(!pocket_kasane_has_submission()&&settle()&&
          memcmp(committed_pixels,panel_pixels,sizeof(panel_pixels))==0,
          "rejected partial sets preserve values, submission state and pixels");
    check(ksn_schema_descriptor_validations==0,
          "rejected candidates use value/draw checks without descriptor revalidation");
    check(run("safeView.set({show:false,page:1,extent:20})")&&settle(),
          "valid visibility/page/geometry changes still replace topology");
    check(memcmp(committed_pixels,panel_pixels,sizeof(panel_pixels))!=0,
          "visibility and page changes alter the rendered scene");
    check(run("safeView.set({show:true,page:0})")&&settle()&&
          memcmp(committed_pixels,panel_pixels,sizeof(panel_pixels))==0,
          "restored visibility/page returns to the exact original pixels");
}

int main(void){
    /* Reuse fixture utilities without invoking its allocation/I/O fault suites. */
    rt=JS_NewRuntime();ctx=rt?JS_NewContext(rt):NULL;host_capabilities_clear();
    check(ctx&&pocket_kasane_install(ctx,NULL)==ESP_OK,"schema-set fixture opens");
    if(!ctx)return 1;
    app_presenter_tests();
    adapter_counts();candidate_safety();
    pocket_kasane_reset();JS_FreeContext(ctx);JS_FreeRuntime(rt);ctx=NULL;rt=NULL;
    check(ksn_runtime_shutdown()==KSN_OK,"schema-set fixture shuts down");
    printf("%s\n",failures?"SCHEMA SET TEST FAIL":"SCHEMA SET TEST PASS");
    return failures?1:0;
}
