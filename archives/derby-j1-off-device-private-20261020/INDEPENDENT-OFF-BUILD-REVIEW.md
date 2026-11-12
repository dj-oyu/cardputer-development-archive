独立判定: provider再検証済OFF buildのflash前record gateはPASS。

ONとのproof差分はBIN/ELFのsize/hash、cache2項目、生成playのsize/hash、生成view hash、detail mode/symbols、owner detail modeだけ。exact J1 verify_modeはdetail_modeに応じたfixed_expectedのplayを、実probeは対応するviewを選ぶため、全dict同一を要求した旧validatorの停止は過剰だった。OFF playは6993B（ON7055B）。この期待差を許容しつつ、telemetry/measure ON、native symbol sets、source hash、embedded verified、fixture/seed/owner契約、IDF/tools/security等は維持されている。

plan canonical hash・成功job・manifest/proof/artifact bindingを独立照合。全2120ログは1..2120連番・gap/expiry/重複なし、唯一の実build proof logとdurable manifest proofが完全一致。OFF detail native symbolsは空、linked mode/seed/viewは正規probeの検証済payload。元98、r2、旧reviewは不変。

reviewerはvalidator/prove/buildを実行せず、BIN/ELF bodiesの実証明を再計算していない。API/USB/SDK/物理作業なし。書込みは本JSON/MDのみ。これは保存build記録のpre-flash gate評価であり、flash/collector実行許可・実機受入・全CLI・ON/OFF overhead合格ではない。
