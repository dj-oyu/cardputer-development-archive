# Cardputer ADV ビルドキット（TOML設定版）

同梱の `cardputer-adv.local.toml` に、確認済みの開発環境パスと対象コミットを記入済みです。環境が変わっていれば設定を修正してください。スクリプトが別の環境に自動で切り替えることはありません。

## 使い方

1. ESP-IDF **6.0.1 が有効な PowerShell** で、展開したフォルダを開きます。環境の有効化が必要な場合は、自分で次を実行してください。ビルドスクリプトは実行しません。

   ```powershell
   . 'C:\Espressif\tools\Microsoft.v6.0.1.PowerShell_profile.ps1'
   ```

2. 設定を読み込み、計画と実際に解決されたパスを確認します。**この段階ではビルド・ダウンロード・出力作成を行いません。**

   ```powershell
   .\Build-Main.ps1 -Config .\cardputer-adv.local.toml
   ```

3. 内容を確認したら、同じコマンドに `-Execute` を付けます。

   ```powershell
   .\Build-Main.ps1 -Config .\cardputer-adv.local.toml -Execute
   ```

設定ファイルの `[actions]` は次の意味です。

- `prepare_dependencies = true`：`-Execute` 時に、依存ソースの取得とIDFの依存関係準備を許可します。計画表示だけでは通信しません
- `fetch_source = false`：対象コミットを取得しません。ローカルに無ければ停止します。取得を許可する場合だけ `true` に変更し、もう一度計画を確認してください

出力先が既にある場合は停止します。設定内の `output.run_root` を新しいディレクトリ名に変更してください。親ディレクトリは事前に存在する必要があります。既存出力の再利用・削除・自動リトライはしません。

## 同梱設定について

- リポジトリ、IDF、Python、コンパイラのパスは、これまでの開発ログで確認された値です。現在も存在するかは計画時に検証します
- IDF toolsルートは推測せず、設定で明示した `IDF_TOOLS_PATH` セレクターから、現在有効な値を読み取ります
- Nodeは、`where.exe node` で確認された `C:\Program Files\nodejs\node.exe` を `mode = 'path'` で指定済みです。VoltaがPATHの先頭にあっても、このパスをバージョン検査と `-DPOCKET_NODE` の両方に使います。存在・実行成功・Node 16以上を計画時に検証し、失敗しても別のNodeへ切り替えません。PATH変更やアンインストールは不要です
- `mode = 'command'` は、指定した名前について現在のPATHで最初に解決されたApplicationを明示的に選びます。候補を並べ替えず、同じ絶対パスの重複（大文字小文字の違いを含む）だけを除きます。後ろに別のインストールがあっても停止しません。先頭が古い・不正・実行不能なら、後ろへフォールバックせず停止します
- Git / CMake / Ninja / コンパイラは、子ツールが名前で呼び出すため、`mode = 'path'` でも現在のPATHの先頭と一致する必要があります。後ろの候補が同じパスである必要はありません。Nodeだけは、この確認済みソースで全ビルド呼び出しが `POCKET_NODE` に束縛されるため、PATHの先頭との一致を要求しません
- 計画の `tools` と `toolSelection` に、使用する絶対パス、PATHの先頭、順序を保った候補一覧、先頭一致が必要かを記録します。`toolVersions` とともに確認してください。環境の有効化、PATHの書き換え、インストールは行いません
- 対象は設定中の完全なSHAです。main/latestの選択・追跡・更新は行いません。既存originと設定URLの不一致も停止します
- この設定には個人のローカルパスが含まれます。公開リポジトリへ追加しないでください

### ツール選択の根拠

