# Batch ON実機受入：PASS、凍結3版の結果

新batch PR27 head711f94fa91c6e0d6ba7bc00def75ad686b724c7dの正規source/build→flash/readback/boot→ON固定計測1回が合格した。旧ea64b0ecのOOM記録とは別の実績として保持する。新OFF/DMA変更を混ぜず、凍結baseline/nativeと同条件を維持。結果は各段階で証拠整理を待たず先行報告した。

## Exact identityと実行

- branch fix/derby-detail-controller-batch-20261020はclean、tree160205ec7e435a6592378d94209a800c02ba2c91、[Draft PR27](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/27)。本工程でコード/head/PR/CIを変更していない。
- source job derby-controller-batch-source-711f94fa-20261020：06:25:54→06:26:23 UTC成功。receipt c0e622dd6c7488f3d1271108cb11304eab611f3df9c36a8a45831752a2a9fdbd、source SHA256 8fccff5bada935d7e8383c1b48c9ebb73312b453f6b5c0ab5cd4edad7cf2186b。
- build job derby-controller-batch-build-711f94fa-20261020：06:27:14→06:29:55 UTC成功。2122連続provider entries、verified durable manifest、唯一mandatory diagnostic proofとbatch専用runner proofを保存。IDF6.0.1/esp32s3、同登録profile、telemetry/measure/fixed/detail 4ON、hardware seed2545F491を確認。
- BIN2298416B SHA256 8daa2cb79582de437d48a16f2366eb2a748b5871ca1acc490506765b5a20a47c、ELF20051584B SHA256 1093bc46b5987042ce8e0c110daf328339eb641a89f5e957ef7471c1d2c4850f。
- flash job derby-controller-batch-flash-711f94fa-20261020：06:32:04→06:36:55 UTC succeeded / firmware_flash_completed。plan6d59733f485ad6cb69e26e96036e3010413e6dae0014bad44d8a82dff681845d。
- current比較元は成功・受入済みnative正式receipt1f4143a623658f01ec1d8d7623b65bc4268fb8b690ed6c106ea0f5c425de63f5。対象firmware 3領域のROM bytes一致後にwrite、全segment SHA256 readbackとIDF6.0.1/ELF prefix1093bc46b、HOME_READY/closeを検証した。8MiB全flash読取やboot text単独のattestationではない。
- flashの233連続provider-decoded entriesはgap/expired=false、fatalなし。成功commit後の新batch正式receiptは **916b1fe2dc4bea181bea6ce71958f995725cba185231706a2fd0d861b92daefe**。

## ON固定計測

- job derby-controller-batch-fixed-711f94fa-20261020：06:37:51→06:39:21 UTC succeeded / derby_fixed_trial_verified / serial_close。plan5d310c36c3f67342473472341984b90d898b9450374f26e20a21cb969357bf81。
- fixture oval-pan8-390-510-v1、fixtureseed9112A7AB、race1000001/cam8/tier1、390→510の120 completed contexts、3 dependent replays。watchdog/session/tailも既存build仕様を維持。
- work_ms：**6606.158 / 6604.002 / 6608.389**。全quality=0・valid=1。
- raw31000B、SHA256 cde6ecae18d01e7cdb854320b227b48496852c17799f201536a090343b0c12c8、duration85881ms。complete=true、gaps/overflow/truncated/partial_tail/disconnect/reset/refused全false。
- END line237→同session owner EXIT238→APP_STOPPED240→HOME_READY241。owner_exit_v2 terminal_success_verified=true、quiet boundary後のserial closeをproviderが成功commitした。
- 保存rawへのcurrent exacthead parse_collected/parse_detailもPASS。known batch work、全summary/26 detail stages/13 events、schema/階層計算/owner終了順序/全transport内fatal拒否を確認。device quality値だけをtransport証明に代用していない。
- collectorのconfigured_expected_hash_onlyは単独の実物image証明ではない。同device/session/epoch51bfd752bc2a460db00a835c45250282の直前exact flash/readback/bootへbindした。

今回の新headは正常完走した。これを旧ea64b0ecの失敗履歴の書換えや、あらゆるOOMの解消保証とはしない。

## 凍結系列の観測結果（DETAIL ON）

| 版/head | rep1 work_ms | rep2 | rep3 |
| --- | ---: | ---: | ---: |
| baseline dc2c5e04 | 6770.279 | 6770.404 | 6767.900 |
| native 3fafcadb | 6720.372 | 6723.824 | 6716.986 |
| batch 711f94fa | 6606.158 | 6604.002 | 6608.389 |

全版quality0/valid1。各版1 fresh flash boot・3 dependent replays、計3 bootsであり独立3試行/版ではない。FROZEN-SERIES-COMPARISON.jsonとfrozen-series-work.csvにexacthead、job、全rep、rawhashと入力hashを保存した。3版のproofから同fixture、同hardware seed、同environment fingerprint、4ON/IDF/targetを照合。OFF overhead、独立反復、信頼区間、統計的性能効果は未評価で、旧coarse計測値との単純比較にも使わない。

ACCEPTANCE.json、detail-stages.csv、detail-events.csv、DETAIL-STAGE-SUMMARY.jsonに内訳を保存。inclusive/selfはpreemptionを含むelapsedでありCPU占有・純transfer時間ではない。論理copy/write bytesと実bus trafficを区別する。物理LCD出力hashも未attest。

## 保全・再現・残工程

正規automatic source回収は旧未参照3ff8113 payloadのみ。旧18receipt/保護13payloadを維持し、固定上限/SDK/auth/configを変更していない。source/build段階をprivate Library v0へ先に保存し、最終ZIPにはv0をbytes不変で内包する。BIN/ELF本体はローカルZIPにmaterializeせずproviderのverified manifest/保持物を根拠にする。

正常baseline/nativeの受入・rollbackデータと旧batch OOM raw902B/SHA92b8e47e55c6aeeccc57e2e622154319b5c243499613418bb14b7020ca8232f6/resultを別保存。過去失敗を成功へ書き換えず、receiptのLKG名称をアプリ正常認定と混同しない。既存baseline Library v2/native v1/maincode v7は変更していない。

lease解放済み、V8 capability消去。final brokerはidle/ownerなし/queue・session・lease0、current execution/ownership/profile uncertainty=false。historical needs_review9はそのまま。追加reset/HELLO/backup/restore/自動再flash/直接USB/新OFF-DMA実機試験はしていない。

保存ファイル再検証はexactheadの/workspace/derby-controller-batchを用意し、このfolderのverify_source_build.pyとverify_trial.pyをpython3で実行。実機/MCPを呼ばない。各段階の独立reviewはINDEPENDENT-BATCH-*.md/jsonに別保存し、旧reviewを変更しない。生ログはprivate限定。

今回batch ONと凍結3版の受入範囲にblockerはない。OFF正常終了契約、新DMA重なり、独立反復/詳細OFF対照は別工程で未実行。次の実機操作は親の新指示待ちとする。
