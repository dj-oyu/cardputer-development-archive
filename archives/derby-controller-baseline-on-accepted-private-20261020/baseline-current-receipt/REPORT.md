# 新baseline ON実機受入：PASS

baseline dc2c5e044429a4904e91564aa7f9cb30d7d4cbbbの正規flash・readback・boot後、ON固定計測1回が厳格受入に合格した。1 fresh flash boot、3 dependent replaysであり、独立3試行ではない。native/batch/OFF、追加backup/restore、再reset、設定/auth/SDK変更へ進んでいない。今回の実績は保存整理を待たず05:55と05:58 UTCに先行報告した。

## Exact imageと実行結果

- branch: fix/derby-detail-controller-baseline-20261020、head dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb、tree d72a737240d48def898899bf6dc71e0ac627c7f8、[Draft PR25](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/25)。本工程でコード・head・計測条件・PRを変更していない。
- build job: derby-controller-baseline-build-dc2c5e04-20261020、05:23:03成功済みを再利用。source receipt f3e20e9932a0cf9322468dafdc157f39b3ae7c40ebd82b618d7392ab7fb30e05、source SHA256 0ce2035d523c75ff15a62f9c322a0adbd9a1938ff3fbf0e6422ff1c5761f61c6。fresh durable manifest artifact_status=verified。
- BIN SHA256 ae7ec8ec1fddd0238003c903fafe7c6de47ffe3c1e7df7c3b7b08a94f861578b、ELF SHA256 f149d372f186a0e6642d2d929db1cbf1ae6cd2f8163458832b2024f0074c7962。
- flash job: derby-controller-baseline-flash-current-dc2c5e04-20261020、05:49:38→05:54:50 UTC succeeded / firmware_flash_completed。
- flash plan: 829e0ae03117682955f0109d9f905ec4c591ead1994d4213df2df6dcef00f6a0。
- device cardputer、principal ephemeral:remote_mcp、epoch51bfd752bc2a460db00a835c45250282。新規plan/execute各1回、deduplicated=false。
- 現物一致比較元は旧batch flash成功履歴から取得した完全receipt 5e1fa311d4a565672d27b5bff976fb04e30c92ff993bcf51f05fe07693a70b22。保持物検証と対象firmware 3領域のROM bytes比較を同じguardで通過し、書込み後に全segment SHA256 readback、IDF6.0.1/ELF prefix f149d372f、HOME_READY、正常closeを確認した。8MiB全flashを読んだという意味ではない。236 provider-decoded entriesは連続、gap/expired=false。boot text単独の暗号学的attestationとは扱わない。
- 新baseline flash成功により保持されたreceipt: e40bf864bafa4a3fdb94b418416ee90bda54801bfa4b0887c19e73d4a3889615。

## ON固定計測

- trial job: derby-controller-baseline-fixed-current-dc2c5e04-20261020、05:55:57→05:57:28 UTC succeeded / derby_fixed_trial_verified / serial_close。
- trial plan: 856cedeba14c533bf48380ac621a97ff9903fb27fe8acd3b79400349eadf66f1。
- fixed fixture oval-pan8-390-510-v1、seed9112A7AB、camera8、race1000001、120 completed contexts、3 dependent replays。250ms watchdog/180秒sessionと未計測tailの既存仕様を維持したbuild。
- work_ms: **6770.279 / 6770.404 / 6767.900**、全quality=0・valid=1。
- raw transport: 31,105B、SHA256 9c71ea832a8d13226afe17fb0d480bb82e125ff66a5a1916557d3cf91076311d、87,913ms。complete=true、gaps/overflow/truncated/partial_tail/disconnect/reset/refusedは全false。
- END line238→同session owner EXIT line239→APP_STOPPED line241→HOME_READY line242。providerのowner_exit_v2 terminal_success_verified=trueとquiet boundary後のconfirmed serial closeを確認。
- 保存rawに対するcurrent exactheadのparse_collectedとparse_detailもPASS。known work、全summary、26 detail stages/13 eventsを3rep分、階層計算・schema・owner終了順序・全transport内fatal拒否を検証した。ログのみのquality値を完全transportの代替にしていない。
- collector planのconfigured_expected_hash_onlyは単独の実機image attestationではない。同device/session/epochで直前のexact flash/readback/bootと結び付けた。

詳細はACCEPTANCE.json、detail-stages.csv、detail-events.csv、DETAIL-STAGE-SUMMARY.jsonへ保存した。inclusive/selfはpreemptionを含むelapsedであり、CPU占有や純transfer時間ではない。copy/writeの論理bytesと実bus trafficは区別する。OFF対照・native/batch再測定・性能改善の結論は今回の受入範囲外。物理LCD出力hashのattestationも行っていない。

## 保全と残工程

旧batch play compile OOM raw902B/SHA92b8e47e55c6aeeccc57e2e622154319b5c243499613418bb14b7020ca8232f6、失敗result、旧正常baseline rollback receipt e9a33d3e3d0a9c1809a4238efc42c85cf440837ec62466c5c52326ddd69c761aを別途保持した。batch receiptのLKG名称をアプリ正常認定へ読み替えず、失敗履歴も今回以前のprewrite拒否も書き換えていない。

親が現行MCP88890ed7を独立reviewし、前回driver.write前停止・receipt用途誤りを確認したことを新しい関連証拠とし、既存のユーザーyを受けた新exact指示の範囲で実行した。同guardを無効化・緩和せず比較元を修正した。AUTHORIZATION-SCOPE.jsonに境界を保存した。

leaseは解放済み、capabilityはV8から消去。final statusはidle・ownerなし・queue/session/lease0・current execution/ownership/profile uncertainty=false。historical needs_review=9はそのまま残る。後続実機操作は停止して親へ戻す。並行のOFF契約/DMA開発は別branch・実機操作禁止であり、今回のheadや条件へ取り込んでいない。

オフライン再検証：exactheadの/workspace/derby-controller-baselineを用意し、`python3 /workspace/derby-evidence/controller-baseline-current-receipt-20261020/verify_trial.py`。これは保存ファイルだけを読み、実機/MCP操作をしない。独立review結果は同folderのINDEPENDENT-CURRENT-RECEIPT-*.md/json。publicには生ログ・秘密を出さず、証拠ZIPはprivate Libraryへ保存する。BIN/ELF本体はこのZIPへmaterializeしておらず、正規providerの検証済みmanifest/保持物に基づく。

今回のbaseline ON受入に未解決blockerはない。native/batchの修正版実機受入とOFF対照は未実行で、親の次指示待ち。コード/旧実機全成果Library v7（libfile_54f384d164808191a369081825204874）、source/build成功packet（libfile_bfd8b5f40ef88191aba876756476ac4a）、前回停止/receipt照合Library v1は上書き破棄せず保全する。
