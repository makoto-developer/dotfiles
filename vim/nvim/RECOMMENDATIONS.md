# Neovim 開発環境強化の提案

現在の設定を分析し、開発効率を向上させるプラグインと設定を提案します。

## 📊 現在の設定分析

### ✅ 既に導入済み

| カテゴリ | プラグイン | 用途 |
|---------|-----------|------|
| プラグインマネージャー | dein.vim | プラグイン管理 |
| ファイル探索 | NERDTree, fzf | ファイルツリー、あいまい検索 |
| 編集補助 | vim-surround, vim-autoclose | テキスト囲み、括弧補完 |
| 補完 | deoplete.nvim | 自動補完 |
| Linter | ALE | 構文チェック |
| 検索 | vim-anzu | 検索結果表示 |
| マルチカーソル | vim-multiple-cursors | 複数箇所同時編集 |

### 🔧 現在の設定の強み

- クリップボード共有設定済み
- 基本的な編集機能が充実
- ファイル探索が快適
- 補完とLinterが導入済み

---

## 🚀 推奨プラグイン（優先度順）

### 🔴 優先度: 高（即導入推奨）

#### 1. LSP（Language Server Protocol）統合

**選択肢1: CoC (Conqueror of Completion) - 推奨**

既に `coc-settings.json` があるため、CoCを完全に導入することを推奨。

```toml
# dein.toml に追加
[[plugins]]
repo = 'neoclide/coc.nvim'
rev = 'release'
hook_add = '''
  " CoCの基本設定
  set updatetime=300
  set signcolumn=yes

  " Tab で補完を選択
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " 定義ジャンプ
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " リネーム
  nmap <leader>rn <Plug>(coc-rename)

  " ドキュメント表示
  nnoremap <silent> K :call ShowDocumentation()<CR>
  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction
'''
```

**必要なCoCエクステンション:**

```vim
:CocInstall coc-tsserver      " TypeScript/JavaScript
:CocInstall coc-json          " JSON
:CocInstall coc-python        " Python
:CocInstall coc-go            " Go
:CocInstall coc-html          " HTML
:CocInstall coc-css           " CSS
:CocInstall coc-yaml          " YAML
:CocInstall coc-prettier      " Prettier
:CocInstall coc-eslint        " ESLint
:CocInstall coc-snippets      " スニペット
```

**選択肢2: Native LSP**

```toml
[[plugins]]
repo = 'neovim/nvim-lspconfig'
# Luaでの設定が必要（init.luaへの移行を検討）
```

---

#### 2. Git統合

**vim-fugitive: Gitコマンドをvim内で実行**

```toml
[[plugins]]
repo = 'tpope/vim-fugitive'
hook_add = '''
  " Git status
  nnoremap <leader>gs :Git<CR>
  " Git blame
  nnoremap <leader>gb :Git blame<CR>
  " Git diff
  nnoremap <leader>gd :Gdiffsplit<CR>
  " Git log
  nnoremap <leader>gl :Git log<CR>
'''
```

**gitsigns.nvim: 行ごとのGit変更表示**

```toml
[[plugins]]
repo = 'lewis6991/gitsigns.nvim'
# Luaでの設定が必要
```

---

#### 3. シンタックスハイライト強化

**nvim-treesitter: より正確なシンタックスハイライト**

```toml
[[plugins]]
repo = 'nvim-treesitter/nvim-treesitter'
# Luaでの設定が必要
# 注: Neovim 0.5以降が必要
```

---

#### 4. コメント補助

**vim-commentary: 簡単にコメントアウト**

```toml
[[plugins]]
repo = 'tpope/vim-commentary'
hook_add = '''
  " gcc で行コメントトグル
  " gc{motion} でモーションの範囲をコメントトグル
  " ビジュアルモードで gc でコメントトグル
'''
```

---

### 🟡 優先度: 中（便利だが必須ではない）

#### 5. ステータスライン改善

**vim-airline: 見やすいステータスライン**

```toml
[[plugins]]
repo = 'vim-airline/vim-airline'
hook_add = '''
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline_powerline_fonts = 1
'''

[[plugins]]
repo = 'vim-airline/vim-airline-themes'
hook_add = '''
  let g:airline_theme='molokai'
'''
```

---

#### 6. カラースキーム

**Gruvbox: 目に優しいカラースキーム**

```toml
[[plugins]]
repo = 'morhetz/gruvbox'
hook_add = '''
  augroup SetColorScheme
    au!
    au VimEnter * nested colorscheme gruvbox
  augroup END
  set background=dark
'''
```

**その他おすすめ:**

- `tokyonight.nvim` - モダンなダークテーマ
- `onedark.vim` - VS Codeライク
- `nord-vim` - 北欧風の落ち着いたテーマ

---

#### 7. インデント表示

**indent-blankline.nvim: インデントラインを表示**

