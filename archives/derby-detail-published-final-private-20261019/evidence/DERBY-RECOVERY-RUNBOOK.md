# DERBY WATCH 作業が停滞した場合の復旧手順

保存日2026-10-19。将来の同種復旧で参照するための記録。これ自体は公開・削除・実機操作の新しい許可ではない。

1. 旧担当のstatus/進行中job/保全状態を確認する。通信停滞と実行拒否を混同しない。旧環境WIPのZIP/checkpointが新環境にもあると仮定せず、取得できなければ仕様再構成と明記する。旧担当が停止・所有権移譲する前に同じ実機へ進まない。archive/削除は別の明示根拠が必要。
2. 選択環境で最初のファイル読取と実着手を短く報告。AGENTS/関連skill/CLAUDE等を読み、既存checkoutとユーザー変更を保護する。exact commitを確認し、独立比較版を累積版と混同しない。今回はbaseline0c52600f/native44f9c561/batch3a641d4d。PR16/17や別アプリへ範囲を広げない。
3. Git proxy503やSDK不足を具体的に記録。保存済みCMake/Ninja環境を使用し、未実行をPASSにしない。認可されたGitHub読取でcommit/tree/blobを再構成する場合、Git SHAを検証し、意図的shallow境界と不足履歴を記録する。旧コード同一とは主張しない。
4. 早期にprivate Libraryへ完全patch・source・manifest・検証証拠・復元helperを保存し、file ID/bytes/hashを返す。success判定はツールstatus=succeeded。返却xattrsを適用し、既存file IDとの関連を保持する。秘密/実機raw/個人環境pathは公開repoへ出さない。Library不可ならlocal checkpointを残し正確に報告する。
5. 公開/CI/実機の権限を分ける。自動承認が拒否した操作をCLI等の別経路へ迂回しない。拒否target/action/reason/実行済み範囲を保全。新しい関連証拠/明示承認が届き、未実行が確定したときだけ、その操作を一度再試行する。不確定なら先に状態確認。今回はGitHub main/main.c blobは404、3ref未更新を確認し、ユーザー本人の具体的な公開承認後の一度の再試行で成功した。それ以前の拒否履歴は消さない。
6. source取得・build・flash・計測は正式USB Device Connection MCPの登録済みoperationだけ。直接USB、任意shell、認可/登録/server変更、cache削除/limit変更を復旧の代替経路にしない。leaseのcapabilityを表示/保存しない。source/buildは非USB、flash/有限計測は単独所有・直列・一度だけ。queued/runningを再executeしない。失敗/不明なら次版へ進まず証拠優先。
7. 長いbuild/flashはlog cursorをページ終端まで読み、gap/expired/has_moreを保存。完了した有限trialはjob_statusのfixed_trial.raw_base64/receipt/bindingを短期cacheからすぐ退避する。固定trialにread_device_logsやcaptureが使えないことがある。利用不能を記録し、無い生ログ/画像をあると言わない。
8. transport完全性、3summary、END、runtime fault、STOP、HOMEを全体で判定する。coarse validはstrict detailed PASSではない。今回の旧job derby-detail-baseline-fixed-90b9f686-20261019はEND後InternalErrorで不合格。旧rawをsanitizeして遡及PASSにしない。
9. app.exitの意図的interruptと250ms watchdogは同じInternalErrorになり得る。例外を一律許容せず、正常guest return/DONE/queueなし/stopなし/last deadline内をownerが確認し、native EXIT、既存teardown/STOP/HOMEへ渡す。EXIT後hook失敗も拒否。詳細wireはMCP-DETAIL-WIRE-CONTRACT参照。expected modeはverified buildに結び付け、欠落したdetailをOFFと推定しない。
10. USB報告の40行burstを1native callへ積み上げない。測定窓/tail後に1record/frameでreturn、最終ENDも独立frame、250msのsession reserve。tail最大8step/frameを維持する。ENDとowner EXITは同tickとなり得るがEXITはJS stackの外。全owner tickの厳密250ms保証や純bus transferとは言わない。
11. strict parserにはbare hostと正しいIDF app/shell tagの完全一致を許し、wrong-tag/重複/順序/欠落/前後例外/partialを負例で固定。実機rawにhost-only表現を要求していないか確認する。schema/version、owner-only scopeのexclusive/inclusive、foreign task/ISR不介入、論理bytesと実bus量の区別を維持する。
12. source cacheのsnapshot枠/bytes/走査時間は別の制約。source_cache_scan_limitは今回の実装では5秒/100万entry走査制約で、slot満杯と同義ではなかった。親が許可した別Windows担当のread-only診断で実数/空容量を照合した。空きがあっても安全preflight失敗中はsource/flash停止を維持。既存receiptを別headへ転用しない。
13. 実ELF検証で追加されたAPIの正確なON/OFF symbol契約を確認する。今回はdf_detail_exit_recordのallowlist漏れで実target proofが失敗。検査を削除せず、ON必須/OFF禁止/未知拒否の修正と負例を追加した。runtime sourceが同じでも実target linkを未実行扱いにし、最終head CIで再確認する。
14. 一過性のCI public-source download失敗は同headの失敗jobだけを再実行し、成功jobは無用に繰り返さない。GitHub CI内のdownload試験と、実MCP source cacheへの取得を区別する。前者の失敗/再試行receiptも保存する。
15. API作成commitはローカル候補とSHAが異なり得る。tree/parents/変更file hashを照合し、unsigned commit rawを再構成してGit SHA1を確認。候補をcheckpoint branchに残し、公開refのexact headをCIのsource/BIN/ELF proofへ結び付ける。新treeへ復元するときはrefだけ動かさずindex/worktreeも正しいcheckoutに揃え、空destinationで全file/完全patch/hashを試験する。
16. 親へは長時間の抽象的な『作業中』でなく、UTC・exact head・run/job ID・現在の具体的step・API実接続/owner/active/uncertainを短く返す。GUIのlive更新不良だけで進行中jobを重複実行しない。MCP read-only状態と物理USB/LCDの受入を分ける。
17. 最終成果には専用branch、完全patch、offline復元、host/CI/source/mode proof、private保存ID/hash、未完/denied/pending/uncertainを明記。compiler per-function stackはruntime high-waterではない。hostのdependent replaysは独立boot統計ではない。前frame同値pixels/strip比率を差分転送節約や性能効果へ直結させない。source/flash/mergeは後続の明示条件が満たされるまで進めない。

今回の最新版コード/CI/evidenceは最終checkpointのREPORT/CHECKPOINT/FINAL-CI等を優先し、途中のimmutable checkpointにある『CI未実行/公開拒否中』を現在状態と取り違えない。元のprivate rawと途中失敗も監査用に残す。
