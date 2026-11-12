# DERBY WATCH 詳細計測の引継ぎ

## 完了した成果

指定されたexact 3版から詳細計測を仕様ベースで再構成し、専用branchへ実装した。旧担当のWIP ZIPはこの環境では取得できず、旧コードと同一とは主張しない。初期の公開禁止は後続の明示承認で解除され、終了修正とELF proof修正を既存Draft PRへ反映した。mainへのmergeは行っていない。

| 版 | 比較元exact commit | 最新public/local head | tree | Draft PR |
|---|---|---|---|---|
| baseline | `0c52600fc34deafbadc53bc48e4fc98931e404e4` | `37af4225ad329aac4c5e79c880d7d69760b770be` | `7753c5c8919ee36c24080ce08102438a285da6f2` | [21](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/21) |
| native | `44f9c56121b5aab4fb2eca0fcf9fbe54d833a276` | `92e70b7fbb2c15d99734a518096dffdf046d2ae3` | `24f0575743c7de7d4873c531221db6e1fcf1f14f` | [22](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/22) |
| batch | `3a641d4d996938339b44fe735aba876ad031b3a2` | `ea64b0ec9c176f852c853cb10142581ee527d7fc` | `63bf0b2ee03168230de588f2a038e3e694b1d4d4` | [23](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/23) |

nativeとbatchは独立比較版であり、累積最適化版ではない。branch名は `feature/derby-detail-{baseline,native,batch}-20261019`、作業場所は `/workspace/derby-detail-recovery`、`/workspace/derby-detail-native`、`/workspace/derby-detail-batch`。元checkout `/workspace/cardputer-adv-pocketjs` と旧checkpointは保護した。

## 計測と終了経路

26 elapsed stageと13 logical-byte/call eventを固定サイズで集計する。JS control/simulation・pose/projection・sort・runner・HUD、procedural VM setup/zero/copy/validate/match/run/segment append、描画prepare/backdrop/composite/span、TX copy/submit/reap waitを含む。owner taskだけがscope stackを扱い、ISR/別taskは触れない。大きなhistogramや常設heapを追加していない。

既存fixture/seed/camera、390→510の120contexts、3 dependent replays、250ms guest watchdog、180秒session、最大8step/frameのtailを維持した。詳細OFFでの非介入とON/OFF意味・描画hash一致を確認した。copy/write bytesは論理量であり、実bus trafficではない。elapsedはpreemption/waitを含み、純transfer時間とは呼ばない。最適化、整数化、PR16/17、梅竹、droneは追加していない。

初回実機旧版のEND後APP ERRORを受け、詳細ONの正常終了をownerへ戻した。最後のguest return成功、DONE、exit要求、pending jobsなし、stop要求なし、last armed deadline内を確認して既存teardownへ進む。追加guest frameを走らせず、pending/finally・既存失敗・runaway・Back・forced stopを成功へ上書きしない。250001usの遅いreturnは即timeout扱いとする。

ownerだけが `DERBY_DETAIL_EXIT v=1 session=N clean=1` を一度出す。strict parserは同一session/versionでEND→EXIT→STOP→HOMEを要求し、全streamのInternalError/watchdog/LOADSTALL/stop-hook例外/rejection/timeoutを拒否する。正しいESP-IDF tagと完全一致marker、ANSI SGRを認識する。`clean=1` は正常guest完了受入の証拠であり、後続teardown全体の無条件成功ではない。詳細OFFはEXITなしの従来契約を使う。MCP側契約は evidence/MCP-DETAIL-WIRE-CONTRACT.md。

reportは測定窓外で1record/logical frame、summary/final ENDを分割し、write失敗を再試行しない。ENDとEXITは同owner tickに2writeとなり得る。110ms/write試験で220msに他処理が加わるため、owner tick全体の厳密250ms上限の証明とはしない。

最初の終了修正headのtarget CIでは、追加した `df_detail_exit_record` をELF proofの固定symbol境界に登録し忘れたため詳細ONが失敗した。この失敗を保存し、2つのPython検査ファイルだけを修正した。現在は詳細ONで必須・OFFで禁止、未知symbol拒否を維持する。runtime/JSは検証済み終了修正から変えていない。

## 検証証拠

