# Independent batch source/build preflight review

予備結論: frozen batch exact source・build plan・cache保護・回復/旧失敗保全は整合する。**build proof/新batch実機/OOM解消は未判定。** source `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` / tree `160205ec7e435a6592378d94209a800c02ba2c91` / receipt `c0e622dd6c7488f3d1271108cb11304eab611f3df9c36a8a45831752a2a9fdbd` / SHA `8fccff5bada935d7e8383c1b48c9ebb73312b453f6b5c0ab5cd4edad7cf2186b`。06:25:54→06:26:23 UTC source成功、prepare/execute/result/3固定Gitlinksが一致し、localHEAD/treeもexact/clean。

build `derby-controller-batch-build-711f94fa-20261020` は同source、epoch `51bfd752bc2a460db00a835c45250282`、registered IDF6.0.1/esp32s3/profile、1,800s budget。06:27:14 executeは期限2026-10-20T06:57:11.096694+00:00前、任意modeflagなし・cleanup disabled。actual link/proof/4ONを先取りしない。

primary前後を再計算し、旧18receipt全保持→計19receipt、payload16維持、pending0、上限16/2GiB不変、inventory/scancomplete。唯一の旧行変更は3ff8113 receipt `512d114d00c4368538f63023d5e35917dd9a55f85c5f9112da89acc7a04c1143`で、source本体85,718,306Bを自動回収、581,397B/2entryのreceipt証拠を保持。旧jobのimmutable診断は以前の保存応答と一致する。保護13payloadは全行不変、manual cleanup許可なし。normalized evidenceも一致。aggregateとowned行合計の未説明64B差は前後同じで、原因は推測しない。

current native receipt1f4143…は直前正式flash/accepted結果と一致。新baseline/native ACCEPTANCEは原本と同じ。旧正常baseline rollback e9a33…を別保持、旧ea64 batch OOM raw902B/SHA92b8e47…8232f6と失敗resultはbyte/JSON不変。baseline/native private ZIPのlocal hashは各保存Library receiptと一致、remote再取得はしていない。

新scopeは同fixture/seed/strict exitのbatch source/build→一度flash/boot→ON固定一度。OFF/DMA・直接USB・設定/SDK/auth変更・未指示reset/backup/restore・拒否/不一致時の自動再試行は禁止。旧failed batchを新headへ混同せず、linked proofとfreshflash/strict終端証拠が来るまで成功へ昇格させない。

reviewerはlocal読取・解析・本MD/JSON保存のみ、API/MCP/device/USB/job/source/build/repo変更0、test追加0。36確認と入力hashをJSONへ保存。
