# Independent batch source/build review

受入範囲: batch exact source/buildとlinked DETAIL ON proof。**実機受入はまだない。** build `derby-controller-batch-build-711f94fa-20261020` は06:29:55 UTC succeeded/no_flash、source `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` / tree `160205ec7e435a6592378d94209a800c02ba2c91` / receipt `c0e622dd6c7488f3d1271108cb11304eab611f3df9c36a8a45831752a2a9fdbd` / source SHA `8fccff5bada935d7e8383c1b48c9ebb73312b453f6b5c0ab5cd4edad7cf2186b` がprepare/execute/result/verified manifestへ一致する。同epoch `51bfd752bc2a460db00a835c45250282`、registered IDF6.0.1/esp32s3、1,800s budgetで161s完了、期限内開始を確認。

保存log pagesを同一重複record検証付きで連結し、sequence1…2,122完全連続、gap/expiredなし、final has_more=false。再構成秘匿化log SHA `70fe7f602c7268971a284d34b3d0e4bd5f007d2ee40b4c5c57f3af64a30a9d96` が保存log/親summaryと一致。verified manifestは全保存pageで同一。mandatory proofは一つ、sequence2109。

actual telemetry/measure/fixed/detailは全ON。hardware seed2545F491とfixture seed9112A7ABを分離し、race1000001/camera8/tier1/390→510/120contexts/3dependent rep/finish5DC86E18を確認。linked df_detail_exit_recordとdetail suspend/resume等symbols、embedded play/view/seed proofが成立する。

| Artifact | Bytes | SHA256 |
|---|---:|---|
| BIN | 2,298,416 | `8daa2cb79582de437d48a16f2366eb2a748b5871ca1acc490506765b5a20a47c` |
| ELF | 20,051,584 | `1093bc46b5987042ce8e0c110daf328339eb641a89f5e957ef7471c1d2c4850f` |

proofとverified manifestのhash/bytesが同一。batch専用runner proofはsequence2107に一つで、runner batch/detailともON、native symbol=true、同BIN/ELF/CMake cacheへbindし、embedded PAN bytes/hashも確認した。raw BIN/ELFを独立download/hashしたとは扱わない。manifest flash_authorized=false、flash admission未評価、proof hardware_tested=false。post-buildはidle/unowned/queue0/current uncertainty=false。実際のstartup/OOM解消・watchdog・固定計測・性能効果はbuildから推測しない。

予備レビューは不変で、旧18receipt/保護13payload/正常rollback/旧OOM保全および未説明64B会計差を保持。後続は親executorの新exact flash/readback/boot/trial証拠待ち。reviewerはlocal読取/解析と本MD/JSON保存だけで、API/MCP/device/USB/job/source/build/repo操作0、test追加0。34確認と入力hashをJSONへ保存。
