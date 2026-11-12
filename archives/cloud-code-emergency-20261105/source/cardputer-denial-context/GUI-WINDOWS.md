# セッションと実機待ち列の管理画面

## まず mock で起動

既存 broker が動いていれば、ジョブが実行中でないことを確認し、そのコンソールで停止します。
更新 ZIP のコードを同じプロジェクトに入れ、private 設定と `.state` はそのまま保持してください。
設定・履歴・認証キーを含むファイルは配布 ZIP に入っていません。

通常の PowerShell を MCP フォルダーで開きます。

```powershell
uv sync --frozen
& .\Start-CardputerGui.ps1
```

既定では認証付き mock broker と GUI を起動します。USB を開きません。
初回だけ汎用テンプレートから device.mock.local.toml を作ります。既存ファイルは上書きしません。
Tunnel の実際の ID や認証キーは自動設定しません。
既存 broker の黙った再利用や強制終了、認証キーの永続保存はしません。
GUI 右上の Tunnel... から、同じ broker TOML の非秘密設定と、GUI が起動した client の死活を管理できます。
GUI を閉じるときは、所有する Tunnel があれば切断確認を表示します。broker と実行中の仕事は継続します。元の PowerShell で再度 GUI だけを開く場合:

```powershell
uv run cardputer --auth-source environment gui
```

別ポート/設定では同じ private config を `gui --config` に指定してください。
Tkinter がない Python では GUI は起動できません。通常の Python 3.11+ の Tk 対応環境が必要です。
実際の Linux GUI と mock HTTP は検証済みですが、Windows のネイティブ表示・PowerShell 起動は未検証です。

## 画面でできること

- MOCK/SERIAL、現在の物理所有者、公開 lease/session/request ID、実行中 job、review/所有権不明状態を表示
- 論理作業セッションを表示。開いているもの、実行継続中の所有者、最近20件の終了セッションが対象
- 実機取得の FIFO 待ち列と、待ち時間の残りを表示
- WAITING の行を選択してキャンセル、上下に移動
- 仕事が動いていない所有者だけを、公開 lease ID を確認して解放

並べ替えは表示時の queue revision と一致した場合のみ受理します。
ほかのクライアントや時間切れで順序が変わった場合は、再取得してから操作します。
待っている間の TTL と、実機取得後の lease TTL は別です。

実行中のジョブ・未確認の USB close がある間は次へ渡しません。
この版には強制停止、実行途中の flash 中断、reset、review の自動解除はありません。
現在の real adapter は passive observation と HELLO の限定版です。
GUI は同じ resident broker の状態を読むだけで、別のシリアル読み取り処理を持ちません。

## 実機モードの起動だけ行う場合

```powershell
& .\Start-CardputerGui.ps1 -EnableSerial -Config '.\device.local.toml'
```

これだけでは USB は開きません。実行には別途、認証・所有 lease・immutable plan・
ローカル承認が必要です。以前の HELLO の needs_review は保持されます。

## Tunnel と同時に使う場合

[TUNNEL-WINDOWS.md](TUNNEL-WINDOWS.md) の公式セットアップを利用者が済ませた後、
同じ一度の起動から GUI を開けます。v0.5 の -Gui は GUI 管理モードです。
-Connect が併記されても別コンソールの client は起動せず、パネルの Connect 操作を待ちます。

```powershell
& .\Start-CardputerTunnel.ps1 -Connect -Gui
```

まず mock を使ってください。実機切替は別途 `-EnableSerial` と private config が必要です。
GUI 操作用のローカル token は公式 Tunnel client に渡しません。
GUI の operator API は local_cli + control の認証だけを受け付け、Tunnel 用 remote_mcp では操作できません。
クラウド側での接続可否は、実際の tools/list と device_status が成功するまで未確認です。
