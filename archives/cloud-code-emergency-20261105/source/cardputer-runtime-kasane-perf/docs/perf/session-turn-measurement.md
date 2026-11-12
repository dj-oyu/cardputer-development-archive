# app_tick のサービス時間と描画時間（2026-10-05）

`main/app_session.c` の前景セッションの計測境界。今回の変更は時計と集計だけで、pump、継続、Back、
描画の呼出し順や VM の予算を変えない。**実機で速くなったことを示す変更ではない**。

## 1. 計測から抜けていたもの

通常経路の時計は `pocket_memory_pump()`、`run_pumps()` とその後の `end_guest_turn()` より後に始まっていた。
これらは native の仕事に加えて、メモリ通知、IMU、input、text、fs などの同期 JS listener も呼び出せる。
従来の `KASANE_PAINT turn_ms` と `MDT js` は、その時間を含めていなかった。

さらに、継続が完了して同じ `app_tick()` 内で新しい `frame()` へ進むと、`MDT js` は新しい frame の時間で
上書きされ、直前の継続の時間を失っていた。Back で保存 frame へ進む場合も同じだった。

## 2. 今の境界

すべて `esp_timer_get_time()` の壁時計の差分。プリエンプトされた時間と native 関数の仕事を含むので、
**JS 命令だけの CPU 時間ではない**。また、owner tick 全体の壁時計時間でもない。

| 値 | 区間 | 集計 |
| --- | --- | --- |
| pump | `pocket_memory_pump()` の直前 → `run_pumps()` 後の `end_guest_turn()` が戻った直後 | メモリ通知＋全 pump＋その後始末 |
| frame | pump 後の時計 → `dispatch_guest(false, buttons)` と `end_guest_turn()` 後の既存 `turn_us` 採取点 | 従来の frame 区間。既存の診断処理の時間も含む |
| continuation | `dispatch_guest(true, 0)` の直前 → その `end_guest_turn()` の直後 | 従来どおり、継続一回の区間 |
| normal service | pump＋frame | 通常経路一回のサービス時間 |
| `KASANE_PAINT turn_ms` | normal service と continuation の合計 / `ticks` / 1000 | 下記の **サービス区間あたり** の平均 |
| `MDT js` | その一回の `app_tick()` の pump＋frame＋continuation | µs。同じ tick の継続を上書きしない |
| `MDT rn` / `sd`、`KASANE_PAINT render_ms` / `send_ms` | 従来の描画・転送区間 | 変更なし |

pump と frame は連続した区間で、間に重複はない。継続と normal service の間にある例外報告や
Back のための描画は、どちらのサービス区間にも入れない。先頭のメモリ標本、presenter、通知面の更新、
VM の arm、表示だけの仕事も含めない。表示のない frame でもサービス時間は数える。

### 母数を変えない

`ticks` は `app_tick()` の呼出し数でも、表示した frame 数でもない。

- normal service が走れば 1
- continuation が走れば 1
- 一回の `app_tick()` が continuation → normal service と進めば 2
- 表示だけなら 0

`KASANE_PAINT` の窓は 30 painted frames で閉じるが、`turn_ms` の母数はその間の `ticks`。
`render_ms` / `send_ms` の母数 30 とは違う。**`turn_ms + render_ms + send_ms` をフレーム周期と読まない**。
継続を含めた一つの論理 frame の時間とも違う（[turn-cpi.md](../vm/turn-cpi.md) §2）。
従来は窓カウンタが 30 painted frames でだけリセットされ、途中でセッションを切り替えると
複数セッションを含む窓になっていた。現在は `reset_paint_window()` を新しいセッションの開始にも呼ぶ。
時間・`painted` / `ticks`・`prof_sum`・帯の値・GRAD 診断の byte 合計を一緒にクリアし、
まだ回収されていない renderer の profile も捨てる。新しいアプリの一枚目で古い 29 枚の窓は閉じない。
同じ helper を 30 枚到達後にも使う。停止時の最終報告の順序と、同じセッションの suspend/resume は変えない。

`KSN_P0_APP_TURN` も PAINT と同じサービス区間を標本にする。
一方、`CONFIG_POCKET_VM_PROBE` の `vmprobe_frame_sample()` と
`CONFIG_POCKET_VM_TURNPERF` の通常 frame の時間・性能カウンタは従来の frame-only 範囲を維持する。
継続側の VM 診断も従来どおり。

## 3. ログ互換性と分解

既存の `MDT`、`KASANE_PAINT`、`AB` などの大文字ログの書式は変えない。
`turn_ms` と `js` の数値は従来取りこぼしていた時間を含むので、旧ログとの単純な性能比較には使わない。
タイミングの範囲をそろえてから比較する。

`KASANE_MEGADEMO_TRACE` のときだけ、既存の `MDT` のあとに独立した行を出す。

```text
MDTP <MDTと同じseq> pump=<µs> frame=<µs> cont=<µs>
```

同一 tick について `MDT js == MDTP pump + frame + cont`。表示だけの `D` はすべて 0。
継続だけの `C` / `P` は `cont` だけが非ゼロ。継続から新規 frame まで進んだ `F` / `Q` は
`cont` と `pump` / `frame` の両方を持てる。既存の kind は変更しないため、`F` を常に
「この tick には continuation が無い」と解釈してはいけない。

確認した既存 consumer は `tools/kasane_contract/megademo_device.py`、
`tools/games/bgcost/bgcost_device.py`、`tools/games/ovalcost/{ser,trig}_device.py`、
`tools/stress_app.py` と PAINT を読む各 capture script。
固定位置の `js/rn/sd`、`turn_ms/render_ms/send_ms` を保ち、未知の `MDTP` 行は既存 reader で読み飛ばせる。
新しい分解は trace 専用で、通常ビルドには新しいログ行や静的 trace field を加えない。
trace の追加出力自体は次の tick の計測前に行われるが、表示周期は延ばす。

## 4. ホスト検証

```sh
python3 tools/test_session_dispatch.py
```

production の `run_pumps()`、`end_guest_turn()`、`dispatch_guest()`、`app_tick()` を抜き出してコンパイルする。
既存の順序試験に加えて `tools/test_session_timing.c` が決定的な偽時計で各 native port に時間を課す。
`tools/test_session_paint_window.c` は production の窓リセットと renderer profile 型を抜き出して検査する。

- メモリ通知、12 個の pump、frame、後始末の合計が一致する
- メモリ通知だけ／pump だけの時間を変えた差分が集計へそのまま反映される
- 描画なしの frame でもサービス時間を計上する
- 継続だけのターンには pump や新規 frame の時間を付けない
- 同一 tick の continuation → frame を一度ずつ計上し、MDT が継続を失わない
- Back の前後 2 回の描画時間をサービス時間へ混ぜない
- 表示専用ターンにサービス時間を付けない
- VM_PROBE / TURNPERF の frame-only 範囲を維持する
- `MDT` / `KASANE_PAINT` の既存書式は完全一致で検査する
- 古い 29 枚の窓と未回収 renderer 値を新しいセッションへ持ち越さず、GRAD 診断でも同じことを確かめる
- 新規開始と 30 枚到達時に窓リセットが呼ばれる source wiring も検査する

2026-10-05 の host では通常・診断構成とも、`-O2 -fstrict-aliasing` と ASan/UBSan で PASS。
この実行環境では LeakSanitizer が ptrace 非対応で起動を拒否したため、
`ASAN_OPTIONS=detect_leaks=0` で実行した。ASan/UBSan は有効、リーク検査は未実施。
実機ビルド、実機上の計測値、USB / flash / reset / 設定変更、OOM 掃引はこの検証では実施していない。
