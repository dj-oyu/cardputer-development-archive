"""Pure original background geometry classification; no light or visibility calls."""
from pathlib import Path
import ctypes,numpy as np

def masks(preflight,metadata):
 p=Path(preflight);c=metadata['sourceCameraFields'];d=Path(__file__).resolve().parent;D=ctypes.POINTER(ctypes.c_double);U=ctypes.POINTER(ctypes.c_uint32);F=ctypes.POINTER(ctypes.c_float);Y=ctypes.POINTER(ctypes.c_uint8);lib=ctypes.CDLL(str(d/'metadata.so'));fn=lib.background_metadata;fn.argtypes=[D,U,U,F,ctypes.c_size_t,Y,F];fn.restype=ctypes.c_int
 cfg=np.array(c['nativeCameraF32']+c['sourceOrigin']+c['sourceUnitView']+[c['near'],c['far']]+sum(c['floorWorld'],[]),dtype=np.float64);ix=np.array(sum(c['floorTriangles'],[]),dtype=np.uint32);target=np.fromfile(str(p)+'.targets.u8',dtype='u1');wr=np.fromfile(str(p)+'.winner-records.u16le',dtype='<u2').reshape(5,32400);wd=np.fromfile(str(p)+'.winner-depths.f32le',dtype='<f4').reshape(5,32400)
 slots=[];dep=[];where=[]
 for phase in range(5):
  for pixel in np.flatnonzero(target==int(phase!=0)):
   hit=int(wr[phase,pixel]!=65535);slots.append([pixel%240,pixel//240,0xffffffff if phase==0 else phase-1,hit]);dep.append(float(wd[phase,pixel]) if hit else 0.);where.append((phase,pixel))
 slots=np.array(slots,dtype=np.uint32);dep=np.array(dep,dtype=np.float32);a=np.zeros(len(slots),dtype='u1');fd=np.zeros(len(slots),dtype=np.float32);assert fn(cfg.ctypes.data_as(D),ix.ctypes.data_as(U),slots.ctypes.data_as(U),dep.ctypes.data_as(F),len(slots),a.ctypes.data_as(Y),fd.ctypes.data_as(F))==0
 full=np.full((5,32400),255,dtype='u1')
 for (phase,pixel),action in zip(where,a):full[phase,pixel]=action
 masks={}
 for name,code in [('character_only',0),('floor_only',1),('world_only',2)]:masks[name]=((target==0)&(full[0]==code))|((target==1)&np.all(full[1:]==code,axis=0))
 masks['mixed_character_floor_world']=~(masks['character_only']|masks['floor_only']|masks['world_only']);assert sum(int(x.sum()) for x in masks.values())==32400
 return masks
