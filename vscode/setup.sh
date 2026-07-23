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

# VSCodeディレクトリが無ければ作成(インストール直後でまだ起動していない場合)
if [ ! -d "$VSCODE_USER_DIR" ]; then
    echo "📁 VSCode User directory not found. Creating..."
    mkdir -p "$VSCODE_USER_DIR"
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

    # 拡張機能の一覧はextensions.txtで管理(スクリプト内に二重管理しない)
    while IFS= read -r extension; do
        [ -z "$extension" ] && continue
        code --install-extension "$extension"
    done < "$SCRIPT_DIR/extensions.txt"

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
