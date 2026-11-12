# Independent native source/build preflight review

予備結論: native exact source・build plan・cache保護・既存recovery保全は整合する。**build proof/実機PASSは未判定。** reviewerはlocal保存ファイルとread-only Gitだけを確認し、本MD/JSONを保存した。API/MCP/USB/device/job/source/build/config/code操作0、test追加0。

source `3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5` / tree `b3de719ac438d8d3373a2c34786bc35c46e9200e` / receipt `bbf729af426e3110943d2fcad025311b1d088b773c0cecdbb53b4fde92e16679` / SHA256 `2b6f8223ef87de643e976686905f7fe75346f39143ea5cbdd3e00210e1200e3d`。source jobは06:04:31→06:05:00 UTC succeeded、prepare/execute/resultが一致し、3固定Gitlinkもbaselineと同じ。local native HEAD/treeはexactかつclean。

build `derby-controller-native-build-3fafcadb-20261020` は同source provenance/epoch `51bfd752bc2a460db00a835c45250282`、registered IDF6.0.1/esp32s3、同profile/registration、execution1,800s、cleanup disabled、mode任意overrideなし。06:06:29 executeは期限2026-10-20T06:36:19.894775+00:00より前。現reviewはqueued snapshotで、リンク成功・mandatory proof・実際の4modeONを先取りしない。

primary cache前後から旧17receipt全保持→計18receipt、16payload維持、pending0、固定16/2GiB上限を再確認した。唯一変わった旧行は50c43df receipt `b7821066e523e1a83e042dbeb694f6ecc1e9280095c027c25fd008a20057abeb`。85,684,739Bのsource本体が自動回収され、579,784B/2entriesのimmutable receipt証拠は保持。保護対象12payloadは全行不変、complete reference inventory/scan、unclassified0、manual cleanup許可なし。normalized RECLAMATION-EVIDENCEも一致する。aggregate bytesとowned行合計の未説明64B差は前後同じで、原因を仮定しない。payload回収とreceipt保持を区別し、旧source本体の保持/再取得は主張しない。

直前成功baseline current receipt e40bf864…889615は正式flash summary/historyおよびBASELINE-ACCEPTANCEと一致。正常historical rollback e9a33d3e…9c761aは別途保持。旧batch OOM raw902B/SHA92b8e47…8232f6とresultは元保存値・base64と同じでFAILのまま。baseline private Library v2 receiptとlocal ZIP SHA06983c3e…8d1d86も一致し、remote再取得は行っていない。

新AUTHORIZATION-SCOPEは同条件native source/build→一度flash/boot→ON固定一度だけで、batch/OFF/DMA統合・追加reset/restore・guard/config/auth/SDK変更・拒否時再試行は禁止。baseline current-image比較と正常rollback保全を分ける。後続build terminal/verified manifest/linked ON proof、freshflash/readback/boot、trial/strict終端、idle/releaseは別証拠待ち。

35確認と入力hashを`INDEPENDENT-NATIVE-PREFLIGHT-REVIEW.json`に保存。
