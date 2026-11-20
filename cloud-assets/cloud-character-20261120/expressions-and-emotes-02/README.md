# 雲のキャラクター｜喜んだ目の形

喜びプリセットの閉じた両目だけを、山形の「∧」に変更。曲線中央と頂点・端の高さを保ち、左右の点を中心側へ詰めた。眉・口・他の表情・漫符・7秒待機は前版を維持する。漫符との重ね合わせも保存後に確認済み。

240×135の固定画角で、顔の左目は14.05→10.20px、右目は12.66→8.85px。中心横位置の移動は左右とも0.02px未満。測定は `smile-caret-validation.json`。開き直した原本の初期設定は通常表情。Cardputerでの表示・性能は未確認。

```sh
blender -b --python narrow_smiling_eyes.py -- \
  /path/to/cloud-faces-and-emotes.blend cloud-faces-and-emotes-caret.blend --no-preview
```

前版の名前とハッシュは検証記録で照合できる。見た目を確認する場合は `--no-preview` を外し、比較画像をローカルで生成する。プレビューはリポジトリに収録しない。
