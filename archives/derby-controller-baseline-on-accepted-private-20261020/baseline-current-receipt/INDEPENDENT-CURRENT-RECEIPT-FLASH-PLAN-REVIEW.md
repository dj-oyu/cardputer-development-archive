# Independent flash and trial-plan review

新baselineの正式flash/readback/normal boot証拠は整合する。head `dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb` / tree `d72a737240d48def898899bf6dc71e0ac627c7f8` / build `derby-controller-baseline-build-dc2c5e04-20261020` / plan `829e0ae03117682955f0109d9f905ec4c591ead1994d4213df2df6dcef00f6a0` を照合した。flashは05:54:50 UTC succeeded。予備reviewは改変していない。**新baselineの固定計測・アプリOOM解消はtrial終端待ちで、まだ受入していない。**

全pollとfinal providerログの同一sequenceを照合し、1…236連続、gap/expiredなし。再構成privateログ/SHA `3ef6c95d017d0cd2b382109e07e4e45b0ab3504fb6b3d582604919a0dfb18379` とcontinuity summaryが一致。security probe→prewrite→write→readback→bootの順が確認できる。providerはfull-segment SHA256 readbackをverifiedとし、boot IDF6.0.1 / ELF prefixf149d372f / HOME_READYが一致。bootprefix単独を暗号学的証明とは扱わない。既知fatal markerは保存bootログに認めない。新LKG receipt `e40bf864bafa4a3fdb94b418416ee90bda54801bfa4b0887c19e73d4a3889615` が記録された。これらは保存したprovider-decoded出力で、raw UART/BINELFの独立再取得ではない。

trial `derby-controller-baseline-fixed-current-dc2c5e04-20261020` は成功flash後05:55:57に一度queued。exact plan `856cedeba14c533bf48380ac621a97ff9903fb27fe8acd3b79400349eadf66f1`、同epoch/session/device fingerprint。v2 END→owner EXIT→STOP→HOME契約、200s/64KiB/1024B line/3dependent repetitions/retry0が一致する。collectorのfirmware_verificationはconfigured_expected_hash_onlyであり、それ自体は新BINのattestationではない。直前の同device verified exact-image flash/readback/boot連鎖と組み合わせて扱う。

post-flashはserial closed/activeなし/current uncertainty=false。同一owner/leaseはtrialのため保持されており、trial完了・lease解放とは未判定。次に必要なのはterminal result、全raw/receipt/SHA、strict exact-head parser、END/EXIT/STOP/HOME順序と後続fault拒否、最終idle/release。HOME bootだけでアプリ正常・OOM解消を推測しない。native/batch/OFFや追加runの許可は含めない。

reviewerはlocal読取/解析と本MD/JSON保存のみ。API/MCP/device/USB/job/code操作0。22確認と入力hashを`INDEPENDENT-CURRENT-RECEIPT-FLASH-PLAN-REVIEW.json`に保存。
