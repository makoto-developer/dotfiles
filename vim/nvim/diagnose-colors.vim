" Elixirカラー診断スクリプト

echo "=========================================="
echo "Elixirシンタックス診断"
echo "=========================================="
echo ""

" 現在の設定を確認
echo "1. 基本設定:"
echo "   filetype: " . &filetype
echo "   syntax: " . &syntax
echo "   termguicolors: " . &termguicolors
echo "   t_Co: " . &t_Co
echo "   background: " . &background

" カラースキームを確認
echo ""
echo "2. カラースキーム:"
if exists('g:colors_name')
  echo "   現在: " . g:colors_name
else
  echo "   カラースキーム未設定"
endif

" シンタックスグループを確認
echo ""
echo "3. Elixir関連シンタックスグループ:"
redir => syntax_groups
silent! syntax list
redir END

let elixir_groups = []
for line in split(syntax_groups, "\n")
  if line =~ 'elixir' || line =~ 'Elixir'
    call add(elixir_groups, line)
  endif
endfor

if len(elixir_groups) > 0
  echo "   見つかったグループ: " . len(elixir_groups) . " 個"
  for group in elixir_groups[:5]
    echo "   - " . group
  endfor
else
  echo "   ⚠️ Elixirシンタックスグループが見つかりません"
endif

" ハイライトグループを確認
echo ""
echo "4. 重要なハイライトグループ:"
for group in ['Function', 'Type', 'Identifier', 'Keyword', 'String']
  redir => hl_info
  silent! execute 'highlight ' . group
  redir END
  echo "   " . group . ": " . substitute(hl_info, '\n', '', 'g')
endfor

echo ""
echo "=========================================="
echo "推奨アクション:"
echo "=========================================="
echo ""

" 問題を特定
if !&termguicolors
  echo "⚠️ termguicolors が無効です"
  echo "   → :set termguicolors"
  echo ""
endif

if &t_Co < 256
  echo "⚠️ 256色モードが無効です"
  echo "   → :set t_Co=256"
  echo ""
endif

if !exists('g:colors_name') || g:colors_name ==# 'default'
  echo "⚠️ カラースキームが未設定またはdefault"
  echo "   → :colorscheme gruvbox"
  echo ""
endif

if len(elixir_groups) == 0
  echo "⚠️ Elixirシンタックスが読み込まれていません"
  echo "   → :set filetype=elixir"
  echo "   → :syntax on"
  echo ""
endif

echo "すべて修正するには:"
echo "  :source ~/.config/nvim/simple-fix.vim"
echo ""
echo "=========================================="
