# 狐アセット

見た目・表情を編集するなら **高精細の基準原本**、三角形数を抑えたモデルを編集するなら **実用2k版**、ホストで描画検証するなら **AYNM** を使う。Blender版とホスト版は同一ではない。ここでの検証は採用・ファーム統合・実機FPSを証明しない。

## 目的別の入口

| 目的 | ファイル | 内容・検証 |
| --- | --- | --- |
| 見た目・表情・モーションの基準原本 | [fox-ground-truth.blend](ground-truth-20261119/fox-ground-truth.blend) | 呼吸と外観を維持した高精細版。18ボーン、7アクション。[検証](ground-truth-20261119/verification.json) |
| 実機向けに軽量化した編集原本 | [fox-2k-bilateral.blend](practical-2k-bilateral-20261119/fox-2k-bilateral.blend) | v3の後頭部・首まわりを左右で整理したBlender版。リグとアクションを維持。実機未検証。[検証](practical-2k-bilateral-20261119/verification.json) |
| ホスト描画用 | [fox-host-v5.aynm](practical-2k-bilateral-20261119/fox-host-v5.aynm) | v4から後頭部を整理。格納1,934三角形、中立ポーズ1,754三角形。比較28組で画素差なし。目や記号の調整はホスト側のみ。[検証](practical-2k-bilateral-20261119/verification.json) |
| ひとつ前のホスト比較対象 | [fox-host-simulator-v4.aynm](host-simulator-v4-20261119/fox-host-simulator-v4.aynm) | 240×135で正面・35°、立ち・遷移・座りを確認した版。[検証](host-simulator-v4-20261119/verification.json) |

## 軽量化の比較

| 版 | 用途・差分 |
| --- | --- |
| [保守的な削減](conservative-lowpoly-20261119/fox-conservative-lowpoly.blend) | 高精細の外観を保ちながら512三角形を物理削減。実用2kとは別。[検証](conservative-lowpoly-20261119/verification.json) |
| [実用2k v1](practical-2k-v1-20261119/fox-practical-2k-v1.blend) | 色補正版。最大同時表示1,980、選択肢を含む格納2,056三角形。[目録](practical-2k-v1-20261119/manifest.json) |
| [実用2k v2](practical-2k-v2-20261119/fox-practical-2k-v2.blend) | 耳内側を削減。最大同時表示1,924、格納2,000三角形。[目録](practical-2k-v2-20261119/manifest.json) |
| [実用2k v3](practical-2k-v3-20261119/fox-practical-2k-v3.blend) | 足と尾の裏側を削減。最大同時表示1,878、格納1,954三角形。[目録](practical-2k-v3-20261119/manifest.json) |

## 表情・動作の編集チェックポイント

| 系統 | 編集原本 |
| --- | --- |
| 視線・まばたき | [視線](gaze-proof-20261119/fox-gaze-proof.blend)、[まばたき](blink-proof-20261119/fox-blink-proof.blend)、[まばたき＋困り眉](blink-worried-brow-20261119/fox-blink-worried-brow.blend)、[虹彩なし制御](iris-free-control-20261119/fox-iris-free-control.blend) |
| 笑顔と漫画表現 | [笑顔の制御](smile-control-20261119/fox-smile-control.blend)、[読み取りやすい笑顔](readable-smile-20261119/fox-readable-smile.blend)、[笑顔＋汗・混乱・怒りの記号](smile-and-manga-20261119/fox-smile-and-manga.blend) |
| 呼吸・ポーズ確認 | [笑顔・漫画表現＋呼吸](smile-manga-breathing-20261119/fox-smile-manga-breathing.blend)（[4秒周期の検証](smile-manga-breathing-20261119/verification.json)）、[座りの周回確認](orbit-seat-20261119/fox-orbit-seat.blend) |

## 造形の比較・旧チェックポイント

| 系統 | 編集原本 |
| --- | --- |
| 眉・目の周辺 | [眉と鼻梁](brow-bridge-20261119/fox-brow-bridge.blend)、[眉の流れ](brow-flow-20261119/fox-brow-flow.blend)、[標準眉](neutral-brow-20261119/fox-neutral-brow.blend)、[まぶた](eyelid-20261119/fox-eyelid.blend) |
| 頬・鼻梁・毛色 | [頬の流れ](cheek-flow-20261119/fox-cheek-flow.blend)、[鼻梁の形状](bridge-fair-20261119/fox-bridge-fair.blend)、[クリーム色の毛](fur-cream-20261119/fox-fur-cream.blend)、[耳の陰影](ear-shade-20261119/fox-ear-shade.blend) |
| 保存点 | [R90](R90/checkpoint-R90.blend)、[顔のポリゴン予算](face-budget-20261119/fox-face-budget.blend) |

同じフォルダの `SHA256SUMS` で取得ファイルを照合できる。内容や検証範囲は、収録されている `verification.json` または `manifest.json` を参照。

