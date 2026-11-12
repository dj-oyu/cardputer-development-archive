'use strict';
const fs=require('node:fs'),path=require('node:path');
const {importGlb}=require(process.env.ASSET_IMPORTER);
const {partition}=require(process.env.ASSET_REDUCER);
const {compile}=require(process.env.MODEL_COMPILER);
const [input,out,scenarioPath]=process.argv.slice(2);const scenario=JSON.parse(fs.readFileSync(scenarioPath));if(!input||!out)throw Error('input.glb NEW_OUTPUT_DIR');
const start=performance.now();
try {
 const ir=importGlb(fs.readFileSync(input));fs.mkdirSync(out,{recursive:false});
 const srgb=x=>x<=.0031308?12.92*x:1.055*x**(1/2.4)-.055;
 const rgb565=c=>(Math.round(srgb(c[0])*31)<<11)|(Math.round(srgb(c[1])*63)<<5)|Math.round(srgb(c[2])*31);
 const materials=new Map(ir.materials.map(m=>[m.stableId,rgb565(m.baseColor.map((x,i)=>i<3?Math.min(1,x*scenario.albedoScale):x))]));
 const nodes=[{index:0,name:'root',parent:-1,kind:'group',enabled:true,pose:[0,0,0,0,0,0,1,1,1]}],parts=[];
 for(const s of ir.surfaces)for(const p of partition(s)){
  const color=materials.get(s.materialId);if(color===undefined)throw Error('OPAQUE_MATERIAL_COLOR_REQUIRED');
  nodes.push({index:nodes.length,name:'part-'+nodes.length,parent:0,kind:'gouraudMesh',enabled:true,pose:[0,0,0,0,0,0,1,1,1],color:0,thickness:1,opacity:1,edgeSoftness:0,
   material:[scenario.ambient,scenario.diffuse,0,1,0,1,1,1,0,0,0],mesh:{vertices:p.positions.flat().map(x=>x*38),normals:p.normals.flat(),indices:p.triangles.flat(),mask:p.positions.map(()=>-1),holes:[],albedoA:color,albedoB:color,thickness:255,order:'authored'}});
  parts.push({nodeId:nodes.length-1,sourceSurface:s.stableId,sourceNode:s.nodeId,sourceTriangles:p.sourceTriangleIds,vertices:p.positions.length,triangles:p.triangles.length});
 }
 const bytes=compile({schema:'ayatsuri-native-model-design-v1',nodes});
 fs.writeFileSync(path.join(out,'model.aynm'),bytes);fs.writeFileSync(path.join(out,'scene.ir.json'),JSON.stringify(ir));
 const report={scope:'IDENTITY GEOMETRY; automatic partition only; static pose diagnostic; unlit material colors',reduction:false,geometryScale:38,nodes:nodes.length,parts,coldBytes:bytes.length,compileMs:performance.now()-start,
  sourceVertices:ir.surfaces.reduce((n,s)=>n+s.positions.length,0),sourceTriangles:ir.surfaces.reduce((n,s)=>n+s.triangles.length,0),partitionVertices:parts.reduce((n,s)=>n+s.vertices,0)};
 fs.writeFileSync(path.join(out,'compile.json'),JSON.stringify(report,null,2));console.log(JSON.stringify(report));
}catch(e){console.error(JSON.stringify({code:e.code,message:e.message,path:e.path,scope:'NO RUNTIME MORPH ADAPTER ADDED'}));process.exit(1);}
