import pathlib,hashlib,json,re,difflib
P=pathlib.Path(__file__).resolve().parent;R=P.parent.parent;D=P/'mirror'
files=[]
def add(base,names):files.extend(base+'/'+n for n in names.split())
add('ayatsuri-latest-fixed-source-20261105/kernel-chain-compact','compact.c compact.h build.sh test_native.c verify.py')
add('ayatsuri-latest-fixed-source-20261105/kernel-chain-prototype','chain.c chain.h reference.c fixtures.inc fixtures.json')
add('ayatsuri-latest-fixed-source-20261105/material-c-compact','material.c material.h generated-q16.inc generated-q20.inc generated-q24.inc')
add('ayatsuri-latest-fixed-source-20261105/control-prototype','control.c control.h')
add('ayatsuri-fixed-integer-light-20261105','integer_light.h normal_bridge.h')
add('ayatsuri-fixed-frame-stage1-20261105/aa/code','integer_aa.c integer_aa.h profile_adapter.c profile_adapter.h')
add('ayatsuri-fixed-integer-output-20261105/code','integer_output.c integer_output.h block_cache.c block_cache.h private_adapter_api.h')
add('ayatsuri-fixed-integer-output-20261105/private','adapter.c shaper.h profile_data.h')
changes={'ayatsuri-fixed-integer-light-20261105/normal_bridge.h':('for(unsigned k=0;k<3;k++)out[k]=result[k];return IL_NORMAL_OK;','for(unsigned k=0;k<3;k++)out[k]=result[k];\n return IL_NORMAL_OK;'),'ayatsuri-latest-fixed-source-20261105/kernel-chain-compact/compact.c':('if(q20<INT32_MIN||q20>INT32_MAX)return KC_INVALID;local[k]=(int32_t)q20;}','if(q20<INT32_MIN||q20>INT32_MAX)return KC_INVALID;\nlocal[k]=(int32_t)q20;\n}')}
sha=lambda b:hashlib.sha256(b).hexdigest();rows=[];diff=[]
for name in files:
 raw=(R/name).read_bytes();text=raw.decode();new=text
 if name in changes:
  a,b=changes[name];assert text.count(a)==1;new=text.replace(a,b);assert re.sub(r'\s','',text)==re.sub(r'\s','',new)
  diff.extend(difflib.unified_diff(text.splitlines(True),new.splitlines(True),fromfile='frozen/'+name,tofile='format-only/'+name))
 dest=D/name;dest.parent.mkdir(parents=True,exist_ok=True)
 if dest.exists():assert dest.read_bytes()==new.encode()
 else:dest.write_text(new)
 rows.append(dict(path=name,original_sha256=sha(raw),copied_sha256=sha(new.encode()),format_only=name in changes,nonwhitespace_sha256=sha(re.sub(r'\s','',new).encode())))
# Assert every local include resolves inside the private mirror. No stub headers.
for name in files:
 source=D/name
 for inc in re.findall(r'^\s*#\s*include\s*"([^"]+)"',source.read_text(),re.M):assert (source.parent/inc).resolve().is_relative_to(D.resolve()) and (source.parent/inc).is_file(),(name,inc)
(P/'minimal.patch').write_text(''.join(diff));(P/'source-proof.json').write_text(json.dumps(dict(files=rows,replacements={n:dict(old=a,new=b) for n,(a,b) in changes.items()},nonwhitespace_equal_for_every_file=True,scope='Exactly two whitespace-only statement-boundary changes. All other source/build/test/fixture bytes identical. Private profile copied only locally for real unchanged tests.'),indent=2)+'\n')
print(json.dumps([r for r in rows if r['format_only']],indent=2))
