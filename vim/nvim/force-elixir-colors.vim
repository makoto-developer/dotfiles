" Elixir強制カラーリング
" より強力なハイライト設定

" シンタックスを完全にクリア
syntax clear

" ファイルタイプを再設定
set filetype=elixir

" 基本的なシンタックスを再読み込み
runtime! syntax/elixir.vim

" 関数呼び出し（括弧の前）- 優先度を高く
syntax match elixirFunctionCall /\v<[a-z_][a-zA-Z0-9_]*\ze\(/ contained containedin=ALL
highlight elixirFunctionCall ctermfg=14 ctermbg=NONE guifg=#61AFEF gui=bold

" モジュール名（大文字始まり、ドット区切り）
syntax match elixirModuleName /\v<[A-Z][a-zA-Z0-9_]*(\.[A-Z][a-zA-Z0-9_]*)*/ contained containedin=ALL
highlight elixirModuleName ctermfg=11 ctermbg=NONE guifg=#E5C07B gui=bold

" パイプ演算子
syntax match elixirPipeOp /|>/ contained containedin=ALL
highlight elixirPipeOp ctermfg=13 ctermbg=NONE guifg=#C678DD gui=bold

" 関数定義の名前（def の後）
syntax match elixirDefName /\v(def|defp|defmodule|defmacro|defmacrop|defdelegate|defguard|defguardp|defimpl|defprotocol|defstruct|defexception)\s+\zs[a-z_][a-zA-Z0-9_!?]*/
highlight elixirDefName ctermfg=10 ctermbg=NONE guifg=#98C379 gui=bold

" アトム（コロン始まり）- 強調
syntax match elixirAtomCustom /:[a-zA-Z_][a-zA-Z0-9_@]*\>/ contained containedin=ALL
highlight elixirAtomCustom ctermfg=208 ctermbg=NONE guifg=#D19A66

" シンタックスの優先順位を設定
syntax sync fromstart
syntax sync minlines=100

" 確認メッセージ
redraw
echo "✓ 強制カラーリング適用完了"
echo ""
echo "色の確認:"
echo "  関数呼び出し: 明るいシアン"
echo "  モジュール名: 黄色"
echo "  パイプ(|>): マゼンタ"
echo "  関数定義: 緑"
echo ""
echo "※まだ色が付かない場合は :colorscheme gruvbox を試してください"
