"""Private synthetic proof matrix; no firmware build/device/network."""
from pathlib import Path
import sys,tempfile,json
from unittest.mock import patch
ROOT=Path('/workspace/derby-detail-recovery');sys.path.insert(0,str(ROOT/'tools'))
import record_verification as r
from derby_fixed_workload_chunks import generate,MANIFEST_SHA256
rows=[]
with tempfile.TemporaryDirectory() as t:
 b=Path(t)
 for name,fixed,detail,extra,expect in [
 ('detail-ON-required-only','ON','ON',set(),True),
 ('detail-ON-missing-owner-exit','ON','ON',{'MISSING_EXIT'},False),
 ('detail-ON-unknown-boundary','ON','ON',{'df_unknown'},False),
 ('detail-YES-alias','ON','YES',set(),True),
 ('detail-TRUE-alias','ON','TRUE',set(),True),
 ('detail-1-alias','ON','1',set(),True),
 ('coarse-OFF-optional-helpers-absent','ON','OFF',set(),True),
 ('coarse-OFF-rejects-owner-exit','ON','OFF',{'df_detail_exit_record'},False),
 ('fixed-OFF-no-boundary','OFF','OFF',set(),True),
 ('fixed-OFF-rejects-owner-exit','OFF','OFF',{'df_detail_exit_record'},False)]:
  enabled=detail in ('ON','YES','TRUE','1');out=b/'generated/derby_fixed_workload';generate(ROOT/'apps/derby',out,enabled)
  (b/'CMakeCache.txt').write_text(f'POCKET_DERBY_FIXED_WORKLOAD:BOOL={fixed}\nPOCKET_DERBY_DETAIL_MEASURE:BOOL={detail}\n')
  elf=b'\0'.join((out/f'derby_{n}.js').read_bytes() for n in ('watch','view','play'))+b'\0'
  if enabled:elf+=(out/'derby_pan.js').read_bytes()+b'\0'
  elf+=MANIFEST_SHA256.encode()+b'\0'
  if fixed=='OFF':elf=b'synthetic shipping ELF\0'
  (b/'cardputer_pocketjs.elf').write_bytes(elf)
  symbols=set(r.FIXED_REQUIRED) if fixed=='ON' else set()
  if enabled:symbols|=r.DETAIL_REQUIRED|r.DETAIL_FIXED_SYMBOLS
  if 'MISSING_EXIT' in extra:symbols-=r.DETAIL_FIXED_SYMBOLS;extra=extra-{'MISSING_EXIT'}
  symbols|=extra
  try:
   with patch.object(r,'elf_symbols',return_value=symbols):r.verify_fixed_mode(b);r.verify_detail_mode(b)
   accepted=True;error=None
  except ValueError as e:accepted=False;error=str(e)
  assert accepted==expect,(name,accepted,error)
  if not expect and fixed=='ON':assert error=='fixed workload ELF boundary symbols differ',(name,error)
  rows.append({'case':name,'accepted':accepted,'expected_acceptance':expect,'error':error})
print(json.dumps({'pass':True,'synthetic_only':True,'cases':rows},indent=2))
