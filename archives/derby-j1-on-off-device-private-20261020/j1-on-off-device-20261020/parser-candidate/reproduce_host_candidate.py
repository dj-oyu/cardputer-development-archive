from pathlib import Path
import json,hashlib,shutil,sys,types,base64,copy,datetime,os
p=Path('/workspace/derby-evidence/j1-on-off-device-20261020');ref=p/'parser-reference';out=p/'parser-candidate';sha=lambda b:hashlib.sha256(b).hexdigest();original={str(f.relative_to(ref)):sha(f.read_bytes()) for f in ref.rglob('*') if f.is_file() and '__pycache__' not in f.parts}
shutil.copytree(ref,out,dirs_exist_ok=True,ignore=shutil.ignore_patterns('__pycache__','*.metadata.json','*.correct-path.metadata.json'))
f=out/'derby_fixed_completion.py';s=f.read_text();s=s.replace("identity = positions(r'APP_ID local\\.derby')","identity = positions(r'(?:I \\([0-9]+\\) app: )?APP_ID local\\.derby')").replace("ready = positions(r'DERBY READY tones=(?:true|false)')","ready = positions(r'(?:I \\([0-9]+\\) js: )?DERBY READY tones=(?:true|false)')").replace("sum(line.startswith('APP_ID') for line in lines)","sum('APP_ID' in line for line in lines)");f.write_text(s)
f=out/'verify_derby_recorded_trial.py';s=f.read_text().replace('configured_expected_firmware_sha256=elf','expected_firmware_sha256=elf')
anchor='    # Both independent parsers remain mandatory.'
extra="""    require(collection_plan['firmware_verification'] == 'successful_flash_receipt' and
            collection_plan['flash_job_id'] == flash_job['id'], 'typed_flash_binding_required')
    expected_binding = dict(schema_version=1, principal_id=flash_plan['flash_principal'],
        device_id=flash_plan['device_id'], device_fingerprint=flash_plan['device_fingerprint'],
        flash_job_id=flash_job['id'], flash_plan_hash=flash_job['plan_hash'],
        firmware_receipt=flash_summary['last_known_good_receipt'],
        build_job_id=manifest['build_job_id'], build_plan_hash=manifest['build_plan_hash'],
        source_receipt=source['source_receipt'], source_commit=source['commit'],
        manifest_sha256=digest(manifest), modeproof_sha256=digest(proof),
        derby_detail_mode=expected_detail, expected_elf_sha256=elf, expected_app_bin_sha256=image)
    require(collection_plan['collector_binding'] == expected_binding and
            binding['flash_receipt'] == expected_binding and
            binding['principal_id'] == expected_binding['principal_id'] and
            collection_plan['broker_epoch'] == flash_plan['broker_epoch'] and
            collection_plan['session_id'] == flash_plan['session_id'], 'typed_flash_binding_mismatch')
"""
assert anchor in s;s=s.replace(anchor,extra+anchor);f.write_text(s)
sys.dont_write_bytecode=True;sys.path.insert(0,str(out));stub=types.ModuleType('verify_diagnostic_build');stub.prove=lambda *a:(_ for _ in ()).throw(RuntimeError('Actual BIN/ELF prove not available in this host metadata candidate test'));sys.modules['verify_diagnostic_build']=stub
from derby_fixed_completion import parse_completion
from derby_fixed_result import parse_collected
from derby_detail_result import parse_detail
from verify_derby_recorded_trial import verify_recorded_trial
rd=lambda n:json.loads((p/n).read_text());raw=(p/'on-trial-raw-private.log').read_bytes();job=rd('on-trial-result-private.json');receipt=rd('on-transport-receipt.json');manifest=rd('on-build-manifest.json')['manifest'];proof=manifest['diagnostic_modeproof']['proof'];fp=rd('on-flash-plan.json')['plan'];fj=rd('on-flash-result.json');fs=rd('on-flash-summary-request-bound.json');tp=rd('on-trial-plan.json')['plan'];head='b561aea1c0798feb28055a00d36681fae81ac58a'
def verify(data,transport,j,plan=tp):return verify_recorded_trial(data,transport,proof,manifest,fp,fj,fs,plan,j,expected_head=head,expected_detail='ON')
assert raw==base64.b64decode(job['fixed_trial']['raw_base64']) and sha(raw)==receipt['sha256'] and len(raw)==receipt['bytes'];assert parse_collected(raw,receipt)==job['fixed_trial']['parsed'];assert len(parse_detail(raw.decode(),expected=True))==3
result=verify(raw,receipt,job);tests=[{'case':'actual_timestamp_ON_export','pass':True}]
mutations={'wrong_identity_tag':raw.replace(b'app: APP_ID local.derby',b'js: APP_ID local.derby',1),'wrong_ready_tag':raw.replace(b'js: DERBY READY',b'app: DERBY READY',1),'duplicate_identity':raw+b'I (999999) app: APP_ID local.derby\n','missing_ready':b''.join(x for x in raw.splitlines(keepends=True) if b'DERBY READY' not in x),'missing_owner':b''.join(x for x in raw.splitlines(keepends=True) if not x.startswith(b'DERBY_DETAIL_EXIT ')),'late_fault_after_HOME':raw+b'InternalError: interrupted\n'}
for name,data in mutations.items():
 try:parse_completion(data,detail_enabled=True)
 except ValueError as e:tests.append({'case':name,'rejected':True,'reason':str(e)})
 else:raise AssertionError(name)
