'use strict';
function check(v, message) {if (!v) throw Error(message);}
function rejects(f) {let threw = false; try { f(); } catch (_) {threw = true;} check(threw, 'expected rejection');}
const controls = FoxControls.create(privateModelBackend.commit);
const motion = controls.motion([0,0,0,0, 1000,1,1,-1],
  ['time','Blink Both','Gaze X','Gaze Up'], {timeUnit:'ms', interpolation:'linear'});
const initial = motion.evaluate(0), half = motion.evaluate(500), closed = motion.evaluate(1000);
check(initial !== half && half !== closed, 'controls must change actual image');
check(motion.evaluate(500) === half, 'reverse');
check(motion.evaluate(500) === half, 'pause');
check(motion.evaluate(0) === initial, 'repeat');
for (let i=0;i<3;i++) {
  check(motion.evaluate(1000) === closed, 'closed repeat');
  check(motion.evaluate(0) === initial, 'open repeat');
}
const before = JSON.stringify(controls.state());
for (const patch of [{'Blink Both':NaN},{'Blink Both':Infinity},{'Blink Both':-1},
    {'Blink Both':1.1},{'Gaze X':2},{'Eye Style':.5},{'Eye Style':3},
    {'Smile':1},{'Show Highlights':2},{'Environment Reflection':-1},
    {'Bubble Pressure':2},{'Blink Both':.5,'Gaze Up':NaN}]) {
  rejects(() => controls.update(patch));
  check(JSON.stringify(controls.state()) === before, 'JS rollback');
  check(privateModelBackend.hash() === initial, 'native rendered image rollback');
}
rejects(() => motion.evaluate(NaN));
rejects(() => motion.evaluate(Infinity));
rejects(() => controls.update({'Blink Both':.5, get 'Gaze X'(){throw Error('getter');}}));
rejects(() => controls.update({get 'Blink Both'(){controls.update({'Blink Both':1});return .5;}}));
check(privateModelBackend.hash() === initial, 'getter/reentrant rollback');
const smooth = controls.motion([0,0, 1000,1], ['time','Blink Both'], {timeUnit:'ms',interpolation:'smooth'});
const smoothQuarter = smooth.evaluate(250);
check(smoothQuarter === controls.update({'Blink Both':.15625}), 'real smooth interpolation');
const styles = controls.motion([0,0, 1000,2], ['time','Eye Style'], {timeUnit:'ms',interpolation:'step'});
styles.evaluate(500);check(controls.state()[5] === 0, 'step initial');
styles.evaluate(1000);check(controls.state()[5] === 2, 'step endpoint');
controls.update({'Blink Both':0,'Eye Style':0});
check(privateModelBackend.hash() === initial, 'recovery');
const fractional = controls.update({'Blink Both':.01});
check(controls.state()[0] === .01, 'fractional control accepted; camera3 may quantize to neutral');
controls.update({'Blink Both':.98});check(privateModelBackend.hidden() === 6, 'source hide_render threshold');
controls.update({'Blink Both':.979});check(privateModelBackend.hidden() === 0, 'source visible below threshold');
controls.update({'Blink Both':0});check(privateModelBackend.hash() === initial, 'final recovery');
print('PASS QuickJS actual AyatsuriMotion -> private native snapshot -> source color/alpha raster; linear/smooth/step, pause/reverse/repeat, rollback/recovery');
for(let time=0;time<=1000;time+=125) {
  privateModelBackend.testmode(100+time/125);
  print('FOX_CONTROL_SWEEP time_ms='+time+' hash='+motion.evaluate(time).toString(16));
}
motion.evaluate(0);
const linearStyles=controls.motion([0,0, 1000,1],['time','Eye Style'],{timeUnit:'ms',interpolation:'linear'});
rejects(()=>linearStyles.evaluate(500));
check(controls.state()[5]===0&&privateModelBackend.hash()===initial,'fractional style motion rollback');
print('PASS nine-time continuous rendered sweep and rejected fractional style motion');
const mutableNames=['time','Blink Both'], mutableKeys=[0,0,1000,1];
const ownedMotion=controls.motion(mutableKeys,mutableNames,{timeUnit:'ms'});
mutableNames[1]='Smile';mutableKeys[3]=NaN;
check(ownedMotion.evaluate(500)===controls.update({'Blink Both':.5}),'owned keys/channel copy');
const beforeGetter=privateModelBackend.hash();
rejects(()=>controls.motion([0,0,1000,1],['time',getSourceName()],{timeUnit:'ms'}));
function getSourceName(){return 'invalid';}
const evilKeys=[0,0,1000,1];Object.defineProperty(evilKeys,3,{get(){controls.update({'Blink Both':1});return 1;}});
rejects(()=>controls.motion(evilKeys,['time','Blink Both'],{timeUnit:'ms'}));
check(privateModelBackend.hash()===beforeGetter,'sampling-key reentrancy rollback');
controls.update({'Blink Both':0});
print('PASS immutable owned keys/channels and construction getter reentrancy rollback');
const nativeBefore=privateModelBackend.hash();
for(const bad of [[],new Float32Array(9),new Float64Array(8),new Float64Array(10)]) rejects(()=>privateModelBackend.commit(bad));
for(const [index,value] of [[0,1+Number.EPSILON],[3,Infinity],[5,1.000000001],[6,.5]]) {
 const packet=new Float64Array([0,0,0,0,0,0,1,.5,0]);packet[index]=value;
 rejects(()=>privateModelBackend.commit(packet));check(privateModelBackend.hash()===nativeBefore,'native strict validation rollback');
}
print('PASS direct native type/length/nonfinite/domain/integer validation before float narrowing');

const retained=privateModelBackend.hash(), retainedState=JSON.stringify(controls.state());
privateModelBackend.testmode(2);
rejects(()=>controls.update({'Blink Both':.4}));
check(privateModelBackend.testmode(4)===2,'unknown submit retains both outstanding strips');
check(privateModelBackend.hash()===retained&&JSON.stringify(controls.state())===retainedState,'late failure retains JS state and native hash');
privateModelBackend.testmode(5);privateModelBackend.testmode(0);
privateModelBackend.testmode(3);
rejects(()=>controls.update({'Blink Both':.4}));
check(privateModelBackend.testmode(4)===2,'exhaustion retains outstanding strips');
check(privateModelBackend.hash()===retained,'exhaustion rollback');
privateModelBackend.testmode(5);privateModelBackend.testmode(0);
privateModelBackend.testmode(1);controls.update({'Blink Both':.4});
check(privateModelBackend.testmode(4)===0,'inline exact retirement');
privateModelBackend.testmode(0);controls.update({'Blink Both':0});
privateModelBackend.testmode(7);
rejects(()=>controls.update({'Blink Both':.4}));
check(privateModelBackend.testmode(4)===1,'close with in-flight transport preserves borrow');
rejects(()=>controls.update({'Blink Both':.6}));
check(privateModelBackend.testmode(4)===1,'closed backend rejects new work');
privateModelBackend.testmode(5);
check(privateModelBackend.testmode(6)===1,'drained after completion');
print('PASS composed late failure, exhaustion, inline, close in-flight, reject after disposal; synchronous JS rollback');
