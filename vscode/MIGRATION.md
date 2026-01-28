# VSCode設定をシンボリックリンクに移行する手順

現在の設定をdotfilesディレクトリで管理するための移行手順です。

---

## 現在の状態確認

```bash
ls -la ~/Library/Application\ Support/Code/User/settings.json
```

**シンボリックリンクの場合:**
```
lrwxr-xr-x  1 user  staff  ... settings.json -> /Users/user/dotfiles/vscode/settings.json
```
↑ 先頭が `l` で、`->` で dotfiles を指している → **すでに正しく設定済み**

**通常ファイルの場合:**
```
-rw-r--r--  1 user  staff  ... settings.json
```
↑ 先頭が `-` → **移行が必要**

---

## 移行手順

### 方法1: セットアップスクリプトを使用（推奨）

```bash
cd ~/dotfiles/vscode
./setup.sh
```

**スクリプトが自動で行うこと:**
1. 既存の `settings.json` をバックアップ
2. dotfilesの設定とマージ（必要に応じて手動）
3. シンボリックリンクを作成

### 方法2: 手動で移行

#### ステップ1: 現在の設定をバックアップ

```bash
cp ~/Library/Application\ Support/Code/User/settings.json \
   ~/Library/Application\ Support/Code/User/settings.json.backup
```

#### ステップ2: dotfilesの設定と比較

```bash
# 差分を確認
diff ~/Library/Application\ Support/Code/User/settings.json \
     ~/dotfiles/vscode/settings.json
```

**差分がある場合:**

```bash
# どちらを優先するか選択

# Option A: 現在の設定を優先（dotfilesを上書き）
cp ~/Library/Application\ Support/Code/User/settings.json \
   ~/dotfiles/vscode/settings.json

# Option B: dotfilesを優先（現在の設定を破棄）
# 何もしない（次のステップでdotfilesの設定が適用される）

# Option C: 手動でマージ
# エディタで両方を開いて手動でマージ
code ~/Library/Application\ Support/Code/User/settings.json \
     ~/dotfiles/vscode/settings.json
# マージ後、dotfiles/vscode/settings.json に保存
```

#### ステップ3: 既存ファイルを削除

```bash
rm ~/Library/Application\ Support/Code/User/settings.json
```

#### ステップ4: シンボリックリンクを作成

```bash
ln -sf ~/dotfiles/vscode/settings.json \
       ~/Library/Application\ Support/Code/User/settings.json
```

#### ステップ5: 確認

```bash
ls -la ~/Library/Application\ Support/Code/User/settings.json
```

**正しく設定されていれば:**
```
lrwxr-xr-x  1 user  staff  ... settings.json -> /Users/user/dotfiles/vscode/settings.json
```

---

## VSCodeで確認

1. VSCodeを再起動
2. `Cmd/Ctrl + ,` で設定を開く
3. 設定が正しく読み込まれているか確認

---

## 設定を変更する場合

シンボリックリンク設定後は：

### VSCode上で変更

```bash
# VSCodeで設定を変更すると、自動的にdotfilesが更新される
# Cmd/Ctrl + , → 設定変更 → 自動保存

# 変更をGitで管理
cd ~/dotfiles
git status  # settings.json が変更されているはず
git add vscode/settings.json
git commit -m "Update VSCode settings"
git push
```

### エディタで直接編集

```bash
# dotfiles/vscode/settings.json を直接編集
vim ~/dotfiles/vscode/settings.json
# または
code ~/dotfiles/vscode/settings.json

# VSCodeを再起動すれば反映される
```

---

## keybindings.json も同様に移行

### 現在の状態確認

```bash
ls -la ~/Library/Application\ Support/Code/User/keybindings.json
```

### keybindings.jsonがある場合

#### ステップ1: dotfilesにコピー

```bash
cp ~/Library/Application\ Support/Code/User/keybindings.json \
   ~/dotfiles/vscode/keybindings.json
```

#### ステップ2: シンボリックリンクを作成

```bash
# 既存ファイルを削除
rm ~/Library/Application\ Support/Code/User/keybindings.json

# シンボリックリンクを作成
ln -sf ~/dotfiles/vscode/keybindings.json \
       ~/Library/Application\ Support/Code/User/keybindings.json
```

#### ステップ3: 確認

```bash
ls -la ~/Library/Application\ Support/Code/User/keybindings.json
```

---

## 複数端末での同期

### 端末A（この端末）で移行完了後

```bash
cd ~/dotfiles
git add vscode/settings.json vscode/keybindings.json
git commit -m "Add VSCode settings to dotfiles"
git push
```

### 端末B（別の端末）での設定

```bash
# dotfilesをクローン（未クローンの場合）
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles

# セットアップスクリプトを実行
cd ~/dotfiles/vscode
./setup.sh

# または手動でシンボリックリンク作成
ln -sf ~/dotfiles/vscode/settings.json \
       ~/Library/Application\ Support/Code/User/settings.json
```

---

## トラブルシューティング

### シンボリックリンクが壊れている

**確認:**
```bash
ls -la ~/Library/Application\ Support/Code/User/settings.json
```

**壊れている場合:**
```
lrwxr-xr-x  1 user  staff  ... settings.json -> /path/to/nonexistent/file
```

**修正:**
```bash
# シンボリックリンクを削除して再作成
rm ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/dotfiles/vscode/settings.json \
       ~/Library/Application\ Support/Code/User/settings.json
```

### 設定が反映されない

**原因:**
- VSCodeがキャッシュしている

**対処:**
```bash
# VSCodeを完全に終了（Cmd+Q）して再起動

# それでも反映されない場合、キャッシュをクリア
rm -rf ~/Library/Application\ Support/Code/Cache
rm -rf ~/Library/Application\ Support/Code/CachedData
```

### dotfilesディレクトリを移動した

**修正:**
```bash
# 新しいパスでシンボリックリンクを再作成
ln -sf /new/path/to/dotfiles/vscode/settings.json \
       ~/Library/Application\ Support/Code/User/settings.json
```

---

## 確認チェックリスト

移行が完了したら、以下を確認：

- [ ] `ls -la`でシンボリックリンクになっている（先頭が`l`）
- [ ] VSCodeで設定が正しく読み込まれている
- [ ] VSCodeで設定を変更すると`~/dotfiles/vscode/settings.json`が更新される
- [ ] `git status`で変更が検出される
- [ ] 別の端末でも同じ設定を使える

---

## まとめ

シンボリックリンクで管理することで：

✅ dotfilesディレクトリで一元管理
✅ 設定変更が自動的にGit管理下に
✅ 複数端末で設定を簡単に同期
✅ バージョン管理で変更履歴を追跡

移行完了後は、Vimの設定と同じようにdotfilesディレクトリで管理できます！
