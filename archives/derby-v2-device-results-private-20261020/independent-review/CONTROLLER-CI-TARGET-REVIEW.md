独立追補: 保存された6件のexact-public-head target ON/OFF link/proofログを再解析し、すべて整合を確認した。これはCI内target build/proofの確認であり、全CI完了、ローカルBIN/ELF実体の再hash、実機受入ではない。

| 版 | 公開head | ON job | OFF job |
|---|---|---:|---:|
| baseline | `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` | 118416860534 | 118416860637 |
| native | `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` | 118416879464 | 118416879479 |
| batch | `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` | 118416896407 | 118416896501 |

各rawログのSHA256と、ログから独立抽出したrecord_verification、DERBY_DIAGNOSTIC_BUILD_PROOF、DERBY_DETAIL_RESOURCESを保存JSONへ照合。source/tree/project version/submodule gitlinksをclean公開checkoutと結び付けた。IDF6.0.1、telemetry/measure/fixed ON、要求されたdetail ON/OFF、fixture/manifest/seed、BIN/ELF hash・長さ・BIN埋込ELF hash整合、生成play/view hashと固定seed symbol検証を確認。owner EXIT boundary df_detail_exit_recordはON必須・OFF不在、DD boundaryもON必須・OFF不在。元レビュー後のsource変更はない。

controllerはON2667B、OFF2354B。CIが公開treeのverify_fixed_modeを成功実行したため、4番目の生成file/controller完全bytesをELFへ要求する検証も通ったと確認できる。ELF実体をローカルで読み直したという主張はしない。

DD静的状態は各ON2304B、OFF0Bで、linked dd_ data/bss symbol合計から再計算。9Cのcompiler stack表の最大は全6件ともmark_fused単体2992B。これは関数単体のcompiler値であり、call chain合計、nested loaderの実行stack、QuickJS stack、runtime highwater/余裕ではない。全診断状態・共有物理heapの総量でもない。

証拠保存の制約: derby-detail.ymlのupload対象はJSON/map/txt/sdkconfig/SHA/.suであり、この6件のbuild_detail BIN/ELF本体を含まない。別のderby-fixed-firmware archiveはbuild_fixedのBIN/ELFを含み、default detail ONだが別job/別hashなので6件のbuild_detail実体と同一視しない。保存inventoryのdetail target archiveは最終確認6/6で、全て公開head/digest/expiryを照合した。3件のfixed-firmware archiveの公開head/digest/expiryは記録されている。archive digestと個別BIN/ELF hashも区別する。

baseline fixed-firmware archive ID12236305882（10422412B）のtool-issued ZIP downloadはCONNECT tunnel503で失敗。保存記録はdenied=false、local_binary_bytes_saved=falseで、実行結果に不確実性はない。コード/patch/bundle、host証拠、今回の6targetログ/proofとartifact metadataは保存済み。reviewerはdownloadを再試行していない。

CI-TARGET-JOBSには後続のsuccessが6件ある一方、CI-JOBS-LATEST原応答snapshotはその前のin_progress/queued時点。全23jobsの最終metadataは別工程で、引継ぎ時点の残4host jobsや全CIを成功扱いにしない。旧実機batch compile OOMは失敗のまま、新実機操作は停止。今回の追補でAPI/MCP/USB/device操作、source変更、build/test再実行は0。

原応答の時点を保つため、CI-JOBS-LATESTと最終artifact inventoryの入力snapshotをprivate `controller-ci-target-inputs/` へ複製保存した。
