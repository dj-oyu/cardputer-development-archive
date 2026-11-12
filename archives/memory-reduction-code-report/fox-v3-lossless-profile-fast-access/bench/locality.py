"""Exact reference sequence; simulated LRU is not implemented cache performance."""
from pathlib import Path
import numpy as np,subprocess,ctypes as C,json,hashlib
R=Path(__file__).resolve().parent;W=R.parents[1];B=W/'fox-v3-lossless-profile-lut/profile'
s=(B/'trace_work.c').read_text();start=s.index(' int flags=');end=s.index('\n unsigned values=');prefix=s[:s.index('void trace(')]
source=prefix+'''void trace(const float *inputs,size_t n,uint64_t stats[16]) {
 unsigned lru1=~0u,lru4[4]={~0u,~0u,~0u,~0u};
 for(size_t sample=0;sample<n;sample++) {
 const float *in=inputs+sample*3; int valid=1;
 for(int c=0;c<3;c++)if(!isfinite(in[c])||in[c]<0)valid=0;
 if(!valid){stats[0]++;continue;}
'''+s[start:end]+'''
 unsigned blocks[4],unique=0,values=0;
 for(unsigned k=0;k<4;k++) {
 unsigned x=(unsigned)ix/4225,y=(unsigned)ix/65%65,z=(unsigned)ix%65;
 unsigned bx=x/4,by=y/4,bz=z/4,block=(bx*17+by)*17+bz;
 unsigned count=3*(bx==16?1:4)*(by==16?1:4)*(bz==16?1:4);
 stats[1]++;stats[8]+=count;
 unsigned found=0;for(unsigned j=0;j<unique;j++)if(blocks[j]==block)found=1;
 if(!found){blocks[unique++]=block;values+=count;}
 if(lru1==block)stats[2]++;else{stats[3]++;stats[10]+=count;if(lru1!=~0u)stats[12]++;lru1=block;}
 unsigned pos=0;while(pos<4&&lru4[pos]!=block)pos++;
 if(pos<4)stats[4]++;else{stats[5]++;stats[11]+=count;if(lru4[3]!=~0u)stats[13]++;pos=3;}
 while(pos){lru4[pos]=lru4[pos-1];pos--;}lru4[0]=block;
 if(k<3)ix+=stride[order[k]];
 }
 stats[6]+=unique;stats[7]+=values;if(unique>stats[9])stats[9]=unique;
 }
}
'''
(R/'locality_trace.c').write_text(source)
subprocess.run(['cc','-O2','-fno-fast-math','-ffp-contract=off','-shared','-fPIC','-I'+str(B),str(R/'locality_trace.c'),'-lm','-o',str(R/'locality_trace.so')],check=True)
l=C.CDLL(str(R/'locality_trace.so'));p=C.POINTER(C.c_float);u=C.POINTER(C.c_uint64);l.trace.argtypes=[p,C.c_size_t,u]
keys=['invalid','fourFetchReferences','lru1Hits','lru1Misses','lru4Hits','lru4Misses','gatherBlockDecodes','gatherDecodedU16','baselineDecodedU16','maxUniqueBlocksPerPixel','lru1DecodedU16','lru4DecodedU16','lru1Evictions','lru4Evictions','unused14','unused15']
rows=[]
for f in json.loads((B/'INPUTS.json').read_text())['frames']:
 a=np.ascontiguousarray(np.fromfile(f['hdr'],'<f8').reshape(-1,3).astype(np.float32));stats=np.zeros(16,np.uint64);l.trace(a.ctypes.data_as(p),len(a),stats.ctypes.data_as(u));rows.append({'name':f['name'],'pixels':len(a),**dict(zip(keys,map(int,stats)))})
tot={k:(max(r[k] for r in rows) if k=='maxUniqueBlocksPerPixel' else sum(r[k] for r in rows)) for k in keys}
report={'method':'Exact baseline coordinate/log/sort/index C arithmetic; four references in actual vertex order; LRU state reset per frame. Alternate frame order has identical totals because reset per frame. Counts only, no cache implemented or timed.','frames':rows,'totals':tot,'lru1HitRate':tot['lru1Hits']/tot['fourFetchReferences'],'lru4HitRate':tot['lru4Hits']/tot['fourFetchReferences'],'modelRAM':{'lru1Payload':384,'lru4Payload':1536,'metadataModel':'uint32_t block tag per slot; UINT32_MAX invalid; LRU order encoded by slot order; no age array. Payload+tag 388/1552 bytes before any surrounding context/alignment. Model only; actual candidate cache RAM is zero.'}}
(R/'LOCALITY.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='frames'},indent=2))
