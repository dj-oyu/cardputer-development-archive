#!/usr/bin/env python3
"""Generate independent tiny AYNM v1 fixtures. No imported model or image data."""
import pathlib, struct, json, hashlib, argparse
ROOT=pathlib.Path(__file__).resolve().parent
p=lambda fmt,*v:struct.pack('<'+fmt,*v)
def make(mesh_only=False):
    names=['root','ellipse','branch','blend','hole_mesh','sided_mesh','hidden','leaf_mesh']
    parents=[-1,0,0,2,2,0,0,2]
    kinds=[0,1,0,2,3,3,1,3] if not mesh_only else [0,3,0,3,3,3,3,3]
    enabled=[1,1,1,1,1,1,0,1]
    poses=[(0,0,0,0,0,0,1,1,1),(-2,0,0,.12,.2,0,1,1,1),(.4,.1,.3,.15,.1,.07,1.2,.8,1.1),
           (1.5,.7,0,.08,0,.12,1,1,1),(-.5,-1.5,.2,.08,.1,0,1,1,1),(2,-1.5,0,0,.2,.15,1,1,1),
           (0,2,0,0,0,0,1,1,1),(-1,1.8,.2,.1,.12,0,1,1,1)]
    # All same material parameters; material 1 is double-sided for mesh 5.
    coeff=[.22,.65,.1,12,.07,.03,.1,.02,.1,.1,.1]
    materials=[p('11fIddd',*coeff,0xd0a060,1,1,0),p('11fIddd',*coeff,0x60b0d0,1,1,0)]
    nodes=[];descs=[];verts=[];tris=[];holes=[];bindings=[];text=b''
    xyz=[(-.72,-.65,0),(.72,-.65,.08),(.72,.65,0),(-.72,.65,-.05)]
    normals=[(0,0,1),(.6,0,.8),(0,.6,.8),(-.6,0,.8)]
    for i,(name,kind,parent,ena) in enumerate(zip(names,kinds,parents,enabled)):
        shape=65535;lobes=0;mat=65535;blend=0
        if kind==1: shape=0;mat=0
        elif kind==2: shape=0;lobes=2;mat=0;blend=.6
        elif kind==3:
            shape=len(descs);mat=int(i==5)
            first=len(verts);tri=len(tris);hole=len(holes);has_hole=int(i==4 and not mesh_only)
            verts.extend(p('7f',*v,*n,[-.7,.3,.8,-.2][j]) for j,(v,n) in enumerate(zip(xyz,normals)))
            tris.extend([p('3H',0,1,2),p('3H',0,3,2) if i==5 else p('3H',0,2,3)])
            if has_hole:holes.extend(p('3f',*v) for v in [(-.15,-.15,0),(.15,-.15,0),(.15,.15,0),(-.15,.15,0)])
            d=bytearray(32);struct.pack_into('<5H4B2HB',d,0,first,4,tri,2,hole,has_hole,i%2,4 if has_hole else 0,0,0xfbe0,0x07df,220);descs.append(bytes(d))
        nodes.append(p('hBB4Hf',parent,kind,ena,shape,lobes,mat,i,blend))
        bindings.append(p('HHI',i,len(name),len(text)));text+=name.encode()
    sections={1:(16,b''.join(nodes)),2:(36,b''.join(p('9f',*x) for x in poses)),3:(12,p('3f',.8,.6,.5) if not mesh_only else b''),
              4:(24,p('6f',-.4,0,0,.6,.5,.4)+p('6f',.4,0,0,.6,.5,.4) if not mesh_only else b''),
              5:(72,b''.join(materials)),6:(8,b''.join(bindings)),7:(1,text),9:(32,b''.join(descs)),10:(28,b''.join(verts)),
              11:(6,b''.join(tris)),12:(12,b''.join(holes)),13:(4,bytes([0,0,0,0,1,0,0,0]))}
    if not mesh_only:
        sections[8]=(32,p('HBB5fII',1,4,0,1,0,0,.1,.08,0x20a0e0,0)+p('HBB5fII',3,5,0,0,1,0,0,.08,0x20d040,0))
    n=len(sections);data=bytearray(32+20*n);data[:4]=b'AYNM';struct.pack_into('<HH5I',data,4,1,32,0,n,32,20,0)
    for j,(kind,(stride,body)) in enumerate(sorted(sections.items())):
        data.extend(b'\0'*((-len(data))%8));off=len(data);data.extend(body)
        struct.pack_into('<HH4I',data,32+20*j,kind,1,off,len(body),len(body)//stride,stride)
    struct.pack_into('<I',data,8,len(data));return bytes(data)
if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output-dir',type=pathlib.Path,required=True);args=parser.parse_args();ROOT=args.output_dir;ROOT.mkdir(parents=True,exist_ok=True)
    manifest={}
    for name,only in [('mixed',False),('mesh_only',True)]:
        data=make(only);(ROOT/(name+'.aynm')).write_bytes(data);manifest[name]={'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'synthetic':True}
    (ROOT/'fixtures.json').write_text(json.dumps(manifest,indent=2)+'\n')
