# DERBY詳細 v2実機結果（進行中）

baseline `37af4225ad329aac4c5e79c880d7d69760b770be` は正式source/build/proof/flash/readback/bootと、v2有限計測のローカルstrict受入までPASSした。trialは2026-10-20 01:10:30 UTC終了。3 dependent repsすべてquality0/valid1、work_us=6775160/6772381/6767447。1版1 fresh flash boot、1計測job内3 dependent replayであり、3独立boot試行ではない。native/batchはまだ実行していない。

job IDは `derby-v2-baseline-{source,build,flash,fixed}-37af4225-20261020`。sourceは00:56:39、buildは01:00:35に成功。詳細・fixed workload・telemetry・measureがON、seed2545F491、df_detail_exit_record必須。manifest/proofのBIN `63f35801715ce8f211a7ded14c138f1e9a6a40415bc39170660f92c779743e7d` / ELF `e2e49a8637d0ef0ee3c7f839c7323f76d5d230e66e474216419a7ba21f7c3a3b` がflash planと一致。全segment readbackと期待ELF prefix/IDF6.0.1のboot観測が成功した。verified flashの成功とLKG更新はMCPがclose/authority gate後に確定し、自動restoreしていない。

測定planは `protocol=pocketjs-derby-fixed-v2`、`fixed_workload.terminal_contract=end_owner_exit_stop_home_v2`、retry0/max200s/64KiB/1024B行を確認した。readback envelopeは別名 `terminal_contract=owner_exit_v2` と terminal_success_verified=trueを返す（exact MCP derby_reports.py L133）。ローカル検査はこの2つの実定義名を厳格に使い分ける。v2契約の緩和や旧契約へのfallbackではない。

rawは30,931B、duration87,918ms、SHA256 `8dca87258c207e6aceb2f373f8ef99cf59e5c81a6576ecca1c99d7686463662a`。complete=true、gap/overflow/truncated/partial_tail/disconnect/reset/refusedは全false。全受信bytesを保存し、何も削除せずexact firmware treeのparse_trial/parse_detail(expected=True)へ入力した。END/EXIT/STOP/HOMEは1-based237/238/240/241行、同sessionで各1回。例外/late faultなし、brokerのquiet境界とconfirmed close後の成功、ローカルschema/accounting/work/quality/詳細26stage・13eventを一緒に確認した。独立レビューのbuild/prepare結果とtrial結果は independent-v2-review/ を参照（保存時点ごとのreview範囲に注意）。

固定試験receiptのinstalled image欄だけではimageを認証しない。exact source→登録build/proof→全hash readback/boot→同lease/epoch/device fingerprint→trialという別の所有/実行連鎖を保持する。物理LCD視認、純transfer時間、target詳細OFF overhead対照は今回の受入範囲外。elapsedはpreemption/waitを含み、bytesは論理量。旧90b9のAPP ERROR試行strict全体FAILは保持する。

旧20 toolsのmetadataは01:06:13 UTCに22 toolsへ更新を確認。新list_registered_targetsでcardputer-main/cardputer、新read_source_resourcesで14/16 snapshots、1,208,222,435B、44,644entries/2,981ms、pending0/remaining2slotsを正式に読取確認した。新include_source_cache引数も公開され、正式ログ読取で使用した。metadata不足は解消済み。

buildログ読取で通信エラーが1回発生したが、既存jobのrunningを確認し同cursorからgapなしで回収した。実行再送・中断・code/config/auth/cache変更・broker再起動なし。source prepare/executeは各工程1回だけ。旧scan失敗jobを再利用していない。baseline完了後idleを確認してleaseをrelease済み。次は承認済みnative、次いでbatchを同gateで直列実施する。

コード/完全patch/offline復元物は既存private Library `libfile_06b2952610cc81918ed4a817993cb700`。今回baseline source/buildの早期退避は `libfile_57dced8d764081919da4de1a4b06f8a3`、SHA256 `8c4aa9ef9c993f4cff31379f777dfa7894dc5eb1c3eabeb086c60c7989910bc3`。baseline受入後raw/receiptの追補IDはZIP外側のV2-BASELINE-ACCEPTED-LIBRARY.jsonに記録する。
