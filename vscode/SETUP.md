# VSCode設定の複数端末共有手順

このガイドでは、VSCodeの設定を複数の端末（Mac/Linux/Windows）で同期する方法を説明します。

---

## 📋 目次

1. [方法1: Gitリポジトリでの管理（推奨）](#方法1-gitリポジトリでの管理推奨)
2. [方法2: VSCode Settings Syncを使用](#方法2-vscode-settings-syncを使用)
3. [方法3: クラウドストレージ経由](#方法3-クラウドストレージ経由)
4. [トラブルシューティング](#トラブルシューティング)

---

## 方法1: Gitリポジトリでの管理（推奨）

このdotfilesリポジトリを使って設定を管理する方法です。

### ✅ メリット

- バージョン管理できる
- 変更履歴が残る
- 複数端末で確実に同じ設定を共有
- OSごとの設定分岐も可能

### 🔧 初回セットアップ

#### 1. dotfilesリポジトリのクローン

```bash
# SSHの場合
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles

# HTTPSの場合
git clone https://github.com/makoto-developer/dotfiles.git ~/dotfiles
```

#### 2. VSCodeのユーザー設定パスを確認

| OS | パス |
|----|------|
| macOS | `~/Library/Application Support/Code/User/` |
| Linux | `~/.config/Code/User/` |
| Windows | `%APPDATA%\Code\User\` |

#### 3. シンボリックリンクの作成

**macOS / Linux:**

```bash
# バックアップを作成
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
# バックアップを作成
Move-Item "$env:APPDATA\Code\User\settings.json" `
          "$env:APPDATA\Code\User\settings.json.backup"

# シンボリックリンクを作成
New-Item -ItemType SymbolicLink `
         -Path "$env:APPDATA\Code\User\settings.json" `
         -Target "$HOME\dotfiles\vscode\settings.json"

# 確認
Get-Item "$env:APPDATA\Code\User\settings.json"
```

#### 4. 拡張機能のインストール

```bash
# 必須拡張機能
code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode

# 推奨拡張機能
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension golang.go
code --install-extension ms-python.python
code --install-extension rust-lang.rust-analyzer
code --install-extension hashicorp.terraform
code --install-extension redhat.vscode-yaml
```

### 🔄 新しい端末へのセットアップ

既に他の端末で設定済みの場合、新しい端末では以下の手順のみ：

```bash
# 1. リポジトリをクローン
cd ~
git clone git@github.com:makoto-developer/dotfiles.git

# 2. シンボリックリンクを作成（上記参照）
cd dotfiles/vscode
./setup.sh  # セットアップスクリプトを使用（後述）
```

### 📝 設定の更新フロー

**端末Aで設定を変更:**

```bash
cd ~/dotfiles
git add vscode/settings.json
git commit -m "Update VSCode settings: add new keybinding"
git push
```

**端末Bで設定を同期:**

```bash
cd ~/dotfiles
git pull
# シンボリックリンクなので自動的に反映される
```

### 🤖 自動セットアップスクリプト

`vscode/setup.sh` を作成して、セットアップを自動化：

```bash
#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VSCODE_USER_DIR=""

# OS判定
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# バックアップ作成
if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
    echo "Backing up existing settings.json..."
    mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
fi

# シンボリックリンク作成
echo "Creating symbolic link..."
ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"

echo "✅ Setup complete!"
echo "VSCode settings.json is now linked to: $SCRIPT_DIR/settings.json"

# 拡張機能のインストール（オプション）
read -p "Install recommended extensions? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing extensions..."
    code --install-extension vscodevim.vim
    code --install-extension esbenp.prettier-vscode
    echo "✅ Extensions installed!"
fi
```

**使い方:**

```bash
cd ~/dotfiles/vscode
chmod +x setup.sh
./setup.sh
```

---

## 方法2: VSCode Settings Syncを使用

VSCode組み込みの同期機能を使う方法です。

### ✅ メリット

- 設定、キーバインド、拡張機能、スニペットをすべて同期
- GitHubまたはMicrosoftアカウントで簡単に同期
- 自動同期

### ⚠️ デメリット

- バージョン管理ができない
- dotfilesリポジトリに設定が残せない
- 競合が発生する可能性

### 🔧 セットアップ

1. VSCodeを開く
2. `Cmd/Ctrl + Shift + P` → "Settings Sync: Turn On"
3. GitHubまたはMicrosoftアカウントでサインイン
4. 同期する項目を選択
   - ✅ Settings
   - ✅ Keyboard Shortcuts
   - ✅ Extensions
   - ✅ User Snippets
5. 他の端末でも同じアカウントでサインイン

### 📝 併用する場合

Settings Syncと併用する場合：

1. Settings Syncで拡張機能とキーバインドを同期
2. `settings.json`だけはdotfilesで管理（シンボリックリンク）

Settings Syncの設定で`settings.json`を除外：

```json
{
  "settingsSync.ignoredSettings": [
    // 必要に応じて追加
  ]
}
```

---

## 方法3: クラウドストレージ経由

Dropbox/Google Drive/iCloud経由で同期する方法です。

### 🔧 セットアップ（macOS/Linux）

```bash
# 1. クラウドストレージに設定を移動
mv ~/Library/Application\ Support/Code/User/settings.json \
   ~/Dropbox/vscode/settings.json

# 2. シンボリックリンクを作成
ln -s ~/Dropbox/vscode/settings.json \
      ~/Library/Application\ Support/Code/User/settings.json
```

### ⚠️ 注意点

- クラウドストレージの同期遅延がある
- 競合ファイルが発生する可能性
- バージョン管理ができない

---

## 🔄 OS別の設定分岐

複数OSで異なる設定が必要な場合：

### パターン1: 条件分岐なし（推奨）

OS非依存の設定のみを記述し、共通化する。

```json
{
  "editor.fontSize": 14,
  "editor.fontFamily": "Menlo, Monaco, 'Courier New', monospace"
}
```

### パターン2: OS別ファイルを用意

```
vscode/
├── settings.json          # 共通設定
├── settings.macos.json    # macOS専用
├── settings.linux.json    # Linux専用
└── settings.windows.json  # Windows専用
```

セットアップスクリプトでOSを判定してマージ：

```bash
#!/bin/bash

OS_TYPE=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
fi

# JSONをマージしてシンボリックリンク
jq -s '.[0] * .[1]' settings.json settings.$OS_TYPE.json > /tmp/settings.json
ln -sf /tmp/settings.json "$VSCODE_USER_DIR/settings.json"
```

### パターン3: プラットフォーム固有の設定をコメント

```json
{
  "editor.fontSize": 14,

  // macOS only
  // "terminal.integrated.fontFamily": "MesloLGS NF",

  // Windows only
  // "terminal.integrated.fontFamily": "Cascadia Code"
}
```

---

## 📦 拡張機能の同期

### 方法1: 拡張機能リストをエクスポート

```bash
# 現在の拡張機能をエクスポート
code --list-extensions > ~/dotfiles/vscode/extensions.txt

# リポジトリにコミット
cd ~/dotfiles
git add vscode/extensions.txt
git commit -m "Update VSCode extensions list"
git push
```

**新しい端末でインストール:**

```bash
# 一括インストール
cat ~/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
```

### 方法2: インストールスクリプトを作成

`vscode/install-extensions.sh`:

```bash
#!/bin/bash

extensions=(
  "vscodevim.vim"
  "esbenp.prettier-vscode"
  "ms-vscode.vscode-typescript-next"
  "golang.go"
  "ms-python.python"
  "rust-lang.rust-analyzer"
)

for ext in "${extensions[@]}"; do
  echo "Installing $ext..."
  code --install-extension "$ext"
done

echo "✅ All extensions installed!"
```

---

## 🔧 キーバインドの同期

`settings.json`と同様に、`keybindings.json`もシンボリックリンクで管理：

```bash
# macOS/Linux
ln -sf ~/dotfiles/vscode/keybindings.json \
       ~/Library/Application\ Support/Code/User/keybindings.json
```

---

## 📋 チェックリスト

新しい端末でのセットアップ時：

- [ ] dotfilesリポジトリをクローン
- [ ] VSCodeをインストール
- [ ] `settings.json`のシンボリックリンクを作成
- [ ] （オプション）`keybindings.json`のシンボリックリンクを作成
- [ ] 拡張機能をインストール
- [ ] VSCodeを再起動
- [ ] 設定が反映されているか確認

---

## 🐛 トラブルシューティング

### 設定が反映されない

**原因:**
- シンボリックリンクが壊れている
- VSCodeが設定ファイルをキャッシュしている

**対処:**

```bash
# シンボリックリンクを確認
ls -la ~/Library/Application\ Support/Code/User/settings.json

# VSCodeを完全に再起動
# macOS: Cmd+Q で終了 → 再起動
# Windows: Alt+F4 で終了 → 再起動

# キャッシュをクリア（最終手段）
rm -rf ~/Library/Application\ Support/Code/Cache
rm -rf ~/Library/Application\ Support/Code/CachedData
```

### シンボリックリンクが作成できない（Windows）

**原因:**
- 管理者権限がない
- 開発者モードが無効

**対処:**

```powershell
# 管理者権限でPowerShellを起動
# または、開発者モードを有効化
# Settings → Update & Security → For developers → Developer mode
```

### 拡張機能がインストールされない

**原因:**
- ネットワークの問題
- VSCodeのバージョンが古い

**対処:**

```bash
# VSCodeを最新版に更新
# Help → Check for Updates

# 手動でインストール
code --install-extension vscodevim.vim --force
```

### Gitの競合が発生

**原因:**
- 複数端末で同時に設定を変更

**対処:**

```bash
# 現在の変更を確認
git status

# 競合を解決
git diff settings.json

# 手動でマージ、またはどちらかを選択
git checkout --ours settings.json   # ローカルを優先
git checkout --theirs settings.json # リモートを優先

git add settings.json
git commit -m "Resolve settings conflict"
```

---

## 📝 推奨フロー

1. **dotfilesで基本設定を管理**
   - `settings.json`
   - `keybindings.json`
   - 拡張機能リスト

2. **Settings Syncで拡張機能の設定を同期**
   - 拡張機能固有の設定
   - ワークスペース設定

3. **定期的にdotfilesを更新**
   ```bash
   cd ~/dotfiles
   git pull
   # 設定を変更
   git add vscode/
   git commit -m "Update VSCode config"
   git push
   ```

---

## 🔗 参考リンク

- [VSCode Settings Sync Documentation](https://code.visualstudio.com/docs/editor/settings-sync)
- [VSCode User and Workspace Settings](https://code.visualstudio.com/docs/getstarted/settings)
- [Managing Extensions](https://code.visualstudio.com/docs/editor/extension-marketplace)

---

## まとめ

| 方法 | バージョン管理 | 自動同期 | 拡張機能 | 推奨度 |
|------|--------------|---------|---------|--------|
| Gitリポジトリ | ✅ | ❌ | 手動 | ⭐⭐⭐ |
| Settings Sync | ❌ | ✅ | ✅ | ⭐⭐ |
| クラウドストレージ | ❌ | ✅ | ❌ | ⭐ |

**最も推奨する方法:**
- **設定ファイル**: Gitリポジトリ（このdotfiles）
- **拡張機能**: Settings Sync または拡張機能リスト

これにより、バージョン管理の利点と自動同期の利便性を両立できます。
