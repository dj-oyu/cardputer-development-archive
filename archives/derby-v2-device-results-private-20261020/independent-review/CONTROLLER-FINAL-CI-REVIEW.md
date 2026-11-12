独立最終確認: 保存されたexact-head CI metadataは10 runs／23 jobsすべてcompleted success。公開head・review済みtree・clean local source・6target proof・local host証拠との整合を確認した。前追補のCI未完判定を、この最終metadataで完了へ更新する。実機受入はfalseのまま。

| 版 | 公開head | reviewed tree | CI jobs |
|---|---|---|---:|
| baseline | `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` | `d72a737240d48def898899bf6dc71e0ac627c7f8` | 7/7 success |
| native | `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` | `b3de719ac438d8d3373a2c34786bc35c46e9200e` | 7/7 success |
| batch | `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` | `160205ec7e435a6592378d94209a800c02ba2c91` | 9/9 success |

10 runsのhead_sha/branch/eventと23jobsのrun_id/run_head_sha/workflow/status/conclusionを相互照合。ID重複・欠落なし。baseline/nativeは各3runs/7jobs、batchは4runs/9jobs。CI-JOBS-LATESTは現在FINALと同じ23件listであり、未加工のAPI原応答とは呼ばない。6件のdetail target ON/OFF job IDは既に独立解析したログ/proofと一致し、rawログSHA256も不変。source/tree/project version/submodules、BIN/ELF hash整合、fixed seed、4生成file/controllerを要求するCI proof、ON owner EXIT必須/OFF不在の確認内容を維持する。

公開3checkoutはcleanで、10ファイルhashとtreeは元レビューから不変。各16checksのlocal HOST-CHECKSと全log hashも再照合（合計48checks）、追加batch通常runner oracleの保存receipt/log hashも一致する。試験binary・target buildを再実行していない。

session-dispatchとminimp3-submoduleの2補助workflowは、10修正pathがpath filterへ一致せず未起動で、PASS数に含めない。主DERBY workflow定義は元headから変更されていない。

CI成功と実体保存は区別する。6件のbuild_detail BIN/ELF本体はdetail artifactのupload対象外で、ローカル実体の再hashはできていない。別jobのfixed-firmware archiveにはBIN/ELFがあるが、同一headでもbuild_detailと同一hashとは仮定しない。baseline fixed ZIP artifact12236305882の取得はCONNECT tunnel503で失敗し、local bytesなし・denied=false・結果不確実性なし。ログ/proof、archive ID/digest/expiry、source/patch/bundle、hostと最終CI metadataは保存済み。

DD静的状態2304B(ON)/0B(OFF)、compilerの関数単体最大2992Bは、call chain、nested loader runtime stack、高水位、実機物理heapを保証しない。修正版の実機起動/OOM解消・性能は未検証。旧batch実機失敗は失敗のまま保全し、実機停止を維持する。この確認でAPI/MCP/USB/serial/reset/flash、repo変更は0。最終metadata入力snapshotはprivate controller-final-ci-inputs/へ保存した。
