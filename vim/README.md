# Vim Configuration

このディレクトリにはVim/Neovim/IdeaVimの設定が含まれています。

---

## 📁 ディレクトリ構成

```
vim/
├── .vimrc                  # 標準Vim設定
├── .ideavimrc              # JetBrains IDEs（IntelliJ/PyCharm等）
├── config/                 # Vim設定の分割管理
│   ├── main.vim
│   └── macro.vim
├── nvim/                   # Neovim設定
│   ├── init.vim
│   ├── dein.toml
│   ├── coc-settings.json
│   └── setup.sh           # 自動セットアップスクリプト
└── README.md              # このファイル
```

---

## 🚀 クイックスタート

### 1. Neovim（推奨）

**自動セットアップ（推奨）:**

```bash
cd ~/dotfiles/vim/nvim
./setup.sh
```

**手動セットアップ:**

```bash
# 1. Neovimをインストール
brew install neovim

# 2. 設定をシンボリックリンク
ln -sf ~/dotfiles/vim/nvim ~/.config/nvim

# 3. Undoディレクトリを作成
mkdir -p ~/.vim/undo

# 4. pynvimをインストール（deopleteに必要）
pip3 install --user pynvim

# 5. Neovimを開いてプラグインをインストール
nvim
:call dein#install()

# 6. CoCエクステンションをインストール
:CocInstall coc-tsserver coc-json coc-python coc-go coc-prettier coc-eslint
```

詳細は [nvim/README.md](./nvim/README.md) を参照してください。

---

### 2. 標準Vim

```bash
# 設定ファイルをリンク
ln -sf ~/dotfiles/vim/.vimrc ~/
ln -sf ~/dotfiles/vim/config ~/.vim/

# Undoディレクトリを作成
mkdir -p ~/.vim/undo
```

---

### 3. JetBrains IDEs（IntelliJ/PyCharm等）

```bash
# IdeaVim設定をリンク
ln -sf ~/dotfiles/vim/.ideavimrc ~/

# JetBrainsのIDEで「IdeaVim」プラグインをインストール
# Settings → Plugins → IdeaVim
```

---

## 📦 依存関係

### Neovim

| 依存 | 必須/推奨 | インストール | 用途 |
|------|----------|-------------|------|
| Node.js | 必須 | `brew install node` | CoC（LSP） |
| Python3 | 必須 | `brew install python3` | deoplete |
| pynvim | 必須 | `pip3 install pynvim` | Pythonプロバイダー |
| fzf | 推奨 | `brew install fzf` | あいまい検索 |
| ripgrep | 推奨 | `brew install ripgrep` | 高速検索 |
| Git | 推奨 | `brew install git` | vim-fugitive |

**一括インストール（macOS）:**

```bash
brew install neovim node python3 fzf ripgrep git
pip3 install --user pynvim
```

---

## 🎯 主な機能

### クリップボード共有

すべての設定で `y` でヤンクした内容がシステムクリップボードにコピーされます。

- **Neovim**: `set clipboard+=unnamedplus`
- **Vim**: `set clipboard+=unnamed`
- **IdeaVim**: `set clipboard+=unnamed`

### 基本設定

- **エンコーディング**: UTF-8
- **インデント**: 2スペース（Goは4スペース、タブ文字）
- **Undo**: ファイルを閉じても復元可能
- **検索**: インクリメンタルサーチ、大文字小文字を区別しない

### 共通キーバインド

| キー | 動作 |
|------|------|
| `Ctrl+h/j/k/l` | ウィンドウ移動 |
| `Esc Esc` | 検索ハイライトクリア |
| `jj`（挿入モード） | Escapeモード |

---

## 📚 プラグイン（Neovim）

### 必須プラグイン

| プラグイン | 用途 |
|-----------|------|
| **CoC (coc.nvim)** | LSP統合、補完、定義ジャンプ |
| **vim-fugitive** | Git操作 |
| **vim-commentary** | コメントアウト |
| **fzf.vim** | あいまい検索 |

