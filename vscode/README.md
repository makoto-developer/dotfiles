# VSCode Vim Settings

VSCodeでVimを使用する際の設定ファイルです。

## セットアップ

### 方法1: 自動セットアップ（推奨）

**最も簡単な方法です。**

```bash
# このディレクトリに移動
cd ~/dotfiles/vscode

# セットアップスクリプトを実行
./setup.sh
```

スクリプトが以下を自動で行います：
- 既存設定のバックアップ
- シンボリックリンクの作成
- 拡張機能のインストール（オプション）

### 方法2: 手動セットアップ

#### 1. 拡張機能のインストール

```bash
code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode
```

#### 2. シンボリックリンクの作成

**macOS/Linux:**

```bash
# 既存設定のバックアップ（必要に応じて）
mv ~/Library/Application\ Support/Code/User/settings.json \
   ~/Library/Application\ Support/Code/User/settings.json.backup

# シンボリックリンクを作成
ln -sf ~/dotfiles/vscode/settings.json \
       ~/Library/Application\ Support/Code/User/settings.json

# 確認
ls -la ~/Library/Application\ Support/Code/User/settings.json
```

**Windows (PowerShell管理者権限):**

```powershell
# 既存設定のバックアップ
Move-Item "$env:APPDATA\Code\User\settings.json" `
          "$env:APPDATA\Code\User\settings.json.backup"

# シンボリックリンクを作成
New-Item -ItemType SymbolicLink `
         -Path "$env:APPDATA\Code\User\settings.json" `
         -Target "$HOME\dotfiles\vscode\settings.json"

# 確認
Get-Item "$env:APPDATA\Code\User\settings.json"
```

**重要:** シンボリックリンクを使うことで、このdotfilesディレクトリで設定を一元管理できます。
設定変更は自動的にVSCodeに反映され、Gitで管理できます。

---

## 複数端末での設定共有

### 新しい端末へのセットアップ

```bash
# 1. dotfilesリポジトリをクローン
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles

# 2. VSCodeをインストール（未インストールの場合）
brew install --cask visual-studio-code

# 3. セットアップスクリプトを実行
cd ~/dotfiles/vscode
./setup.sh

# 4. 完了！
```

### 設定の更新フロー

**端末Aで設定を変更:**

```bash
# VSCodeで設定を変更すると、dotfiles/vscode/settings.json が自動更新される
# （シンボリックリンクのため）

cd ~/dotfiles
git add vscode/settings.json
git commit -m "Update VSCode settings"
git push
```

**端末Bで設定を同期:**

```bash
cd ~/dotfiles
git pull
# シンボリックリンクなので自動的に反映される
# VSCodeを再起動すれば設定が適用される
```

---

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

---

## 🔗 関連ファイル

- **[MIGRATION.md](./MIGRATION.md)** - シンボリックリンクへの移行手順
- **[SETUP.md](./SETUP.md)** - 複数端末での設定共有の詳細ガイド
- [extensions.txt](./extensions.txt) - インストール済み拡張機能リスト
- [setup.sh](./setup.sh) - 自動セットアップスクリプト

---

## 参考

- [VSCodeVim Documentation](https://github.com/VSCodeVim/Vim)
- [VSCode Key Bindings](https://code.visualstudio.com/docs/getstarted/keybindings)
- [VSCode Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync)

---

## まとめ

このdotfilesリポジトリを使えば：

✅ VSCode設定が1コマンドでセットアップ完了
✅ 複数端末で設定を自動同期
✅ シンボリックリンクで一元管理
✅ Git管理で変更履歴を追跡

まずは `./setup.sh` を実行して始めましょう！
