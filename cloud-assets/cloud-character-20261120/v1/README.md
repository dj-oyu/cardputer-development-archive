# 雲のキャラクター｜試作1

脚のない淡青白の雲、分離した二つの手、頭上の薄い彩雲。身体の造形は滑らかな球面の合成、顔は編集可能な独立パーツ、彩雲は閉じた薄いリボンで構成する。元の設定画は再配布せず、外部画像・テクスチャへの依存はない。

- `cloud-delivery.blend`: Blender 4.3.2。6ボーン。24fpsの編集可能な10秒アクション（待機→左右の傾け→圧縮・伸長・復帰→停止）。手は胴体とは別に遅れて追従。彩雲は独立ボーン、端は数値ドライバーで本体より遅れて変形する。1と241は同じ姿勢。
- `cloud-opaque-*.glb`: フレーム1・84・166・241のポーズを静的メッシュへ書き出した比較素材。Y-up。閉じたメッシュを片面として描画し、対象インポーターが扱う法線・不透明ベースカラーのみ。淡青の階調は材質帯で近似。物理的な透過・体積散乱・実機アニメーションの実証ではない。連続モーションの原本は .blend。
- `blend-validation.json`: 骨構成、ループ、対象画角でサンプルした隙間の機械検証。接地を持たないため、脚の検査の代わりに、手と体・彩雲と体の隙間と、動作の収まり方を見る。

## 再生成

ZIPを展開し、そのフォルダで実行する。Blenderでは面光源を世界座標に固定した。レンダリングはCyclesを使うが、RGB565比較とは分ける。

```sh
blender -b --python tools/build_cloud.py
blender -b --python tools/export_cloud.py --
blender -b --python tools/check_cloud.py
blender -b --python tools/render_motion.py
ffmpeg -y -framerate 4 -i delivery/motion-frames/frame-%03d.png \
  -vf 'scale=480:270:flags=neighbor,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=4' \
  -loop 0 delivery/cloud-motion-10s.gif
```

1周目の試作は画像サイズで手と胴がつながって読めた。第2案以降では手の中心を広げ、頭上と左右に見える隙間を測り直した。さらに球面が連なる輪郭に変更し、光の設定は固定したまま雲としてのまとまりを比較した。

## アーカイブの使い方

`cloud-delivery.blend` はそのまま開ける編集用モデル。再生成・検証する場合は `cloud-source-and-target.zip` を展開し、そこで上記のコマンドを実行する。ZIP 内の `delivery/` に .blend と 4 ポーズの GLB、`native/` にリプレイ手順とソース、`target/` に AYNM と機械可読な検証記録を収録。プレビュー画像・動画・描画した RGB565 フレームは同梱しない。ホスト検証の再実行と RGB565 フレームの再生成は `native/README.md` を参照。

固定ファームウェア版 `5a3dedcba86f46bf74567fc07c42a85e7bb3e25f` の描画コードを使うホスト試験では、240×135、4ポーズ×3画角×2照明の24枚を描画。主画角では全4ポーズで左右の手と彩雲が胴から分かれて読める。1ポーズ2,019三角形、描画データ最大34,644 B（テスト設定65,536 B）。サンプルは静的な評価済みポーズで、連続したランタイム再生、物理透過、実機性能、ファームウェアへの組み込みは未検証。
