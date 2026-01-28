#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "=========================================="
echo "Neovim Configuration Setup"
echo "=========================================="
echo ""

# Neovimがインストールされているか確認
if ! command -v nvim &> /dev/null; then
    echo "⚠️  Neovim is not installed."
    echo ""
    echo "Install Neovim first:"
    echo "  macOS:   brew install neovim"
    echo "  Linux:   sudo apt install neovim  (or yum/pacman)"
    echo ""
    exit 1
fi

echo "✅ Neovim found: $(nvim --version | head -n 1)"
echo ""

# 既存の設定をバックアップ
if [ -d "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
    echo "📦 Backing up existing Neovim config..."
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    echo "   Backup saved to: $BACKUP_DIR"
    echo ""
fi

# シンボリックリンク作成
echo "🔗 Creating symbolic link..."
ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
echo "   Neovim config linked successfully!"
echo ""

# 確認
if [ -L "$NVIM_CONFIG_DIR" ]; then
    echo "✅ Setup complete!"
    echo ""
    echo "Symbolic link created:"
    ls -la "$NVIM_CONFIG_DIR"
    echo ""
else
    echo "❌ Failed to create symbolic link"
    exit 1
fi

# Undoディレクトリを作成
echo "📁 Creating undo directory..."
mkdir -p ~/.vim/undo
echo "   ~/.vim/undo created"
echo ""

# dein.vimのインストール確認
DEIN_DIR="$HOME/.cache/dein"
if [ ! -d "$DEIN_DIR" ]; then
    echo "=========================================="
    echo "dein.vim Installation"
    echo "=========================================="
    echo ""
    read -p "dein.vim is not installed. Install now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing dein.vim..."
        curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein_installer.sh
        sh /tmp/dein_installer.sh "$DEIN_DIR"
        rm /tmp/dein_installer.sh
        echo ""
        echo "✅ dein.vim installed!"
    else
        echo "⏭️  Skipped dein.vim installation"
        echo ""
        echo "To install manually:"
        echo "  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein"
    fi
    echo ""
else
    echo "✅ dein.vim is already installed"
    echo ""
fi

# プラグインインストール
echo "=========================================="
echo "Plugin Installation"
echo "=========================================="
echo ""
echo "After opening Neovim, run the following commands:"
echo ""
echo "  :call dein#install()"
echo ""
echo "To install CoC extensions:"
echo ""
echo "  :CocInstall coc-tsserver coc-json coc-python coc-go coc-prettier coc-eslint"
echo ""

# 必要な依存関係の確認
echo "=========================================="
echo "Dependencies Check"
echo "=========================================="
echo ""

# Node.js（CoCに必要）
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
else
    echo "⚠️  Node.js not found (required for CoC)"
    echo "   Install: brew install node  (or nvm/asdf)"
fi

# Python3（deopleteに必要）
if command -v python3 &> /dev/null; then
    echo "✅ Python3: $(python3 --version)"

    # pynvimのインストール確認
    if python3 -c "import pynvim" 2>/dev/null; then
        echo "✅ pynvim installed"
    else
        echo "⚠️  pynvim not found"
        read -p "Install pynvim? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pip3 install --user pynvim
            echo "✅ pynvim installed"
        fi
    fi
else
    echo "⚠️  Python3 not found"
fi

# fzf
if command -v fzf &> /dev/null; then
    echo "✅ fzf: $(fzf --version)"
else
    echo "⚠️  fzf not found (optional)"
    echo "   Install: brew install fzf"
fi

# ripgrep（検索高速化）
if command -v rg &> /dev/null; then
    echo "✅ ripgrep: $(rg --version | head -n 1)"
else
    echo "⚠️  ripgrep not found (optional, for faster search)"
    echo "   Install: brew install ripgrep"
fi

echo ""
echo "=========================================="
echo "🎉 Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Open Neovim: nvim"
echo "  2. Install plugins: :call dein#install()"
echo "  3. Install CoC extensions (see above)"
echo "  4. Restart Neovim"
echo ""
echo "Useful commands:"
echo "  :checkhealth          - Check Neovim health"
echo "  :CocInfo              - Check CoC status"
echo "  :CocList extensions   - List CoC extensions"
echo ""
echo "Documentation:"
echo "  README.md             - Quick reference"
echo "  RECOMMENDATIONS.md    - Detailed plugin suggestions"
echo ""
