# grid: 旧出力を読まない run のコピー削減

2026-10-05、基準 `main` = `1b4524e3`。host の機能検査とコピー byte 数の計数。
実機の速度・fps・DRAM 使用量は未測定。

## 変更

`pocket_grid.c` は、従来すべての `run()` で確定 DEST を候補 DEST へコピーしていた。
登録時に不変 plan の `LOAD DEST` の有無を記録し、旧 DEST を読む plan にだけ
このコピーを残す。RGB565 resize は入力だけから全面を作るのでコピーしない。

- `ksn_grid_image_bind()` は出力を `base=0, x=1, y=width` の dense な画像に限る。
  成功した非再帰 run は全出力画素を上書きする。
- 入力 map／params の getter 順、入力コピー、整列、scalar／PIE 選択は変えない。
- 二つの出力世代、表示待ち BUSY、ACK、repair は変えない。
- 算術失敗が候補を途中まで書いても公開しない。次の非再帰 run は全面を上書きし、
  DEST を読む run は従来どおり確定面で候補を seed する。
- `measure()` の署名・前回入力の保持・検査方法は変えない。

出力上限は4096画素のため、対象 run の削減量は `width × height × 2` B、
最大8192 B/run。これはコードから決まるコピー量であり、速度向上率ではない。
入力の高水位バッファ保持と grid の明示的解放 API は、この変更では扱わない。

## 検査

```sh
python3 tools/kasane_contract/run_pocket_grid_qjs.py
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
  python3 tools/kasane_contract/run_pocket_grid_qjs.py --sanitize
```

追加した test-only byte counter は firmware には入らない。MAC／resize の
旧 DEST コピーが0 Bであること、DEST依存の加算が6回とも1ずつ進み毎回正しいbyte数を
seedすることを検査する。非再帰scalarでは最後の画素で算術overflowする合法IRを使い、
失敗後の表示画素が変わらず、その後の正常runで全画素が更新されることを確認する。
この検査は確保失敗を注入せず、OOM試験を行わない。

sanitizer mode は QuickJS を含む全リンク元をASan/UBSan付きで再コンパイルする。
2026-10-05、通常構成とsanitizer構成の両方がPASS。
このexecutorではLeakSanitizerをptrace制約のため無効にしている。
実機では同じimageで `grid.profile()` の copyUs／bindUs／kernelUs／totalUs と
Kasane render/send を別々に測定すること。
