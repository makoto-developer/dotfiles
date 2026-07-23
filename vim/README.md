# Vim設定

Vim/Neovim/IdeaVimの設定。メインはNeovim。

## ディレクトリ構成

```
vim/
├── README.md               # このファイル
├── .vimrc                  # 標準Vim設定(エントリポイント)
├── .ideavimrc              # JetBrains IDEs(IntelliJ等)用
├── config/                 # 標準Vim設定の分割管理
│   ├── main.vim
│   └── macro.vim
├── MACRO_GUIDE.md          # マクロの使い方
├── check-underscore-highlight.vim
└── nvim/                   # Neovim設定(メイン) -> nvim/README.md参照
    ├── init.lua
    └── setup.sh
```

## セットアップ

### 1. Neovim(メイン)

[nvim/README.md](./nvim/README.md)を参照。`./setup.sh`を実行するだけ。

### 2. 標準Vim

```shell
ln -sf ~/dotfiles/vim/.vimrc ~/
mkdir -p ~/.vim/undo
ln -sfn ~/dotfiles/vim/config ~/.vim/config
```

### 3. JetBrains IDEs(IntelliJ等)

```shell
ln -sf ~/dotfiles/vim/.ideavimrc ~/

# JetBrainsのIDEで「IdeaVim」プラグインをインストール
# Settings -> Plugins -> IdeaVim
```

## 方針

- Neovimは`nvim/init.lua`の1ファイル構成(lazy.nvim + 組み込みLSP + treesitter)。Node/Python依存なし
- 標準Vim(.vimrc)はプラグインなしの素の設定。サーバ作業など最低限の用途向け
- クリップボード共有(`y`でシステムクリップボードへ)、インデント2スペース(Goは4・タブ)、undo永続化は全環境共通
