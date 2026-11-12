# Native ON実機受入：PASS

凍結済みnative PR26 head3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5の正規source/build→flash/readback/boot→ON固定計測1回が合格した。1 fresh flash boot・3 dependent replaysであり、独立3試行ではない。新OFF/DMA変更を混ぜず、batchへ進んでいない。実結果はflash成功・計測成功・strict parser成功の各段階で、Library整理を待たず先に報告した。

## Exact source/imageと実行

- branch fix/derby-detail-controller-native-20261020はclean。treeb3de719ac438d8d3373a2c34786bc35c46e9200e、[Draft PR26](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/26)。本工程でhead・コード・計測条件・PR/CIを変更していない。
- source job derby-controller-native-source-3fafcadb-20261020：06:04:31→06:05:00 UTC成功。receipt bbf729af426e3110943d2fcad025311b1d088b773c0cecdbb53b4fde92e16679、source SHA256 2b6f8223ef87de643e976686905f7fe75346f39143ea5cbdd3e00210e1200e3d。
- build job derby-controller-native-build-3fafcadb-20261020：06:06:29→06:09:32 UTC成功。durable manifest verified、2120連続provider entries、唯一linked image proof、同IDF6.0.1/esp32s3/profile、telemetry/measure/fixed/detail 4ON、hardware seed2545F491を確認。
- BIN2296944B SHA256 aeb601df47809fb6b651ee265a41dcbf727520dd0678c1030bd8e3c1ffd892b1、ELF20046164B SHA256 0e8abb684ab242633288861488a969f15f91bfb004dd37708d2a793c8f0e80d4。
- flash job derby-controller-native-flash-3fafcadb-20261020：06:12:08→06:16:58 UTC succeeded / firmware_flash_completed。plan e9ca6b05be362112a14c0ef0e91ce23c29484398caf6fe7cab41417385df8d5c。
- 現物比較は直前に成功・受入済みbaseline dc2c5eの正式receipt e40bf864bafa4a3fdb94b418416ee90bda54801bfa4b0887c19e73d4a3889615へ完全bind。対象firmware 3領域のROM bytes一致後に書込み、全segment SHA256 readbackとIDF6.0.1/ELF prefix0e8abb684、HOME_READY、closeを確認した。8MiB全flash読取やboot text単独attestationという意味ではない。
- flashの231連続provider-decoded entriesはgap/expired=false、fatalなし。成功commitが保持した新native receiptは **1f4143a623658f01ec1d8d7623b65bc4268fb8b690ed6c106ea0f5c425de63f5**。

## ON固定計測と品質

- job derby-controller-native-fixed-3fafcadb-20261020：06:18:04→06:19:36 UTC succeeded / derby_fixed_trial_verified / serial_close。plan2b4f8297a27e537147985e4f3f3b573d76ada47d93319725bc8adfa660d1df2c。
- fixture oval-pan8-390-510-v1、fixture seed9112A7AB、race1000001/cam8/tier1、390→510の120 completed contexts、3 dependent replays。baselineと同じ固定条件、watchdog/session/tailのbuild仕様を維持。
- work_ms：**6720.372 / 6723.824 / 6716.986**。全quality=0・valid=1。
- raw31145B、SHA256 9dff6892ae8e86b3f972de57f12f438dc86140747f272747495ba3a6e939a9f4、duration87602ms。complete=true、gaps/overflow/truncated/partial_tail/disconnect/reset/refused全false。
- END line240→同session owner EXIT241→APP_STOPPED243→HOME_READY244。owner_exit_v2 terminal_success_verified=true、quiet boundary後のserial closeをproviderが成功commitした。
- 保存rawに現exactheadのparse_collectedとparse_detailを適用してPASS。known work、全summaryと26 detail stages/13 events、schema/階層計算/owner終了順序/全transport中のfatal拒否を確認。quality値だけをtransport受入に流用していない。
- fixed collectorのconfigured_expected_hash_onlyは単独の実物image証明ではない。同device/session/epoch51bfd752bc2a460db00a835c45250282で直前のexact flash/readback/bootへ結び付けた。

ACCEPTANCE.json、detail-stages.csv、detail-events.csv、DETAIL-STAGE-SUMMARY.jsonに3repの内訳を保存。inclusive/selfはpreemptionを含むelapsedであり、CPU占有や純transfer時間ではない。論理copy/write量と実bus trafficは区別する。OFF対照、独立反復、統計的な性能効果、物理LCD出力hashは今回未評価。

## 保全・再現・引継ぎ

保護付き正規source回収で旧50c43dfの未参照payloadだけを回収し、旧17receipt/保護12payloadを維持した。固定上限、SDK、auth/configを変更していない。詳細はSOURCE-BUILD-REPORT.mdとRECLAMATION-EVIDENCE.json。source/build成功時点のprivate Library v0を先に保存し、完全な証拠ZIPはそのv0をbytes不変で内包して同Library identityへ追記保存する。BIN/ELF本体はこのZIPにmaterializeせず、正規providerの検証済みmanifest/保持物を根拠にする。

成功済み新baseline receipt e40bf…、旧正常baseline rollback receipt e9a33d3e3d0a9c1809a4238efc42c85cf440837ec62466c5c52326ddd69c761a、旧batch OOM raw902B/SHA92b8e47e55c6aeeccc57e2e622154319b5c243499613418bb14b7020ca8232f6と失敗resultを別保持。旧失敗を成功へ書き換えず、receiptのLKG名称をアプリ正常認定と混同しない。baseline accepted Library v2も変更していない。

leaseは解放済み、V8 capability消去済み。final brokerはidle/ownerなし/queue・session・lease0、current execution/ownership/profile uncertainty=false。historical needs_review9はそのまま保持。追加backup/restore/reset/HELLO、直接USB、新OFF/DMA混入、batch実行はしていない。

保存データ再検証：exactheadの/workspace/derby-controller-nativeを用意し、`python3 verify_source_build.py` と `python3 verify_trial.py` をこのfolderのscriptへ実行する。実機/MCPを呼ばない。独立reviewはINDEPENDENT-NATIVE-*.md/jsonとして各段階別に保存し、過去reviewを変更しない。生ログはprivate限定。

native ON受入範囲の未解決blockerはない。親へ新nativeの完全receiptとimage/計測証拠を引き継ぎ、batchの次工程は親の新指示待ちとする。修正版batch/OFF対照は未実行。
