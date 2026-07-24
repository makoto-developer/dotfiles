" 標準Vim用の最小設定(サーバ作業・緊急用)
" 普段使いはNeovim(nvim/init.lua)。リッチな設定はすべてそちらに集約している

" エンコード
set encoding=utf8
scriptencoding utf8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set nobomb

" バックアップを作らない
set nowritebackup
set nobackup
set noswapfile

" ヤンクをクリップボードへ繋ぐ
set clipboard+=unnamed

" 編集中のファイルが変更されたら自動で読み直す
set autoread

" Undoをファイルが閉じても戻れるように(事前に `mkdir -p ~/.vim/undo`)
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' .. undo_path
  set undofile
endif

" 挿入モードでバックスペース削除を有効
set backspace=indent,eol,start

" インデント
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
au FileType go setlocal sw=4 ts=4 sts=4 noet

" 表示
syntax on
set belloff=all
set title
set laststatus=2
set showmatch matchtime=1
set history=1000

" 検索
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

" ファイル保存時に最終行に改行を追加する
set fixeol
set eol

" 最小限のキーマップ
inoremap jj <Esc>
nnoremap <Esc><Esc> :nohlsearch<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
