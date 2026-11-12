'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const {adapt,main}=require('./glb_to_fixed_input.cjs');
const root=path.resolve(process.argv[2]||'fox-v3-floor-direct-reflection-evaluation/actual-002');
const importer=root+'/product/tools/ayatsuri/asset/import_glb.cjs',batcher=root+'/product/tools/ayatsuri/asset/compact_opaque/batch_static.cjs';
const {importGlb}=require(importer),{batchStaticSurfaces}=require(batcher);let passed=0;
function test(name,f){f();passed++;console.log('PASS '+name);}
function fixture(change=()=>{}){
 const bin=Buffer.alloc(72);[0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,1].forEach((v,i)=>bin.writeFloatLE(v,i*4));
 const g={asset:{version:'2.0'},scene:0,scenes:[{nodes:[0]}],nodes:[{mesh:0}],meshes:[{primitives:[{attributes:{POSITION:0,NORMAL:1},material:0}]}],buffers:[{byteLength:72}],bufferViews:[{buffer:0,byteOffset:0,byteLength:36},{buffer:0,byteOffset:36,byteLength:36}],accessors:[{bufferView:0,componentType:5126,count:3,type:'VEC3',min:[0,0,0],max:[1,1,0]},{bufferView:1,componentType:5126,count:3,type:'VEC3'}],materials:[{pbrMetallicRoughness:{baseColorFactor:[.25,.5,1,1]}}]};change(g);
 let j=Buffer.from(JSON.stringify(g));j=Buffer.concat([j,Buffer.alloc((4-j.length%4)%4,32)]);const b=Buffer.alloc(28+j.length+bin.length);b.writeUInt32LE(0x46546c67);b.writeUInt32LE(2,4);b.writeUInt32LE(b.length,8);b.writeUInt32LE(j.length,12);b.writeUInt32LE(0x4e4f534a,16);j.copy(b,20);b.writeUInt32LE(bin.length,20+j.length);b.writeUInt32LE(0x004e4942,24+j.length);bin.copy(b,28+j.length);return b;
}
const run=(b,s={albedoScale:1})=>adapt(importGlb(b),s,batchStaticSurfaces);
test('single-sided v1 with explicit native metre contract',()=>{const a=run(fixture());assert.equal(a.parts[0].materialSidedness,'single');assert.deepEqual(a.parts[0].positions,[[0,0,0],[0,-1,0],[1,0,0]]);assert.equal(a.geometry_scale,1);assert.deepEqual(a.materialTrace,[{id:'material/0',scaledLinear:[.25,.5,1]}]);});
test('double-sided v2 unchanged',()=>assert.equal(run(fixture(g=>g.materials[0].doubleSided=true)).parts[0].materialSidedness,'double'));
test('explicit zero and half albedo scale',()=>{assert.deepEqual(run(fixture(),{albedoScale:0}).materialTrace[0].scaledLinear,[0,0,0]);assert.deepEqual(run(fixture(),{albedoScale:.5}).materialTrace[0].scaledLinear,[.125,.25,.5]);});
test('missing, negative, NaN and infinite scale rejected',()=>{for(const albedoScale of [undefined,-1,NaN,Infinity,'1'])assert.throws(()=>run(fixture(),{albedoScale}),/EXPLICIT_ALBEDO_SCALE_REQUIRED/);});
test('scaled albedo out of unit interval rejected',()=>assert.throws(()=>run(fixture(),{albedoScale:2}),/ALBEDO_RANGE/));
test('morphs, animation and skins stay unsupported',()=>{assert.throws(()=>run(fixture(g=>g.meshes[0].primitives[0].targets=[])),/morph unsupported/);for(const key of ['animations','skins'])assert.throws(()=>run(fixture(g=>g[key]=[{}])),/unsupported content/);});
test('unmapped default material stays rejected like current wrapper',()=>assert.throws(()=>run(fixture(g=>delete g.meshes[0].primitives[0].material)),/MATERIAL_MAPPING_REQUIRED/));
test('invalid source unit metadata rejected',()=>{const ir=importGlb(fixture());ir.source.units='centimetres';assert.throws(()=>adapt(ir,{albedoScale:1},batchStaticSurfaces),/UNSUPPORTED_SOURCE_UNITS_OR_BASIS/);});
test('negative-scale geometry and normals stay importer-defined',()=>{const ir=importGlb(fixture(g=>g.nodes[0].scale=[-2,3,4])),a=adapt(ir,{albedoScale:1},batchStaticSurfaces);assert.deepEqual(a.parts[0].positions,ir.surfaces[0].positions);assert.deepEqual(a.parts[0].triangles,ir.surfaces[0].triangles);assert.deepEqual(a.parts[0].normals,ir.surfaces[0].normals);});
test('actual old parts and pre-RGB565 linear colors exactly match',()=>{const old=JSON.parse(fs.readFileSync(root+'/compiled/model-baseline/compile.json')),a=JSON.parse(fs.readFileSync(__dirname+'/private-fixed-source.json'));assert.deepEqual(a.parts,old.parts);assert.deepEqual(a.materialTrace,old.materialTrace.map(m=>({id:m.id,scaledLinear:m.scaledLinear})));assert.equal(a.parts.reduce((n,p)=>n+p.triangles.length,0),1564);});
test('CLI hash checking and exclusive no-overwrite output',()=>{const d=fs.mkdtempSync(__dirname+'/test-private-'),b=fixture();fs.writeFileSync(d+'/in.glb',b);fs.writeFileSync(d+'/scenario.json','{"albedoScale":1}');const h=crypto.createHash('sha256').update(b).digest('hex');const args=['--importer',importer,'--batcher',batcher,'--source',d+'/in.glb','--source-sha256',h,'--scenario',d+'/scenario.json','--output',d+'/out.json'];const wrong=args.slice();wrong[7]='0'.repeat(64);assert.throws(()=>main(wrong),/SOURCE_HASH_MISMATCH/);assert.equal(fs.existsSync(d+'/out.json'),false);main(args);const before=fs.readFileSync(d+'/out.json');assert.throws(()=>main(args),e=>e.code==='EEXIST');assert.deepEqual(fs.readFileSync(d+'/out.json'),before);});
console.log(JSON.stringify({passed}));
