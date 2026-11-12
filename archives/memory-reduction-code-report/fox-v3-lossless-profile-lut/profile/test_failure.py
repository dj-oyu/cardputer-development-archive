from pathlib import Path
import subprocess,ctypes as C,numpy as np,json
R=Path(__file__).resolve().parent;B=R/'private/failure';B.mkdir(exist_ok=True)
m=json.loads((R/'PROFILE_CONSTANTS.json').read_text());(B/'profile_data.h').write_text(''.join('#define '+k+' '+v+'\n' for k,v in m['literalStrings'].items())+'#include <stdint.h>\nstatic const uint8_t agx_encoded[]={0};\n')
subprocess.run(['cc','-O2','-fno-fast-math','-ffp-contract=off','-fPIC','-shared','-I'+str(B),'-I'+str(R),str(R/'candidate_profile.c'),str(R.parent/'research/block_decoder.c'),'-lm','-o',str(B/'bad.so')],check=True)
l=C.CDLL(str(B/'bad.so'));p=C.POINTER(C.c_float);l.agx_profile_eval.argtypes=[p,p];cases=0
for inp,status in [([0,0,0],3),([1,2,3],3),([1e20,2,3],3),([-1,0,0],2),([np.nan,0,0],2)]:
 a=np.array(inp,np.float32);out=np.array([.123,.456,.789],np.float32);before=out.tobytes()
 assert l.agx_profile_eval(a.ctypes.data_as(p),out.ctypes.data_as(p))==status and out.tobytes()==before;cases+=1
(R/'FAILURE_RESULTS.json').write_text(json.dumps({'status':'PASS','cases':cases,'scope':'Candidate with deliberately one-byte malformed immutable table; valid inputs return3 without output writes; original invalid-input rejection returns2 first. Codec malformed-input coverage is independently reported.'},indent=2)+'\n')
print('PASS',cases)
