# 雲のキャラクター｜黒い点の目と ε の口

統合済み「∧」の笑顔版を土台に、ギャグ表情を1つ追加した。目全体が左右それぞれ一つの大きな黒い点で、白目、輪郭線、ハイライト、別の虹彩は表示しない。曲線の口は小画面でもεと分かる形にし、眉は通常の太さ・幅を使う。

Blenderで `Cloud face controls` の `cloud_face_preset` を **5** にする。目・眉・口の各上書き設定（`cloud_face_eyes`、`cloud_face_brows`、`cloud_face_mouth`）でも5を個別選択できる。−1はプリセットに従う。通常の初期値・他の表情・7秒待機・独立した漫符は維持。

検証は `dot-gag-validation.json`。元の全表情・待機途中・ループ境界を含む7つの組み合わせで、従来のモデル頂点は完全に一致。240×135の固定画角で、εの投影サイズは約9.18×9.19px。実機描画の検証ではない。

```sh
blender -b --python add_dot_gag.py -- \
  /path/to/cloud-faces-and-emotes-caret.blend cloud-faces-and-emotes-dot-gag.blend --no-preview
```

確認画像はリポジトリに収録しない。ローカルで必要なら `--no-preview` を外して生成する。
