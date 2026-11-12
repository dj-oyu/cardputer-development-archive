from pathlib import Path
import subprocess,json,hashlib
R=Path(__file__).resolve().parent;W=R.parents[1];BASE=W/'fox-v3-lossless-profile-lut/profile';I=R.parent/'implementation';B=R/'build';B.mkdir(exist_ok=True)
flags=['-std=c11','-O2','-fno-fast-math','-ffp-contract=off','-fstack-usage','-fPIC','-I'+str(I),'-I'+str(BASE/'private')]
def run(args):subprocess.run(args,check=True,cwd=B)
run(['cc',*flags,'-c',str(R/'batch_bridge.c'),'-o','batch.o'])
paths={}
for arm in ['raw','baseline','fast_bits','gather','gather_fast_bits']:
 if arm=='raw':profile=W/'fox-v3-profile-integration-feasibility/build-private/agx_profile.c';decoder=None
 elif arm=='baseline':profile=BASE/'candidate_profile.c';decoder=BASE.parent/'research/block_decoder.c'
 else:profile=I/'candidate_profile.c';decoder=I/'block_decoder.c'
 defs=['-DFAST_BITS='+str(int(arm in ['fast_bits','gather_fast_bits'])),'-DGATHER='+str(int(arm in ['gather','gather_fast_bits']))]
 run(['cc',*flags,*defs,'-c',str(profile),'-o',arm+'_profile.o']);objs=[arm+'_profile.o']
 if decoder:run(['cc',*flags,*defs,'-c',str(decoder),'-o',arm+'_decoder.o']);objs.append(arm+'_decoder.o')
 run(['cc','-shared',*objs,'batch.o','-lm','-o',arm+'.so']);paths[arm]=str(B/(arm+'.so'))
(B/'size.txt').write_text(subprocess.check_output(['size','-A',*[p.name for p in B.glob('*.o')]],cwd=B,text=True))
(R/'LIBRARIES.json').write_text(json.dumps(paths,indent=2)+'\n')
(R/'BUILD.json').write_text(json.dumps({'flags':flags,'compiler':subprocess.check_output(['cc','--version'],text=True),'sourcePins':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [I/'candidate_profile.c',I/'block_decoder.c',R/'batch_bridge.c']},'armMacros':{'raw':'N/A','baseline':'N/A','fast_bits':[1,0],'gather':[0,1],'gather_fast_bits':[1,1]}},indent=2)+'\n')
