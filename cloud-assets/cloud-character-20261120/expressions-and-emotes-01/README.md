# 雲の表情差分と漫符

`cloud-faces-and-emotes.blend` は7秒の待機モーションを保った編集原本。ニュートラルで開き、漫符は非表示。通常の眉は投影横幅・位置を変えず、線を少し太くした。プロジェクトの描画・実機エクスポートは含まない。

- `Cloud face controls` の `cloud_face_preset`: 0 通常、1 にっこり、2 困り、3 びっくり、4 眠い。 `cloud_face_eyes`・`cloud_face_brows`・`cloud_face_mouth` の -1 はプリセット準拠、0–4 は部位ごとの上書き。
- `Cloud emote controls` の `sweat`・`confusion`・`anger` はキツネの元素材と同じメッシュ・材質。0.5以上で表示。複数オンの優先順は怒り、ぐるぐる、汗。表示する形の追加はそれぞれ20・96・64三角形（Blenderのメッシュ。実機測定ではない）。
- Blenderで表情と漫符を同時に出し、通常・非表示へ戻せることを確認。確認画像は同梱しない。 `expression-*.json` は表情単体の比較、 `cloud-faces-and-emotes.json` と `integrated-verification.json` は統合版の記録。

## 再生成

Blender 4.3系。編集原本をそのまま使う場合は追加素材不要。再生成の場合、同アーカイブの [7秒待機原本](../idle-wind-7s/cloud-idle-wind-7s.blend) と [狐の固定原本](https://github.com/dj-oyu/cardputer-development-archive/blob/ba71ff28339200212297bef5fb4e98b385c2c5e2/fox-assets/ground-truth-20261119/fox-ground-truth.blend) を使う。

```sh
blender -b -t 4 --python-exit-code 2 --python build_cloud_expressions.py -- ../idle-wind-7s/cloud-idle-wind-7s.blend expression-local.blend --no-preview
blender -b expression-local.blend -t 4 --python-exit-code 2 --python add_fox_emotes.py -- --fox-source fox-ground-truth.blend --output combined-local.blend
blender -b -t 4 --python-exit-code 2 --python check_preservation.py -- ../idle-wind-7s/cloud-idle-wind-7s.blend expression-local.blend
```