```toml
[[plugins]]
repo = 'lukas-reineke/indent-blankline.nvim'
# Luaでの設定が必要
```

---

#### 8. 括弧ハイライト

**rainbow-parentheses.vim: 括弧を色分け**

```toml
[[plugins]]
repo = 'junegunn/rainbow_parentheses.vim'
hook_add = '''
  augroup rainbow_parentheses
    au!
    au VimEnter * RainbowParentheses
  augroup END
'''
```

---

#### 9. バッファ管理改善

**vim-buffergator: バッファ一覧と切り替え**

```toml
[[plugins]]
repo = 'jeetsukumaran/vim-buffergator'
hook_add = '''
  " <Leader>b でバッファリストを表示
  nnoremap <leader>b :BuffergatorToggle<CR>
'''
```

---

#### 10. ターミナル統合

**vim-floaterm: フローティングターミナル**

```toml
[[plugins]]
repo = 'voldikss/vim-floaterm'
hook_add = '''
  " <Leader>t でターミナルトグル
  nnoremap <leader>t :FloatermToggle<CR>
  tnoremap <leader>t <C-\><C-n>:FloatermToggle<CR>

  let g:floaterm_width = 0.8
  let g:floaterm_height = 0.8
'''
```

---

### 🟢 優先度: 低（特定の用途）

#### 11. Markdown プレビュー

**markdown-preview.nvim: ブラウザでプレビュー**

```toml
[[plugins]]
repo = 'iamcco/markdown-preview.nvim'
build = 'cd app && yarn install'
on_ft = ['markdown']
hook_add = '''
  " <Leader>md でプレビュー
  nmap <leader>md <Plug>MarkdownPreviewToggle
'''
```

---

#### 12. スニペット

**UltiSnips: 強力なスニペットエンジン**

```toml
[[plugins]]
repo = 'SirVer/ultisnips'
hook_add = '''
  let g:UltiSnipsExpandTrigger="<c-j>"
  let g:UltiSnipsJumpForwardTrigger="<c-j>"
  let g:UltiSnipsJumpBackwardTrigger="<c-k>"
'''

[[plugins]]
repo = 'honza/vim-snippets'
# UltiSnipsで使えるスニペット集
```

---

#### 13. プロジェクト管理

**vim-projectionist: プロジェクト固有の設定**

```toml
[[plugins]]
repo = 'tpope/vim-projectionist'
```

---

#### 14. セッション管理

**vim-startify: スタート画面とセッション管理**

```toml
[[plugins]]
repo = 'mhinz/vim-startify'
hook_add = '''
  " セッション保存ディレクトリ
  let g:startify_session_dir = '~/.config/nvim/session'

  " 最近使ったファイルの数
  let g:startify_files_number = 10
'''
```

---

## ⚙️ 設定の改善提案

### 1. init.vimの構造改善

現在の設定は1ファイルに集約されていますが、以下のように分割すると管理しやすくなります。

```
nvim/
├── init.vim              # メインエントリポイント
├── dein.toml             # 通常ロードプラグイン
├── dein_lazy.toml        # 遅延ロードプラグイン
├── coc-settings.json     # CoC設定
└── config/
    ├── main.vim          # 基本設定（既存）
    ├── mappings.vim      # キーマッピング（新規）
    ├── autocmds.vim      # 自動コマンド（新規）
    └── plugins/          # プラグイン別設定
        ├── coc.vim
        ├── fzf.vim
        └── ...
```

### 2. キーマッピングの整理

**提案するキーマッピング:**

```vim
" mappings.vim として分離

" ========================================
" Leader キー
" ========================================
let mapleader = "\<Space>"

" ========================================
" ファイル操作
" ========================================
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>x :x<CR>

" ========================================
" バッファ操作
" ========================================
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :buffers<CR>

" ========================================
" タブ操作
" ========================================
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

" ========================================
" 検索
" ========================================
" ハイライトクリア
nnoremap <leader>h :nohlsearch<CR>

" ========================================
" Git操作（fugitiveが必要）
" ========================================
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gb :Git blame<CR>

" ========================================
" 編集補助
" ========================================
" 行の結合をスペースなしで
nnoremap <leader>j :join<CR>

" 全選択
nnoremap <leader>a ggVG

" インデント整理
nnoremap <leader>= gg=G

" ========================================
" ターミナル
" ========================================
" ターミナルを開く
nnoremap <leader>t :terminal<CR>
" ターミナルモードから抜ける
tnoremap <Esc> <C-\><C-n>
```

### 3. 自動コマンドの整理

