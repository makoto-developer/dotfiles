#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "dotfiles Setup"
echo "=========================================="
echo ""
echo "Location: $DOTFILES_DIR"
echo ""

# OS確認
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  This script is designed for macOS"
    echo "Some features may not work on other OS"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# ========================================
# 1. Git Configuration
# ========================================
echo "=========================================="
echo "1. Git Configuration"
echo "=========================================="
echo ""

if [ ! -f "$HOME/.git_user" ]; then
    echo "⚠️  Personal git config files not found"
    echo ""
    echo "Please create the following files first:"
    echo ""
    echo "  \$HOME/.git_user:"
    echo "    [user]"
    echo "    name = Your Name"
    echo "    email = your.email@example.com"
    echo ""
    echo "  \$HOME/.git_github:"
    echo "    [github]"
    echo "    user = \"your-github-username\""
    echo ""
    echo "  \$HOME/.git_globalignore:"
    echo "    [core]"
    echo "    excludesFile = /Users/yourname/.git_globalignore"
    echo ""
    echo "See git/README.md for more details"
    echo ""
    read -p "Skip git setup and continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please create the required files and run this script again"
        exit 1
    fi
    echo "⏭️  Skipping git setup"
else
    # Gitシンボリックリンク作成
    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/git/.git_alias" "$HOME/.git_alias"
    ln -sf "$DOTFILES_DIR/git/.git_core" "$HOME/.git_core"
    ln -sf "$DOTFILES_DIR/git/.git_delta" "$HOME/.git_delta"
    ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

    echo "✅ Git configuration linked"

    # 確認
    if git config user.name &> /dev/null; then
        echo "   User: $(git config user.name) <$(git config user.email)>"
    fi
fi
echo ""

# ========================================
# 2. Shell Configuration
# ========================================
echo "=========================================="
echo "2. Shell Configuration"
echo "=========================================="
echo ""

# Fish shell
if command -v fish &> /dev/null; then
    echo "Fish shell detected"
    mkdir -p "$HOME/.config/fish"
    mkdir -p "$HOME/.config/omf"

    ln -sf "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
    ln -sf "$DOTFILES_DIR/fish/init.fish" "$HOME/.config/omf/init.fish"
    ln -sf "$DOTFILES_DIR/fish/conf.d" "$HOME/.config/fish/conf.d"

    echo "✅ Fish configuration linked"
else
    echo "⚠️  Fish shell not installed"
    echo "   Install: brew install fish"
    read -p "Skip fish setup? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please install fish and run this script again"
        exit 1
    fi
fi

# Zsh (optional)
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
    echo ""
    read -p "Setup Zsh configuration? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
        ln -sf "$DOTFILES_DIR/zsh/.zshrc.profile.alias.zsh" "$HOME/.zshrc.profile.alias.zsh"
        ln -sf "$DOTFILES_DIR/zsh/.zshrc.profile.iterm.zsh" "$HOME/.zshrc.profile.iterm.zsh"
        ln -sf "$DOTFILES_DIR/zsh/.zshrc.profile.zsh" "$HOME/.zshrc.profile.zsh"
        echo "✅ Zsh configuration linked"
    else
        echo "⏭️  Skipped Zsh setup"
    fi
fi
echo ""

# ========================================
# 3. Version Manager
# ========================================
echo "=========================================="
echo "3. Version Manager (mise/asdf)"
echo "=========================================="
echo ""

ln -sf "$DOTFILES_DIR/asdf/.tool-versions" "$HOME/.tool-versions"
echo "✅ .tool-versions linked"

if command -v mise &> /dev/null; then
    echo "   mise detected: $(mise --version)"
elif command -v asdf &> /dev/null; then
    echo "   asdf detected: $(asdf version)"
else
    echo "⚠️  Neither mise nor asdf installed"
    echo "   Install mise (recommended): brew install mise"
    echo "   Or install asdf: brew install asdf"
fi
echo ""

# ========================================
# 4. Vim/Neovim Configuration
# ========================================
echo "=========================================="
echo "4. Vim/Neovim Configuration"
echo "=========================================="
echo ""

read -p "Setup Vim/Neovim? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 標準Vim
    mkdir -p "$HOME/.vim"
    ln -sf "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    ln -sf "$DOTFILES_DIR/vim/.ideavimrc" "$HOME/.ideavimrc"
    ln -sf "$DOTFILES_DIR/vim/config" "$HOME/.vim/config"

    # Undo directory
    mkdir -p "$HOME/.vim/undo"

    echo "✅ Vim configuration linked"

    # Neovim
    if command -v nvim &> /dev/null; then
        echo ""
        read -p "Setup Neovim with plugins? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [ -x "$DOTFILES_DIR/vim/nvim/setup.sh" ]; then
                cd "$DOTFILES_DIR/vim/nvim"
                ./setup.sh
                cd "$DOTFILES_DIR"
            else
                ln -sf "$DOTFILES_DIR/vim/nvim" "$HOME/.config/nvim"
                echo "✅ Neovim configuration linked"
            fi
        else
            ln -sf "$DOTFILES_DIR/vim/nvim" "$HOME/.config/nvim"
            echo "✅ Neovim configuration linked (without plugin setup)"
        fi
    else
        echo "⚠️  Neovim not installed"
        echo "   Install: brew install neovim"
    fi
else
    echo "⏭️  Skipped Vim/Neovim setup"
fi
echo ""

# ========================================
# 5. VSCode Configuration
# ========================================
echo "=========================================="
echo "5. VSCode Configuration"
echo "=========================================="
echo ""

if command -v code &> /dev/null; then
    read -p "Setup VSCode? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -x "$DOTFILES_DIR/vscode/setup.sh" ]; then
            cd "$DOTFILES_DIR/vscode"
            ./setup.sh
            cd "$DOTFILES_DIR"
        else
            # Manual setup
            if [[ "$OSTYPE" == "darwin"* ]]; then
                VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
            else
                VSCODE_USER_DIR="$HOME/.config/Code/User"
            fi

            if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
                mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
            fi

            ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
            echo "✅ VSCode configuration linked"
        fi
    else
        echo "⏭️  Skipped VSCode setup"
    fi
else
    echo "⚠️  VSCode not installed"
    echo "   Install: brew install --cask visual-studio-code"
    echo "⏭️  Skipped VSCode setup"
fi
echo ""

# ========================================
# 6. Summary
# ========================================
echo "=========================================="
echo "🎉 Setup Complete!"
echo "=========================================="
echo ""
echo "✅ Configuration files linked successfully"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec \$SHELL)"
echo "  2. Verify git config: git config --list"
echo "  3. Test vim/nvim: nvim"
echo "  4. Check fish shell: fish"
echo ""
echo "For detailed configuration, see:"
echo "  - git/README.md"
echo "  - vim/README.md"
echo "  - vscode/README.md"
echo "  - vscode/SETUP.md"
echo ""
echo "To update dotfiles:"
echo "  cd $DOTFILES_DIR"
echo "  git pull"
echo ""
echo "For improvements and suggestions, see:"
echo "  IMPROVEMENTS.md"
echo ""
