from pathlib import Path
import ctypes as C,json
D=Path(__file__).parent;lib=C.CDLL(str((D/'predicates.so').resolve()));lib.qtriangle.argtypes=[C.POINTER(C.c_int32),C.c_int,C.POINTER(C.c_uint64)];out=[]
for f,dx,dz in [(20,31,3),(20,32,3),(20,30,3),(16,1,3)]:
 x=[-100,-100,0,100,-100,0,0,100,0,0,0,-1,dx,0,dz-1];o=(C.c_uint64*5)();status=lib.qtriangle((C.c_int32*15)(*x),f,o);near_distance_ticks=(dx*dx+dz*dz)**.5/dz;out.append(dict(f=f,dx=dx,dz=dz,status=status,nearDistanceTicks=near_distance_ticks,epsilonTicks=(1<<f)/100000))
assert out[0]['status']==2 and out[1]['status']==1 and out[2]['status']==0
with (D/'BOUNDARIES.json').open('x') as f:json.dump({'additionalCases':4,'totalAcrossRuns':64009,'cases':out},f,indent=2)
print(out)
