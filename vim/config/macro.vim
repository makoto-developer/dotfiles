" Macro

" HTML/XML閉じタグ自動補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" ============================================================
" 基本操作の改善
" ============================================================

" Yを行末までコピーに変更（CやDと統一）
nnoremap Y y$

" Uをredoに変更（uとの対称性）
nnoremap U <C-r>

" xで削除した内容をレジスタに入れない（ブラックホールレジスタ使用）
nnoremap x "_x
xnoremap x "_x

" 連続ペーストでレジスタを上書きしない
xnoremap p P

" ============================================================
" 編集効率化
" ============================================================

" 行の複製
nnoremap <Space>y yyp
nnoremap <Space>Y yyP

" 行末にセミコロンを追加
nnoremap <Leader>; A;<Esc>
nnoremap <Leader>, A,<Esc>

" 空行の挿入（インサートモードに入らない）
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" 行全体を削除（レジスタを汚さない）
nnoremap <Leader>d "_dd

" ============================================================
" ビジュアルモード
" ============================================================

" ビジュアルモードでのインデント後に選択を維持
xnoremap < <gv
xnoremap > >gv

" ビジュアルモードでコピー後にカーソル位置を保持
xnoremap y y`>

" ビジュアルモード選択範囲を*で検索
xnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

" ============================================================
" 検索・置換
" ============================================================

" カーソル下の単語を置換（確認あり）
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" ビジュアル選択範囲を置換
xnoremap <Leader>s y:%s/<C-r>"//gc<Left><Left><Left>

" 検索ハイライトを消去
nnoremap <Esc><Esc> :nohlsearch<CR>

" Very Magic モード（正規表現を簡単に）
nnoremap / /\v

" ============================================================
" ナビゲーション
" ============================================================

" 括弧ジャンプを簡単に
nnoremap M %

" 空行間の移動
nnoremap <C-j> }
nnoremap <C-k> {

" バッファ移動
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" タブ移動
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" ============================================================
" ウィンドウ操作
" ============================================================

" ウィンドウ分割を簡単に
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>h :split<CR>

" ウィンドウサイズ調整
nnoremap <silent> <C-w>+ :resize +5<CR>
nnoremap <silent> <C-w>- :resize -5<CR>
nnoremap <silent> <C-w>> :vertical resize +5<CR>
nnoremap <silent> <C-w>< :vertical resize -5<CR>

" ============================================================
" プログラミング支援
" ============================================================

" JavaScript/TypeScript: console.log追加
augroup ProgrammingShortcuts
  autocmd!
  " カーソル下の変数をconsole.logで出力
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact
    \ nnoremap <buffer> <Leader>cl yiwoconsole.log('<C-r>":', <C-r>");<Esc>

  " 選択範囲をconsole.logで出力
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact
    \ xnoremap <buffer> <Leader>cl yoconsole.log('<C-r>":', <C-r>");<Esc>

  " 空のconsole.logを挿入
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact
    \ nnoremap <buffer> <Leader>co oconsole.log();<Esc>hi

  " Python: print追加
  autocmd FileType python
    \ nnoremap <buffer> <Leader>cl yiwoprint(f'<C-r>": {<C-r>"}')<Esc>

  autocmd FileType python
    \ xnoremap <buffer> <Leader>cl yoprint(f'<C-r>": {<C-r>"}')<Esc>

  " Go: fmt.Println追加
  autocmd FileType go
    \ nnoremap <buffer> <Leader>cl yiwofmt.Println("<C-r>":", <C-r>")<Esc>

  " Ruby: puts追加
  autocmd FileType ruby
    \ nnoremap <buffer> <Leader>cl yiwoputs "<C-r>": #{<C-r>"}"<Esc>
augroup END

" セミコロンを行末に追加（JavaScript/TypeScript/C/C++/Java等）
augroup SemicolonLanguages
  autocmd!
  autocmd FileType javascript,typescript,c,cpp,java,rust
    \ nnoremap <buffer> <Leader>; A;<Esc>
augroup END

" ============================================================
" コメントトグル（簡易版）
" ============================================================

" 言語別コメント記号の設定
augroup CommentToggle
  autocmd!
  autocmd FileType javascript,typescript,c,cpp,java,rust,go
    \ nnoremap <buffer> <Leader>/ I// <Esc>
  autocmd FileType python,sh,bash,zsh,fish,ruby
    \ nnoremap <buffer> <Leader>/ I# <Esc>
  autocmd FileType vim
    \ nnoremap <buffer> <Leader>/ I" <Esc>
augroup END

" ============================================================
" Markdown支援
" ============================================================

augroup MarkdownHelpers
  autocmd!
  " 選択したテキストを太字に
  autocmd FileType markdown xnoremap <buffer> <Leader>b c**<C-r>"**<Esc>

  " 選択したテキストをイタリックに
  autocmd FileType markdown xnoremap <buffer> <Leader>i c*<C-r>"*<Esc>

  " 選択したテキストをコードブロックに
  autocmd FileType markdown xnoremap <buffer> <Leader>c c`<C-r>"`<Esc>

  " リンク挿入
  autocmd FileType markdown nnoremap <buffer> <Leader>l i[]()<Esc>F]a
augroup END

" ============================================================
" その他の便利機能
" ============================================================

" ファイルパスをクリップボードにコピー
nnoremap <Leader>fp :let @+ = expand('%:p')<CR>:echo 'Copied: ' . expand('%:p')<CR>

" ファイル名をクリップボードにコピー
nnoremap <Leader>fn :let @+ = expand('%:t')<CR>:echo 'Copied: ' . expand('%:t')<CR>

" 現在の日付を挿入
nnoremap <Leader>dt "=strftime('%Y-%m-%d')<CR>p
inoremap <C-d><C-d> <C-r>=strftime('%Y-%m-%d')<CR>

" 現在の時刻を挿入
nnoremap <Leader>tt "=strftime('%H:%M:%S')<CR>p
inoremap <C-t><C-t> <C-r>=strftime('%H:%M:%S')<CR>

" 保存して終了を簡単に
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>x :x<CR>

" ============================================================
" レジスタ・クリップボード
" ============================================================

" 0レジスタ（最後にyankした内容）から貼り付け
nnoremap <Leader>p "0p
nnoremap <Leader>P "0P

" システムクリップボードへコピー
xnoremap <Leader>y "+y
nnoremap <Leader>y "+y

" システムクリップボードから貼り付け
nnoremap <Leader>p "+p
xnoremap <Leader>p "+p

" ============================================================
" 設定の補足
" ============================================================

" インクリメンタルサーチを有効化
set incsearch

" 検索時に大文字小文字を無視（大文字が含まれる場合は区別）
set ignorecase
set smartcase

" 行番号を表示
set number
set relativenumber

" カーソル行をハイライト
set cursorline

