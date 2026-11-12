# Independent batch flash and trial-plan review

新batchの正式flash/readback/normal boot証拠は整合する。head `711f94fa91c6e0d6ba7bc00def75ad686b724c7d` / tree `160205ec7e435a6592378d94209a800c02ba2c91` / build `derby-controller-batch-build-711f94fa-20261020` / plan `6d59733f485ad6cb69e26e96036e3010413e6dae0014bad44d8a82dff681845d` を照合した。flashは06:36:55 UTC succeeded。予備reviewは改変していない。**新batchの固定計測・アプリOOM解消はtrial終端待ちで、まだ受入していない。**

全pollとfinal providerログの同一sequenceを照合し、1…233連続、gap/expiredなし。再構成privateログ/SHA `fb5642807e98fa3ebeb58a23153bcc53ecd1c17f8e549f7a604406fe4e27062d` とcontinuity summaryが一致。security probe→prewrite→write→readback→bootの順が確認できる。providerはfull-segment SHA256 readbackをverifiedとし、boot IDF6.0.1 / ELF prefix1093bc46b / HOME_READYが一致。bootprefix単独を暗号学的証明とは扱わない。既知fatal markerは保存bootログに認めない。新LKG receipt `916b1fe2dc4bea181bea6ce71958f995725cba185231706a2fd0d861b92daefe` が記録された。これらは保存したprovider-decoded出力で、raw UART/BINELFの独立再取得ではない。

trial `derby-controller-batch-fixed-711f94fa-20261020` は成功flash後06:37:51に一度queued。exact plan `5d310c36c3f67342473472341984b90d898b9450374f26e20a21cb969357bf81`、同epoch/session/device fingerprint。v2 END→owner EXIT→STOP→HOME契約、200s/64KiB/1024B line/3dependent repetitions/retry0が一致する。collectorのfirmware_verificationはconfigured_expected_hash_onlyであり、それ自体は新BINのattestationではない。直前の同device verified exact-image flash/readback/boot連鎖と組み合わせて扱う。

post-flashはserial closed/activeなし/current uncertainty=false。同一owner/leaseはtrialのため保持されており、trial完了・lease解放とは未判定。次に必要なのはterminal result、全raw/receipt/SHA、strict exact-head parser、END/EXIT/STOP/HOME順序と後続fault拒否、最終idle/release。HOME bootだけでアプリ正常・OOM解消を推測しない。OFFや追加runの許可は含めない。

reviewerはlocal読取/解析と本MD/JSON保存のみ。API/MCP/device/USB/job/code操作0。23確認と入力hashを`INDEPENDENT-BATCH-FLASH-PLAN-REVIEW.json`に保存。
