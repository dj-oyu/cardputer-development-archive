# Independent preliminary current-receipt plan review

予備結論: 保存済みpreflight/plan/保全データは整合する。**進行中snapshotのみであり、flash成功・正常起動・新baseline実機PASSは未判定。** reviewerはlocal読取/解析とこのMD/JSON保存のみ。API/MCP/USB/job/source/build/config/code操作0、test追加0。

新AUTHORIZATION-SCOPEは、完全な旧batch current receiptを使うbaseline flash一度→正常boot→ON固定trial一度だけを許可し、uncertainty・gate拒否・current不一致・fatal/OOM停止、別receipt推測/再試行禁止、native/batch/OFF・直接USB・guard/config/auth変更禁止を明記する。以前の拒否を無視した再実行ではなく、新しい明示指示とexact current receiptに基づく別jobとして扱う。

- 新job `derby-controller-baseline-flash-current-dc2c5e04-20261020` / plan `829e0ae03117682955f0109d9f905ec4c591ead1994d4213df2df6dcef00f6a0`。epoch `51bfd752bc2a460db00a835c45250282`。preflightはidle・ownerなし・current uncertainty=false、新job重複なし。
- current比較入力 `5e1fa311d4a565672d27b5bff976fb04e30c92ff993bcf51f05fe07693a70b22` は保存済み旧batch正式flash/readback receiptと一致する。旧正常baseline rollback receipt `e9a33d3e3d0a9c1809a4238efc42c85cf440837ec62466c5c52326ddd69c761a` は別に保持。旧batchはcurrent比較対象であり、正常アプリへの再分類ではない。
- source `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` / tree `d72a737240d48def898899bf6dc71e0ac627c7f8`、verified source/buildと4modeONが一致。BIN `ae7ec8ec1fddd0238003c903fafe7c6de47ffe3c1e7df7c3b7b08a94f861578b` / ELF `f149d372f186a0e6642d2d929db1cbf1ae6cd2f8163458832b2024f0074c7962` は同じlinked proof。canonical manifest SHA `0a6a2a8c37f9902751d53b6b5fbcc56ab78064adf4e2749673a67dfcd52b9299` を再計算して一致。
- 旧失敗planから変わったfieldはjob_id/session_id/fingerprint/lkg_receipt/backup_sha256だけ。device/build/images/registration/stages/effects/argv等は同じで、gate緩和は認めない。

旧OOM raw/resultは元保存値・receipt base64と同一、902B/SHA92b8e47…8232f6、terminal_success=falseのまま。旧正常baselineのstrict成功記録も別途保持。先の失敗gate private packet v1は保存Library receiptとlocal ZIP SHAe7d4158d…5e5c20が一致。旧履歴を消去していない。remote Library再取得やrollback実行は行っていない。

予備snapshotは`flash-poll-002-job.json`: running / flash_backup_prewrite_check / resultなし。ログseq1…17にgap/expiredなし。22,528Bと3,072BのROM read完了後、旧app領域2,298,336Bのうち934,912B読取まで保存され、write stageはまだ記録されていない。前段から進んだことと整合するが各region比較結果が明記されていないため、全current比較完了とは断言しない。今後新しいlogが増えても本reviewはこの固定snapshotへの予備判定である。

未完: terminal flash/readback/boot証拠、および新baseline ON固定1runのraw/strict/終端契約。親の唯一executorが継続し、こちらは追加操作しない。24確認と入力hashを`INDEPENDENT-CURRENT-RECEIPT-PREFLIGHT-REVIEW.json`に保存。
