# Independent final batch ON trial review

**受入: batch `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` / tree `160205ec7e435a6592378d94209a800c02ba2c91` のDETAIL ON固定計測1boot/3dependent replay。** exact source/build→同device freshflash/readback/boot→有限trial→終端/close→idle/lease解放の保存証拠を確認し、exact batch HEADのstrict parserを独立に再実行してPASS。

- trial `derby-controller-batch-fixed-711f94fa-20261020`、06:37:51→06:39:21 UTC succeeded/serial_close。
- private raw31,000B、SHA256 `cde6ecae18d01e7cdb854320b227b48496852c17799f201536a090343b0c12c8`。receipt内base64・保存file・独立digest一致、complete=true、全7transport flags=false、85,881ms、200s/64KiB/1024B bounds内。
- work_us **6,606,158 / 6,604,002 / 6,608,389**、全quality0/valid1。
- END237 → session1 owner EXIT238 → APP_STOPPED240 → HOME_READY241。全243lines、HOME後2linesを含め既知fatalなし。

parse_collectedはbatch固有known work/call数、fixture/schema/qualityを検証しprovider parsed値と一致。parse_detail(expected=True)は全stage/event/階層会計/owner終了を検証し、親ACCEPTANCEと同じ3repを得た。baselineで既に確認した7negative gateケースは、結果parser2本/schemaが同一hashと確認したため再実行せず参照した。新batch rawのstrict解析は別途実行済み。

plan/execute/resultとbindingは同epoch `51bfd752bc2a460db00a835c45250282`、device/session/principal、exact job/hash、成功flash後の順序で一致。planのend_owner_exit_stop_home_v2とenvelopeのowner_exit_v2を区別。configured_expected_hash_only/installed_boot_source_image=unverifiedを独立attestationへ昇格させず、直前fresh同deviceのfullsegment SHA256 readbackと一致IDF/ELF boot・ordered chainを根拠とする。physical LCDは未attest。

最終active/profilejobなし、ownerなし、queues/lease0、current uncertainty=false、releaseok/releasedtrue。旧OOM raw/resultとhistorical needs_review9件は保持。予備/source-build/flash-planレビュー3本はhash不変。今回範囲にblockerなし。OFF対照、独立boot反復、性能効果は未評価。追加実機や再試行の許可を含めない。

reviewerはlocal読取・host parser解析・本MD/JSON保存のみ。API/MCP/USB/device/job/repo変更0。36確認とexact入力hashを`INDEPENDENT-BATCH-FINAL-REVIEW.json`に保存。
