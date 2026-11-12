"""Describe actual immutable OFF input bytes and explicit JSON projections."""
from pathlib import Path
import hashlib
import json

root = Path(__file__).resolve().parent
roles = [
    ('--raw','off-trial-raw-private.log',None,'Exact raw capture bytes'),
    ('--transport','off-transport-receipt.json','','Owner byte/digest/quality receipt'),
    ('--manifest','off-build-manifest.json','/manifest','Durable actual build manifest'),
    ('--flash-plan','off-flash-plan.json','/plan','Exact immutable successful flash plan'),
    ('--flash-job','off-flash-result.json','','Successful flash job'),
    ('--flash-summary','off-flash-summary-request-bound.json','','Summary plus caller request context'),
    ('--collection-plan','off-trial-plan.json','/plan','Exact typed collector plan'),
    ('--collection-job','off-trial-result-private.json','','Raw/receipt/binding-bearing successful collector job'),
]
sha = lambda data: hashlib.sha256(data).hexdigest()
digest = lambda value: sha(json.dumps(value,sort_keys=True,separators=(',',':')).encode())
rows = []
for arg, filename, pointer, role in roles:
    data = (root/filename).read_bytes()
    row = dict(argument=arg, original_file=filename, bytes=len(data), file_sha256=sha(data), selection=pointer, role=role)
    if pointer is not None:
        value = json.loads(data)
        if pointer:
            value = value[pointer[1:]]
        row['selected_canonical_sha256'] = digest(value)
    rows.append(row)
manifest = json.loads((root/'off-build-manifest.json').read_text())['manifest']
proof = manifest['diagnostic_modeproof']['proof']
report = dict(private=True, source_head=manifest['source_provenance']['commit'], expect_detail='OFF',
    build_job_id=manifest['build_job_id'], build_plan_hash=manifest['build_plan_hash'],
    build_location=manifest['build_location'], artifacts=proof['artifacts'],
    modeproof_sha256=digest(proof), inputs=rows,
    code_sha256={'tools/games/derby_fixed_completion.py':'237c43498778333a939a7481249d1f13a7b97ddd8127723e7af6b3b420ac29ed',
                 'tools/games/verify_derby_recorded_trial.py':'a8d93c6656a850f577d7397a71ac5e597feaf22a25ea6ce1774166e589154b12'},
    full_actual_build_CLI_executed_here=False,
    next_step='Independent Windows read-only actual prove(build) and all-argument unmodified r2 CLI using these exact OFF records; no new build, flash, ON run or OFF recapture.',
    comparison='Compare exact original bytes first. For JSON select only the declared response envelope, then compare canonical JSON with duplicate keys rejected. Preserve boolean/integer types. Retain originals and create separate derived CLI files with source-hash/pointer/output-hash provenance. Raw bytes must not be normalized.',
    flash_summary_context='requested_job_id is the caller query context, not an invented server field; retain it separately from the original server response.')
(root/'PRIVATE-WINDOWS-OFF-HANDOFF.json').write_text(json.dumps(report,indent=2)+'\n')
command = '''python -B "$R2Source/tools/games/verify_derby_recorded_trial.py" `
  --build "$ExistingOFFBuild" `
  --raw "$Inputs/trial.log" `
  --transport "$Inputs/transport.json" `
  --manifest "$Inputs/manifest.json" `
  --flash-plan "$Inputs/flash-plan.json" `
  --flash-job "$Inputs/flash-job.json" `
  --flash-summary "$Inputs/flash-summary.json" `
  --collection-plan "$Inputs/collection-plan.json" `
  --collection-job "$Inputs/collection-job.json" `
  --expect-head b561aea1c0798feb28055a00d36681fae81ac58a `
  --expect-detail OFF `
  --out "$NewOutput/verified-off.json"'''
text = '# Private Windows OFF full CLI handoff\n\n'+report['next_step']+'\n\n```powershell\n'+command+'\n```\n\n'
text += 'The expected head is the firmware head above. Use the existing actual OFF build and real verifier modules/app ROOT, no test harness/import stub.\n\n'
text += '| Argument | Cloud original / selection | Byte SHA256 | Selected JSON canonical SHA256 |\n|---|---|---|---|\n'
for row in rows:
    text += '| '+row['argument']+' | '+row['original_file']+' '+str(row['selection'] or '(whole)')+' | '+row['file_sha256']+' | '+row.get('selected_canonical_sha256','raw bytes only')+' |\n'
text += '\n'+report['comparison']+'\n\n'+report['flash_summary_context']+'\n'
(root/'PRIVATE-WINDOWS-OFF-HANDOFF.md').write_text(text)
print(json.dumps(dict(build_job_id=report['build_job_id'],head=report['source_head'],expect_detail='OFF',inputs=len(rows),raw_sha256=rows[0]['file_sha256'])))
