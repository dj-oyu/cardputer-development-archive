#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <assert.h>
#include "generated-v2/preflight.h"
#include "generated-v2/floor_input.h"
#include "generated-v2/background_input.h"
#include "generated-v2/scene_core_input.h"
int main(void){
 for(unsigned i=0;i<20;i++){
  if(i<3){uint64_t h=aa_preflight_rows[i].snapshot;assert(h&&h==floor_input_rows[i].snapshot&&h==fox_bg_inputs[i].snapshot);assert(aa_preflight_lookup(h)==aa_preflight_rows+i);assert(floor_input_lookup(h)==floor_input_rows+i);assert(aa_preflight_targets[i]==2385);assert(floor_input_rows[i].shaders==17070);assert(fox_bg_inputs[i].slots==39555);uint64_t hits[4];for(unsigned j=0;j<4;j++)hits[j]=aa_preflight_rows[i].hits[j];assert(aa_preflight_actual_matches(aa_preflight_rows+i,hits,2385));hits[0]++;assert(!aa_preflight_actual_matches(aa_preflight_rows+i,hits,2385));}
  else assert(!aa_preflight_rows[i].snapshot&&!floor_input_rows[i].snapshot&&!fox_bg_inputs[i].snapshot&&!aa_preflight_targets[i]);
 }
 assert(floor_input_rows[0].hits==70342&&floor_input_rows[1].hits==70342&&floor_input_rows[2].hits==70341);
 assert(!aa_preflight_lookup(UINT64_C(0xffffffffffffffff))&&!floor_input_lookup(UINT64_C(0xffffffffffffffff)));
 assert(fox_scene_mask_hash[0]==UINT64_C(0xdd51bcec009b27b1));
 puts("PASS: three genuine snapshot rows; inactive zeros; count mismatch rejected; unchanged readonly preflight360B; q20 authentic70341 ground hits.");return 0;
}
