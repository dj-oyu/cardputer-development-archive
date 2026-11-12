# J1 ON parser discrepancy — OFF held

公式collector成功と原本J1 strict gate不一致を確認。実rawのAPP_IDはapp tag、DERBY READYはjs tagの正規timestamp付きだが、原本parse_completionは両者をbare行限定で拒否。END238→EXIT239→STOP241→HOME242は各1。原本verifierはactual expected_firmware_sha256/flash_receiptに対しobsolete configured_expected_firmware_sha256を参照する。

parser-candidate内の2ファイルだけを最小修正: anchored app/js timestamp対応とduplicate/relaunch拒否維持、actual typed flash bindingの全field/source/modeproof/image/current receipt一致を必須化。実ON exportの候補host metadata gateがPASS、誤tag/重複/欠落/latefaultとbinding改竄10負ケースを拒否。patchと結果をcandidateへ保存、原本/raw不変。

BIN/ELF actual proveは未再実行（host testは既存verified proofを使用しprove importだけ未実行stub）。候補PASSはoriginal exact-J1 gateや新firmwareの受入ではない。OFF停止、ON再試行/新buildなし。releaseはinvalid_sessionで成功ではなく、期限切れ後statusはidle/ownerなし/lease0/current uncertaintyfalse。API/USB/実機/prepare/execute/設定操作なし。
