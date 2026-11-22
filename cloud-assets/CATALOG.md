# 雲キャラクター アセット案内

## まず開くもの

| やりたいこと | ファイル | 内容 |
| --- | --- | --- |
| 顔・漫符を含むモデルを編集する | [表情・漫符 04 (.blend)](cloud-character-20261120/expressions-and-emotes-04/cloud-faces-and-emotes-epsilon.blend) | **編集の入口。** 7秒待機・表情・漫符を収録した選定版。ギャグ顔の ε 口は横棒のない一筆。通常顔で開く。 |
| 待機の動きだけを編集・比較する | [7秒待機 (.blend)](cloud-character-20261120/idle-wind-7s/cloud-idle-wind-7s.blend) | 風で輪郭の形がゆっくり受け渡されるループ。待機02の10秒を形と順序を保って7秒に短縮。 |
| 反応の「ポップ」を編集する | [3連ポップ (.blend)](cloud-character-20261120/pop-chain-01/cloud-pop-chain.blend) | 左上・右下・左下へ、反発を重ねながら約3秒で3回弾む。待機とは別の原本。 |
| Cardputer向け形式を試す | [軽量試験出力](cloud-character-20261120/practical-trim-01/poses/) | フレーム001・084・166・241の **静止ポーズ4点**。各1,775三角形の不透明GLBと、対応するAYNM。 |

表情は Blender の `Cloud face controls` → `cloud_face_preset`（0 通常／1 にっこり／2 困り／3 びっくり／4 眠い／5 黒い点の目＋ε口）。目・眉・口の上書きの `-1` はプリセット準拠。汗・ぐるぐる・怒りは別の `Cloud emote controls` で切り替える。[操作と再生成](cloud-character-20261120/expressions-and-emotes-01/README.md)／[選定版04の変更点](cloud-character-20261120/expressions-and-emotes-04/README.md)。

## 試作と比較への入口

| 系統 | 保存版と違い |
| --- | --- |
| 初期造形と基準 | [WIP 01](cloud-character-20261120/wip-01/README.md) は初期ブロックアウト。[v1](cloud-character-20261120/v1/README.md) は6ボーン・10秒の編集可能な基準モデル。[再生成ZIP](cloud-character-20261120/v1/cloud-source-and-target.zip) にスクリプト、基準の2,019三角形静止4ポーズとホスト再生手順。 |
| 弾性の試作 | [02](cloud-character-20261120/motion-study-02/README.md) は輪郭を巡る局所変形、[03](cloud-character-20261120/motion-study-03/README.md) は全体の弾性に局所の時間差、[04](cloud-character-20261120/motion-study-04/README.md) は収縮の支点を三方向へ変更。04が[3連ポップ](cloud-character-20261120/pop-chain-01/README.md)の土台。 |
| 待機の比較 | [待機01](cloud-character-20261120/idle-wind-01/README.md) で穏やかな輪郭変形を作り、[待機02](cloud-character-20261120/idle-wind-02/README.md) で小画面でも分かるよう強めた。[7秒版](cloud-character-20261120/idle-wind-7s/README.md) は02の時間だけ変更。 |
| 表情の比較 | [01 基本表情と漫符](cloud-character-20261120/expressions-and-emotes-01/README.md) → [02 ∧の笑顔](cloud-character-20261120/expressions-and-emotes-02/README.md) → [03 点目＋ε口](cloud-character-20261120/expressions-and-emotes-03/README.md) → [04 口を一筆に（選定版）](cloud-character-20261120/expressions-and-emotes-04/README.md)。[05 くびれを深くした案](cloud-character-20261120/expressions-and-emotes-05/README.md)は未採用の比較用。 |

## 検証の範囲

[軽量試験出力の再生成と比較結果](cloud-character-20261120/practical-trim-01/README.md)／[検証データ](cloud-character-20261120/practical-trim-01/verification.json)。旧出力との比較は固定ファームウェア版の描画コードを使った **ホスト** 試験（240×135、4ポーズ×3画角×2照明）。この出力は最近の待機・ポップ・表情を収録せず、彩雲も不透明近似。**Cardputerでの採用、連続再生、透過、実機FPS・メモリは未確認。** 比較画像・動画は保存対象外で、個別READMEの手順から生成できる。
