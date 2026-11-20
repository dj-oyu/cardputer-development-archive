'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const [runtime, source, output] = process.argv.slice(2);
if (![runtime, source, output].every(Boolean)) throw Error('usage: pack_scene.cjs <runtime> <opaque.glb> <output.aynm>');
const asset = path.resolve(runtime, 'tools/ayatsuri/asset');
const {importGlb} = require(path.join(asset, 'import_glb.cjs'));
const {compileStatic} = require(path.join(asset, 'compile_static.cjs'));
const rgbaTo565 = ([r,g,b]) => (Math.round(r*31)<<11)|(Math.round(g*63)<<5)|Math.round(b*31);
const src=fs.readFileSync(source);
const ir=importGlb(src);
const scopeBySurface=new Map(ir.surfaces.map(s=>[s.stableId,s.stableId]));
const materials=Object.fromEntries([...ir.materials,{stableId:'default',baseColor:ir.defaultMaterial.baseColor}].map(m=>[m.stableId,{
 albedo565:rgbaTo565(m.baseColor), hone:[0.78,0.22,0,16,0,1,1,1,1,1,1]
}]));
const {bytes,parts,manifest}=compileStatic(ir,{scopeBySurface,materials,scale:1});
const lo=[Infinity,Infinity,Infinity],hi=[-Infinity,-Infinity,-Infinity];
for(const s of ir.surfaces) for(const p of s.positions) for(let k=0;k<3;k++){lo[k]=Math.min(lo[k],p[k]);hi[k]=Math.max(hi[k],p[k]);}
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
fs.writeFileSync(output,bytes,{flag:'wx'});
console.log(JSON.stringify({coordinateSystem:'GLTF X; negative GLTF Y (down); GLTF Z',bounds:[lo,hi],sourceSHA256:hash(src),aynmSHA256:hash(bytes),
 vertices:ir.counts.vertices,triangles:ir.counts.triangles,parts:parts.length,sidedParts:manifest.nodes.filter(n=>n.materialSidedness==='double').length,
 coldBytes:bytes.length,materials:ir.materials.map(m=>({name:m.name,albedo565:materials[m.stableId].albedo565}))},null,2));
