#!/usr/bin/env python3
"""Summarize saved correction evidence without claiming target runtime success."""
from pathlib import Path
import json,datetime,hashlib
b=Path(__file__).resolve().parent;j=json.loads((b/'PUBLICATION.json').read_text())
out=['# DERBY固定controller分割：実装修正・復旧資料','',
'3比較版の固定診断controllerをstrict globalの別chunkへ分け、元の位置から同期loadする共通修正を公開した。元headと実機失敗証拠は保持。修正版の実機OOM解消・性能は未検証であり、全体完了とは扱わない。','',
'| 版 | Draft PR | exact correction head | 保持した元head |','|---|---|---|---|']
for v,x in j.items():out.append(f"| {v} | [PR{x['pr']}]({x['pr_url']}) | {x['remote_commit']} | {x['parent']} |")
out+=['',
'branchはfix/derby-detail-controller-{baseline,native,batch}-20261020、PR baseは各feature/derby-detail-* branch。既存PR21/22/23のheadと元checkoutは変更せず、main mergeなし。GitHub Git dataで公開したcommitをSHA照合してlocalへimportし、local/publicのhead/tree一致・cleanを確認。通信proxy503でCLI GitHub APIが使えなかったため、認証済みGitHub connectorの正規Git data APIを使用した。','',
'## 変更と契約','',
'全3版の変更10fileは同一bytes。詳細ON/OFFも同じchunk配置にして、計測instrumentation以外の比較条件をそろえた。生成playは元wrapperの場所でpocket.app.load(fixed)を同期実行し、その成功後に元enter(pad)/READYへ進む。watchのprog→view→scene→pan→play呼出順は不変。nestedなのでAPP_LOAD完了ログはfixed→playの順となる。controllerは明示strictで同じrealmのglobal lexical stateを使う。','',
'controllerの欠落・syntax/runtime例外・strict違反は起動失敗として伝播し、READY/測定開始へ進まない。例外のfilename/causeと外側playのcompile/run・retry分類は分割前と異なる。完全に同じ例外文言やretry分類とは主張しない。fatal interrupt/timeoutを緩和するC変更、fallbackや再試行は追加していない。','',
'固定fixture・seed・camera・390→510/120contexts・3 dependent replay・8step tail・250ms watchdog/180秒session、C計測/VM/描画/同期I/O、heap/stack予算は変更しない。controllerをinlineへ戻すと各旧headのON/OFF生成playとbyte完全一致。通常アプリとnative CのOFF bytesも維持。proofはcontrollerのgenerated fileとELF内完全bytesを追加検証し、欠落・改変・strict欠落を拒否する。','',
'新しく分けたcontrollerを実機でcompileした際の追加call stack/起動費用は未測定。前段sequential候補のhost peak186360→173684Bは、このnested実装や実機RAMの値へ流用しない。','',
'## ローカル検証','',
'| 版 | check数 | 完了 | fixed O2/ASan ON/OFF |','|---|---:|---|---|']
for v in j:
 r=json.loads((b/v/'HOST-CHECKS.json').read_text())
 out.append(f"| {v} | {len(r['checks'])} | {'PASS' if r['all_pass'] else '未完/FAIL'} | "+' / '.join(f"{x['name']}={x['exit_code']}" for x in r['checks'] if x['name'] in ('fast-off','fast-on','asan-off','asan-on'))+' |')
out+=['',
'全3版×O2/ASan×ON/OFFの12 actual fixed実行、36 dependent windows。120contexts/4975draws、input986b2e6e027af00d、procedural pixelc1b0fdbde748d0de、panelcec4b765a2794b14、race finish5DC86E18、logical events/stage calls一致。strict schema/accounting、collector/終了契約、old synchronous tail拒否、6 startup probesを確認。通常host回帰3件と追加のbatch runner oracleもPASS。全checkのcommand/exit/log hashは各HOST-CHECKS.json。時間比はhost overhead参考値でtarget性能ではない。','',
'独立レビューはindependent-review/に収録。reviewerは保存rawを現parserで再解析し、10file hashes、新public head/tree、48checks＋batch runner、最終10runs/23jobsと6target proofを照合した。最終判定はCONTROLLER-FINAL-CI-REVIEW.md/JSON。試験binaryや実機の再実行ではない。','',
'途中失敗も保持：初回ON driverはinstrument済watchに対するNode oracleのS未定義で失敗。計測境界をpure simulation oracle内でno-opにして再実行した。failed-attempt-001/と進捗logを残し、初回をdriver全体PASSに数えていない。','',
'## CI / target proof','']
ci=b/'CI-FINAL-SUMMARY.json'
if ci.exists():
 x=json.loads(ci.read_text());out+=['同じDERBY workflow定義を各新public headで実行し、10runs/23jobsすべてcompleted success。旧headの結果を流用しない。', '', '| 版 | exact-head CI jobs |', '|---|---:|'];out += [f"| {v} | {q['passed']}/{q['total']} success |" for v,q in x['per_variant'].items()];out+=['', '6件の詳細ON/OFF target proofをCI実ログから検証し、offline復元repoの検証器でも再解析PASS。head/tree・4生成file/controller・fixed seed・BIN/ELF pair・mode・submoduleを照合。詳細static stateはON2304B/OFF0B、compilerの関数単体最大stackは2992B（call chain/実行時高水位ではない）。target実機受入はfalse。2補助workflowはpath filter不一致で未起動、PASSに含めない。CI-FINAL-SUMMARY.json、CI-JOBS-FINAL.json、CI-TARGET-PROOFS.jsonを参照。']
