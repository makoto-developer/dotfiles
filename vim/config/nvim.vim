" Neovim

set nu

"****************************************************************
" 移動
"****************************************************************
nnoremap sn :NERDTree<CR> " NERDTree
nnoremap sf :Files<CR>    " fzf
nnoremap sw :Windows<CR>  " fzf

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/user/.cache/dein/repos/github.com/Shougo/dein.vim


if dein#load_state('/Users/user/.cache/dein')
  " Required:
  call dein#begin('/Users/user/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/user/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#load_toml('/Users/user/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('/Users/user/.config/nvim/dein_lazy.toml', {'lazy': 1})

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
endif

" If have not installed dein plugins, auto starting install.
if dein#check_install()
 call dein#install()
endif

" Required:
filetype plugin indent on
syntax enable
"hi Visual  guifg=#000000 guibg=#FFFFFF gui=none
"highlight CursorLine ctermbg=LightBlue

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" NERDTree設定
autocmd vimenter * NERDTree      " NERDTreeを常に表示
let NERDTreeShowHidden=1         " 隠しファイルを常に表示

" Molokaiテーマ
"let g:molokai_original=1

" fzf
let $FZF_DEFAULT_COMMAND='find . -not -regex ".*node_modules/.*" -not -regex ".*\.git/.*" -not -regex ".*\.next/.*" -not -regex ".*\.idea/.*" -not -regex ".*\.idea/"'
