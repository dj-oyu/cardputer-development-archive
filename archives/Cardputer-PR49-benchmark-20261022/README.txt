Cardputer PR49 実機ベンチ / 2026-10-22 UTC

実機: 登録済み同一Cardputer / ESP32-S3、32bit pointer、CPU240MHz、PSRAMなし。
source: ebd42393eb9b382e39737b45e3e092e86c9908c3
IDF6.0.1、ccache OFF、正規broker-owned build。CI配布物そのものではなく、同sourceのWindowsローカルbuild。

同一boot内、各group64試行。warmup64、記録512、総検証576。
各trialのruntime/context/native stateはfresh。process/cacheはwarm。
setup/teardownを除くstartup workload。cold boot時間やPR46 header単独効果ではない。
timing passとallocation accounting passは分離。
medianはsorted indices31/32の平均、p95はsorted index60。近似quantileではない。
時刻単位ns、ESP timerの分解能は1us。個々の512 trialの時系列は送信せず、device内のexact summaryを保存。

supported: generic median2.2655ms、prepared2.3640ms (+4.35%)。
fallback: generic median2.8020ms、prepared2.8255ms (+0.84%)。
この観測では高速化は確認されない。単一bootの結果で、起動間の分散は未評価。

accountingのbytes/peakは要求payload量で、計測headerを除く。nativeは登録対象の計測domain。
live_deltaはworkload直後の値。teardown後の残量とは異なる。
internal_min_freeはboot以降のlow-waterで、trial固有heap peakではない。
timing passの未計測allocation countersをゼロallocationと解釈しない。

通常brokerのfull-segment SHA256 readback＋boot ELF prefix/IDF照合が成功。
元receipt ac2d2314d19cb45bf1f4903d8142c5be4c4ad575a6a043552f6a48eebe7440f8へfirmware-only restore成功。
元設定はbyte単位で復元。台帳・ACL・認証scope変更なし。
