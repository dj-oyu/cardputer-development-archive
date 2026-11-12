# `view.set` の不変定義検査と IMUCAL の更新回数

2026-10-05、`feature/codex-runtime-kasane-perf`。基準は `main` の `1b4524e`。
以下は **host の呼出し回数・処理回数・画素一致**の結果であり、実機の時間・heap・LCD 測定ではない。

## 変更と境界

`js_schema_set` は mount 済みの定義に対して毎回
`ksn_schema_preflight_view` → `ksn_schema_values_validate` →
`ksn_schema_validate` を呼んでいた。最後の検査は slot の名前重複を
O(S²) で調べ、binding や node の不変属性も再検査する。

`schema_alloc` は mount 時に定義を検証する。組込み定義は不変の flash
データ、動的 JS 定義は `runtime_compile` が所有する native 配列・文字列へ
コピー済みで、元の JS オブジェクトの変更は反映しない。
この所有権を前提に、mount 済みの `view.set` だけを
`ksn_schema_preflight_view_validated` へ切り替えた。
新しい入口の契約は「定義と参照先を検証済みのまま不変に保つ」こと。
任意の native 定義を受ける従来の preflight は完全な定義検査を続ける。

**省くのは不変定義の再検査だけ。** 候補値全体の UTF-8・文字容量・矩形・
数値上限・背景 alpha、全 node の可視性/page・派生座標・reveal、画像の
所有権/寸法、展開後の命令数/文字容量は同じ共通経路で検査する。
候補値を commit する前の検査であり、資源検査や全 node preflight を
dirty bit だけで置き換えてはいない。変更されない node も含めた集計上限、
隠れていた node の出現、外部資源の寿命を扱う dirty-preflight は別設計とする。
native の `submit` / ref-map 構築などの定義検査も今回は変更しない。

IMUCAL は `show()` の局所オブジェクトへ head/foot/live/stat/spin を集め、
最後に一度だけ `view.set` する。センサー試料がないときも head/foot の
更新を失わない。校正の状態機械、表示文字列、`report()`、保存の非同期完了は
変更しない。旧コードの複数 set による途中の部分提出を維持することは目的ではない。

## JS 入口を含む回帰検査

[`tools/test_kasane_schema_set.c`](../../tools/test_kasane_schema_set.c) は実 QuickJS、
`pocket_kasane.c`、schema、core、renderer を通す。画像 producer のうち試験に
使わない grid/video/pixel は stub とし、既存 fixture の失敗注入 suite は呼ばない。

24 slot / 24 node の mount を表示・ack した後、2 color slot を同時変更した実測:

| changed JS `view.set` 1回 | 旧 preflight 呼出し | 新入口 |
| --- | ---: | ---: |
| descriptor 検査回数 | 1 | 0 |
| 重複名の `strcmp` 回数 | 276 | 0 |
| node 解決回数 | 28 | 28 |

28回は全24 node の preflight と、dirty 2 node の比較/変更用の各1回。
native dirty-node 試験の「2回」だけを JS 更新全体の仕事量としていない。
計器は既存の `KSN_SCHEMA_DIRTY_COUNT` 定義下だけにあり、通常 firmware の
データ領域・実行経路には追加されない。時間短縮率の主張ではない。

負の対照は一時ファイルに adapter をコピーして呼出し先だけ旧入口に戻し、
同じ新しい計器付き core と試験を link したもの。上表の旧値を実測し、
再検査ゼロを要求する2 assertionだけが失敗することを確認した。

試験範囲:

- 変更2 slot の PATCH と独立した literal descriptor の全描画が32,400画素一致
- 元の JS 定義の slot 型・bounds・配列長を変更し getter を例外化しても、mount 済み画面は同じ
- 未変更 set は提出も node 解決もしない
- 非表示 page の座標が、可視化で範囲外になる候補を commit 前に拒否
- 文字/reveal/数値/page/背景 alpha の不正値、未知名、型・UTF-8・容量、末尾 getter 例外の拒否と回復
- 可視性/page の切替と復元、既存の mounted-app 画像範囲/stale resource・APP文字総容量の検査

再現:

```sh
TEST_SOURCE=tools/test_kasane_schema_set.c \
CACHE=/tmp/qjs-kasane-schema-set OUT=/tmp/test-kasane-schema-set \
CFLAGS='-O2 -g -fsanitize=address,undefined -DKSN_SCHEMA_DIRTY_COUNT' \
bash tools/build_kasane_test.sh
ASAN_OPTIONS=detect_leaks=0 /tmp/test-kasane-schema-set
```

`SCHEMA SET TEST PASS`。この環境の LeakSanitizer は ptrace のため終了時に
fatal となるので `detect_leaks=0` で実行した。ASan/UBSan は有効、LSan 合格とは
呼ばない。既存 builder に従い QuickJS object は `-O1`、adapter/core/test は上記の
`-O2` と sanitizer を使用する。

native の `test_schema.c`、`test_schema_session.c`、`test_schema_workloads.c` も
`-O2 -Wall -Wextra -Werror -fsanitize=address,undefined -DKSN_SCHEMA_DIRTY_COUNT`
で PASS。後者は120 single-slot +600 mixed frame の全描画 reference 比較を含む。
全 Kasane suite・実機・OOM/故障注入はこの作業の検証結果に含めない。

## IMUCAL の検査

[`tools/test_kasane_imucal.c`](../../tools/test_kasane_imucal.c) は現行アプリの
`show()` だけを旧実装に差し替えた基準と新実装を、実 QuickJS/Kasane で比較する。
モデル・ログ・保存・音・購読解除の状態を比較し、表示は pending の提出を
present/ack して収束した後の32,400画素を照合する。これは途中の部分提出まで
同じという意味ではない。

O1 + ASan/UBSan の結果は `IMUCAL KASANE TEST PASS`。試料なし、gyro なし、
dropped 件数、静止/移動/再arm、途中resume、6方向の校正、非同期 `SAVED` と
購読解除後まで **373 turn の状態・収束後の全画素が一致**した。

| 同じ台本の host 実測 | 旧 `show()` | 集約後 |
| --- | ---: | ---: |
| `view.set` 呼出し総数 | 1,795 | 367 |
| 試料なしの `show()` 1回 | 2 | 1 |
| 試料ありの `show()` 1回 | 5 | 1 |
| 提出 bank 総数 | 368 | 345 |
| 最初の present と収束後の画素が異なる turn | 25 | 2 |

残る2 turn は起動と `report()` で、今回の集約範囲外。最初の試料を表示する
代表turnでは、旧コードの2提出・途中の部分画面に対し、集約後は1提出で収束後と
同じ画面になることも assertion にした。実機のフレーム遅延を測った値ではない。
元の試験にあった raw scene 作成済み fixture は `mount` を `BUSY` にするため、
試験は clean な tracked QuickJS runtime から開始するように直した。

```sh
TEST_SOURCE=tools/test_kasane_imucal.c \
CACHE=/tmp/qjs-kasane-imucal OUT=/tmp/test-kasane-imucal \
CFLAGS='-O1 -g -fsanitize=address,undefined' \
bash tools/build_kasane_test.sh
ASAN_OPTIONS=detect_leaks=0 /tmp/test-kasane-imucal
```

実機での更新頻度、CPU 時間、評価 heap の余裕、物理 LCD の確認は未測定。
