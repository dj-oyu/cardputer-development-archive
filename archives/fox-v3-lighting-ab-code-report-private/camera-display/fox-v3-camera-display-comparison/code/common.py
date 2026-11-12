from pathlib import Path
import json,hashlib,importlib.util,ctypes,sys
import numpy as np
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parents[1];W=R.parent;OLD=W/'fox-v3-camera-background-evaluation';D=OLD/'actual-002';RAW=W/'fox-v3-lid-display-combination/run-001';P=W/'fox-v3-agx-profile/profile';LIB=W/'fox-v3-lid-display-combination/postprocess-002/profile-buffer.so'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,x):Path(p).write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
def module(name,p):
 s=importlib.util.spec_from_file_location(name,p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
def check_profile():
 f=json.load(open(R/'PROFILE_INPUT_FREEZE.json'));assert sha(R/'PROFILE_INPUT_FREEZE.json')=='073725203b53ea1680920c48804a02ae4f95071efa475327427c4d242e9c7e50'
 for n,h in f['files'].items():assert sha(Path(n) if Path(n).is_absolute() else W/n)==h,n
 lib=ctypes.CDLL(str(LIB));fun=lib.profile_buffer;fun.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint,ctypes.POINTER(ctypes.c_ulong)];fun.restype=ctypes.c_int;return lib,fun

def admission():
 S=module('frozen_scene_admission',OLD/'analysis-code/strict_scene_score.py');a=S.Admission(W,OLD/'analysis-code/TRUST_INPUTS.json','d4392ca85bf91d6c287241549d0d8c5bd43941723bd846db6bd8803554714183',OLD/'analysis-code/ALL_OUTPUT_PINS.json','88c5f4d7d68e111795cc25b53d55e472dfec8da58c27d63985e02823e7b05259');a.load('on');return a

def encode(fun,raw,enabled):
 assert raw.dtype==np.float64 and raw.shape==(135,240,3) and raw.flags.c_contiguous
 out=np.empty((135,240),np.uint16);clamp=ctypes.c_ulong();assert fun(raw.ctypes.data,out.ctypes.data,32400,enabled,ctypes.byref(clamp))==1;return out,int(clamp.value)
