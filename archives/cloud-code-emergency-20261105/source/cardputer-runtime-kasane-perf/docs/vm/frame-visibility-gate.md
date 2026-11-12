# frame 直接入口: 表示世代をそろえるための採用条件

2026-10-05、基準 `main` = `1b4524e3`。
`feature/codex-runtime-kasane-perf` では `FRAME_WRAP` の直接入口への置換を見送る。
既存候補の receiver／例外互換性とは別に、途中park時の表示境界が未解決だからである。

## host で再現したこと

`tools/test_frame_visibility.c` は実QuickJSの `JS_VMCall` と `JS_VMRequestYield`、
実 `pocket_proc.c`／`pocket_kasane.c`／Kasane core／renderer を使う。
既存fixtureのアロケータ・I/O失敗suiteは呼ばない。grid／video／pixel は未使用stub。
HAL、実 `app_tick()`、8ms timer割込みはこのテストには含まない。

1. 黒い手続き画像と赤いUI矩形を表示する
2. frameで手続き画像を青へ更新する
3. `proc.commit()` と UI矩形を緑へ変更する `kasane.patch()` の間でparkする
4. host turn間の `pocket_kasane_park_turn()` と `present()` を実行する

結果は「青い新画像＋赤い旧UI」。resume後は「青い新画像＋緑の新UI」になる。
commit前でparkした対照は旧画像のまま。`f.apply(this, arguments)` の旧wrapperを
置いた対照は本体でparkせず、両更新後の画像だけが出る。

```sh
bash tools/test_frame_visibility.sh o2
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 bash tools/test_frame_visibility.sh asan
```

両構成で再現した。表示の安全性に合格したという意味ではなく、未解決条件を
再現できたという検査である。sanitizer構成はadapter／core／rendererを計装する。
共通builderのQuickJS objectsは非計装。LeakSanitizerもptrace制約で無効である。
実LCD GRAM、実機fps、timer競合、実機heap余裕は未検証。

## 採用前に必要な設計

- HOST frameが開いている間、公開可能なAPP表示世代をどう定義するかを決める
- proc画像だけでなく、view submission、native source、SYSTEM通知、overlay、
  repairが同居する場合も、途中世代を表示せずresumeを妨げない
- 単に `present()` を止めるだけでは、次tick冒頭のpending-display gateが
  continuationへ進めなくなるおそれがある。待機とresumeの両経路を一緒に検証する
- 例外・終了・Back保存では、既存の「継続完了→表示→save frame」の順序を守る
- Promise drain中の途中表示やhost入力の配送順を不用意に変更しない

直接入口は協調実行を回復する変更であり、演算自体を速くする変更ではない。
この条件を満たさないまま通常アプリ全体へ有効化しない。
