"""Verify exact-head real target link/mode proof logs; never hardware acceptance."""
from pathlib import Path
import argparse,json,re,hashlib,sys
p=argparse.ArgumentParser();p.add_argument('--ledger',type=Path,required=True);p.add_argument('--jobs',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--repo',type=Path);a=p.parse_args()
ledger=json.loads(a.ledger.read_text());jobs=json.loads(a.jobs.read_text());assert len(jobs)==6
sys.path.insert(0,str((a.repo or Path(ledger['baseline']['root']))/'tools'))
from record_verification import FIXED_REQUIRED,FIXED_SYMBOLS,DETAIL_FIXED_SYMBOLS,DETAIL_REQUIRED
rows=[]
for j in jobs:
 v,mode=j['variant'],j['mode'];d=ledger[v];assert mode in ('ON','OFF') and j['head']==d['remote_commit'] and j['conclusion']=='success'
 raw=(a.jobs.parent/'ci-target'/Path(j['log']).name).read_bytes();text=raw.decode('utf-8');text='\n'.join(re.sub(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(?:\.\d+)?Z ?', '',x) for x in text.splitlines());text=re.sub(r'\x1b\[[0-9;]*m','',text)
 def marker(prefix):
  found=[json.loads(x.split(prefix,1)[1]) for x in text.splitlines() if x.startswith(prefix)]
  assert found and all(x==found[0] for x in found),prefix
  return found[0]
 proof=marker('DERBY_DIAGNOSTIC_BUILD_PROOF ');resources=marker('DERBY_DETAIL_RESOURCES ')
 records=[]
 for match in re.finditer(r'\{\s*"source_commit"\s*:',text):
  record,_=json.JSONDecoder().raw_decode(text[match.start():]);records.append(record)
 assert records and all(x==records[0] for x in records);record=records[0]
 assert record['source_commit']==d['remote_commit'] and record['source_tree']==d['tree']
 assert record['project_version']==d['remote_commit'][:12] and record['idf_version']=='v6.0.1' and record['hardware_tested'] is False
 for obj in (record,proof):
  assert obj['detail_measurement']['mode']==mode and obj['fixed_workload']['mode']=='ON'
  assert obj['build_mode']['telemetry_mode']=='ON' and obj['build_measure']['measure_mode']=='ON'
  symbols=set(obj['fixed_workload']['native_symbols']);extra=DETAIL_FIXED_SYMBOLS if mode=='ON' else set()
  assert FIXED_REQUIRED|extra<=symbols<=FIXED_SYMBOLS|extra
  dd=set(obj['detail_measurement']['native_symbols']);assert (DETAIL_REQUIRED<=dd) if mode=='ON' else not dd
  for name in ('cardputer_pocketjs.bin','cardputer_pocketjs.elf'):
   item=obj['artifacts'][name];assert item['bytes']>0 and re.fullmatch('[0-9a-f]{64}',item['sha256'])
 assert proof['artifacts']['cardputer_pocketjs.elf']['sha256']==record['embedded_elf_sha256']==record['artifacts']['cardputer_pocketjs.elf']['sha256']
 assert proof['artifacts']['cardputer_pocketjs.bin']==record['artifacts']['cardputer_pocketjs.bin']
 assert proof['comparison_seed']['hardware_seed']=='2545F491' and proof['comparison_seed']['elf_seed_symbol_verified'] and proof['comparison_seed']['elf_embedded_view_verified']
 assert resources['detail_mode']==mode and ((resources['detail_state_bytes']>0) if mode=='ON' else resources['detail_state_bytes']==0)
 assert resources['compiler_stack'] and resources['max_function_stack_bytes']==max(x['bytes'] for x in resources['compiler_stack'])
 rows.append(dict(variant=v,mode=mode,job_id=j['job_id'],head=d['remote_commit'],tree=d['tree'],log_sha256=hashlib.sha256(raw).hexdigest(),record_verification=record,proof=proof,resources=resources,hardware_accepted=False))
assert {(x['variant'],x['mode']) for x in rows}=={(v,m) for v in ledger for m in ('ON','OFF')}
a.out.write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps({'all6_exact_head_target_proofs_verified':True,'hardware_accepted':False,'summary':[{'variant':x['variant'],'mode':x['mode'],'head':x['head'],'exit_symbol':'df_detail_exit_record' in x['proof']['fixed_workload']['native_symbols'],'detail_state_bytes':x['resources']['detail_state_bytes'],'max_per_function_stack_bytes':x['resources']['max_function_stack_bytes']} for x in rows]}))
