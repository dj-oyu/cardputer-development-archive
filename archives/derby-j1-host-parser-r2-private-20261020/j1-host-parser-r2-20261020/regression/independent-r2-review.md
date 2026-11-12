独立r2 review判定: 固定99ケースとhost patch reviewはPASS。

同一固定harnessを旧候補→r2の順で実行。旧候補は前回reviewの全99件でcase順・expected_accept・acceptedが完全一致し、同じ7件の拒否漏れを再現。r2は正例2件通過・負例97件拒否、予期外accept/rejectなし。変異条件、期待値、ケース数を維持。

差分を独立に読取確認。追加terminal偽装をsubstring件数で拒否、schema_versionのbool/int混同をint型必須で解消、collector parser commit・device-reported session・installed-imageの未照合claimを明示検証。installed-imageはunverifiedを要求しており、installed identityを証明した扱いにはしない。従来の正規tag/timestamp、owner/END/STOP/HOME順序、fatal、transport、raw/export、typed flash→build/source/modeproof結合と独立parser必須条件を維持。追加findingなし。

旧98入力・旧candidate・旧review2files・既存checkpoint ZIPはhash一致、r2 parserも評価前後不変。production変更者は親のみで、reviewerはproduction未変更。新規書込みはregression内のharness・固定ケース・結果・レビューのみ。raw/receiptのコピーや書換えなし。

proveは呼ぶと例外になる未使用import stub、actual BIN/ELF証明とCLI全体は未評価。実機/API/network/prepare/execute/ON/OFF操作なし。host局所結果であり、実機受入・現在installed状態・再実行許可を意味しない。
