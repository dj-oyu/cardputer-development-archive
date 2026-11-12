'use strict';
const fs=require('fs'),path=require('path');const {compile}=require(process.argv[2]);const out=process.argv[3];
const root={index:0,name:'root',parent:-1,kind:'group',enabled:true,pose:[0,0,0,0,0,0,1,1,1]};
function rect(name,x,y,w,h,z,color,normal=[0,0,1]){return {name,parent:0,kind:'gouraudMesh',enabled:true,pose:[0,0,0,0,0,0,1,1,1],color:0,thickness:1,opacity:1,edgeSoftness:0,material:[.2,.6,0,1,0,1,1,1,0,0,0],mesh:{vertices:[x,y,z,x+w,y,z,x,y+h,z,x+w,y+h,z],normals:[...normal,...normal,...normal,...normal],indices:[0,1,2,1,3,2],mask:[-1,-1,-1,-1],holes:[],albedoA:color,albedoB:color,thickness:255,order:'authored'}};}
const body=rect('body',-45,-35,90,70,0,0xbdf7,[.6,0,.8]),eye=rect('eye',-15,-20,12,12,20,0xffff),tail=rect('tail',-80,5,35,20,0,0xbdf7);
for(const [name,parts]of Object.entries({base:[body,eye,tail],missingEye:[body,tail],missingTail:[body,eye],depth0:[rect('near',-30,-25,60,50,20,0xbdf7),rect('far',-30,-25,60,50,0,0xbdf7)],depth1:[rect('near',-30,-25,60,50,40,0xbdf7),rect('far',-30,-25,60,50,0,0xbdf7)]})){
 const nodes=[root,...parts.map((p,i)=>({...p,index:i+1}))];fs.writeFileSync(path.join(out,name+'.aynm'),compile({schema:'ayatsuri-native-model-design-v1',nodes}));}
