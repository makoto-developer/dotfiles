" main

"****************************************************************
" シェルを指定
"****************************************************************
set shell=/usr/local/bin/fish


"****************************************************************
" エンコード
"****************************************************************
set encoding=utf8
scriptencoding utf8
set fileencoding=utf-8
set termencoding=utf8
set fileencodings=utf-8,ucs-boms,euc-jp,ep932
set fileformats=unix,dos,mac
set ambiwidth=double
set nobomb
set t_Co=256




"****************************************************************
" バックアップ
"****************************************************************
" ファイルを上書きする前にバックアップを作ることを無効化
set nowritebackup
set nobackup
set noswapfile



"****************************************************************
" クリップボード
"****************************************************************
" ヤンクをクリップボードへ繋ぐ
set clipboard+=unnamed
" yでコピーした時にクリップボードに入る
set guioptions+=a



"****************************************************************
" 編集
"****************************************************************
" 編集中のファイルが変更されたら自動で読み直す
set autoread

" Undoをファイルが閉じても戻れるように "事前に実行しておく-> `mkdir -p ~/.vim/undo`
if has('persistent_undo')
	let undo_path = expand('~/.vim/undo')
	exe 'set undodir=' .. undo_path
	set undofile
endif

" 挿入モードでバックスペース削除を有効
set backspace=indent,eol,start

" インデント系
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set shiftwidth=2
au FileType go setlocal sw=4 ts=4 sts=4 noet




"****************************************************************
" Display
"****************************************************************
syntax on
"set nu
" ビープ音を消す
set belloff=all
set visualbell " ideavim用
set noerrorbells " ideavim用
" タイトル
set title
" ステータスライン
set laststatus=2
set statusline=%F%m%h%w\ %<[ENC=%{&fenc!=''?&fenc:&enc}]\ [FMT=%{&ff}]\ [TYPE=%Y]\ %=[CODE=0x%02B]\ [POS=%l/%L(%02v)]
" 対応する括弧を強調表示
set showmatch
" 対応する括弧やブレースを表示
set showmatch matchtime=1
" コマンドラインの履歴を1000件保存する
set history=1000
" コメントの色を水色
hi Comment ctermfg=darkgray

" Colorのメモ
" term	白黒端末での属性
" cterm	カラー端末での属性
" ctermfg	カラー端末での文字色
" ctermbg	カラー端末での背景色
" gui	GUI での属性
" font	GUI でのフォント
" guifg	GUI での文字色
" guibg	GUI での背景色
" guisp	GUI での波線色






"****************************************************************
" 検索
"****************************************************************
" 大文字小文字を区別しない
set ignorecase
" 小文字で検索するとき、大文字と小文字を無視
set smartcase
" ファイル末尾まで進んだら、先頭へジャンプ
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果を黄色背景/黒字に変更(デフォルトだと見えづらいので)
set hlsearch
hi Search ctermbg=Yellow
hi Search ctermfg=Black
" 選択範囲を桜色背景/黒字に変更(デフォルトだと見えづらいので)
hi Visual ctermbg=magenta
hi Visual ctermfg=Black

" Escの2回押しでハイライト消去
nnoremap <Esc><Esc> <ESC>:nohlsearch<CR><ESC>



"****************************************************************
" 補完
"****************************************************************
" 括弧の補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap \<<Enter> \<\><Left><CR><ESC><S-o>

" クオーテーションの補完
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

" Ctrl + hjilでウィンドウ移動ができる
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l




"****************************************************************
" 移動
"****************************************************************
" vim の矩形選択で文字が無くても右へ進める
set virtualedit=onemore
" 行をまたいで移動
set whichwrap=b,s,h,l,<,>,[,],~
" ウィンドウの移動f
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l
