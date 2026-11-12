from pathlib import Path
import numpy as np,subprocess,ctypes as C,json
R=Path(__file__).resolve().parent;W=R.parents[1];S=W/'fox-v3-profile-integration-feasibility/build-private'
s=(S/'agx_profile.c').read_text();a=s.index(' int flags=');b=s.index(' float result[')
loop=s[a:b]
constants='\n'.join((S/'agx_lut.inc').read_text().splitlines()[:4])
source='''/* Generic test-only work counter; exact evaluator index arithmetic. */
#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "agx_profile.h"
'''+constants+'''
void trace(const float *inputs,size_t n,uint64_t stats[12]) {
for(size_t sample=0;sample<n;sample++) {
 const float *in=inputs+sample*3;int valid=1;
 for(int c=0;c<3;c++)if(!isfinite(in[c])||in[c]<0)valid=0;
 if(!valid){stats[0]++;continue;}
'''+loop+'''
 unsigned values=0,blocks[4],unique=0;
 for(unsigned k=0;k<4;k++){
  unsigned x=(unsigned)ix/4225,y=(unsigned)ix/65%65,z=(unsigned)ix%65;
  unsigned bx=x/4,by=y/4,bz=z/4,block=(bx*17+by)*17+bz;
  unsigned sx=bx==16?1:4,sy=by==16?1:4,sz=bz==16?1:4;
  values+=3*sx*sy*sz;unsigned found=0;
  for(unsigned j=0;j<unique;j++)if(blocks[j]==block)found=1;
  if(!found)blocks[unique++]=block;
  if(k<3)ix+=stride[order[k]];
 }
 stats[1]++;stats[2]+=4;stats[3]+=12;stats[4]+=values;
 if(values>stats[5])stats[5]=values;
 stats[5+unique]++;
}
}
'''
(R/'trace_work.c').write_text(source)
subprocess.run(['cc','-O2','-fno-fast-math','-ffp-contract=off','-shared','-fPIC',str(R/'trace_work.c'),'-lm','-o',str(R/'private/trace.so')],check=True)
l=C.CDLL(str(R/'private/trace.so'));p=C.POINTER(C.c_float);u=C.POINTER(C.c_uint64);l.trace.argtypes=[p,C.c_size_t,u]
a=np.fromfile(R/'private/all_inputs.f32le','<f4').reshape(-1,3);stats=np.zeros(12,np.uint64);l.trace(a.ctypes.data_as(p),len(a),stats.ctypes.data_as(u))
r={'corpusSamples':len(a),'invalidNoDecodes':int(stats[0]),'validProfiles':int(stats[1]),'RGBBlockDecodes':int(stats[2]),'channelDecodes':int(stats[3]),'reconstructedUint16Values':int(stats[4]),'maxValuesPerProfile':int(stats[5]),'uniqueBlocksHistogram':{str(k):int(stats[5+k]) for k in range(1,5)},'implementation':'Always four fetches for valid inputs, even when blocks coincide; no global cache. Each fetch independently decodes three channels.','worstPerValidProfile':{'RGBBlockDecodes':4,'channelDecodes':12,'reconstructedUint16Values':768,'gatherCopiesUint16':12},'scope':'Derived counts using original C coordinate/log/sort/index arithmetic compiled with same flags; not CPU instruction or elapsed-time counts.'}
(R/'WORK_COUNTS.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2))
