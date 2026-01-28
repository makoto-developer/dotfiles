# VSCode Vim Settings

VSCodeでVimを使用する際の設定ファイルです。

## セットアップ

### 1. 拡張機能のインストール

```bash
code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode
```

### 2. 設定ファイルのコピー

#### macOS/Linux

```bash
# VSCodeのユーザー設定ディレクトリにコピー
cp settings.json ~/Library/Application\ Support/Code/User/settings.json

# または、既存の設定とマージする場合
cat settings.json >> ~/Library/Application\ Support/Code/User/settings.json
```

#### Windows

```powershell
# VSCodeのユーザー設定ディレクトリにコピー
Copy-Item settings.json $env:APPDATA\Code\User\settings.json

# または、既存の設定とマージする場合
Get-Content settings.json | Add-Content $env:APPDATA\Code\User\settings.json
```

### 3. シンボリックリンクでの管理（推奨）

```bash
# macOS/Linux
ln -sf $(pwd)/settings.json ~/Library/Application\ Support/Code/User/settings.json

# Windows (管理者権限が必要)
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\settings.json" -Target "$(pwd)\settings.json"
```

## 主な機能

### クリップボード共有

- `y` でヤンクした内容が自動的にシステムクリップボードにコピーされます
- `vim.useSystemClipboard: true` により実現
- ヤンク時に一時的にハイライト表示されます（200ms）

### キーバインド

#### リーダーキー

リーダーキーは `<space>` に設定されています。

| キー | 動作 |
|------|------|
| `<space>w` | ファイル保存 |
| `<space>q` | タブを閉じる |
| `<space>f` | ファイル検索 |
| `<space>c` | コメントトグル（ビジュアルモード） |

#### ウィンドウ移動

| キー | 動作 |
|------|------|
| `Ctrl+h` | 左のエディタグループへ移動 |
| `Ctrl+j` | 下のエディタグループへ移動 |
| `Ctrl+k` | 上のエディタグループへ移動 |
| `Ctrl+l` | 右のエディタグループへ移動 |

#### その他

| キー | 動作 |
|------|------|
| `jj` | インサートモードから抜ける |

### VSCodeショートカットの無効化

以下のVSCode標準ショートカットはVimモードでは無効化されています：

- `Ctrl+a` (全選択)
- `Ctrl+f` (検索)
- `Ctrl+c` (コピー)
- `Ctrl+v` (貼り付け)
- `Ctrl+x` (切り取り)
- `Ctrl+z` (元に戻す)

Vimのキーバインドを優先するための設定です。

## エディタ設定

- **行番号**: 相対行番号表示（`editor.lineNumbers: "relative"`）
- **タブサイズ**: 2スペース（Goは4スペース、タブ文字使用）
- **改行コード**: LF（`\n`）
- **文字エンコーディング**: UTF-8
- **末尾空白**: 保存時に自動削除
- **ファイル末尾**: 自動的に空行を挿入

## 言語別設定

| 言語 | タブサイズ | 保存時フォーマット | 備考 |
|------|-----------|------------------|------|
| Go | 4（タブ文字） | 有効 | - |
| Python | 4 | 有効 | - |
| TypeScript/JavaScript | 2 | 有効 | Prettier使用 |
| JSON | 2 | 有効 | Prettier使用 |
| Markdown | 2 | 無効 | ワードラップ有効 |

## カスタマイズ

設定をカスタマイズする場合は、`settings.json`を直接編集してください。

### 例: リーダーキーを変更

```json
"vim.leader": ",",
```

### 例: 追加のキーバインド

```json
"vim.normalModeKeyBindings": [
  {
    "before": ["<leader>", "n"],
    "commands": ["workbench.action.toggleSidebarVisibility"]
  }
]
```

## トラブルシューティング

### クリップボード共有が動作しない

1. VSCode Vim拡張機能が最新版か確認
2. VSCodeを再起動
3. システムのクリップボードマネージャーとの競合を確認

### キーバインドが効かない

1. VSCodeの設定で競合するキーバインドを確認
2. `Preferences: Open Keyboard Shortcuts (JSON)` で確認
3. 必要に応じて `keybindings.json` で上書き

## 参考

- [VSCodeVim Documentation](https://github.com/VSCodeVim/Vim)
- [VSCode Key Bindings](https://code.visualstudio.com/docs/getstarted/keybindings)
