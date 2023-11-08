" nvim/init.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" install dein
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:rc_dir = expand('~/.config/nvim/')

" automatic installation of dein.vim
if !isdirectory(s:dein_repo_dir)
  execute '!git clone <https://github.com/Shougo/dein.vim>' s:dein_repo_dir
endif
execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " load the file which contain the plugin list
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" automatically install any plug-ins that need to be installed.
if dein#check_install()
  call dein#install()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load original vim settings.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime! config/main.vim
runtime! config/macro.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" add shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
nnoremap sn :NERDTree<CR>
" Search local files
nnoremap sf :Files<CR>
" Search nvim tabs
snoremap sw :Windows<CR>
" select multiple keywords intellij -> ctrl + g
nnoremap <silent> <c-n> *Ncgn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTreeを自動的に起動する
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if argc() == 0 || argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    autocmd vimenter * NERDTree
else
    autocmd vimenter * NERDTree | wincmd p
endif
" NERDTree以外のバッファを閉じると自動でNERDTreeも閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" 隠しディレクトリを表示
let NERDTreeShowHidden = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 行番号表示
set nu


