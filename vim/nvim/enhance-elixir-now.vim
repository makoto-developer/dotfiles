" Elixir関数名・モジュール名のハイライト強化
" nvim内で :source ~/.config/nvim/enhance-elixir-now.vim で即座に適用

" 関数呼び出しのハイライト（括弧の前の識別子）
syntax match elixirFunctionCall /\<\h\w*\ze(/
highlight link elixirFunctionCall Function

" モジュール名のハイライト（大文字で始まる識別子）
syntax match elixirModuleName /\<[A-Z]\w*\(\.[A-Z]\w*\)*/
highlight link elixirModuleName Type

" 変数のハイライト（小文字で始まる識別子）
syntax match elixirVariable /\<[a-z_]\w*/
highlight link elixirVariable Identifier

" パイプ演算子の強調
syntax match elixirPipeOperator /|>/
highlight link elixirPipeOperator Operator

" シンタックスを再読み込み
syntax sync fromstart

" カラーを強調
if &background == 'dark'
  highlight Function ctermfg=cyan guifg=#56B6C2
  highlight Type ctermfg=yellow guifg=#E5C07B
  highlight Identifier ctermfg=white guifg=#ABB2BF
  highlight Operator ctermfg=magenta guifg=#C678DD
endif

echo "✓ Elixir拡張ハイライト適用完了"
echo "関数呼び出し: シアン"
echo "モジュール名: 黄色"
echo "変数: 白"
echo "パイプ(|>): マゼンタ"
