" キーマッピング確認スクリプト

echo "=========================================="
echo "Ctrl + 矢印キー/hjkl マッピング"
echo "=========================================="
echo ""

" ノーマルモードのマッピングを確認
echo "【ノーマルモード】"
echo ""

for key in ['<C-h>', '<C-j>', '<C-k>', '<C-l>', '<C-Left>', '<C-Right>', '<C-Up>', '<C-Down>']
  " マッピングの存在確認
  redir => mapping
  silent! execute 'nmap ' . key
  redir END

  if mapping =~ 'No mapping found'
    echo key . " → マッピングなし（デフォルト動作）"
  else
    " マッピングの詳細を取得
    redir => verbose_mapping
    silent! execute 'verbose nmap ' . key
    redir END

    let lines = split(verbose_mapping, "\n")
    if len(lines) >= 1
      echo key . " → " . substitute(lines[0], '^\s*n\s*', '', '')
      if len(lines) >= 2 && lines[1] =~ 'Last set from'
        echo "   定義: " . substitute(lines[1], '^\s*', '', '')
      endif
    endif
  endif
  echo ""
endfor

echo "=========================================="
echo "その他の便利なキーバインド"
echo "=========================================="
echo ""

" よく使うキーバインドも表示
let useful_keys = {
  \ 'ウィンドウ操作': ['<C-w>s', '<C-w>v', '<C-w>q'],
  \ 'タブ操作': ['gt', 'gT'],
  \ 'ジャンプ': ['gd', 'gr', 'gi'],
  \ 'コメント': ['gcc'],
  \ }

for [category, keys] in items(useful_keys)
  echo category . ":"
  for key in keys
    redir => mapping
    silent! execute 'nmap ' . key
    redir END

    if mapping !~ 'No mapping found'
      let lines = split(mapping, "\n")
      if len(lines) >= 1
        echo "  " . key . " → " . substitute(lines[0], '^\s*n\s*', '', '')
      endif
    endif
  endfor
  echo ""
endfor

echo "=========================================="
echo ""
echo "すべてのマッピングを見るには:"
echo "  :nmap    - ノーマルモード"
echo "  :imap    - インサートモード"
echo "  :vmap    - ビジュアルモード"
echo ""
echo "=========================================="