```vim
" autocmds.vim として分離

" ========================================
" ファイルタイプ別設定
" ========================================
augroup FileTypeSettings
  au!

  " Go
  au FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  au FileType go nmap <leader>r :!go run %<CR>
  au FileType go nmap <leader>b :!go build<CR>
  au FileType go nmap <leader>tt :!go test<CR>

  " Python
  au FileType python setlocal tabstop=4 shiftwidth=4
  au FileType python nmap <leader>r :!python3 %<CR>

  " JavaScript/TypeScript
  au FileType javascript,typescript setlocal tabstop=2 shiftwidth=2
  au FileType javascript nmap <leader>r :!node %<CR>

  " Markdown
  au FileType markdown setlocal wrap linebreak
  au FileType markdown setlocal spell spelllang=en,cjk

  " JSON
  au FileType json setlocal tabstop=2 shiftwidth=2

  " YAML
  au FileType yaml setlocal tabstop=2 shiftwidth=2
augroup END

" ========================================
" 保存時の処理
" ========================================
augroup AutoSave
  au!
  " 保存時に末尾の空白を削除
  au BufWritePre * :%s/\s\+$//e
augroup END

" ========================================
" その他
" ========================================
augroup Misc
  au!
  " カーソル位置を復元
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " ファイル変更を自動的に読み込む
  au FocusGained,BufEnter * checktime
augroup END
```

### 4. パフォーマンス最適化

```vim
" config/performance.vim

" ========================================
" パフォーマンス設定
" ========================================
" 描画を遅延
set lazyredraw

" タイムアウト設定
set timeout timeoutlen=500 ttimeoutlen=10

" 更新時間を短縮（CoCなどで必要）
set updatetime=300

" より多くのメモリを使用
set maxmempattern=5000

" 正規表現エンジン
set regexpengine=1

" ファイル変更検知の間隔
set updatetime=100
```

---

## 📝 導入手順

### 1. 最小限の導入（即効性あり）

```toml
# dein.toml に以下を追加

# CoC（LSP統合）
[[plugins]]
repo = 'neoclide/coc.nvim'
rev = 'release'

# Git統合
[[plugins]]
repo = 'tpope/vim-fugitive'

# コメント補助
[[plugins]]
repo = 'tpope/vim-commentary'

# カラースキーム
[[plugins]]
repo = 'morhetz/gruvbox'
hook_add = '''
  augroup SetColorScheme
    au!
    au VimEnter * nested colorscheme gruvbox
  augroup END
  set background=dark
'''
```

### 2. プラグインのインストール

```vim
:call dein#install()
```

### 3. CoCエクステンションのインストール

```vim
:CocInstall coc-tsserver coc-json coc-python coc-go coc-prettier
```

---

## 🔄 Luaへの移行検討

Neovim 0.5以降では、Lua設定が推奨されています。以下のメリットがあります：

- より高速
- モダンなプラグイン（TreeSitter, Native LSP等）が使える
- 設定がより柔軟

### 移行の手順

1. `init.lua` を作成
2. 既存の設定を段階的にLuaに変換
3. プラグインマネージャーをLazy.nvimなどに変更検討

---

## 📊 推奨導入優先順位まとめ

| 優先度 | プラグイン | 理由 |
|-------|-----------|------|
| 🔴 最高 | CoC (coc.nvim) | LSP統合で開発効率が劇的に向上 |
| 🔴 最高 | vim-fugitive | Git操作がvim内で完結 |
| 🔴 最高 | vim-commentary | コメントアウトが超快適 |
| 🟡 高 | gruvbox | 見やすいカラースキーム |
| 🟡 高 | vim-airline | ステータスラインが見やすい |
| 🟡 中 | vim-floaterm | ターミナル統合が便利 |
| 🟢 低 | その他 | 必要に応じて導入 |

---

## 💡 Tips

### CoCの設定を既存のcoc-settings.jsonに追加

```json
{
  "coc.preferences.formatOnSaveFiletypes": [
    "python",
    "go",
    "dart",
    "html",
    "javascript",
    "typescript",
    "css",
    "json",
    "graphql",
    "markdown"
  ],
  "suggest.enablePreselect": true,
  "suggest.noselect": false,
  "diagnostic.errorSign": "✗",
  "diagnostic.warningSign": "⚠",
  "diagnostic.infoSign": "ℹ",
  "diagnostic.hintSign": "➤"
}
```

### 既存のプラグインとの競合回避

- `deoplete` と `coc.nvim` は競合する可能性があるため、CoCを導入する場合はdeopleteを無効化推奨
- `vim-autoclose` と CoCのスニペットが競合する可能性があるため、動作を確認

---

## 🔗 参考リンク

- [CoC Documentation](https://github.com/neoclide/coc.nvim)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim) - プラグイン一覧
- [Neovim公式ドキュメント](https://neovim.io/doc/)

---

## まとめ

現在の設定は基本的な開発には十分ですが、以下を追加することで更に快適になります：

1. **CoC導入** - LSP統合で補完・定義ジャンプ・リファクタリングが強化
2. **Git統合** - vim-fugitiveでGit操作がシームレス
3. **コメント補助** - vim-commentaryで簡単コメントアウト
4. **カラースキーム** - gruvboxで目に優しい環境

まずは優先度の高いプラグインから試してみてください！
