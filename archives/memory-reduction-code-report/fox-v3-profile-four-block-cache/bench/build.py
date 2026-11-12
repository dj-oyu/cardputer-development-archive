from pathlib import Path
import subprocess,json,hashlib
R=Path(__file__).resolve().parent;W=R.parents[1];BASE=W/'fox-v3-lossless-profile-lut/profile';I=R.parent/'implementation';OLD=W/'fox-v3-lossless-profile-fast-access/implementation';B=R/'build';B.mkdir(exist_ok=True)
flags=['-std=c11','-O2','-fno-fast-math','-ffp-contract=off','-fstack-usage','-fPIC','-I'+str(I),'-I'+str(BASE/'private')]
def run(args):subprocess.run(args,check=True,cwd=B)
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
paths={};pins={};objects={}
for arm in ['raw','baseline','gather','cache4']:
 if arm=='raw':profile=W/'fox-v3-profile-integration-feasibility/build-private/agx_profile.c';decoder=None
 elif arm=='baseline':profile=BASE/'candidate_profile.c';decoder=BASE.parent/'research/block_decoder.c'
 elif arm=='gather':profile=OLD/'candidate_profile.c';decoder=OLD/'block_decoder.c'
 else:profile=I/'candidate_profile.c';decoder=I/'block_cache.c'
 defs=['-DFAST_BITS=0','-DGATHER='+str(int(arm=='gather')),'-DCACHE_ARM='+str(int(arm=='cache4'))]
 sources=[('profile',profile),('bridge',R/'batch_bridge.c')]+([('decoder',decoder)] if decoder else [])
 objs=[]
 for kind,src in sources:
  name=arm+'_'+kind+'.o';run(['cc',*flags,*defs,'-c',str(src),'-o',name]);objs.append(name);pins[str(src.relative_to(W))]=digest(src)
 run(['cc','-shared',*objs,'-lm','-o',arm+'.so']);paths[arm]=str(B/(arm+'.so'));objects[arm]=objs
pins[str((I/'block_cache.h').relative_to(W))]=digest(I/'block_cache.h')
(B/'size.txt').write_text(subprocess.check_output(['size','-A',*[p.name for p in B.glob('*.o')]],cwd=B,text=True))
(R/'LIBRARIES.json').write_text(json.dumps(paths,indent=2)+'\n')
(R/'BUILD.json').write_text(json.dumps({'flags':flags,'compiler':subprocess.check_output(['cc','--version'],text=True),'sourcePins':pins,'objects':objects,'armMacros':{'raw':[0,0,0],'baseline':[0,0,0],'gather':[0,1,0],'cache4':[0,0,1]},'macroOrder':['FAST_BITS','GATHER','CACHE_ARM']},indent=2)+'\n')
