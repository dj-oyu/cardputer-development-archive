# Cardputer runtime / Kasane 性能改善

作成日: 2026-10-05 UTC

対象: https://github.com/dj-oyu/cardputer-adv-pocketjs

- ブランチ: `feature/codex-runtime-kasane-perf`
- 基準 main: `1b4524e3db8524365f58e8c7fb56531c31b55e22`
- 完成 HEAD: `865b362469470435640dccbf4908acac456489e4`
- ローカル4コミット。リモートへのpush、mainへのmerge、実機への書込みは未実施

## 変更

1. runtime計測: memory/pump callback の処理時間を集計し、セッション切替時の計測窓をリセット。frame単独の計測は維持
2. grid: 旧DESTを読まない全面上書きの処理で、不要な出力コピーを省略。最大8192 B/run。DEST依存の処理は従来どおりコピー
3. Kasane: mount時に検証・所有した不変descriptorの再検査を省略。候補値、全node、資源、容量の検査は維持
4. IMUCAL: show内のview.setを1回に集約。host台本373箇所で、呼出し回数1795→367、提出bank数368→345

24 slot / 24 node のhost試験では、1回の更新でdescriptor再検査1→0、重複名比較276→0。node解決28回は変わらない。実機の速度向上率を示す値ではない

重要: IMUCALの集約は途中の部分画面の提出タイミングを変更する。状態と、提出を処理し終えた最終32,400画素の一致を確認した。途中画面、物理LCDのタイミング、実時間での表示保持時間が同一という検証ではない

## コミット

- `b3e70730d723d245b1da77f6929d7b605997293c` fix(perf): account for pump callbacks and reset session timing windows
- `8ac5a80b3afa3a730f6f492999914de2b487299a` perf(grid): skip destination seeding for full overwrite kernels
- `4a84621d94101635a0b669c91be6cd5ad4d3146f` perf(kasane): batch IMUCAL updates and reuse validated mount descriptors
- `865b362469470435640dccbf4908acac456489e4` test(perf): add safe aggregate checks and frame visibility adoption gate

## 検証済みの範囲

Linux hostで次の両方がPASS:

```bash
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 bash tools/test_runtime_kasane_perf.sh o2
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 bash tools/test_runtime_kasane_perf.sh asan
```

- session計測、schemaの更新・拒否・回復、IMUCALの状態と最終画素、gridのコピー量・DEST再帰・算術失敗後の回復を検査
- ASan/UBSan有効。gridのasan構成はQuickJSも計装。schema / IMUCAL / frame表示試験の共通builderはQuickJSを非計装でリンク
- この環境のptrace制約によりLeakSanitizerは無効。リーク検査合格という意味ではない
- 全Kasane contract suite、ESP-IDF全体ビルド、実機の時間・heap・LCD測定は未実施。OOM掃引や確保失敗注入は実施していない

直接frame入口への切替は保留。proc.commit後・view.patch前で中断すると、新画像と旧UIの組合せが表示されることを再現した。表示試験のPASSはこの問題の再現成功を意味する。既存FRAME_WRAPを維持し、grid入力の借用・明示解放も未導入

## 内容と取込み

- `feature-codex-runtime-kasane-perf.bundle`: 基準main以降の4コミット。既存repoに基準コミットが必要。単独clone用の完全なリポジトリではない
- `feature-codex-runtime-kasane-perf.patch`: 同じ4コミットのmbox形式パッチ
- `SHA256SUMS`: 上記2ファイルとこのREADMEのSHA-256

bundle verify と、基準main上での patch apply --check は成功。ただしclean repoへの完全な復元試験は未完了。元repoがpartial cloneで、基準履歴の完全bundle作成に必要な追加取得がこの環境で許可されなかったため。上記2検査を復元試験成功と読み替えないこと

既存repoが基準コミットを持っている場合のbundle取込み例（展開したファイルの場所に置換）:

```bash
git cat-file -t 1b4524e3db8524365f58e8c7fb56531c31b55e22
git bundle verify /path/to/feature-codex-runtime-kasane-perf.bundle
git fetch /path/to/feature-codex-runtime-kasane-perf.bundle refs/heads/feature/codex-runtime-kasane-perf:refs/heads/feature/codex-runtime-kasane-perf
git worktree add ../cardputer-runtime-kasane-perf feature/codex-runtime-kasane-perf
git -C ../cardputer-runtime-kasane-perf rev-parse HEAD
```

最後の出力が上記完成HEADと一致することを確認。同名ブランチやworktreeが既にある場合は上書きせず、既存状態を確認する。bundleとpatchは同じ変更なので両方を重ねて適用しない

詳細はブランチ内の `docs/perf/session-turn-measurement.md`、`docs/perf/kasane-set-preflight.md`、`docs/perf/grid-output-seed.md`、`docs/vm/frame-visibility-gate.md`、`docs/platform/test-commands.md` を参照
