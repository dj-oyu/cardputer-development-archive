# Independent native flash and trial-plan review

新nativeの正式flash/readback/normal boot証拠は整合する。head `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` / tree `b3de719ac438d8d3373a2c34786bc35c46e9200e` / build `derby-controller-native-build-3fafcadb-20261020` / plan `e9ca6b05be362112a14c0ef0e91ce23c29484398caf6fe7cab41417385df8d5c` を照合した。flashは06:16:58 UTC succeeded。予備reviewは改変していない。**新nativeの固定計測・アプリOOM解消はtrial終端待ちで、まだ受入していない。**

全pollとfinal providerログの同一sequenceを照合し、1…231連続、gap/expiredなし。再構成privateログ/SHA `d3651f4347977c7811a053bec65ada12756791d1726f7bdc69521ff913177c01` とcontinuity summaryが一致。security probe→prewrite→write→readback→bootの順が確認できる。providerはfull-segment SHA256 readbackをverifiedとし、boot IDF6.0.1 / ELF prefix0e8abb684 / HOME_READYが一致。bootprefix単独を暗号学的証明とは扱わない。既知fatal markerは保存bootログに認めない。新LKG receipt `1f4143a623658f01ec1d8d7623b65bc4268fb8b690ed6c106ea0f5c425de63f5` が記録された。これらは保存したprovider-decoded出力で、raw UART/BINELFの独立再取得ではない。

trial `derby-controller-native-fixed-3fafcadb-20261020` は成功flash後06:18:04に一度queued。exact plan `2b4f8297a27e537147985e4f3f3b573d76ada47d93319725bc8adfa660d1df2c`、同epoch/session/device fingerprint。v2 END→owner EXIT→STOP→HOME契約、200s/64KiB/1024B line/3dependent repetitions/retry0が一致する。collectorのfirmware_verificationはconfigured_expected_hash_onlyであり、それ自体は新BINのattestationではない。直前の同device verified exact-image flash/readback/boot連鎖と組み合わせて扱う。

post-flashはserial closed/activeなし/current uncertainty=false。同一owner/leaseはtrialのため保持されており、trial完了・lease解放とは未判定。次に必要なのはterminal result、全raw/receipt/SHA、strict exact-head parser、END/EXIT/STOP/HOME順序と後続fault拒否、最終idle/release。HOME bootだけでアプリ正常・OOM解消を推測しない。batch/OFFや追加runの許可は含めない。

reviewerはlocal読取/解析と本MD/JSON保存のみ。API/MCP/device/USB/job/code操作0。22確認と入力hashを`INDEPENDENT-NATIVE-FLASH-PLAN-REVIEW.json`に保存。
