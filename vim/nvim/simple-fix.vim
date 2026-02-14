" シンプル確実なElixir色付け

" 1. カラースキームをGruvboxに変更（確実に動作）
colorscheme gruvbox

" 2. 256色モードを有効化
set t_Co=256

" 3. termguicolorsを有効化
if has('termguicolors')
  set termguicolors
endif

" 4. シンタックスを強制有効化
syntax on
syntax enable

" 5. Elixir用の直接ハイライト定義
" 関数呼び出し
highlight ElixirFunc ctermfg=cyan guifg=#56B6C2 gui=NONE
syn match ElixirFunc /\<\w\+\ze(/

" モジュール名
highlight ElixirMod ctermfg=yellow guifg=#E5C07B gui=NONE
syn match ElixirMod /\<[A-Z]\w*\(\.[A-Z]\w*\)*/

" パイプ演算子
highlight ElixirPipe ctermfg=magenta guifg=#C678DD gui=bold
syn match ElixirPipe /|>/

" 6. 既存のElixirハイライトも強化
highlight link elixirKeyword Statement
highlight link elixirString String
highlight link elixirAtom Constant
highlight link elixirComment Comment

" 7. 画面を再描画
redraw!

echo "=========================================="
echo "✓ シンプル修正適用完了"
echo "=========================================="
echo ""
echo "変更内容:"
echo "  • カラースキーム: Gruvbox"
echo "  • 関数呼び出し: シアン"
echo "  • モジュール名: 黄色"
echo "  • パイプ(|>): マゼンタ"
echo ""
echo "※色が見えない場合: :set background=dark"
echo "=========================================="
