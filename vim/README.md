# Vim設定

方針: **普段使いはNeovim**で、リッチな設定(キーマップ・マクロ・プラグイン)はすべて`nvim/init.lua`に集約。
標準VimとIdeaVimは最小限の設定だけ持つ。VSCodeのVimモードは`vscode/settings.json`側で設定。

## 構成

```
vim/
├── README.md
├── .vimrc          # 標準Vim用の最小設定(サーバ作業・緊急用)
├── .ideavimrc      # IdeaVim用の最小設定(クリップボード共有・検索・ideajoin)
└── nvim/           # Neovim(メイン) -> nvim/README.md参照
    ├── init.lua
    └── setup.sh
```

## セットアップ

### Neovim(メイン)

[nvim/README.md](./nvim/README.md)を参照。`./setup.sh`を実行するだけ。

### 標準Vim

```shell
ln -sf ~/dotfiles/vim/.vimrc ~/
mkdir -p ~/.vim/undo
```

### JetBrains IDEs(IdeaVim)

```shell
ln -sf ~/dotfiles/vim/.ideavimrc ~/

# JetBrainsのIDEで「IdeaVim」プラグインをインストール
# Settings -> Plugins -> IdeaVim
```
