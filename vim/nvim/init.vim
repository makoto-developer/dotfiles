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
" vim-visual-multi settings (must be set before plugin load)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-g>'
let g:VM_maps['Find Subword Under'] = '<C-g>'
let g:VM_maps["Select All"]         = '<C-S-g>'
let g:VM_maps["Skip Region"]        = '<C-x>'
let g:VM_maps["Remove Region"]      = '<C-p>'
let g:VM_maps["Visual Cursors"]     = '<C-g>'
let g:VM_theme = 'iceblue'
let g:VM_highlight_matches = 'underline'

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
" NERDTreeを自動的に起動する
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグイン読み込み後に実行
augroup NERDTreeAuto
  autocmd!
  autocmd VimEnter * if exists(':NERDTree') && (argc() == 0 || (argc() == 1 && isdirectory(argv()[0]))) | NERDTree | endif
  autocmd VimEnter * if exists(':NERDTree') && argc() > 0 && !isdirectory(argv()[0]) | NERDTree | wincmd p | endif
  " NERDTree以外のバッファを閉じると自動でNERDTreeも閉じる
  autocmd BufEnter * if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | q | endif
augroup END
" 隠しディレクトリを表示
let NERDTreeShowHidden = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load original vim settings.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime! config/*.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" add shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
nnoremap sn :NERDTree<CR>
" Search local files
nnoremap sf :Files<CR>
" Search nvim tabs
snoremap sw :Windows<CR>
" select multiple keywords intellij -> ctrl + g, canceling ctrl + c
nnoremap <silent> <c-n> *Ncgn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" True Color サポート（Kanagawaなどの高度なカラースキームに必要）
if has('termguicolors')
  set termguicolors
endif

" ファイルタイプ検出とプラグイン・インデントを有効化
filetype plugin indent on

" シンタックスハイライトを有効化
syntax on

" 行番号表示
set nu
" クリップボードを共有
set clipboard+=unnamedplus

" Elixir/Phoenix ファイルタイプの明示的な認識
augroup ElixirFiletypes
  autocmd!
  autocmd BufRead,BufNewFile *.ex set filetype=elixir
  autocmd BufRead,BufNewFile *.exs set filetype=elixir
  autocmd BufRead,BufNewFile *.eex set filetype=eelixir
  autocmd BufRead,BufNewFile *.heex set filetype=eelixir
  autocmd BufRead,BufNewFile *.leex set filetype=eelixir
  autocmd BufRead,BufNewFile mix.lock set filetype=elixir
  " ファイルを開いた時に強制的にシンタックスを再読み込み
  autocmd FileType elixir,eelixir syntax on
  autocmd FileType elixir,eelixir setlocal syntax=ON
augroup END

" カラースキーム読み込み後もシンタックスを維持
augroup PreserveElixirSyntax
  autocmd!
  autocmd ColorScheme * if &filetype ==# 'elixir' || &filetype ==# 'eelixir' | syntax on | endif
augroup END

" Treesitter用のハイライトグループ定義
augroup TreesitterHighlights
  autocmd!
  " Elixir関数・変数のハイライト
  autocmd FileType elixir,eelixir highlight link @function.call Function
  autocmd FileType elixir,eelixir highlight link @function.method Function
  autocmd FileType elixir,eelixir highlight link @variable Identifier
  autocmd FileType elixir,eelixir highlight link @parameter Identifier
  autocmd FileType elixir,eelixir highlight link @module Type
  autocmd FileType elixir,eelixir highlight link @type Type
  autocmd FileType elixir,eelixir highlight link @constant Constant
  autocmd FileType elixir,eelixir highlight link @keyword.function Keyword
  autocmd FileType elixir,eelixir highlight link @operator Operator
augroup END

