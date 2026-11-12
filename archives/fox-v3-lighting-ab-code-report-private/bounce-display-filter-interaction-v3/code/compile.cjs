'use strict';
const fs=require('fs'),path=require('path');
const {importGlb}=require('../product/tools/ayatsuri/asset/import_glb.cjs');
const {compileStatic}=require('../product/tools/ayatsuri/asset/compile_static.cjs');
const [input,param,out]=process.argv.slice(2);const s=JSON.parse(fs.readFileSync(param));const ir=importGlb(fs.readFileSync(input));
const srgb=x=>x<=.0031308?12.92*x:1.055*x**(1/2.4)-.055;
const materials={},trace=[];
for(const m of ir.materials){const linear=m.baseColor.slice(0,3).map(x=>x*s.albedoScale);if(linear.some(x=>!Number.isFinite(x)||x<0||x>1))throw Error('albedo range');const encoded=linear.map(srgb),quant=encoded.map((x,i)=>Math.round(x*(i===1?63:31)));const albedo565=(quant[0]<<11)|(quant[1]<<5)|quant[2];materials[m.stableId]={hone:[s.ambient,s.diffuse,0,1,0,1,1,1,0,0,0],albedo565};trace.push({id:m.stableId,name:m.name,sourceLinear:m.baseColor,scaledLinear:linear,encoded,quantized:quant,albedo565,sidedness:m.sidedness});}
const scopeBySurface=new Map(ir.surfaces.map(s=>[s.stableId,'fixed-static-scene']));const result=compileStatic(ir,{scopeBySurface,materials,scale:38});fs.mkdirSync(out,{recursive:false});fs.writeFileSync(path.join(out,'model.aynm'),result.bytes);fs.writeFileSync(path.join(out,'compile.json'),JSON.stringify({sourceTriangles:ir.surfaces.reduce((n,s)=>n+s.triangles.length,0),parts:result.parts,materialTrace:trace,coldBytes:result.bytes.length,scope:'Static fixed pose; exact ordered partition; no reduction by compiler'},null,2));console.log(JSON.stringify({parts:result.parts.length,coldBytes:result.bytes.length}));
