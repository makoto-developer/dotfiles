#!/bin/bash

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VSCODE_USER_DIR=""

echo "=========================================="
echo "VSCode Settings Setup"
echo "=========================================="
echo ""

# OS判定
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    echo "Detected OS: macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    echo "Detected OS: Linux"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "VSCode User Directory: $VSCODE_USER_DIR"
echo ""

# VSCodeディレクトリが存在するか確認
if [ ! -d "$VSCODE_USER_DIR" ]; then
    echo "⚠️  VSCode User directory not found."
    echo "Please install VSCode first."
    exit 1
fi

# バックアップ作成
if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
    BACKUP_FILE="$VSCODE_USER_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
    echo "📦 Backing up existing settings.json..."
    mv "$VSCODE_USER_DIR/settings.json" "$BACKUP_FILE"
    echo "   Backup saved to: $BACKUP_FILE"
    echo ""
fi

# シンボリックリンク作成
echo "🔗 Creating symbolic link..."
ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
echo "   settings.json linked successfully!"
echo ""

# 確認
if [ -L "$VSCODE_USER_DIR/settings.json" ]; then
    echo "✅ Setup complete!"
    echo ""
    echo "Symbolic link created:"
    ls -la "$VSCODE_USER_DIR/settings.json"
    echo ""
else
    echo "❌ Failed to create symbolic link"
    exit 1
fi

# 拡張機能のインストール（オプション）
echo "=========================================="
echo "Extension Installation (Optional)"
echo "=========================================="
echo ""
read -p "Install recommended extensions? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing extensions..."
    echo ""

    # 必須拡張機能
    echo "Installing essential extensions..."
    code --install-extension vscodevim.vim
    code --install-extension esbenp.prettier-vscode

    # 推奨拡張機能
    echo ""
    read -p "Install additional recommended extensions? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing additional extensions..."
        code --install-extension ms-vscode.vscode-typescript-next
        code --install-extension golang.go
        code --install-extension ms-python.python
        code --install-extension rust-lang.rust-analyzer
        code --install-extension hashicorp.terraform
        code --install-extension redhat.vscode-yaml
        code --install-extension eamodio.gitlens
        code --install-extension ms-azuretools.vscode-docker
    fi

    echo ""
    echo "✅ Extensions installed!"
else
    echo "⏭️  Skipped extension installation"
fi

echo ""
echo "=========================================="
echo "🎉 All done!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Restart VSCode"
echo "  2. Check settings: Cmd/Ctrl + ,"
echo "  3. Test Vim mode: Try 'jj' in insert mode"
echo ""
