// Private source asset semantics. Never part of the generic candidate.
'use strict';
globalThis.FoxControls = {create(commit) {
  const names=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure'];
  const low=[0,0,0,-1,-1,0,0,0,-1], high=[1,1,1,1,1,2,1,1,1], defaults=[0,0,0,0,0,0,1,.5,0];
  return AyatsuriControls.create(names.map((name,i)=>({name,min:low[i],max:high[i],value:defaults[i],integer:i===5||i===6})),commit);
}};
