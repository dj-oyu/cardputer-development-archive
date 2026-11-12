'use strict';
// Offline static adapter. No AYNM packing, RGB565 encoding, or runtime mutation.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
function adapt(ir,scenario,batchStaticSurfaces){
 if(!scenario||typeof scenario.albedoScale!=='number'||!Number.isFinite(scenario.albedoScale)||scenario.albedoScale<0)throw Error('EXPLICIT_ALBEDO_SCALE_REQUIRED');
 if(!ir||!['hone-scene-ir-v1','hone-scene-ir-v2'].includes(ir.schema)||!Array.isArray(ir.materials)||!Array.isArray(ir.surfaces))throw Error('INVALID_IR');
 if(ir.source?.units!=='metres'||JSON.stringify(ir.source.basis)!=='[1,0,0,0,-1,0,0,0,1]')throw Error('UNSUPPORTED_SOURCE_UNITS_OR_BASIS');
 const ids=new Set(),traces=[];
 const sideById=new Map(ir.materials.map(m=>{
  if(typeof m.stableId!=='string'||!m.stableId||ids.has(m.stableId))throw Error('INVALID_MATERIAL_ID');ids.add(m.stableId);
  if(ir.schema==='hone-scene-ir-v1'&&m.sidedness!==undefined)throw Error('SIDEDNESS_REQUIRES_IR_V2');
  const side=ir.schema==='hone-scene-ir-v1'?'single':m.sidedness;
  if(!['single','double'].includes(side))throw Error('MISSING_MATERIAL_SIDEDNESS');
  if(!Array.isArray(m.baseColor)||m.baseColor.length!==4||m.baseColor[3]!==1||m.baseColor.some(x=>typeof x!=='number'||!Number.isFinite(x)||x<0||x>1))throw Error('INVALID_LINEAR_MATERIAL');
  const scaledLinear=m.baseColor.slice(0,3).map(x=>x*scenario.albedoScale);
  if(scaledLinear.some(x=>!Number.isFinite(x)||x<0||x>1))throw Error('ALBEDO_RANGE');
  traces.push({id:m.stableId,scaledLinear});return [m.stableId,side];
 }));
 // Match current compileStatic sidedness mapping and preserve original ordering.
 const surfaces=ir.surfaces.map(s=>{
  const id=s.materialId??'default',side=s.materialId===null?(ir.schema==='hone-scene-ir-v1'?'single':ir.defaultMaterial?.sidedness):sideById.get(id);
  if(!side)throw Error('UNKNOWN_MATERIAL');
  // Current wrapper supplies mappings only for explicit GLB materials.
  if(!ids.has(id))throw Error('MATERIAL_MAPPING_REQUIRED');
  return {...s,materialId:id,materialSidedness:side};
 });
 const scopeBySurface=new Map(surfaces.map(s=>[s.stableId,'fixed-static-scene']));
 const parts=batchStaticSurfaces(surfaces,{scopeBySurface,preserveOrder:true});
 return {schema:'ayatsuri-fixed-static-input-v1',coordinate_system:'ayatsuri-native-metres',source_units:'metres',geometry_scale:1,source_mode:'baked-static',parts,materialTrace:traces};
}
function main(argv){
 const flags=['importer','batcher','source','source-sha256','scenario','output'],o={};
 for(let i=0;i<argv.length;i+=2){const k=argv[i]?.slice(2);if(!argv[i]?.startsWith('--')||!flags.includes(k)||o[k]!==undefined||!argv[i+1])throw Error('INVALID_ARGUMENTS');o[k]=argv[i+1];}
 if(flags.some(k=>o[k]===undefined))throw Error('Required: '+flags.map(k=>'--'+k+' VALUE').join(' '));
 if(!/^[a-f0-9]{64}$/.test(o['source-sha256']))throw Error('INVALID_EXPECTED_SOURCE_SHA256');
 // CLI module paths identify trusted local code; never take executable paths from GLB/scenario.
 const importerPath=path.resolve(o.importer),batcherPath=path.resolve(o.batcher),sourcePath=path.resolve(o.source),scenarioPath=path.resolve(o.scenario);
 const source=fs.readFileSync(sourcePath),scenarioBytes=fs.readFileSync(scenarioPath),hash=sha(source);
 if(hash!==o['source-sha256'])throw Error('SOURCE_HASH_MISMATCH');
 const importerBytes=fs.readFileSync(importerPath),batcherBytes=fs.readFileSync(batcherPath);
 const {importGlb}=require(importerPath),{batchStaticSurfaces}=require(batcherPath);
 if(typeof importGlb!=='function'||typeof batchStaticSurfaces!=='function')throw Error('INVALID_MODULE_EXPORTS');
 const scenario=JSON.parse(scenarioBytes),ir=importGlb(source),result=adapt(ir,scenario,batchStaticSurfaces);
 if(ir.source.sha256!==hash)throw Error('IMPORTER_SOURCE_HASH_MISMATCH');
 result.provenance={adapter_schema:'glb-to-fixed-input-adapter-v1',source_sha256:hash,source_byte_length:source.length,source_file:path.basename(sourcePath),importer_sha256:sha(importerBytes),batcher_sha256:sha(batcherBytes),adapter_sha256:sha(fs.readFileSync(__filename)),scenario_sha256:sha(scenarioBytes),scenario:{albedoScale:scenario.albedoScale},imported_source:ir.source,imported_counts:ir.counts};
 fs.writeFileSync(o.output,JSON.stringify(result,null,2)+'\n',{flag:'wx'});
 return result;
}
if(require.main===module){try{const r=main(process.argv.slice(2));console.log(JSON.stringify({schema:r.schema,parts:r.parts.length,source_sha256:r.provenance.source_sha256}));}catch(e){console.error(e.code||e.message);process.exitCode=1;}}
module.exports={adapt,main};