- 対象コミット `1b4524e3db8524365f58e8c7fb56531c31b55e22` の [`main/CMakeLists.txt`](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/1b4524e3db8524365f58e8c7fb56531c31b55e22/main/CMakeLists.txt#L354-L400) は、Node検査・plan変換・ROM生成の全てで `POCKET_NODE` を使用します。追跡対象に `package.json` / `.node-version` / `.nvmrc` は無く、Volta固有の版指定はありません。要件はNode 16以上です
- 同コミットの [`prepare_dependencies.py`](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/1b4524e3db8524365f58e8c7fb56531c31b55e22/tools/prepare_dependencies.py) は `git` を名前で呼びます。IDF v6.0.1の [`tools.py`](https://github.com/espressif/esp-idf/blob/v6.0.1/tools/idf_py_actions/tools.py#L534-L566) と [`constants.py`](https://github.com/espressif/esp-idf/blob/v6.0.1/tools/idf_py_actions/constants.py#L13-L22) もCMake/Ninjaを名前で呼びます。`CMAKE_MAKE_PROGRAM` の指定だけではIDF自身のNinja選択を変えられません
- コンパイラはこのキットから直接上書きせず、既に有効なIDFツールチェーンに選択させます。IDF v6.0.1の [`toolchain.cmake`](https://github.com/espressif/esp-idf/blob/v6.0.1/tools/cmake/toolchain.cmake) はCコンパイラを通常の変数として設定します。PATHの先頭一致に加え、構成後の `project_description.json` でも指定パスとの一致を確認します

## 対応するTOMLの範囲

外部パーサーをインストールせず、PowerShellだけで設定全体を検証してからツールを実行します。一般的なTOMLのうち、以下だけを受け付ける小さな厳密サブセットです。

- UTF-8（先頭BOM可）、最大64 KiB、LFまたはCRLF
- この設定ファイルで使っている既知のテーブル名・キー名のみ。大文字小文字を区別します
- 1行のシングルクォート文字列 `'...'` と、小文字の `true` / `false`
- 文字列の外の空白は半角スペースかタブ。`#` は文字列の外でのみコメントになります
- 文字列内の `\`、`#`、`$...` はそのままの文字です。変数展開・コマンド評価はしません

重複テーブル・重複キー・不明キー・不足キー・空値・不正UTF-8・不正制御文字はエラーです。ダブルクォート、複数行文字列、配列、数値、インラインテーブル、キーの省略には対応しません。

設定内のパスは絶対パスが必須です。コマンド名は `mode = 'command'`、環境変数参照は `tools_path_mode = 'environment'` と明示します。環境セレクターは `IDF_TOOLS_PATH` のみを許可します。設定ファイル自身は `-Config .\ファイル名.toml` のように指定できます。

設定ファイルのパス・SHA-256・選択方法・解決結果は計画に記録します。検証中に設定内容が変わった場合は、実行せず新しい計画の確認を求めます。

## 実行範囲と保護

- 新しいRunRootを `os.mkdir`（WindowsではCreateDirectoryW）で排他的に作成し、所有マーカーも新規作成します。既存ディレクトリ・ファイル・マーカーは保持します
- 設定SHAのdetached worktreeを作り、その中の `build_main` と専用sdkconfigでビルドします。既存チェックアウトの作業ファイル、index、ブランチ選択は変更しません。Gitのオブジェクト保存先とworktree管理情報には、計画に記載した変更が発生します
- 設定したソースの `prepare_dependencies.py` とIDFの依存関係処理を実行します。確認済みコミットの依存元はBMI270、Opus v1.6.1、minimp3です。実際の依存SHA/origin、dependencies.lockのハッシュと差分を記録します
- ソースのsdkconfig.defaultsのみ使用します。Node / Python / NinjaをCMakeへ明示します。構成後・ビルド後の `CMakeCache.txt` で `POCKET_NODE` / `CMAKE_COMMAND` / `CMAKE_MAKE_PROGRAM` / `PYTHON` の実パスを照合し、欠落・重複・不一致は停止します。CコンパイラとIDFは `project_description.json` の実パスを照合します（コンパイラがキャッシュ変数とは限らないため、キャッシュへの記録は要求しません）。コンパイラキャッシュは明示的にOFFです
- 一時的なGitトレース無効化・置換/lazy-fetch抑止、空hooks設定、RunRoot内のコンポーネントキャッシュを計画に表示します。変更はプロセス内のみで、終了時に元へ戻します
- Gitのフィルター・fsmonitor・URL書換え、未対応のコンポーネント設定や独自プロファイルなどは停止理由になります。既存の設定を勝手に解除しません。EIMのmirror/profile/constraintsにより停止した場合は、実行前に明示的な確認が必要です
- RunRoot以外のIDF/ツール/user/temp領域を外部ビルドツールが利用することがあります。既存共有キャッシュの削除はしません。このキットはファイルシステムのサンドボックスではありません

PowerShell 5.1+、IDF 6.0.1、Node 16+、Python 3.9+、`--no-lazy-fetch` 対応Gitが必要です。Junction/symlinkや入れ子の出力先は拒否します。読み取り専用の正規化パス検査も行い、指定パスと解決後パスを計画に表示します。

ビルド成功後は `manifest.json`、`plan.json`、`evidence`、`logs` を確認用に返してください。アプリサイズ/SHA-256、生成sdkconfig、project_description.json、flasher_args.json、パーティション情報、ソースSHA、ツール情報が入ります。バイナリ/ELF/mapは `wt-main\build_main` に残ります。

**USB・シリアル・flash・reboot・erase・merge・pushは行いません。** ビルドの成功だけで実機起動を確認済みとはしません。

## 検証状況

40件のオフラインテストが通過しています。Pythonヘルパーの実行試験、排他的作成/衝突保護、生成物検証に加え、同梱設定の標準TOML互換性、TOMLサブセットの参照実装・境界ケース、PowerShellソースの静的契約を検査しています。追加8件は、複数Node候補と絶対パス選択、PATH順序・重複、子ツールの先頭不一致拒否、CMakeキャッシュ照合の参照実装/静的検査です。

**準備環境にPowerShellが無いため、実際のPowerShellパーサー/スクリプト、Windowsパス処理、ESP-IDFビルドは未実行です。** Pythonの参照実装テストは、PowerShellパーサーの実行試験を代替しません。実機へもアクセスしていません。

実際のPowerShellパーサーを別途検査するための `tests\Test-Config.ps1` と29件のfixtureも同梱しています。これは自動実行されません。実行する場合は、既存の親の下に新しい一時出力先を明示してください。

```powershell
.\tests\Test-Config.ps1 -ScratchDirectory '<新しい絶対パス>'
```

ツール選択/キャッシュ照合のPowerShell用模擬テスト24件も `tests\Test-ToolSelection.ps1` に同梱しています。こちらはコマンド検索を模擬し、実行ファイル起動・PATH変更・書き込みを行いません。この準備環境では未実行です。Windows上で次を実行できます。

```powershell
.\tests\Test-ToolSelection.ps1
```

パーサー検査のfixturesは削除せず残します。オフラインPythonテスト全体の実行には、テスト用の `tomllib` が標準搭載されたPython 3.11+が必要です。ビルド用ヘルパーの要件はPython 3.9+のままです。
