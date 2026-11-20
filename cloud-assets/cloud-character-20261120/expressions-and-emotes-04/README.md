# 雲のキャラクター｜ε の口の修正

ギャグ表情の口だけを変更。左側の輪郭につながる独立した横棒をなくし、上の小さな丸み、なめらかなくびれ、下の大きな丸みを一筆でつないだ。黒い点の目、眉、他の表情、漫符と7秒待機は変更しない。Blenderで `Cloud face controls` の `cloud_face_preset` を5にして確認する。通常の初期値はそのまま。

固定画角240×135で約10.35×10.74px。検証記録 `epsilon-validation.json` の8状態で、口以外の評価済み頂点は元版と完全に一致する。保存後、待機中にギャグ表情と漫符が同時に使えることを確認。Cardputerでの描画・実機性能は未確認。

```sh
blender -b --python reshape_epsilon.py -- \
  ../dot-gag-v3/cloud-faces-and-emotes-dot-gag.blend \
  cloud-faces-and-emotes-epsilon.blend --no-preview
```

確認画像を生成する場合は `--no-preview` を外す。プレビューはリポジトリに含めない。
