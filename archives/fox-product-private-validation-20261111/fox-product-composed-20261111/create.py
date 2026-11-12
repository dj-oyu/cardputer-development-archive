from pathlib import Path
p=Path(__file__).parent/'private'
s=(p/'bridge.c').read_text().replace('static fox_eye_snapshot snapshots[2];\nstatic unsigned active;','')
s=s.replace('entered=true;uint32_t hash=0;unsigned next=active^1;\n bool ok=fox_eye_snapshot_build(&snapshots[next],&c)&&fox_bridge_render(&snapshots[next],&hash);\n if(ok){active=next;committed_hash=hash;}','entered=true;uint32_t hash=0;\n bool ok=fox_composed_commit(&c,&hash);\n if(ok){committed_hash=hash;}')
a=s.index('unsigned n=0;for(unsigned i=0;i<74;i++)');b=s.index('return JS_NewUint32(ctx,n);',a)
s=s[:a]+'unsigned n=fox_composed_hidden();'+s[b:]
s=s.replace('static JSValue print(','''static JSValue testmode(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){(void)self;int32_t mode=0;if(argc!=1||JS_ToInt32(ctx,&mode,argv[0]))return JS_EXCEPTION;return JS_NewUint32(ctx,fox_composed_mode(mode));}
static JSValue print(''')
s=s.replace('JS_CFUNC_DEF("hidden",0,hidden)','JS_CFUNC_DEF("hidden",0,hidden),JS_CFUNC_DEF("testmode",1,testmode)').replace('methods,3','methods,4')
s=s.replace('/* Private synchronous proof. No outstanding DMA/guest callback survives commit.\n * A device integration must retain the published snapshot until DMA retirement. */','/* Private synchronous JS result contract, with explicitly leased mock transport. */')
(p/'bridge.c').write_text(s)
s=(p/'bridge.h').read_text().replace('bool fox_bridge_render(const fox_eye_snapshot*,uint32_t*);','bool fox_composed_commit(const FoxEyeControls*,uint32_t*);\nunsigned fox_composed_hidden(void);\nunsigned fox_composed_mode(int);\nvoid fox_composed_finish(void);')
(p/'bridge.h').write_text(s)
s=(p/'main.c').read_text().replace('JS_FreeContext(ctx);','fox_composed_finish();JS_FreeContext(ctx);');(p/'main.c').write_text(s)
s=(p/'build_test.py').read_text().replace("'render.c'","'composed.c'")
s=s.replace("mode=sys.argv", "src=[str(root/'fox-firmware-budget-20261111/composite-cutout.c') if x.endswith('/composite.c') else x for x in src]+[str(root/'fox-snapshot-lifetime-20261111'/x) for x in ['lease.c','render_adapter.c']]\nflags+=['-pthread']\nmode=sys.argv")
(p/'build_test.py').write_text(s)
