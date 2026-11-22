# 雲のキャラクター｜ε のくびれ

口全体を動かさず、εの中央のくびれだけを右へ寄せた。上下の丸み、口全体の投影寸法、黒い点の目・眉・他の表情・漫符・7秒の待機は維持。一筆のままで横棒や分岐は追加していない。

Blenderで `Cloud face controls` の `cloud_face_preset` を5にすると確認できる。固定画角240×135で、くびれ中央の移動は右へ約1.9px。詳細は `epsilon-waist-validation.json`。Cardputerの実機描画・性能は未検証。

```sh
blender -b --python deepen_epsilon.py -- \
  ../epsilon-mouth-v4/cloud-faces-and-emotes-epsilon.blend \
  cloud-faces-and-emotes-epsilon-waist.blend --no-preview
```

確認画像が必要な場合は `--no-preview` を外す。確認画像はリポジトリに含めない。
