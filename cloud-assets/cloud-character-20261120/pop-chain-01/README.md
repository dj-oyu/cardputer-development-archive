# 雲キャラクター 3回つながるポップ

比較動画・確認画像は同梱しない。文中のファイル名は、下記手順で再生成したときの名前。

motion-study-04の三方向の弾性変形（左上・右下・左下）を、約3秒のひとまとまりの動きにしたBlender試作。単純な動画の詰め直しではなく、前の跳ね返りが残っている間に次の圧縮を重ねる。勢いを落とすのは3回目の後だけ。待機の風による変形とは別のアクション。

- `cloud-pop-chain.blend`: 24fpsの編集用。三方向の全体変形と時間差のある局所変形はシェイプキー、手・彩雲はボーン。顔の間隔は維持。
- `cloud-pop-chain.mp4`: 前と同じ固定カメラの240×135描画を2倍表示。12fps、3秒。
- `pop-chain-contact.png`: 圧縮と反発、最後の静止の抜粋。
- `pop-chain-validation.json`: 72姿勢、固定画角で各回の圧縮から反発に23.3、22.5、34.7 pxの幅増加。隣り合う動きが有意に重なるのは7、6フレーム。左手・右手・彩雲の最小投影隙間は4.59 / 10.92 / 5.96 px。実機性能の測定ではない。

## 再生成

```sh
blender -b -t 8 --python-exit-code 1 --python build_pop_chain.py -- ../motion-study-04/cloud-variable-center.blend
python3 preview_pop_chain.py
```

Blender、Python/Pillow、Noto CJKフォント、ffmpegが必要。元の .blend は読み取りのみ。再生成先はこのフォルダ。