### 推奨プラグイン

詳細は [nvim/RECOMMENDATIONS.md](./nvim/RECOMMENDATIONS.md) を参照してください。

---

## 🔄 複数端末での設定共有

### 新しい端末へのセットアップ

```bash
# 1. dotfilesリポジトリをクローン
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles

# 2. Neovimセットアップスクリプトを実行
cd ~/dotfiles/vim/nvim
./setup.sh

# 3. 完了！
```

### 設定の更新フロー

**端末Aで設定を変更:**

```bash
cd ~/dotfiles
git add vim/
git commit -m "Update vim config"
git push
```

**端末Bで設定を同期:**

```bash
cd ~/dotfiles
git pull
# シンボリックリンクなので自動的に反映される
```

---

## 🐛 トラブルシューティング

### CoCが動作しない

**原因:**
- Node.jsがインストールされていない
- CoCエクステンションがインストールされていない

**対処:**

```bash
# Node.jsをインストール
brew install node

# CoCのログを確認
:CocInfo

# エクステンションを再インストール
:CocUninstall coc-tsserver
:CocInstall coc-tsserver
```

### プラグインがインストールされない

**原因:**
- dein.vimがインストールされていない
- インターネット接続の問題

**対処:**

```bash
# dein.vimを再インストール
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein

# Neovimでプラグインを再インストール
nvim
:call dein#clear_state()
:call dein#install()
```

### 補完が効かない

**原因:**
- pynvimがインストールされていない
- Python3が見つからない

**対処:**

```bash
# pynvimをインストール
pip3 install --user pynvim

# Neovimのヘルスチェック
nvim
:checkhealth
```

### Undoが効かない

**原因:**
- Undoディレクトリが存在しない

**対処:**

```bash
mkdir -p ~/.vim/undo
```

---

## 📖 参考リンク

### Neovim

- [Neovim公式](https://neovim.io/)
- [dein.vim](https://github.com/Shougo/dein.vim)
- [CoC.nvim](https://github.com/neoclide/coc.nvim)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)

### Vim

- [Vim公式](https://www.vim.org/)
- [.vimrcファイルを分割して管理する方法](https://qiita.com/mrtry/items/66c432dd79ddcaae6066)

### IdeaVim

- [IdeaVim GitHub](https://github.com/JetBrains/ideavim)

---

## 📝 各エディタの使い分け

| エディタ | 用途 | 特徴 |
|---------|------|------|
| **Neovim** | メイン開発環境 | 高速、プラグイン豊富、LSP統合 |
| **Vim** | サーバー作業 | 軽量、どこでも使える |
| **IdeaVim** | Java/Kotlin開発 | IDE機能 + Vimキーバインド |
| **VSCode Vim** | Web開発 | モダンなUI + Vimキーバインド |

---

## 🎓 学習リソース

### 初心者向け

```bash
# Vimチュートリアル
vimtutor

# Neovimチュートリアル
nvim +Tutor
```

### 中級者向け

- [Vim Adventures](https://vim-adventures.com/) - ゲームでVimを学ぶ
- [Vim Golf](https://www.vimgolf.com/) - 最小キーストローク競争

### 上級者向け

- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)

---

## 🔗 関連ファイル

- [nvim/README.md](./nvim/README.md) - Neovim詳細ガイド
- [nvim/RECOMMENDATIONS.md](./nvim/RECOMMENDATIONS.md) - プラグイン提案
- [../vscode/README.md](../vscode/README.md) - VSCode Vim設定
- [../vscode/SETUP.md](../vscode/SETUP.md) - VSCode複数端末共有

---

## まとめ

このdotfilesリポジトリを使えば：

✅ Neovim環境が1コマンドでセットアップ完了
✅ 複数端末で設定を自動同期
✅ LSP統合で快適な開発体験
✅ Git/クリップボード連携でスムーズな作業

まずは `nvim/setup.sh` を実行して始めましょう！