2026-10-19 22:16:43 UTCに最新public headを再取得し、baseline 9/9・native 9/9・batch 11/11、合計29/29件のCI成功を確認した。各PRはDraft/openを維持し、remote ref/local HEAD/CI headが一致する。詳細ON/OFF target 6件、ASan/UBSan・O2・m32 host検証を含む。完全なcheck ID/URLは evidence/FINAL-PUBLISHED-CI.json、targetのsource/BIN/ELF/mode証拠は evidence/FINAL-CI-TARGET-RECEIPTS.json。PR本文もこの結果へ更新済み。

- ローカルO2/ASan/UBSanで3版ON/OFFの12実行、36 dependent windowsが成功。これは終了修正candidate 64a13d3/2b82842/8b49236の記録で、最新headとはtree全体が異なる。最新headとの差分は2つのproof Pythonファイルだけで、runtime/JSの同一性と最新head CIを別々に確認した。
- 120contexts/4975draws、input `986b2e6e027af00d`、procedural pixels `c1b0fdbde748d0de`、panel `cec4b765a2794b14`、race `5DC86E18` が一致した。各repの前frame同値3,499,706/3,888,000pixels、全strip同値449/2040はhost観測であり、性能効果や差分送信節約を意味しない。
- production dispatch/app_tick/tick_run/end_run/interruptを抽出したowner lifecycle試験、38 parser負例と独立6追加拒否例、生成ON/OFF/ON、OFF .text/通常owner経路比較、slow-output/拒否/deadline例、proof負例が成功した。guest・budget・app_stop内部の一部はstubであり、実機lifecycleを証明しない。
- CMake/Ninjaを保存済み環境PATHから使用し、integrationにskipなし。独立reviewでは18 Xtensa syntax/6 objects、OFF preprocessor比較、実CIの6件target proofと公開commit/tree対応を確認した。FINAL-PUBLICATION-TARGET-REVIEW.md参照。
- 実target 6件のrecord/proofはexact commit/tree、PROJECT_VER、BIN/ELF hash対応、embedded fixture/view、詳細ON/OFF境界を満たす。詳細固定stateはON 2304B/OFF 0B、最大単一関数stackは双方2992Bであり、全call chainやruntime high-waterではない。CIのmandatory検査が実ELF/BINに対して実行され、そのログを独立照合した。ここではBIN/ELFを別途downloadして再解析していない。

host timingは並列負荷の影響を受け、target overheadや独立boot統計には用いない。有効な最新3版実機詳細比較、同head実機ON/OFF対照はまだない。

## 実機の不合格と現在の保留

以前のbaseline `90b9f686` の正式source/build/全segment readback/bootは成功したが、fixed試験 `derby-detail-baseline-fixed-90b9f686-20261019` は21:27:33 UTCに完了後、strict全体FAILになった。31,098B・88.954秒のcomplete capture、SHA256 `c25c11fc9a04e73a430291d202f00fceca3e94748976ec37a5604e9e4d66b3d5`。3 summaryがvalid1/quality0を広告していても、ENDの後にInternalError: interruptedがあり、ユーザーのAPP ERROR→HOME表示とも整合する。coarse brokerのsucceededを実機受入PASSへ転用しない。この修正でも旧結果を遡及変更しない。旧work値は不合格試行中の参考観測である。

legacy self-exit経路が有力説明だが、同じexception文字列はwatchdogでも起こるため原因確定とはしない。完全captureにwatchdog/LOADSTALL/stack overflow/OOM記録がないことはruntime余裕の証明ではない。capture画像はcapture_not_available。native/batchの実機試験は実行していない。装置の最後の書込みは旧詳細baseline BIN `c71e7381be4ecfed8c8afeadf2d6812de920b7668bcc8b259c55202e6e22d8c4`、ELF `166214130f735f298e64dc3e2143d01e645ad3c11de971a4d5f7e459f30c20d8` のままで、自動restoreしていない。

現在の正確な未完工程は **最新headのMCP source/build/flash/詳細実機受入**。親の指示でsource/flash holdを維持する。read-only APIではactive job/owner/queueなし、uncertainty falseで、接続API到達と物理接続/LCD確認を区別している。直接USB、追加lease、cache削除、登録/limit変更、main mergeは行っていない。

