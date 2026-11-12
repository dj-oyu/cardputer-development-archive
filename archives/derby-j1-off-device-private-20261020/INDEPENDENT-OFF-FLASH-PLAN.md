独立判定: 保存OFF flash planとON復旧record gateはPASS。

plan canonical hash、OFF build/manifest/BIN/ELF、同一source/headとOFF modeを照合。ON plan比の変更はsession/job、LKG/backup identity、build/manifest/images/fingerprintの9項目だけ。device/principal/registration/backend/stages/effects/worker/targetは同一。自動restoreや追加操作なし。

現在ONの正確なartifact_bundle LKG receiptを明示freezeし、backup_sha256もそのreceipt identityと一致。同じON recovery buildのdurable manifestはartifact_status=verifiedで原本と完全一致、元のsuccessful flash/readback/boot記録に結合する。raw full-backup body/hashを再検証した意味ではない。

保存before-acquire statusのhistorical review/needs_reviewとauthorizes_new_work=falseは保持する。保存された300s acquire成功は確認したが、現在lease/capabilityの有効性や実機状態は再確認していない。実行時のbroker検査と既存ユーザー許可は実行担当rootの責任。本reviewは物理操作・新たな実行許可ではない。

原本98・r2・旧review・既存gateは不変。reviewerのAPI/USB/SDK/prove実行なし。書込みは本JSON/MDのみ。

field意味補足: buildとflash planのfingerprintは別domain（元ONも不一致）。build manifestのflash_authorized=falseは、manifest自体がflash権限を付与しない意味であり、別途明示許可・broker準備済planを否定する扱いにはしない。初期reviewer checkerのこの2追加仮定を修正したもので、image/manifest/LKG/registration要件は緩和していない。
