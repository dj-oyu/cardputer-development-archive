独立追補: 公開3headは、先にレビューした10-file候補treeと完全一致する。local checkoutはexact公開headでclean。通常hostを含む各16checks（合計48checks）の保存receiptはall_pass=trueで、各exit0とログSHA256を照合した。batchの追加`--runner-batch`通常host ASan/UBSan oracleも保存ログでPASSを確認した。試験の再実行はしていない。

| 版 | 公開head | tree | Draft PR |
|---|---|---|---|
| baseline | `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` | `d72a737240d48def898899bf6dc71e0ac627c7f8` | [#25](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/25) |
| native | `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` | `b3de719ac438d8d3373a2c34786bc35c46e9200e` | [#26](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/26) |
| batch | `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` | `160205ec7e435a6592378d94209a800c02ba2c91` | [#27](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/27) |

保存PUBLICATION.jsonのAPI commit/PR記録、local Git raw commit、published.commit、HEAD/tree/parentを突き合わせた。unsigned commit rawのGit SHA1とSHA256、author/committerのname/email/UTC timestamp、messageを独立計算・照合。署名検証の主張はしない。公開10ファイルのhashは前レビューと同一で、親headとの差分もその10個だけ。各bundleのheadとhashを確認した。PUBLICATION.jsonの`head`は公開前元headを保持する欄であり、公開headの判定にはremote_commit/local_published_head/保存API shaを使用した。

通常host3件は14563frames、exceptions/bad_present/failuresすべて0、DERBY_HOST PASSを確認。追加batch runner試験は2000 randomized boundary cases、negative boundary、checked=true、ser fuzz 0 mismatchesを確認。runner有無の通常host pixel hashを同一とは主張しない。固定12試行/36 dependent windowsの同一work・hash・終了契約は前レビューの受入範囲を維持する。

前レビューで未完としていた通常host工程はこの追補で完了に更新する。CIは引き続き実行中として扱い、target ON/OFF link/proof/資源をPASSにしていない。local target依存取得のproxy503と、修正版の実機起動/OOM解消・性能が未検証である点は残る。旧batchの実機失敗は失敗のまま保全。今回の追補はlocal file/Git readのみで、API/MCP/USB/device操作、repo変更、追加実行はない。前レビューは当時点の記録として保持し、この追補を追加した。
