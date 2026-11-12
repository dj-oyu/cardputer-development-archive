# Independent final native ON trial review

**受入: native `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` / tree `b3de719ac438d8d3373a2c34786bc35c46e9200e` のDETAIL ON固定計測1boot/3dependent replay。** exact source/build→同device freshflash/readback/boot→有限trial→終端/close→idle/lease解放の保存証拠を確認し、exact native HEADのstrict parserを独立に再実行してPASS。

- trial `derby-controller-native-fixed-3fafcadb-20261020`、06:18:04→06:19:36 UTC succeeded/serial_close。
- private raw31,145B、SHA256 `9dff6892ae8e86b3f972de57f12f438dc86140747f272747495ba3a6e939a9f4`。receipt内base64・保存file・独立digest一致、complete=true、全7transport flags=false、87,602ms、200s/64KiB/1024B bounds内。
- work_us **6,720,372 / 6,723,824 / 6,716,986**、全quality0/valid1。
- END240 → session1 owner EXIT241 → APP_STOPPED243 → HOME_READY244。全246lines、HOME後2linesを含め既知fatalなし。

parse_collectedはnative固有known work/call数、fixture/schema/qualityを検証しprovider parsed値と一致。parse_detail(expected=True)は全stage/event/階層会計/owner終了を検証し、親ACCEPTANCEと同じ3repを得た。baselineで既に確認した7negative gateケースは、結果parser2本/schemaが同一hashと確認したため再実行せず参照した。新native rawのstrict解析は別途実行済み。

plan/execute/resultとbindingは同epoch `51bfd752bc2a460db00a835c45250282`、device/session/principal、exact job/hash、成功flash後の順序で一致。planのend_owner_exit_stop_home_v2とenvelopeのowner_exit_v2を区別。configured_expected_hash_only/installed_boot_source_image=unverifiedを独立attestationへ昇格させず、直前fresh同deviceのfullsegment SHA256 readbackと一致IDF/ELF boot・ordered chainを根拠とする。physical LCDは未attest。

最終active/profilejobなし、ownerなし、queues/lease0、current uncertainty=false、releaseok/releasedtrue。旧OOM raw/resultとhistorical needs_review9件は保持。予備/source-build/flash-planレビュー3本はhash不変。今回範囲にblockerなし。batch修正版実機、OFF対照、独立boot反復、性能効果は未評価。追加実機や再試行の許可を含めない。

reviewerはlocal読取・host parser解析・本MD/JSON保存のみ。API/MCP/USB/device/job/repo変更0。36確認とexact入力hashを`INDEPENDENT-NATIVE-FINAL-REVIEW.json`に保存。
