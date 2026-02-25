" アンダースコアに色がつく原因を調査するスクリプト
" vim内で :source check-underscore-highlight.vim を実行

echo "=== アンダースコアハイライト調査 ==="
echo ""

" 1. conceal設定の確認
echo "1. Conceal設定:"
echo "  conceallevel: " . &conceallevel
echo "  concealcursor: " . &concealcursor
echo ""

" 2. spell check設定の確認
echo "2. Spell Check設定:"
echo "  spell: " . &spell
echo "  spelllang: " . &spelllang
echo ""

" 3. filetype確認
echo "3. ファイルタイプ:"
echo "  filetype: " . &filetype
echo "  syntax: " . &syntax
echo ""

" 4. マークダウン関連の設定確認
echo "4. マークダウン設定:"
if exists('g:markdown_syntax_conceal')
  echo "  g:markdown_syntax_conceal: " . g:markdown_syntax_conceal
else
  echo "  g:markdown_syntax_conceal: 未設定"
endif

if exists('g:markdown_fenced_languages')
  echo "  g:markdown_fenced_languages: " . string(g:markdown_fenced_languages)
else
  echo "  g:markdown_fenced_languages: 未設定"
endif
echo ""

" 5. カーソル下の文字のハイライトグループを確認
echo "5. カーソル位置のハイライトグループ:"
echo "  以下のコマンドでカーソル下のハイライトを確認できます:"
echo "  :echo synIDattr(synID(line('.'), col('.'), 1), 'name')"
echo ""

echo "=== 調査完了 ==="
echo ""
echo "【対処方法】"
echo "concealが原因の場合:"
echo "  :set conceallevel=0"
echo ""
echo "spell checkが原因の場合:"
echo "  :set nospell"
echo ""
echo "マークダウンシンタックスが原因の場合:"
echo "  let g:markdown_syntax_conceal = 0"
