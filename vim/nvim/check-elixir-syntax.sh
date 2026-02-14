#!/bin/bash

echo "=========================================="
echo "Elixirシンタックス診断スクリプト"
echo "=========================================="

# 1. vim-elixirプラグインの存在確認
echo ""
echo "[1/5] vim-elixirプラグインの確認"
if [ -d "$HOME/.cache/dein/repos/github.com/elixir-editors/vim-elixir" ]; then
  echo "✓ vim-elixir: インストール済み"
  echo "  パス: $HOME/.cache/dein/repos/github.com/elixir-editors/vim-elixir"
else
  echo "✗ vim-elixir: 未インストール"
fi

# 2. シンタックスファイルの確認
echo ""
echo "[2/5] シンタックスファイルの確認"
SYNTAX_FILES=(
  "$HOME/.cache/dein/repos/github.com/elixir-editors/vim-elixir/syntax/elixir.vim"
  "$HOME/.cache/dein/repos/github.com/elixir-editors/vim-elixir/syntax/eelixir.vim"
  "$HOME/.cache/dein/repos/github.com/elixir-editors/vim-elixir/ftdetect/elixir.vim"
)

for file in "${SYNTAX_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "✓ $(basename $file)"
  else
    echo "✗ $(basename $file) が見つかりません"
  fi
done

# 3. テストファイルの作成
echo ""
echo "[3/5] テストファイルの作成"
TEST_FILE="/tmp/test_syntax.ex"
cat > "$TEST_FILE" << 'EOF'
defmodule TestModule do
  def hello(name) do
    "Hello, #{name}!"
  end
end
EOF
echo "✓ テストファイル作成: $TEST_FILE"

# 4. nvimでfiletypeを確認
echo ""
echo "[4/5] nvimでfiletypeを確認"
FILETYPE=$(nvim --headless -c "e $TEST_FILE" -c "set filetype?" -c "qa!" 2>&1 | grep filetype)
if [ -n "$FILETYPE" ]; then
  echo "✓ $FILETYPE"
else
  echo "✗ filetypeを取得できませんでした"
fi

# 5. シンタックスハイライトの確認
echo ""
echo "[5/5] シンタックスハイライトの確認"
echo "nvimを起動して以下のコマンドを実行してください："
echo ""
echo "  nvim $TEST_FILE"
echo ""
echo "nvim内で以下を確認："
echo "  :set filetype?  → filetype=elixir と表示されるか"
echo "  :syntax list    → elixir関連のシンタックスグループが表示されるか"
echo ""

# 6. 手動修正が必要な場合
echo "=========================================="
echo "もしシンタックスが表示されない場合："
echo "=========================================="
echo ""
echo "1. nvimを再起動"
echo "   $ nvim"
echo ""
echo "2. プラグインを手動で更新"
echo "   :call dein#update()"
echo ""
echo "3. ファイルタイプを手動設定"
echo "   :set filetype=elixir"
echo ""
echo "4. init.vimを再読み込み"
echo "   :source ~/.config/nvim/init.vim"
echo ""
echo "5. それでも表示されない場合、以下を確認："
echo "   :echo &runtimepath"
echo "   （vim-elixirのパスが含まれているか）"
echo ""
