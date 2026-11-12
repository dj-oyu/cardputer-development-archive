# Independent J1 ON flash / collector-plan review

正式ON flashを受入、**ON固定trialは終端待ち**。exact J1 `b561aea1c0798feb28055a00d36681fae81ac58a` /既存s30 ON buildのverified source/manifest/modeproof/BINELFがflash planへ一致。10:42:00→10:47:15 UTC succeeded。237provider entriesは重複同一・1…237連続/gapなし。対象3領域ROM読取完了→write→readback→boot順、fullsegment SHA256 verified、IDF6.0.1/ELF25249d3df/HOMEが一致し、既知fatalなし。8MiB全領域読取を意味しない。

新receipt `db1e10643f69ab8510dfd43df9d4649ddf26f91a03c081910cfec15f6de46a18`。collector planのtyped flash_job_idは成功flashjob/plan/current receiptへbindし、build job/plan、source receipt/commit、canonical manifest/modeproof SHA、ON、両artifact hash、principal/device/session/epochも一致する。firmware_verificationはsuccessful_flash_receipt、expected hashは今回ELFであり旧configured-hash-onlyへ依存しない。

trial `derby-j1-on-fixed-b561aea1-20261020` は10:49:01に一度queued。strictv2、200s/64KiB/1024B line、3dependent reps/retry0。raw/quality・END/EXIT/STOP/HOME・latefault・close/lease解放は未確認で、1boot/3rep予定を成功扱いしない。

24確認と入力hashをJSONへ保存。saved acquireにcapability fieldなし。reviewerはlocal読取・本MD/JSON保存のみ、API/MCP/USB/実機/prepare/execute/retry/設定/checkout操作0。
