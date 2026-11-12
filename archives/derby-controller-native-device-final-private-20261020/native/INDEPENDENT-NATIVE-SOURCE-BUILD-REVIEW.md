# Independent native source/build review

受入範囲: native exact source/buildとlinked DETAIL ON proof。**実機受入はまだない。** build `derby-controller-native-build-3fafcadb-20261020` は06:09:32 UTC succeeded/no_flash、source `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` / tree `b3de719ac438d8d3373a2c34786bc35c46e9200e` / receipt `bbf729af426e3110943d2fcad025311b1d088b773c0cecdbb53b4fde92e16679` / source SHA `2b6f8223ef87de643e976686905f7fe75346f39143ea5cbdd3e00210e1200e3d` がprepare/execute/result/verified manifestへ一致する。同epoch `51bfd752bc2a460db00a835c45250282`、registered IDF6.0.1/esp32s3、1,800s budgetで183s完了、期限内開始を確認。

保存log pagesを同一重複record検証付きで連結し、sequence1…2,120完全連続、gap/expiredなし、final has_more=false。再構成秘匿化log SHA `afe817c266c1714dbae25215dced12a3611bcf9141e1e120d9a620d8e7ea6fae` が保存log/親summaryと一致。verified manifestは全保存pageで同一。mandatory proofは一つ、sequence2107。

actual telemetry/measure/fixed/detailは全ON。hardware seed2545F491とfixture seed9112A7ABを分離し、race1000001/camera8/tier1/390→510/120contexts/3dependent rep/finish5DC86E18を確認。linked df_detail_exit_recordとdetail suspend/resume等symbols、embedded play/view/seed proofが成立する。

| Artifact | Bytes | SHA256 |
|---|---:|---|
| BIN | 2,296,944 | `aeb601df47809fb6b651ee265a41dcbf727520dd0678c1030bd8e3c1ffd892b1` |
| ELF | 20,046,164 | `0e8abb684ab242633288861488a969f15f91bfb004dd37708d2a793c8f0e80d4` |

proofとverified manifestのhash/bytesが同一。raw BIN/ELFを独立download/hashしたとは扱わない。manifest flash_authorized=false、flash admission未評価、proof hardware_tested=false。post-buildはidle/unowned/queue0/current uncertainty=false。実際のstartup/OOM解消・watchdog・固定計測・性能効果はbuildから推測しない。

予備レビューは不変で、旧17receipt/保護12payload/正常rollback/旧OOM保全および未説明64B会計差を保持。後続は親executorの新exact flash/readback/boot/trial証拠待ち。reviewerはlocal読取/解析と本MD/JSON保存だけで、API/MCP/device/USB/job/source/build/repo操作0、test追加0。30確認と入力hashをJSONへ保存。
