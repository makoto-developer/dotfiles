" Elixirシンタックス緊急修正スクリプト
" このファイルをnvim内で :source ~/.config/nvim/fix-syntax-now.vim として実行

" termguicolorsを有効化
if has('termguicolors')
  set termguicolors
endif

" シンタックスを強制的に有効化
syntax on

" ファイルタイプを確実に設定
filetype plugin indent on

" カラースキームを設定（Gruvboxが確実）
try
  colorscheme gruvbox
catch
  try
    colorscheme desert
  catch
    colorscheme default
  endtry
endtry

" Elixirファイルタイプを強制設定
if &filetype ==# ''
  set filetype=elixir
endif

" シンタックスを再度有効化
syntax on

" Elixir固有のハイライトを設定
if &filetype ==# 'elixir' || &filetype ==# 'eelixir'
  highlight link elixirModuleDefine Keyword
  highlight link elixirDefine Keyword
  highlight link elixirPrivateDefine Keyword
  highlight link elixirKeyword Keyword
  highlight link elixirAtom Constant
  highlight link elixirString String
  highlight link elixirStringDelimiter String
  highlight link elixirInterpolation Special
  highlight link elixirInterpolationDelimiter Special
  highlight link elixirDocString Comment
  highlight link elixirAlias Type
  highlight link elixirModule Type
endif

echo "✓ シンタックスハイライト修正完了"
echo "現在の設定:"
echo "  filetype=" . &filetype
echo "  syntax=" . &syntax
echo "  colors_name=" . get(g:, 'colors_name', 'none')