else:out.append('exact public headのCI実行中。CI-RUNS-LATEST.jsonを参照。以前の29/29 PASSを新headへ流用しない。target link/m32/ONOFF proofが完了するまでPASSとは扱わない。')
out+=['',
'ローカルの依存初期化はbmi270取得時のGitHub CONNECT tunnel proxy503で失敗。既存checkoutにも必要な依存sourceはなく、local full target linkは未実行。CMake/Ninjaを使った実際のchunk選択fragmentは各版7testsの一部としてPASS。未実行をPASSにしない（DEPENDENCY-BLOCKER.json）。','',
'CI-ARTIFACT-INVENTORY.jsonに6detail target archiveと別3fixed-firmware archiveのID/head/digest/期限を保存。detail target uploadはJSON/map/txt/sdkconfig/SHA/.suだけで、同6件のbuild_detail BIN/ELF本体は対象外。別build_fixed archiveにはBIN/ELFがあるが、baseline ZIPのworkspace downloadもproxy503で失敗し、今回local実体は取得できていない。CI内のBIN/ELF pair照合とlocal保存・再hashを区別する。期限は2026-11-03 UTC、CI-ARTIFACT-DOWNLOAD-BLOCKER.jsonを参照。', '', '## 実機状態と次担当','',
'実機は旧batch ea64b0ecのまま。旧job derby-v2-batch-fixed-ea64b0ec-20261020（01:43:53 UTC終了）はneeds_review/serial_fault_marker、play compile OOM、測定窓0、valid=false/terminal_success_verified=false。serial close/idle/lease解放済み。今回、新たなMCP source/build/flash/計測、追加接続/reset/recovery、直接USBは行っていない。旧baseline/native受入結果は旧headの結果として保持。修正版で遡及的に成功へ変えない。','',
'次担当は親thread。修正結果と新head proofを確認し、登録source/build profile・固定collector契約・復旧手順・排他所有を含む実機再試験手順を調整する。新head source/build/flash/有限計測とtarget OFF overhead対照、独立boot反復、追加stack/heap実測は未完。アプリ正常起動を確認するまでflash LKGを正常動作保証にしない。','',
'## 復旧と保全','',
'prior-device-v4.zipは以前の全コード・完全patch・commit bundles・host/CI・2受入実機raw・batch OOM rawの完全checkpoint（SHA256 6094ba0e158c7b7eb69c9a6c7779e0b4993b0e4c7d5c93a52d4bdad6dc223a68）。今回の各variant/source、correction.patch、complete.patch、correction.bundle、published.commit、SOURCE-CHECKPOINT.json、PUBLICATION.jsonを追加した。SDK・全submodule履歴は収録しない。','',
'復元先は空の新directoryだけを許可する。','',
'python3 restore_correction.py --variant batch --destination /workspace/restored-controller-batch','',
'batchのoffline復元を実行しexact711f94fa/tree160205ec・10変更file・完全patch hash一致を確認（RESTORE-SMOKE.log）。復元は新しいCIや実機試験を実行しない。Library stable IDはlibfile_54f384d164808191a369081825204874。最新version/file ID/外側ZIP hashは自己参照を避け外側CONTROLLER-LIBRARY.jsonへ保存。SHA256SUMSは収録全fileを検証。共有link・秘密・生ログの公開なし。','']
(b/'REPORT.md').write_text('\n'.join(out))
print(json.dumps({'report':str(b/'REPORT.md'),'hardware_tested':False,'ci_final':ci.exists()}))