親側の確認ではcache13/16、1,121,839,000B。今回3snapshotの追加推定257,445,764B、合計1,379,284,764/2,147,483,648Bでslot/byte容量は収まる。一方、safe preflightは `source_cache_scan_limit`（5秒/100万entry走査制約）で未成功のため **pending hold**。容量満杯とは扱わず、既存receiptを新headへ転用しない。MCP担当のread-only走査調査待ちで、このworkerはsource操作を実行していない。

通常PR19 `c47084d0` の先行source/build/verified flash/registered smokeは別証拠として保存済み。full demo cycle・同phase render-buffer写真・q後fresh HOMEを確認したが、物理LCD/moving視認、数値WIDE>=2fps、heap/eval余裕、LOADSTALL完全性が未確認でoverall normal PASSではない。現在の搭載imageとも異なる。

## 承認と失敗履歴

終了修正のGitHub create_blobは当初、自動承認レビューにより初期の公開禁止を理由として拒否された。先行3blobと未実行対象404・旧refsを確認し、許可根拠更新後の一度の再試行も拒否された時点で停止・保全した。その後、親から実ユーザーの公開/既存Draft反映/新CIへの「いいよ」という明示承認を受け、対象未実行とrefsを再確認して同一操作を一度だけ再試行し成功した。**公開拒否は解決済み**である。別経路回避は行っていない。歴史的なdenied receiptはevidenceへ保存しているが、現在の停止理由ではない。

最新baselineのcontract CIでは `source_download_failed` が1件発生した。これはGitHub CI内のdownload失敗で、MCP source取得ではない。当該jobだけ一度再実行し成功した。最初のsymbol-boundary失敗・復元helperの初回失敗も隠さず保存し、修正後の成功証拠と区別した。

## 保全と再現

このアーカイブは完全patch3本、全変更source38/38/40ファイル、最新public commitのincrement bundle、25MBの以前の完全code/host/device checkpointを含む。元exact commit/tree、公開commit/tree、全変更fileとfull patchのhashをCHECKPOINT.jsonとSHA256SUMSで照合する。private rawや秘密を公開PRへ載せない。

アーカイブを展開し、**空の新規destination**へ復元する。既存変更のある場所は拒否する。intentional shallow境界を含むため通常のbundle cloneの代わりにhelperを使う。全submodule履歴は含まない。nativeでhelperの復元・clean status・full patch・38file hashとproof単体試験を実際に確認した。

```sh
python3 restore_final.py --variant baseline --destination /workspace/restored-baseline
python3 restore_final.py --variant native --destination /workspace/restored-native
python3 restore_final.py --variant batch --destination /workspace/restored-batch
cd /workspace/restored-baseline
git diff --check
python3 -B tools/test_derby_detail.py
python3 -B tools/test_derby_detail_generation.py
python3 -B tools/test_derby_detail_board.py
python3 -B tools/test_derby_detail_proof.py
python3 -B tools/test_derby_fixed_integration.py
python3 -B tools/test_diagnostic_build.py
python3 tools/games/compare_derby_detail.py --baseline /workspace/restored-baseline --native /workspace/restored-native --batch /workspace/restored-batch --out /workspace/derby-recheck-o2 --fast
python3 tools/games/compare_derby_detail.py --baseline /workspace/restored-baseline --native /workspace/restored-native --batch /workspace/restored-batch --out /workspace/derby-recheck-asan
```

CMake/Ninja/Node/Cコンパイラ/jsonschema等が必要。実環境では `/workspace/.setup/venv/bin` をPATHへ追加した。m32はmultilibが必要。actual target proofの再照合は evidence/verify_final_ci_targets.py と保存済みledger/job/logを使う。最新CIは公開headに紐づく証拠であり、上のoffline復元コマンド自体がCIや実機を再実行するわけではない。

再発時の保全・通信停滞復旧・承認拒否対応手順は evidence/DERBY-RECOVERY-RUNBOOK.md。過去の指示を記録する資料であり、将来の禁止や承認を置き換えない。最新Library file IDとZIP SHA256は外側の `FINAL-PUBLISHED-LIBRARY.json` に記録する（自己参照hashを避けるためZIP内部には含めない）。
