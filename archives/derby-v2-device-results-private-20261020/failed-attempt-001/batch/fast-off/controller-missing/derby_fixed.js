'use strict';
// DF fixture oval-pan8-390-510-v1: three dependent replays in one boot.
const dfFrame=globalThis.frame;
let dfRep=1,dfMode=0,dfTicks=0,dfTailTicks=0,dfNext=391;
function dfAbort() { S.fixture(4,0,0,0,0,0,0); pocket.app.exit(); }
function dfIdentity() {
  if (F.seed!==0x9112A7AB || !F.o || tier!==1 || cm!==8) throw Error('DF_IDENTITY');
}
globalThis.frame=function(b) {
  try {
    if (b || K.down().length || GK.some(k=>K.pressed(k))) return dfAbort();
    if (dfMode===0) {
      if (S.fixture(0,0,0,0,0,0,0)===6) return pocket.app.exit();
      drop(Object.keys(live));queue.length=0;
      pts=1500;raceNo=1000001;sn=19;tier=1;pick=0;stake=100;
      dm=0;idle=1e20;fe=-1e9;notes=[];A=null;enter('pad');
      if(F.seed!==0x9112A7AB||!F.o)throw Error('DF_SEED');
      dfTicks=0;dfTailTicks=0;dfNext=391;dfMode=1;
    }
    if(dfMode===1) {
      if(++dfTicks>800)throw Error('DF_WARMUP_LIMIT');
      dfFrame(0);
      if(scene==='pad'&&t>=20&&!queue.length)enter('gate');
      if(scene==='race'&&rnd(rs.t/DT)===390) {
        dfIdentity();if(queue.length)throw Error('DF_LOAD');
        S.fixture(1,dfRep,390,F.seed,cm,tier,0);dfMode=2;
      }
      return;
    }
    if(dfMode===2) {
      dfFrame(0);dfIdentity();
      if(scene!=='race'||rnd(rs.t/DT)!==dfNext||slow||disp!==0)throw Error('DF_STEP');
      S.fixture(2,dfRep,dfNext,F.seed,cm,tier,0);
      if(dfNext++===510)dfMode=3;
      return;
    }
    if(dfMode===3) {
      if(S.fixture(0,0,0,0,0,0,0)!==4)throw Error('DF_BOUNDARY');
      // DF bounded tail: return from this logical frame, not a VM continuation.
      // Same step order/DT/terminal predicate as settle(), outside measurement.
      // No dfFrame(), paint or capture; settlement runs once after its loop ends.
      if(++dfTailTicks>512)throw Error('DF_TAIL_LIMIT');
      for(let n=0;n<8&&rs.done<8&&rs.t<200;n++)step(F,rs,DT);
      if(rs.done<8&&rs.t<200)return;
      settle();
      const text=fin.o.map(i=>i+1).join(',')+'|'+fin.o.map(i=>rnd(rs.tc[i]*1e6)).join(',');
      let digest=2166136261;
      for(let i=0;i<text.length;i++)digest=M.imul(digest^text.charCodeAt(i),16777619)>>>0;
      if(digest!==0x5DC86E18)throw Error('DF_FINISH');
      S.fixture(3,dfRep,510,F.seed,cm,tier,digest);
      if(++dfRep>3){dfMode=4;pocket.app.exit();}else dfMode=0;
    }
  } catch(e) { dfAbort(); }
};
