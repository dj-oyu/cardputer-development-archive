from pathlib import Path
import json,subprocess,hashlib,re,shlex
from elftools.elf.elffile import ELFFile
r=Path(__file__).resolve().parent;t=Path('/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin');ev=r/'evidence';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
results={}
for arm in ['off','on']:
 b=r/('build-'+arm);d=ev/arm;elf=b/'cardputer_pocketjs.elf'
 assert (r/('build-'+arm+'.exit.txt')).read_text().strip()=='0'
 cache=(b/'CMakeCache.txt').read_text();opts={n:re.search(n+':BOOL=(\\w+)',cache).group(1) for n in ['KASANE_MESH_Q7_CERTIFIED_PROTOTYPE','KASANE_MESH_PREPARED_PROTOTYPE','KASANE_MESH_EDGE4_PROTOTYPE']}
 db=json.loads((d/'selected-compile-commands.json').read_text());nm=(d/'symbols-by-size.txt').read_text()
 assert not any('KSN_MESH_EDGE4_HOST_STATS' in x['command'] for x in db)
 assert 'pie_edge4_reject_raw' not in nm and 'ksn_mesh_prepared_edge4_stats' not in nm
 assert ('ksn_mesh_q7_render' in nm)==(arm=='on')
 if arm=='on':
  for name in ['ksn_mesh_q7_certified.c','ksn_mesh_prepared.c','ksn_mesh_depth.c']:
   x=next(x for x in db if x['file'].endswith('/'+name));a=x['argv']
   for flag in ['-O2','-fno-fast-math','-fno-associative-math','-fno-reciprocal-math','-ffp-contract=off','-frounding-math','-fno-lto','-fstack-usage']:assert flag in a,(name,flag)
 for name in ['ksn_mesh_q7_bytes','ksn_mesh_q7_prepare','ksn_mesh_q7_render','ksn_mesh_q7_span','ieee_environment','certificate','ksn_mesh_prepare','ksn_mesh_prepared_render','ksn_mesh_render','render_rows','commit_impl','js_commit','nextafter','fegetround']:
  if re.search(r'\s'+name+r'$',nm,re.M):
   out=subprocess.check_output([str(t/'xtensa-esp32s3-elf-objdump'),'-d','--disassemble='+name,str(elf)],text=True);(d/(name+'.linked.txt')).write_text(out)
 size=json.loads(subprocess.check_output(['/workspace/.setup/espressif/python_env/idf6.0_py3.12_env/bin/python','-m','esp_idf_size','--format','json2',str(b/'cardputer_pocketjs.map')],text=True));(d/'idf-size.json').write_text(json.dumps(size,indent=2))
 files={str(p.relative_to(d)):{'bytes':p.stat().st_size,'sha256':sha(p)} for p in d.rglob('*') if p.is_file() and p.name!='HASHES.json'};(d/'HASHES.json').write_text(json.dumps(files,indent=2))
 results[arm]={'options':opts,'undefined':(d/'undefined.txt').read_text(),'files':{n:files[n] for n in ['cardputer_pocketjs.elf','cardputer_pocketjs.bin','cardputer_pocketjs.map','sdkconfig']},'su':{p.name:p.read_text() for p in d.glob('*.su')}}
# Resolve typedefs and anonymous structure size/member layouts from actual final ELF DWARF.
abi={}
with (r/'build-on/cardputer_pocketjs.elf').open('rb') as f:
 dw=ELFFile(f).get_dwarf_info()
 names=['ksn_mesh_q7_certificate','ksn_mesh_q7_extra','ksn_mesh_q7_triangle','ksn_mesh_q7_snapshot','ksn_mesh_q7_stats','ksn_prepared_triangle','ksn_mesh_prepared','proc_surface']
 for cu in dw.iter_CUs():
  for die in cu.iter_DIEs():
   n=die.attributes.get('DW_AT_name');n=n.value.decode(errors='replace') if n else ''
   if n not in names or n in abi:continue
   q=die
   while 'DW_AT_byte_size' not in q.attributes and 'DW_AT_type' in q.attributes:q=q.get_DIE_from_attribute('DW_AT_type')
   if 'DW_AT_byte_size' not in q.attributes:continue
   members={}
   for m in q.iter_children():
    if m.tag=='DW_TAG_member':
     mn=m.attributes.get('DW_AT_name');loc=m.attributes.get('DW_AT_data_member_location');members[mn.value.decode() if mn else '?']=loc.value if loc else None
   abi[n]={'bytes':q.attributes['DW_AT_byte_size'].value,'members':members}
(ev/'ABI_DWARF.json').write_text(json.dumps(abi,indent=2))
results['config_identical']=(r/'build-off/sdkconfig').read_bytes()==(r/'build-on/sdkconfig').read_bytes()
results['partitions_identical']=(r/'build-off/partition_table/partition-table.bin').read_bytes()==(r/'build-on/partition_table/partition-table.bin').read_bytes()
(ev/'RESULTS.json').write_text(json.dumps(results,indent=2))
print(json.dumps({'ABI':abi,'builds':{a:{k:v for k,v in results[a].items() if k!='su'} for a in ['off','on']}},indent=2))
