# Independent final baseline ON trial review

**受入: exact baseline `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` のDETAIL ON固定計測1boot/3dependent replay。** source→verified build→同device exact flash/readback/boot→有限trial→終端/close→idle/lease解放の保存証拠が一致し、現exact headのparserを独立再実行してPASS。予備/flashレビューはそのまま保持した。

| 項目 | 確認値 |
|---|---|
| source tree | `d72a737240d48def898899bf6dc71e0ac627c7f8` |
| build | `derby-controller-baseline-build-dc2c5e04-20261020` |
| flash | `derby-controller-baseline-flash-current-dc2c5e04-20261020`、05:54:50 UTC succeeded |
| trial | `derby-controller-baseline-fixed-current-dc2c5e04-20261020`、05:57:28 UTC succeeded/serial_close |
| raw | 31,105B、SHA256 `9c71ea832a8d13226afe17fb0d480bb82e125ff66a5a1916557d3cf91076311d` |
| collector | complete=true、全7transport flags=false、87,913ms、200s/64KiB/1024B bounds内 |
| work_us | 6,770,279 / 6,770,404 / 6,767,900 |
| quality / valid | 全0 / 全1 |
| terminal lines | END238 → owner EXIT239 → APP_STOPPED241 → HOME_READY242 |

rawはreceipt内base64・private raw file・独立digest計算が一致する。現HEAD/treeはexactかつcleanで、parse_collectedはknown fixture/work/schema/qualityを全3repで確認しprovider parsed値と一致。parse_detail(expected=True)も3repの全stage/event/schema・scope accounting/固定call数/owner EXITを確認し親ACCEPTANCE.jsonと一致した。fixture seed9112A7AB/race1000001/camera8/390→510/120contextsを保持する。

全244linesを解析し、HOME後の2linesも含め既知fatalはない。strict parserを緩めず、RAM上のrawコピーだけへEND後InternalError、EXIT後runaway、HOME後OOM/hook throw、末尾InternalErrorを追加した5例とEXIT欠落/HOME重複2例を拒否することを確認。digestを更新した各mutationはcoarse parserを通し、detail/terminal gateが拒否した。これはhost側の7negative解析で、追加実機実行ではない。

trial plan名end_owner_exit_stop_home_v2と結果envelope名owner_exit_v2を区別して照合。同epoch `51bfd752bc2a460db00a835c45250282` /session/device/principal/job/planが一致し、flash終了後にtrialが一度executeされた。finalstatusはactive/profilejobなし、ownerなし、queues/lease0、current uncertainty=false、release ok=true/released=true。旧OOM raw902B/SHA92b8e47…8232f6と失敗resultは不変、historical needs_review9件は保持。

試験collectorのconfigured_expected_hash_onlyとinstalled_boot_source_image=unverifiedはそのまま記録する。このfield単独をsource/image attestationへ昇格させない。本受入のimage bindingは直前fresh同device fullsegment SHA256 readbackと一致boot IDF/ELF、ordered flash→trial連鎖に依る。physical LCD/UIは独立に見ていない。quiet closeは保存complete receiptとv2 owner terminal確認の範囲であり、将来無期限の無故障を意味しない。

今回の受入範囲にblockerはない。native/batch実機、OFF overhead対照、独立boot反復は未実施で別工程。1boot/3dependent windowsを3independent trialsと数えず、性能効果や送信削減を断定しない。reviewer操作はlocalファイル読取・exact parser実行・本MD/JSON保存のみで、API/MCP/USB/device/job/repo変更0。

`INDEPENDENT-CURRENT-RECEIPT-FINAL-REVIEW.json` に36確認、7host negative結果、exact入力hashを保存。
