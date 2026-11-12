// Optional control companion. No model data, wire-format extension or renderer.
'use strict';
globalThis.AyatsuriControls = (() => {
  function create(metadata, commit) {
    if (!Array.isArray(metadata) || !metadata.length || metadata.length > 256 || typeof commit !== 'function')
      throw new TypeError('control metadata and synchronous commit required');
    const names = [], domains = [], initial = [];
    for (const row of metadata) {
      const {name, min, max, value, integer = false} = row;
      if (typeof name !== 'string' || !name.length || name === 'time' || names.includes(name) ||
          typeof min !== 'number' || !Number.isFinite(min) || typeof max !== 'number' || !Number.isFinite(max) ||
          min > max || typeof integer !== 'boolean') throw new TypeError('invalid control metadata');
      names.push(name); domains.push({min,max,integer}); initial.push(value);
    }
    function validate(v, i) {
      const d = domains[i];
      if (typeof v !== 'number' || !Number.isFinite(v) || v < d.min || v > d.max || (d.integer && !Number.isInteger(v)))
        throw new RangeError('control outside declared domain');
    }
    initial.forEach(validate);
    let values = initial, busy = false, dead = false;
    function guarded(fn) {
      if (busy || dead) throw new Error('control companion busy/disposed');
      busy = true; try {return fn();} finally {busy = false;}
    }
    function apply(patch) {
      if (!patch || typeof patch !== 'object') throw new TypeError('control patch required');
      const next = values.slice();
      for (const key of Object.keys(patch)) {
        const i = names.indexOf(key);
        if (i < 0) throw new TypeError('unknown control');
        const v = patch[key]; validate(v, i); next[i] = v;
      }
      // A fresh packet prevents backend mutation/retention from aliasing state.
      // Backend MUST synchronously validate/build/publish or throw before publish.
      const result = commit(new Float64Array(next));
      values = next;
      return result;
    }
    return {
      update(patch) {return guarded(() => apply(patch));},
      state() {return guarded(() => values.slice());},
      motion(keys, channels, options) {return guarded(() => {
        if (!Array.isArray(channels) || (!Array.isArray(keys) && !(keys instanceof Float32Array)))
          throw new TypeError('keys and channels required');
        const namesCopy = channels.slice(), keysCopy = Array.from(keys);
        if (namesCopy[0] !== 'time' || namesCopy.length < 2 ||
            namesCopy.slice(1).some((n,i,a) => names.indexOf(n) < 0 || a.indexOf(n) !== i))
          throw new TypeError('unique declared channels required');
        const track = AyatsuriMotion.track(keysCopy, Object.assign({}, options, {stride:namesCopy.length,timeColumn:0}));
        const performance = AyatsuriMotion.performance({track,channels:namesCopy});
        return {evaluate(time) {return guarded(() => {
          const sampled = performance.evaluate(time), patch = Object.create(null);
          for (let i=1;i<namesCopy.length;i++) patch[namesCopy[i]]=sampled[namesCopy[i]];
          return apply(patch);
        });}};
      });},
      // Only releases companion use. Backend/frame retirement belongs to owner.
      dispose() {if (dead) return; guarded(() => {dead=true;values=null;commit=null;});}
    };
  }
  return {create};
})();
if(typeof module!=='undefined')module.exports=globalThis.AyatsuriControls;
