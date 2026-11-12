#!/usr/bin/env python3
"""Verify saved provider receipts/logs; never opens hardware or runs a build."""
from pathlib import Path
import hashlib,json,datetime
b=Path(__file__).resolve().parent
source=json.loads((b/'source-result.json').read_text())
plan=json.loads((b/'build-plan.json').read_text())['result']
job=json.loads((b/'build-result.json').read_text())
assert source['ok'] and source['state']=='succeeded'
s=source['diagnostic']['source']
assert s['commit']=='3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5'
assert s['tree_sha1']=='b3de719ac438d8d3373a2c34786bc35c46e9200e'
assert s['source_receipt']=='bbf729af426e3110943d2fcad025311b1d088b773c0cecdbb53b4fde92e16679'
assert s['source_sha256']=='2b6f8223ef87de643e976686905f7fe75346f39143ea5cbdd3e00210e1200e3d'
assert job['ok'] and job['state']=='succeeded'
assert job['id']==plan['plan']['job_id'] and job['plan_hash']==plan['plan_hash']
assert plan['plan']['broker_epoch']=='51bfd752bc2a460db00a835c45250282'
created=datetime.datetime.strptime(job['created'],'%Y-%m-%d %H:%M:%S').replace(tzinfo=datetime.timezone.utc).timestamp()
assert created<plan['plan']['source_plan_expires_at']
pages=[json.loads((b/'build-001-logs.json').read_text())]+[json.loads(p.read_text()) for p in sorted(b.glob('build-log-page-*.json'))]
assert pages and not pages[-1]['has_more']
assert all(x['ok'] and not x['expired'] and not x['gap'] for x in pages)
entries={}
for page in pages:
 for e in page['entries']:
  if e['sequence'] in entries:assert entries[e['sequence']]==e
  entries[e['sequence']]=e
assert sorted(entries)==list(range(1,max(entries)+1))
manifest=next(x['manifest'] for x in reversed(pages) if x.get('artifact_status')=='verified' and x.get('manifest'))
assert manifest['build_job_id']==job['id'] and manifest['build_plan_hash']==job['plan_hash']
assert manifest['idf_version']=='6.0.1' and manifest['target']=='esp32s3'
assert manifest['fingerprint']==plan['plan']['fingerprint']
assert manifest['flash_authorized'] is False
m=manifest['source_provenance']
for k in ('source_receipt','repository','commit','tree_sha1','source_sha256'):assert m[k]==s[k]
assert m['submodules']==plan['plan']['source_provenance']['submodules']
proofs=[json.loads(e['text'].split('DERBY_DIAGNOSTIC_BUILD_PROOF ',1)[1]) for e in entries.values() if e['text'].startswith('DERBY_DIAGNOSTIC_BUILD_PROOF ')]
assert len(proofs)==1;proof=proofs[0]
for k,field in (('build_mode','telemetry_mode'),('build_measure','measure_mode'),('fixed_workload','mode'),('detail_measurement','mode')):assert proof[k][field]=='ON'
assert proof['comparison_seed']['hardware_seed']=='2545F491'
f=proof['fixed_workload']['fixture']
for k,v in dict(id='oval-pan8-390-510-v1',seed='9112A7AB',race=1000001,camera=8,tier=1,start=390,end=510,contexts=120,repetitions=3,finish='5DC86E18').items():assert f[k]==v
assert 'df_detail_exit_record' in proof['fixed_workload']['native_symbols']
assert {'dd_enter','dd_leave','dd_finish','dd_start'}<=set(proof['detail_measurement']['native_symbols'])
assert proof['hardware_tested'] is False
artifacts={x['name']:x for x in manifest['artifacts']}
for name,a in proof['artifacts'].items():
 assert artifacts[name]['sha256']==a['sha256'] and artifacts[name]['bytes']==a['bytes']
reclaim=json.loads((b/'RECLAMATION-EVIDENCE.json').read_text())
before=json.loads((b/'resources-before-source.json').read_text())
after=json.loads((b/'resources-after-source.json').read_text())
assert before['source_cache']['snapshots']==after['source_cache']['snapshots']==16
assert after['source_cache']['snapshot_entries']==18 and after['source_cache']['evicted_snapshots']==2
prior={x['source_receipt']:x for x in before['owned_snapshots']}
current={x['source_receipt']:x for x in after['owned_snapshots']}
assert set(prior)<=set(current) and len(prior)==17
for receipt,row in prior.items():
 if row['payload_present'] and not row['payload_reclamation_candidate']:assert current[receipt]['payload_present']
assert reclaim['preserved_receipts']==17 and reclaim['protected_payloads_preserved']==12
assert len(reclaim['reclaimed'])==1
old=json.loads((b/'build-001-reclaimed_old_job.json').read_text())['diagnostic']['source']
assert old['source_receipt']==reclaim['reclaimed'][0]['before']['source_receipt']
assert old['source_sha256']=='6563fd0647d97a8c5a928342dd36a792bd9fea41281725b8183e002e985ed7e6'
(b/'build-output-redacted.log').write_text(''.join(entries[i]['text']+'\n' for i in sorted(entries)))
result={'verified':True,'hardware_accepted':False,'job':job,'manifest':manifest,'proof':proof,'source':s,'observed_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'log_entries':len(entries),'log_complete_in_provider_sequence':True,'log_sha256':hashlib.sha256((b/'build-output-redacted.log').read_bytes()).hexdigest(),'reclamation_protection_verified':True,'firmware_bytes_materialized_locally':False,'scope':'Provider revalidated manifest and mandatory linked image proof; saved redacted output is not raw UART and no physical operation occurred.'}
(b/'SOURCE-BUILD-PROOF.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'verified':True,'source_receipt':s['source_receipt'],'build_job':job['id'],'bin':proof['artifacts']['cardputer_pocketjs.bin'],'elf':proof['artifacts']['cardputer_pocketjs.elf'],'log_entries':len(entries),'hardware_accepted':False}))
