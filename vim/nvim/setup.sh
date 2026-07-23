#!/bin/bash
# Neovim設定のセットアップ
# やることはシンボリックリンクを張るだけ。プラグインとLSPサーバは初回起動時に自動で入る。

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Neovimがインストールされているか確認
if ! command -v nvim &> /dev/null; then
    echo "Neovim is not installed. -> brew install neovim"
    exit 1
fi
echo "Neovim found: $(nvim --version | head -n 1)"

# 既存の設定をバックアップ(シンボリックリンクでない場合のみ)
if [ -d "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing config to: $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# シンボリックリンク作成
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
echo "Linked: $NVIM_CONFIG_DIR -> $SCRIPT_DIR"

echo ""
echo "Setup complete!"
echo "次にnvimを起動するとプラグインとLSPサーバが自動でインストールされる。"
echo "動作確認: nvim +checkhealth"
