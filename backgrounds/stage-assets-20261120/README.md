# Cardputer 背景アセット

各フォルダに、実装に使う背景画像と編集用のBlender原本を1組ずつ保存。背景だけの画像で、キャラクター、比較画像、動画は含まない。

| ステージ | 本番用PNG | 編集用Blender | 元の生成コード |
| --- | --- | --- | --- |
| 子供部屋 | [background.png](child-room/background.png) | [stage.blend](child-room/stage.blend) | [ソース](../five-depth-eyeline-studies-20261120/room) |
| ビーチ | [background.png](beach/background.png) | [stage.blend](beach/stage.blend) | [ソース](../five-depth-eyeline-studies-20261120/beach) |
| 恐竜の森 | [background.png](dinosaur-forest/background.png) | [stage.blend](dinosaur-forest/stage.blend) | [ソース](../three-depth-look-revisions-20261120/dino-procedural) |
| Pipe Dream 倉庫版 | [background.png](pipe-warehouse/background.png) | [stage.blend](pipe-warehouse/stage.blend) | [ソース](../pipe-dream-warehouse-20261120) |
| Vaporwave Temple | [background.png](vaporwave-temple/background.png) | [stage.blend](vaporwave-temple/stage.blend) | [ソース](../three-depth-look-revisions-20261120/temple-wide) |
| 初期Mac | [background.png](early-mac/background.png) | [stage.blend](early-mac/stage.blend) | [ソース](../six-backdrop-studies-20261120/retro-mac) |
| 夕暮れの入江 | [background.png](dusk-bay/background.png) | [stage.blend](dusk-bay/stage.blend) | [ソース](../dusk-bay-pathtraced-01) |

- 画像は全て240×135、不透明なRGB PNG。そのまま実機に置いて読む形式ではなく、背景の入力素材。
- Cardputer側のRGB565変換には [既存の変換ツール](../dusk-bay-pathtraced-01/encode_rgb565.py) を使用。
- 画像と原本のSHA-256は [manifest.json](manifest.json)。初期Macの見た目は既存版と同じ。
