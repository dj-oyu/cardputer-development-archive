# 人間キャラクターとゲーミングチェア アセット案内

## まず開くもの

| 用途 | 編集原本 |
| --- | --- |
| キャラクターの造形を直す | [立位の高詳細マスター v44](leg-lines-44/human-leg-lines-44.blend)。衣装と膝下の輪郭を含む採用原本。[v45の説明](gaming-chair-lod-45/README.md)に経緯。 |
| リグと基準姿勢を確認する | [立位の首振り](human-character-20261120/motion-review-v125/head-turn-standing.blend)／[座位の首振り](human-character-20261120/motion-review-v125/head-turn-seated.blend)のフレーム1。 |
| 表情を扱う | [表情・漫符 v78](girl-expressions-and-emotes-78/girl-expressions-and-emotes-v78.blend)／[劇画顔 v85](girl-gag-gekiga-gpt-85/girl-gekiga-gpt-strong.blend)。 |
| 椅子を扱う | [背面ウィンドウ v109](human-character-20261120/chair-back-topdown-v109/chair-rear-topdown-v109.blend)／[200三角形の不透明形状候補](gaming-chair-opaque-200/chair-opaque-combined-200.blend)。 |

いずれも作業別のBlender原本。最新版の顔・椅子・全モーションをまとめた単一ファイルではない。

## 確認した15組の動作と原本

| 姿勢 | 動作 | 編集原本 |
| --- | --- | --- |
| 立位 | 首を横に向けて戻す | [首振り](human-character-20261120/motion-review-v125/head-turn-standing.blend) |
| 立位 | 右足を開き、右手を腰に置き、右に体重を預ける | [右ステップのZIP](human-character-20261120/standing-ik-20261121/standing-right-step-and-reaction-v113.zip) 内の right-step-waist.blend（v112） |
| 立位 | 体重移動後に前傾と首を同期し、顔の角度を保つ | [前傾 v115](human-character-20261120/standing-ik-20261121/girl-forward-lean-sync-v115.blend) |
| 立位 | 肩のひねりに手の甲が追従し、頭に両手を置く | [両手を頭へ v124](human-character-20261120/standing-ik-20261121/girl-overhead-stretch-v124.blend) |
| 立位 | 左手で「いいね」の後、親指を鼻に寄せる | [親指を鼻へ v106](human-character-20261120/standing-ik-20261121/girl-thumb-nose-v106.blend) |
| 立位 | 両手を腰に置き、腰を左右にひねる | [腰ストレッチ v103](human-character-20261120/motion-review-v125/girl-waist-twist-standing-v103.blend) |
| 座位 | 首を横に向けて戻す | [首振り](human-character-20261120/motion-review-v125/head-turn-seated.blend) |
| 座位 | 足と骨盤を固定し、顔の角度を保って前傾 | [前傾の座位版](human-character-20261120/motion-review-v125/forward-lean-seated-v115.blend) |
| 座位 | 両手を頭の近くに上げてから戻す | [両手を頭へ・座位版](human-character-20261120/motion-review-v125/hands-to-head-seated-v124.blend) |
| 座位 | 左手の「いいね」から親指を鼻に寄せる | [親指を鼻へ・座位版](human-character-20261120/motion-review-v125/thumb-near-nose-seated-v106.blend) |
| 座位 | 膝に肘を置くように前傾し、頭の形を保って戻る | [膝に肘を置く前傾 v76](gaming-chair-seated-lean-rigid-head-76/chair-idle-lean-rigid-head-v76.blend) |
| 座位 | 右足首を据え、右膝を寄せて組み、元に戻す | [膝組み v90](gaming-chair-knee-thigh-yaw-90/chair-knee-thigh-yaw-v90.blend) |
| 座位＋椅子 | 座った人物と座面が一緒に回転。台座は固定 | [椅子 v109](human-character-20261120/chair-back-topdown-v109/chair-rear-topdown-v109.blend) ＋ [回転を再現する手順](human-character-20261120/motion-review-v125/TURNTABLE.md) |
| 立位→座位 | 一歩で座面に合わせ、脱力して腰と上体が連動して落ちる | [着座 v100](gaming-chair-quick-release-sit-100/chair-quick-release-v100.blend) |
| 座位→立位 | 肘掛けに手を置いて体重を移し、手を離して立つ | [立ち上がり v99](gaming-chair-earlier-hands-stand-99/chair-stand-earlier-hands-v99.blend) |

[5本のv125原本](human-character-20261120/motion-review-v125/README.md)は首振り2本と座位に移した3動作。右ステップ・腰ストレッチの座位版はない。座位の前傾2本は別の動作。両手を頭に置く立位版は終点保持、座位版は戻りまで。ZIP内の首だけを出す旧派生と [頭上ストレッチ旧版 v105](human-character-20261120/standing-ik-20261121/girl-overhead-stretch-v105.blend) は比較用で15本に含めない。

## 表情・椅子・旧版

- **表情と漫符：** [v78の操作](girl-expressions-and-emotes-78/README.md)を参照。顔は通常・困り・驚き・ギャグ・眠い、まばたきと笑顔は別操作。漫符は汗・混乱・怒り。[劇画顔 v85](girl-gag-gekiga-gpt-85/RESULT.md)は顔テクスチャの別系統で、膝・足首の新版と統合していない。
- **椅子の背面：** [v109の演出](human-character-20261120/chair-back-topdown-v109/README.md)はV8、照り返し、蛇腹、白タンクと青い小瓶。[着座した人物込みのターンテーブル手順](human-character-20261120/motion-review-v125/TURNTABLE.md)では、人物・座面・窓が一体で回り、台座・キャスターは固定。この回転では人物は座り姿勢を保持する。足裏を床に据える別の試作は [同期旋回 v74](gaming-chair-seat-height-74/chair-seated-v74.blend)。
- **椅子の軽量化と試作：** [不透明200三角形版の内訳](gaming-chair-opaque-200/ARCHIVE.md)は椅子が200、人物が1,913三角形（背面演出は別）。[9層の試作](gaming-chair-nine-50/README.md)、[セルフシャドウ](gaming-chair-self-shadow-52/README.md)、[点火反射](gaming-chair-isolated-ignition-64/README.md)は演出の比較用。
- **動作の経緯：** [座面+0.12 BU](gaming-chair-seat-height-74/README.md)／[膝組みの太ももと足首](gaming-chair-knee-thigh-yaw-90/RESULT.md)／[脱力のタイミング](gaming-chair-quick-release-sit-100/RESULT.md)／[肘掛けの接触](gaming-chair-earlier-hands-stand-99/RESULT.md)。v74の旋回端では太ももとクッションに交差が残る。
- **初期造形：** [ブロックアウト](blockout-01/README.md) → [奥行きと関節](anatomy-04/README.md) → [ジャケット案](varsity-06/README.md)。[顔テクスチャ](face-texture-08/README.md)、[ざんぎり髪](chopped-hair-27/README.md)、[ポケット修正](jacket-markup-42/human-jacket-markup-42.blend)は当時の比較原本。

**検証範囲：** Blenderでの編集・プレビュー用の保存版。ファームウェア統合、Cardputer実機での連続再生・FPS、椅子演出の負荷は未確認。レビュー動画は原本ではないため、現在の保存版には含めず、必要に応じて対応する手順から再生成する。