for name,mutate in [('tampered_record_expected_elf',lambda j,pl:j['fixed_trial']['binding'].__setitem__('expected_firmware_sha256','0'*64)),('tampered_record_flash_receipt',lambda j,pl:j['fixed_trial']['binding']['flash_receipt'].__setitem__('firmware_receipt','0'*64)),('tampered_plan_mode',lambda j,pl:pl['collector_binding'].__setitem__('derby_detail_mode','OFF')),('tampered_plan_source',lambda j,pl:pl['collector_binding'].__setitem__('source_commit','0'*40))]:
 j=copy.deepcopy(job);pl=copy.deepcopy(tp);mutate(j,pl)
 try:verify(raw,receipt,j,pl)
 except (ValueError,KeyError) as e:tests.append({'case':name,'rejected':True,'reason':str(e)})
 else:raise AssertionError(name)
assert original=={str(f.relative_to(ref)):sha(f.read_bytes()) for f in ref.rglob('*') if f.is_file() and '__pycache__' not in f.parts}
patches={}
import difflib
for name in ['derby_fixed_completion.py','verify_derby_recorded_trial.py']:
 before=(ref/name).read_text();after=(out/name).read_text();patches[name]=dict(original_sha256=sha(before.encode()),candidate_sha256=sha(after.encode()));(out/(name+'.patch')).write_text(''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='parser-reference/'+name,tofile='parser-candidate/'+name)))
status=rd('status-stopped.json');release=rd('on-release.json');assert release=={'ok':False,'error':'invalid_session'};assert status['active_job'] is None and status['owner'] is None and status['lease_remaining_seconds']==0 and status['execution_uncertain'] is False and status['safety']['current_resource_uncertain'] is False
report={'verdict':'OFF_HELD_ORIGINAL_J1_GATE_MISMATCH_REPRODUCED_HOST_CANDIDATE_PASSES','scope':'Local host candidate only. Original parser/reference/raw unchanged. No API/MCP/device/USB/replay/new firmware/build.','official_collector':{'state':job['state'],'result':job['result'],'terminal_success_verified':job['fixed_trial']['terminal_success_verified']},'original_J1_gate':'completion_missing_or_duplicate_marker; APP_ID/READY require bare lines; verifier additionally expects obsolete configured_expected_firmware_sha256','actual_markers':{'identity_line':3,'identity_tag':'app','ready_line':10,'ready_tag':'js','END':238,'EXIT':239,'STOP':241,'HOME':242},'raw_bytes':len(raw),'raw_sha256':sha(raw),'candidate_changes':patches,'host_candidate_metadata_gate_pass':result['recorded_chain_matches'],'host_tests':tests,'negative_cases':len(tests)-1,'actual_ELF_prove_recomputed':False,'prove_import_stubbed_host_metadata_only':True,'limitations':['Function test uses already provider-verified proof; CLI actual BIN/ELF prove was not rerun and is explicitly unavailable in the host test stub.','Candidate is not a new firmware head or original exact-J1 parser acceptance. Official collector success is preserved; original project strict completion discrepancy remains a stop reason.','OFF not started, no ON rerun authorized or executed.'],'lease':{'release_result':release,'final_idle':True,'owner':None,'lease_seconds':0,'current_uncertainty':False,'interpretation':'Release was not successful; invalid_session after expiry with idle status is consistent with no active lease. No fresh physical state is inferred.'},'original_reference_hashes':original,'input_sha256':{n:sha((p/n).read_bytes()) for n in ['on-trial-result-private.json','on-trial-raw-private.log','on-transport-receipt.json','ON-PARSER-DISCREPANCY.json','status-stopped.json','on-release.json']}}
(out/'HOST-CANDIDATE-RESULT.json').write_text(json.dumps(report,indent=2)+'\n');(p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.json').write_text(json.dumps(report,indent=2)+'\n')
(p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.md').write_text('''# J1 ON parser discrepancy — OFF held

公式collector成功と原本J1 strict gate不一致を確認。実rawのAPP_IDはapp tag、DERBY READYはjs tagの正規timestamp付きだが、原本parse_completionは両者をbare行限定で拒否。END238→EXIT239→STOP241→HOME242は各1。原本verifierはactual expected_firmware_sha256/flash_receiptに対しobsolete configured_expected_firmware_sha256を参照する。

parser-candidate内の2ファイルだけを最小修正: anchored app/js timestamp対応とduplicate/relaunch拒否維持、actual typed flash bindingの全field/source/modeproof/image/current receipt一致を必須化。実ON exportの候補host metadata gateがPASS、誤tag/重複/欠落/latefaultとbinding改竄10負ケースを拒否。patchと結果をcandidateへ保存、原本/raw不変。

BIN/ELF actual proveは未再実行（host testは既存verified proofを使用しprove importだけ未実行stub）。候補PASSはoriginal exact-J1 gateや新firmwareの受入ではない。OFF停止、ON再試行/新buildなし。releaseはinvalid_sessionで成功ではなく、期限切れ後statusはidle/ownerなし/lease0/current uncertaintyfalse。API/USB/実機/prepare/execute/設定操作なし。
''')
for f in [p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.md',p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.json',out/'HOST-CANDIDATE-RESULT.json']:os.chmod(f,0o600)
print(json.dumps({'candidate_pass':True,'negative_cases':len(tests)-1,'originals_unchanged':True,'raw_sha256':sha(raw),'review_md_sha256':sha((p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.md').read_bytes()),'review_json_sha256':sha((p/'INDEPENDENT-J1-ON-PARSER-DISCREPANCY-REVIEW.json').read_bytes())}))
