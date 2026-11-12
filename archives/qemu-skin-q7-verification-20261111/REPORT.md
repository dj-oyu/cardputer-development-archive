# ESP32-S3 QEMU: 実QuickJS skin統合とQ7 ON検証

日付: 2026-11-11
対象: dj-oyu/cardputer-adv-pocketjs PR #126、commit 828baa3af69c55e7884c53557ea39f91190010a0。着手時のGitHub headと一致。
環境: Espressif QEMU9.2.2 esp_develop_9.2.2_20250817、ESP-IDF6.0.1、Xtensa GCC15.2.0。PSRAMなし。

## 結果

先行した「JS rigid scene」と「native C skin」の個別検証に続き、実QuickJSからskinを評価し、native modelとKasaneを通して240×135を出力する一貫経路を確認した。Q7 ONは独立したnative profileで検証した。公開fixtureのみ。製品修正は不要だった。

### 実QuickJS → evaluateSkin → native model → Kasane

- 120 pose往復、240 visitsを、runtime生成から破棄まで2回。計480 visitsを完走。
- 元のhost suite由来のstrict入力検査、無効値・alignment・SAB/detach、OOM rollback、busy復帰、独立actor、評価後の入力変更、IO失敗/retry、pending source破棄、cyclic GCを維持。
- 初回work OOMは16失敗/17成功。増量失敗で480Bを保持し、回復後576B。
- 各ライフサイクルの120 forward hashがhostと一致。target内のreverse replayもPASS。
- frame0/30/60を2回分、合計6枚のRGB565出力はhostとbyte完全一致。
- target JS frame標本最大72,676/72,744B、上限163,840B。internal free heap最小117,804B。

### 実QuickJS → evaluateSkins → 複数mesh batch → Kasane

- 同じく240 visits×2回、計480 visitsを完走。
- 2meshの同時skin、descriptor逆順、alias、不正な後半meshのatomic rejection、subset/empty/単mesh切替、独立actor、OOM後のready/capacity保持、pending disposal、GC、容量上限を確認。
- OOM13失敗/12成功。target work803B、上限近傍の合法work16,307B、上限16,384B。64bit host値823/16,327Bをtargetへ流用していない。
- 各120 forward hashとreverse replayがPASS。frame0/30/60を2回分、6枚すべてhostとbyte完全一致。
- target JS frame標本最大78,924/78,952B、internal free heap最小110,824B。

両profileのfree heapは285,692B → 1回目破棄後285,400B → 2回目破棄後285,400B。初回292Bの差は、先行の描画なしQuickJS context-only試験と同じ形で、2回目の累積減少は観測されない。所有allocationを今回追跡したわけではなく、普遍的なleak-freeの証明ではない。

host referenceはASan/UBSanとrequested-allocation解放検査にPASS。LSanはptrace環境のため明示的に無効。targetのhost allocation counter欄はplaceholderであり、その0値をtarget allocation-freeの証拠にしていない。

### Q7 ON native profile

- 実ksn_mesh_prepare / ksn_mesh_q7_prepare / ksn_mesh_q7_renderを組み込み、PREPARED=1、Q7=1、Q7_CERT_MODE=3、EDGE4なし。厳密FP compile flagsとsource/symbolを検査。
- 公開4quad・8triangle、16frame×2条件（band4/workspace1、band8/workspace8）×2 lifecycle =64 candidate visits。
- 固定した先行Q7実装とのpixel bytes、depth、owner、stats、FP exception flag一致。
- 16frameごとにdepth_fast286,720、mask_fast210,432。fallback-onlyではなくcertified fast pathを実行。
- workspace/alignment/overflow/capacity、signed zero等9境界群、partial failure、stats wrap、不正y・容量超過・出力sentinelもPASS。
- Q7の3枚とfloat referenceの3枚、計6枚がそれぞれhostとbyte完全一致。このfixtureではQ7とfloatの選択画像も一致。
- 通常floatとの一般的な完全一致は主張しない。別の既存host numeric suiteでは17,172,000 samples中、coverage差158、owner差164、depth差162、RGB差2,518が観測され、その近似契約下でplain/ASan/UBSan試験がPASSしている。certified depth/maskとcoverage/color近似、先行Q7との同値性は別の主張。
- free heapは各run終了時202,764Bへ復帰。最大連続領域139,264B、最小free197,108B、heap integrity全て正常。main stack残量19,672/24,576B。
- prepared1,624B＋Q7 3,864B＋alignment padding14B = requested5,502B。実heap減少5,640Bにはallocator overheadを含む。testにはfull image比較buffer等のstatic BSSがあるため、製品全体のRAMではない。
- IRAM leafとROM double helperの配置を記録したが、cache-disabled安全性やフルcall-chain認定ではない。

## 独立再確認

収録された選択18枚（single6、batch6、Q7/reference6）を親側でも再読込し、各64,800B・hostとの完全一致を確認した。画像一覧は各profileの先頭lifecycleの3枚ずつを表示する。公開の帯状meshやquadであり、完成キャラクターではない。

## 再現と変更範囲

新規test-only directoryはtools/qemu_skinとtools/qemu_q7。それぞれREADMEに生成、host、独立IDF build、bounded QEMU、UART復号の手順がある。各buildのrun-metadata.jsonにcommand・QEMU version・binary/config/UART hash、入力manifestに製品source hashを保存した。以前のuntracked harnessへの依存はなく、上記commitへこの二つを配置して再現できる。

初回configureの相対build pathとQ7 testのprintf型指定に失敗した記録は成功結果と区別。最終buildは絶対pathで隔離し、成功時のbinary/ログだけを検証根拠とした。共有された初回失敗build directoryは同梱しない。

tracked production diffは0。既存baseline証跡は保持。commit/push/mergeは行っていない。実機、Omnibook、flash、USB、ネットワーク・security設定、並行QuickJS2コア最適化ブランチには触れていない。

## 未検証・別課題

- scene facadeの自動skin制御とAYNM skin table/importerは未実装のまま。今回の成功は既存の低位JS skin API経路。
- 私有fox原本、Blender export・bind/weight・normal/morph/material・眼の忠実性は未検証。
- Q7 profileはnativeのみで、JS skin＋Q7 ONの同時統合やbenchmark preflight admissionではない。
- scalar fallback、mock delayed display transportのため、PIE、LCD/SPI/USB/DMA実周辺機器、実機fpsを保証しない。
- JS usageはframe時点の標本最大で全時点peakではない。全firmware RAM・PSRAM・並行2コア動作は別検証。
- per-visitのJS skin oracle比較はhash。抽出した18枚は実byte比較。oracleは同じ製品skin/rasterを共有し、独立した数学的正解の証明ではない。
- 実機20fps・CI全体・merge基準は今回満たしたとは扱わない。
