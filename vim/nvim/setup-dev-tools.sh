#!/bin/bash

set -e

echo "=========================================="
echo "nvim 開発環境セットアップスクリプト"
echo "=========================================="

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Go関連ツール
echo ""
echo "${YELLOW}[1/7] Go開発ツールのインストール${NC}"
if command -v go &> /dev/null; then
  echo "✓ gopls インストール確認..."
  go install golang.org/x/tools/gopls@latest
  echo "✓ go-tools インストール..."
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  echo "${GREEN}✓ Go開発ツール完了${NC}"
else
  echo "⚠️  Go がインストールされていません"
fi

# Rust関連ツール
echo ""
echo "${YELLOW}[2/7] Rust開発ツールのインストール${NC}"
if command -v cargo &> /dev/null; then
  echo "✓ rust-analyzer 確認..."
  rustup component add rust-analyzer
  echo "✓ rust-fmt インストール..."
  rustup component add rustfmt
  echo "✓ clippy インストール..."
  rustup component add clippy
  echo "${GREEN}✓ Rust開発ツール完了${NC}"
else
  echo "⚠️  Rust がインストールされていません"
fi

# Node.js関連ツール
echo ""
echo "${YELLOW}[3/7] Node.js開発ツールのインストール${NC}"
if command -v npm &> /dev/null; then
  echo "✓ TypeScript関連ツール..."
  npm install -g typescript typescript-language-server
  echo "✓ React/Next.js関連ツール..."
  npm install -g @types/react @types/node
  echo "✓ Linter/Formatter..."
  npm install -g eslint prettier
  echo "✓ YAML Language Server..."
  npm install -g yaml-language-server
  echo "${GREEN}✓ Node.js開発ツール完了${NC}"
else
  echo "⚠️  Node.js がインストールされていません"
fi

# Terraform関連ツール
echo ""
echo "${YELLOW}[4/7] Terraform開発ツールのインストール${NC}"
if command -v mise &> /dev/null; then
  echo "✓ terraform-ls インストール..."
  mise use -g terraform-ls@latest
  echo "✓ tflint インストール..."
  mise use -g tflint@latest
  echo "${GREEN}✓ Terraform開発ツール完了${NC}"
else
  echo "⚠️  mise がインストールされていません"
fi

# Elixir関連ツール
echo ""
echo "${YELLOW}[5/7] Elixir開発ツールのインストール${NC}"
if command -v elixir &> /dev/null; then
  echo "✓ Hex インストール..."
  mix local.hex --force
  echo "✓ Rebar インストール..."
  mix local.rebar --force

  # elixir-lsのインストール確認
  if [ ! -d "/usr/local/Cellar/elixir-ls" ]; then
    echo "✓ elixir-ls インストール（Homebrew経由）..."
    if command -v brew &> /dev/null; then
      brew install elixir-ls
    else
      echo "⚠️  Homebrew がインストールされていません"
    fi
  else
    echo "✓ elixir-ls は既にインストール済み"
  fi

  echo "${GREEN}✓ Elixir開発ツール完了${NC}"
else
  echo "⚠️  Elixir がインストールされていません"
fi

# nvimプラグインのインストール
echo ""
echo "${YELLOW}[6/7] nvimプラグインのインストール${NC}"
if command -v nvim &> /dev/null; then
  echo "✓ dein.vim プラグインインストール..."
  nvim --headless "+call dein#install()" +qall

  echo "✓ CoCエクステンションインストール..."
  nvim --headless "+CocInstall -sync coc-go coc-rust-analyzer" +qall

  echo "${GREEN}✓ nvimプラグイン完了${NC}"
else
  echo "⚠️  nvim がインストールされていません"
fi

# ヘルスチェック
echo ""
echo "${YELLOW}[7/7] ヘルスチェック${NC}"
echo ""
echo "インストール済みツール確認:"
echo "---"

check_tool() {
  if command -v $1 &> /dev/null; then
    echo "${GREEN}✓${NC} $1: $(command -v $1)"
  else
    echo "✗ $1: 未インストール"
  fi
}

check_tool go
check_tool gopls
check_tool rust-analyzer
check_tool cargo
check_tool node
check_tool npm
check_tool typescript-language-server
check_tool terraform
check_tool terraform-ls
check_tool elixir
check_tool mix

echo ""
echo "${GREEN}=========================================="
echo "セットアップ完了！"
echo "==========================================${NC}"
echo ""
echo "次のコマンドでnvimを起動してください:"
echo "  $ nvim"
echo ""
echo "初回起動時は :CocInstall でエクステンションをインストールします"
echo ""
