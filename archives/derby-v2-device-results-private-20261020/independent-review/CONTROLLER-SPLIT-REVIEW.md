独立レビュー: 共通10ファイルのcontroller分割に、未解決の重大なコード問題は見つからない。ホストで試験したfixtureの意味維持を支持する。実機OOM解消・実機stack余裕・target link成功はこのレビューの判定外であり、未実施をPASSにしない。

対象は `derby-controller-baseline/native/batch` のstaged修正。元headは37af4225/92e70b7f/ea64b0ecのまま保全され、10ファイルの修正bytesは3版で同一。候補index treeは以下。完全ファイルhash・保存ログhash・確認時の進行状況はJSONに記録した。

| 版 | 候補index tree |
|---|---|
| baseline | `d72a737240d48def898899bf6dc71e0ac627c7f8` |
| native | `b3de719ac438d8d3373a2c34786bc35c46e9200e` |
| batch | `160205ec7e435a6592378d94209a800c02ba2c91` |

`derby_fixed_workload_chunks.py`は旧wrapper位置に同期`pocket.app.load('fixed')`を置き、strict global scriptのcontrollerを読み終えてから元playのstartup enter/READYへ進む。watchのprog/view/scene/pan/play列は不変。loader上限32に対して7chunks。追加C・予算・VM・描画・I/O・fixture・shipping app変更はない。detail ON/OFFとも同じ分割を使う。

独立に3版×ON/OFFをprivate evidence内へ生成した。controllerを元位置へ戻すと、OFFだけでなくONも各frozen headの旧generator出力playとbyte完全一致する。watch/viewおよびONのPANも旧生成物と一致。strict、top-level enter/READY前のload、生成JS構文検査を確認。証拠は`controller-generated/result.json`。

hostは生成済みON部品を使い、fixedをchunk登録する。proofはwatch/view/play/fixedの4個について生成fileとELF内の完全bytesを要求し、controller欠落・改変・strict欠落を拒否する。CMake既存生成chunk表経由で追加fileを登録/埋込みする構造も確認した。既存uncatchable watchdogの再throwは不変である。

保存positive rawは現parser・既知work/hash・保存generated hashで独立再解析した。最終startup/tail/collector記録が揃ったケースはJSONのcompleted_host_casesへ列挙し、進行中ケースと分けた。OFF/ON間でcontexts/done/finish、全c counters、coarse stage calls、draw/input/procedural/panel hash、同値pixel/stripを照合した。3rep、tail最大8step、旧同期tailのfatal拒否、controller欠落/syntax/runtime/strict失敗でREADYを出さないことは、保存負例のhashと内容から確認する。binaryの再走行はしていない。target proof unitはsynthetic ELFの試験であり、実target linkとは区別する。

変更中にhost生成へ旧applyを重ねる問題、startup enter位置テストのanchor、instrument済みwatchを純Node tail oracleで評価した際のS未定義を報告/確認し、最終10-file patchでは解消。最初の失敗試行はfailed-attempt-001へ保全されており、成功扱いにしない。

nested loadにより起動時のcall depth/heap/stackは増えうる。fixed内のsyntax/runtime失敗はfixed filename/causeを持ち、外側playは実行中失敗として部分初期化済み/再実行不可になるため、元のplay compile失敗と例外文言・retry分類まで同一とは主張できない。docsはこれを明記している。以前のsequential候補のhost peak低下を新nested方式やESP物理heapへ流用していない。

残工程: 保存driverが未完ならその完了、通常host/ASan、公開exact-head CIのtarget ON/OFF link/proof/資源検証。ローカル依存初期化はbmi270 cloneのproxy503で失敗しており、local full target buildは未実行。これは承認拒否ではなく通信失敗。実機batch startup compile OOMは未解決のまま、実機停止・操作禁止を維持する。reviewerによるMCP/USB/serial/reset/flashは0。

read-only逸脱の記録: 最初の9-file hash確認で誤ってgit write-treeを各repoに1回使い、tree objectを作成した。ref/index内容/sourceの変更はなく、親へ即報告した。再実行していない。最終10-file treeは親の保存receiptとread-only index hash計算で照合した。
