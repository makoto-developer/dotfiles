-- Neovim設定 (lazy.nvim + 組み込みLSP + treesitter)
-- 初回起動時にプラグイン・LSPサーバが自動インストールされる
-- 外部依存はgitとnvim本体のみ(Node/Python不要)

-- ================================================================
-- リーダーキー (プラグイン読み込み前に設定する必要がある)
-- ================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ================================================================
-- オプション (旧config/main.vimから移植)
-- ================================================================
local opt = vim.opt

-- エンコード
opt.fileencoding = 'utf-8'
opt.fileformats = 'unix,dos,mac'
opt.bomb = false

-- バックアップ(作らない)
opt.writebackup = false
opt.backup = false
opt.swapfile = false

-- ヤンクをクリップボードへ繋ぐ
opt.clipboard = 'unnamedplus'

-- 編集中のファイルが変更されたら自動で読み直す
opt.autoread = true
-- 外部(Claude/orca等のAIエージェント)がファイルを書き換えたら即座に反映する
-- (autoreadだけだと反映が遅く、古いバッファの保存でエージェントの変更を上書きする事故が起きる)
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then pcall(vim.cmd, 'checktime') end
  end,
})

-- Undoをファイルが閉じても戻れるように(undodirはnvimのデフォルトを使う)
opt.undofile = true

-- インデント
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true

-- 補完表示
opt.completeopt = 'menuone,noinsert,noselect'

-- 表示
-- 背景は常に「暗い」扱いにする。
-- ※明示的に設定しておくと、Neovimが起動時にターミナルへ背景色を問い合わせて(OSC 11)
--   'background'を自動で書き換える動作が無効になる(runtime/lua/vim/_core/defaults.lua)。
--   これが無いと、macOSをライトモードにするとiTermが白背景になり、'background'がlightへ
--   変わった副作用でカラースキームが解除され(colors_nameがnilに戻る)、組み込みのライト配色に落ちる。
opt.background = 'dark'
opt.title = true
opt.showmatch = true
opt.matchtime = 1
opt.belloff = 'all'
opt.history = 1000
opt.number = true          -- 行番号(普通の連番)
opt.cursorline = true      -- カーソル行をハイライト
opt.signcolumn = 'yes'     -- git変更・ブレークポイント等の表示列を常に確保(ガタつき防止)
opt.scrolloff = 8          -- カーソルの上下に常に8行の余白(VSCode設定と同じ)

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.incsearch = true
opt.hlsearch = true

-- 移動
opt.virtualedit = 'onemore'          -- 矩形選択で文字が無くても右へ進める
opt.whichwrap = 'b,s,h,l,<,>,[,],~'  -- 行をまたいで移動

-- ファイル保存時に最終行に改行を追加する
opt.fixendofline = true
opt.endofline = true

-- goはタブ幅4のハードタブ
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ================================================================
-- キーマップ (旧config/main.vimから移植)
-- ================================================================
local map = vim.keymap.set

-- Escの2回押しでハイライト消去
map('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>', { silent = true })

-- Ctrl + hjklでウィンドウ移動
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- sはプレフィックス専用にする(単体では何も起きない)
-- 組み込みのsは「1文字削除して挿入モード」。sの後の入力がtimeoutlen(1秒)を超えると
-- 素のsが発動して意図せず文字が消えるため無効化する。本来のsが必要な場合はclで代替
map({ 'n', 'x' }, 's', '<Nop>')

-- sプレフィックスでウィンドウ・タブ操作
map('n', 'sj', '<C-w>j')
map('n', 'sk', '<C-w>k')
map('n', 'sl', '<C-w>l')
map('n', 'sh', '<C-w>h')
map('n', 'ss', '<Cmd>sp<CR><C-w>j')   -- 横分割
map('n', 'sv', '<Cmd>vs<CR><C-w>l')   -- 縦分割
map('n', 'st', '<Cmd>tabnew<CR>')     -- 新規タブ
map('n', 'sn', 'gt')                  -- 次のタブ
map('n', 'sp', 'gT')                  -- 前のタブ
map('n', 'sq', '<Cmd>q<CR>')          -- 閉じる

-- s系: LSP操作(IntelliJの機能名の頭文字で覚える)
-- 検索系(sf/sg/so/se/sb)はtelescopeプラグインのkeysで定義
map('n', 'sd', function() vim.lsp.buf.definition() end)              -- definition: 定義へ(戻りはCtrl+o)
map('n', 'su', function() vim.lsp.buf.references() end)              -- usage: 使用箇所検索
map('n', 'si', function() vim.lsp.buf.implementation() end)          -- implementation: 実装へ
map('n', 'sr', function() vim.lsp.buf.rename() end)                  -- rename: リネーム
map('n', 'sa', function() vim.lsp.buf.code_action() end)             -- action: コードアクション
map('n', 'sF', function() vim.lsp.buf.format({ async = true }) end)  -- Format: ファイル全体をフォーマット

-- 挿入モードのjjでEsc
map('i', 'jj', '<Esc>')

-- 基本操作の改善
map('n', 'Y', 'y$')                   -- Yを行末までコピーに(C/Dと統一)
map('n', 'U', '<C-r>')                -- Uをredoに(uとの対称性)
map({ 'n', 'x' }, 'x', '"_x')         -- xはレジスタを汚さない
map('x', 'p', 'P')                    -- 連続ペーストでレジスタを上書きしない

-- ビジュアルモード
map('x', '<', '<gv')                  -- インデント後に選択を維持
map('x', '>', '>gv')
map('x', 'y', 'y`>')                  -- コピー後にカーソル位置を保持
map('x', '*', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]]) -- 選択範囲を*で検索

-- 編集効率化
map('n', '<leader>y', 'yyp')          -- 行の複製
map('n', '<leader>Y', 'yyP')
map('n', '<leader>o', 'o<Esc>')       -- 空行の挿入(インサートモードに入らない)
map('n', '<leader>O', 'O<Esc>')
map('n', '<leader>d', '"_dd')         -- 行削除(レジスタを汚さない)
map('n', '<leader>;', 'A;<Esc>')      -- 行末にセミコロン
map('n', '<leader>,', 'A,<Esc>')      -- 行末にカンマ

-- 置換
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]]) -- カーソル下の単語を置換(確認あり)
map('x', '<leader>s', [[y:%s/<C-r>"//gc<Left><Left><Left>]])        -- 選択範囲を置換

-- ナビゲーション
map('n', 'M', '%')                    -- 括弧ジャンプ
map('n', '[b', '<Cmd>bprevious<CR>')  -- バッファ移動
map('n', ']b', '<Cmd>bnext<CR>')
map('n', '[t', '<Cmd>tabprevious<CR>') -- タブ移動
map('n', ']t', '<Cmd>tabnext<CR>')

-- 保存・終了
map('n', '<leader>w', '<Cmd>w<CR>')
map('n', '<leader>q', '<Cmd>q<CR>')
map('n', '<leader>x', '<Cmd>x<CR>')

-- ファイルパス/ファイル名をクリップボードにコピー
map('n', '<leader>fp', function()
  local p = vim.fn.expand('%:p'); vim.fn.setreg('+', p); print('Copied: ' .. p)
end)
map('n', '<leader>fn', function()
  local t = vim.fn.expand('%:t'); vim.fn.setreg('+', t); print('Copied: ' .. t)
end)

-- 日付・時刻の挿入
map('n', '<leader>dt', [["=strftime('%Y-%m-%d')<CR>p]])
map('n', '<leader>tt', [["=strftime('%H:%M:%S')<CR>p]])
map('i', '<C-d><C-d>', [[<C-r>=strftime('%Y-%m-%d')<CR>]])
map('i', '<C-t><C-t>', [[<C-r>=strftime('%H:%M:%S')<CR>]])

-- ================================================================
-- IntelliJ風ショートカット
-- 方針: IntelliJ風 > vim標準 > 独自キー の優先順で割り当てる
-- ※OS/orca/iTermと競合するもの(Cmd+B: orcaのサイドバー、Cmd+1: タブ切替)は定義せず、
--   vim標準(Ctrl+]等)や独自キー(Space e等)で代替する
-- ※telescope系のCmdキーはtelescopeプラグインのkeysで定義(遅延読み込みのトリガーにするため)
-- ================================================================
map('n', '<D-M-l>', function() vim.lsp.buf.format({ async = true }) end) -- Cmd+Opt+L: フォーマット
map('n', '<S-F6>', function() vim.lsp.buf.rename() end)                  -- Shift+F6: リネーム
map('n', '<M-F7>', function() vim.lsp.buf.references() end)              -- Opt+F7: 使用箇所検索
map('n', '<D-/>', 'gcc', { remap = true })                               -- Cmd+/: コメントトグル
map('x', '<D-/>', 'gc', { remap = true })

-- ================================================================
-- IntelliJの機能をキーに割り当てる(プラグイン不要。LSP・treesitterの機能を呼ぶだけ)
-- ================================================================

-- import整理(IntelliJのCtrl+Opt+O)。未使用importの削除と並べ替え
map('n', 'sI', function()
  vim.lsp.buf.code_action({
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
    apply = true,
  })
end, { desc = 'importを整理(Imports)' })

-- 行・選択範囲を上下に移動(IntelliJのCmd+Shift+↑↓)
map('n', '<A-j>', '<Cmd>m .+1<CR>==', { desc = '行を下へ移動' })
map('n', '<A-k>', '<Cmd>m .-2<CR>==', { desc = '行を上へ移動' })
map('x', '<A-j>', ":m '>+1<CR>gv=gv", { desc = '選択範囲を下へ移動' })
map('x', '<A-k>', ":m '<-2<CR>gv=gv", { desc = '選択範囲を上へ移動' })

-- 選択範囲を構文単位で拡大・縮小(IntelliJのOpt+↑↓)
-- 変数 -> 式 -> 文 -> 関数 のように、意味のあるかたまり単位で広がる
local ts_sel_stack = {}
local function ts_select_node(node)
  local sr, sc, er, ec = node:range()
  vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
  vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
  vim.cmd('normal! gv')
end
local function ts_expand()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return end
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    vim.cmd('normal! \27') -- 選択範囲をマークに確定させる
    local s = vim.api.nvim_buf_get_mark(0, '<')
    local e = vim.api.nvim_buf_get_mark(0, '>')
    node = vim.treesitter.get_node({ pos = { s[1] - 1, s[2] } })
    -- 今の選択範囲より大きいノードまで親を辿る
    while node do
      local sr, sc, er, ec = node:range()
      if sr < s[1] - 1 or (sr == s[1] - 1 and sc < s[2])
        or er > e[1] - 1 or (er == e[1] - 1 and ec > e[2] + 1) then
        break
      end
      node = node:parent()
    end
    if not node then return end
    table.insert(ts_sel_stack, { s, e })
  else
    ts_sel_stack = {}
  end
  ts_select_node(node)
end
local function ts_shrink()
  local prev = table.remove(ts_sel_stack)
  if not prev then return end
  vim.cmd('normal! \27')
  vim.fn.setpos("'<", { 0, prev[1][1], prev[1][2] + 1, 0 })
  vim.fn.setpos("'>", { 0, prev[2][1], prev[2][2] + 1, 0 })
  vim.cmd('normal! gv')
end
map({ 'n', 'x' }, '<A-o>', ts_expand, { desc = '選択範囲を構文単位で拡大(out)' })
map('x', '<A-i>', ts_shrink, { desc = '選択範囲を構文単位で縮小(in)' })

-- テストと実装を行き来する(IntelliJのCmd+Shift+T)
map('n', '<leader>tf', function()
  local path = vim.fn.expand('%:p')
  local candidates
  if path:match('_test%.go$') then
    candidates = { (path:gsub('_test%.go$', '.go')) }
  elseif path:match('%.go$') then
    candidates = { (path:gsub('%.go$', '_test.go')) }
  elseif path:match('_test%.exs$') then
    -- test/foo/bar_test.exs -> lib/foo/bar.ex
    candidates = { (path:gsub('/test/', '/lib/'):gsub('_test%.exs$', '.ex')) }
  elseif path:match('%.ex$') then
    candidates = { (path:gsub('/lib/', '/test/'):gsub('%.ex$', '_test.exs')) }
  else
    -- TS/JS: foo.ts <-> foo.test.ts / foo.spec.ts
    local base, ext = path:match('^(.*)%.([tj]sx?)$')
    if not base then return vim.notify('対応していないファイル種別です', vim.log.levels.WARN) end
    if base:match('%.test$') or base:match('%.spec$') then
      candidates = { base:gsub('%.[ts][ep][se]c?$', '') .. '.' .. ext }
    else
      candidates = { base .. '.test.' .. ext, base .. '.spec.' .. ext }
    end
  end
  for _, c in ipairs(candidates) do
    if vim.fn.filereadable(c) == 1 then return vim.cmd.edit(c) end
  end
  vim.notify('対応するファイルが見つかりません: ' .. table.concat(candidates, ', '), vim.log.levels.WARN)
end, { desc = 'テストと実装を往復' })

-- 折りたたみ(IntelliJのCmd+- / Cmd+=)。treesitterで構文に沿って畳む
-- zaで開閉、zRで全部開く、zMで全部畳む。起動時は開いた状態にしておく
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99

-- ================================================================
-- ファイルタイプ別マクロ(デバッグ出力・Markdown支援)
-- ================================================================
vim.cmd([[
  " カーソル下の変数をデバッグ出力
  augroup ProgrammingShortcuts
    autocmd!
    autocmd FileType javascript,typescript,javascriptreact,typescriptreact
      \ nnoremap <buffer> <Leader>cl yiwoconsole.log('<C-r>":', <C-r>");<Esc>
    autocmd FileType javascript,typescript,javascriptreact,typescriptreact
      \ xnoremap <buffer> <Leader>cl yoconsole.log('<C-r>":', <C-r>");<Esc>
    autocmd FileType python
      \ nnoremap <buffer> <Leader>cl yiwoprint(f'<C-r>": {<C-r>"}')<Esc>
    autocmd FileType go
      \ nnoremap <buffer> <Leader>cl yiwofmt.Println("<C-r>":", <C-r>")<Esc>
    autocmd FileType elixir
      \ nnoremap <buffer> <Leader>cl yiwoIO.inspect(<C-r>", label: "<C-r>"")<Esc>
  augroup END

  " Markdown支援
  augroup MarkdownHelpers
    autocmd!
    autocmd FileType markdown xnoremap <buffer> <Leader>b c**<C-r>"**<Esc>
    autocmd FileType markdown xnoremap <buffer> <Leader>i c*<C-r>"*<Esc>
    autocmd FileType markdown xnoremap <buffer> <Leader>c c`<C-r>"`<Esc>
    autocmd FileType markdown nnoremap <buffer> <Leader>l i[]()<Esc>F]a
  augroup END
]])

-- ================================================================
-- lazy.nvim (プラグインマネージャ)を自動ブートストラップ
-- ================================================================
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ================================================================
-- プラグイン
-- ================================================================
require('lazy').setup({

  -- カラースキーム(真っ黒背景 + 高コントラスト)
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    config = function()
      require('nightfox').setup({
        palettes = {
          carbonfox = {
            bg0 = '#000000', -- 画面全体の背景を純黒に
            bg1 = '#000000',
          },
        },
        groups = {
          carbonfox = {
            -- 純黒同士だと境界が消えるので、ウィンドウの境界線をはっきりさせる
            WinSeparator = { fg = '#5a5a5a' },
          },
        },
      })
      vim.cmd.colorscheme('carbonfox')
    end,
  },

  -- シンタックスハイライト(Elixir含む。旧force-elixir-colors等の応急処置はすべて不要になる)
  -- ※mainブランチの新API(旧masterのnvim-treesitter.configsは廃止された)
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').install({
        'elixir', 'heex', 'eex',
        'javascript', 'typescript', 'tsx',
        'go', 'rust', 'lua', 'vim', 'vimdoc',
        'json', 'yaml', 'toml', 'markdown', 'markdown_inline',
        'bash', 'html', 'css', 'sql', 'terraform', 'dockerfile',
        -- マイクロサービス関連
        'proto', 'graphql', 'gomod', 'gosum', 'gowork', 'make',
      })
      -- ファイルを開いたらtreesitterハイライトを有効化(パーサがあれば)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  -- LSP(言語サーバは:Masonで管理。初回起動時に自動インストール)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          ensure_installed = {
            'elixirls',        -- Elixir(.ex/.exs/.heex)
            'ts_ls',           -- TypeScript/JavaScript
            'eslint',          -- TS/JSのlint(警告をsaで自動修正できる)
            'gopls',           -- Go
            'rust_analyzer',   -- Rust
            'lua_ls',          -- Lua
            'html',            -- HTML
            'cssls',           -- CSS
            'tailwindcss',     -- Tailwind(クラス名補完・色プレビュー。heexにも効く)
            'bashls',          -- シェルスクリプト(deploy.sh等)
            'dockerls',        -- Dockerfile
            'marksman',        -- Markdown(記事間のリンク補完・見出しジャンプ)
            'protols',         -- Protocol Buffers(message定義へのジャンプ・import解決)
            'graphql',         -- GraphQL(federationのスキーマ含む)
            'jsonls', 'yamlls',
          },
        },
      },
    },
    config = function()
      -- lua_lsにvimグローバルを認識させる
      vim.lsp.config('lua_ls', {
        settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
      })
      -- inlay hints(引数名・型のインライン表示)をサーバ側で有効にする
      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            hints = {
              parameterNames = true,
              assignVariableTypes = true,
              functionTypeParameters = true,
              rangeVariableTypes = true,
              compositeLiteralFields = true,
            },
          },
        },
      })
      local ts_inlay = {
        includeInlayParameterNameHints = 'all',
        includeInlayVariableTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      }
      vim.lsp.config('ts_ls', {
        settings = { typescript = { inlayHints = ts_inlay }, javascript = { inlayHints = ts_inlay } },
      })
      -- Tailwindのクラス名補完をPhoenixのheexテンプレートでも効かせる
      vim.lsp.config('tailwindcss', {
        filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'elixir', 'eelixir', 'heex' },
        init_options = { userLanguages = { elixir = 'html-eex', eelixir = 'html-eex', heex = 'html-eex' } },
      })
      -- 補完エンジンのcapabilitiesを全サーバに適用
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- Mason管理外のサーバ(既にディスク上にあるものを使う。追加インストール不要)
      -- Swift: Xcodeに同梱 / Terraform: miseで導入済み
      if vim.fn.executable('xcrun') == 1 then vim.lsp.enable('sourcekit') end
      if vim.fn.executable('terraform-ls') == 1 then vim.lsp.enable('terraformls') end
    end,
  },

  -- 補完(deoplete/CoCの置き換え。Node/Python不要)
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          -- 補完表示時のEnterで確定(未選択なら通常の改行)
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
      })
    end,
  },

  -- ファジーファインダー(denite/fzf.vimの置き換え。検索はripgrepを使用)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- 高速なfuzzyソーター(C実装)。sgのfuzzy全文検索を快適にする
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      -- s系(メイン。sプレフィックスは上書きしていいルール)
      { 'sf', '<Cmd>Telescope find_files<CR>', desc = 'ファイル名でジャンプ(file)' },
      -- 全行を読み込んでfuzzyで絞り込む(多少typoしてもヒットする。sfと同じ操作感)
      {
        'sg',
        function()
          require('telescope.builtin').grep_string({
            search = '',
            only_sort_text = true,
            prompt_title = '全文検索(fuzzy)',
          })
        end,
        desc = '全文検索(grep/fuzzy)',
      },
      { 'so', '<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'シンボル検索(IntelliJのCmd+O)' },
      { 'se', '<Cmd>Telescope oldfiles<CR>',   desc = '最近のファイル(IntelliJのCmd+E)' },
      { 'sb', '<Cmd>Telescope buffers<CR>',    desc = 'バッファ一覧(buffer)' },
      -- カーソル下の単語をプロジェクト全体からexact検索(リポジトリを跨ぐ呼び出し追跡に。LSPのsuはリポジトリ内のみ)
      { 'sw', function() require('telescope.builtin').grep_string() end, desc = 'カーソル下の単語を横断検索(word)' },
      -- 呼び出し階層(IntelliJのCtrl+Opt+H)。「この関数を呼んでいるのは誰か」を辿る
      { 'sC', '<Cmd>Telescope lsp_incoming_calls<CR>', desc = '呼び出し元をたどる(Callers)' },
      { '<leader>co', '<Cmd>Telescope lsp_outgoing_calls<CR>', desc = 'この関数が呼んでいる先' },
      -- コマンド一覧(IntelliJのCmd+Shift+A: Find Action)。;は:と同じキーなので覚えやすい
      { 's;', '<Cmd>Telescope commands<CR>', desc = 'コマンドを探して実行' },
      { 's:', '<Cmd>Telescope keymaps<CR>', desc = 'キーマップを検索' },
      -- git変更ファイル一覧(レビュー開始の起点)
      { '<leader>gs', '<Cmd>Telescope git_status<CR>', desc = 'git変更ファイル一覧' },
      -- Space系(予備)
      { '<leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'ファイル検索' },
      { '<leader>fg', '<Cmd>Telescope live_grep<CR>',  desc = 'テキスト検索(rg)' },
      { '<leader>fb', '<Cmd>Telescope buffers<CR>',    desc = 'バッファ一覧' },
      { '<leader>fh', '<Cmd>Telescope oldfiles<CR>',   desc = '最近開いたファイル' },
      { '<leader>fs', '<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'シンボル検索(関数・型名でジャンプ)' },
      -- IntelliJ風(OS/orca/iTermと競合しない検索・ジャンプ系のみ)
      { '<D-S-o>', '<Cmd>Telescope find_files<CR>',    desc = 'ファイル名でジャンプ(IntelliJ風)' },
      { '<D-o>',   '<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'シンボル検索(IntelliJ風)' },
      { '<D-S-f>', '<Cmd>Telescope live_grep<CR>',     desc = '全文検索(IntelliJ風)' },
      { '<D-e>',   '<Cmd>Telescope oldfiles<CR>',      desc = '最近のファイル(IntelliJ風)' },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          mappings = {
            -- IntelliJと同じくEsc1回で閉じる(候補の移動はCtrl+n/Ctrl+p)
            i = { ['<Esc>'] = actions.close },
          },
        },
      })
      pcall(require('telescope').load_extension, 'fzf')
    end,
  },

  -- git操作(:Git blame等)
  { 'tpope/vim-fugitive', cmd = { 'Git', 'Gdiffsplit', 'Gvdiffsplit' } },

  -- gitグラフ表示(コミット上でEnterすると差分を確認できる)
  {
    'rbong/vim-flog',
    dependencies = { 'tpope/vim-fugitive' },
    cmd = { 'Flog', 'Flogsplit' },
    keys = {
      { 'sG', '<Cmd>Flog<CR>', desc = 'gitグラフ(Git)' },
      { '<leader>gg', '<Cmd>Flog<CR>', desc = 'gitグラフ' },
    },
  },

  -- ブランチ差分・ファイル履歴のレビュー用ビューア
  -- :DiffviewOpen main...HEAD でブランチ差分、:DiffviewFileHistory % でファイルの変更履歴
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    keys = {
      { 'sD', '<Cmd>DiffviewOpen<CR>', desc = 'diffビューア(Diff。閉じるは:DiffviewClose)' },
    },
  },

  -- 画面上部に「今いる関数・モジュールの宣言行」を固定表示(巨大ファイルの迷子防止)
  { 'nvim-treesitter/nvim-treesitter-context', opts = {} },

  -- GitHubのPRをnvim内でレビュー(diffに行コメント・approve・マージ。gh CLIの認証を利用)
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Octo',
    keys = {
      { 'sP', '<Cmd>Octo pr list<CR>', desc = 'PR一覧(PR)' },
    },
    opts = {},
  },

  -- プロジェクト横断の検索置換UI(rg結果を一覧で見ながら一括置換)
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      { 'sR', '<Cmd>GrugFar<CR>', desc = '横断検索置換(Replace)' },
    },
    opts = {},
  },

  -- Claude CodeのIDE統合(nvim内でclaudeを開く・選択範囲を渡す・変更提案をdiffで確認)
  {
    'coder/claudecode.nvim',
    cmd = { 'ClaudeCode', 'ClaudeCodeFocus', 'ClaudeCodeSend' },
    keys = {
      { 'sc', '<Cmd>ClaudeCode<CR>', desc = 'Claudeをトグル(claude)' },
      { 'sc', '<Cmd>ClaudeCodeSend<CR>', mode = 'x', desc = '選択範囲をClaudeへ送る' },
    },
    opts = {},
  },

  -- カーソル下のシンボルの出現箇所を自動ハイライト(IntelliJが標準でやること)
  { 'RRethy/vim-illuminate', event = 'LspAttach' },

  -- 関数・クラス・引数を「かたまり」として選択・移動する
  -- ※nvim-treesitterのmainブランチを使っているので、こちらもmainブランチ(混在不可)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- VeryLazyも入れる: ファイルを開く前(No Nameバッファ)でも]fを自前のキーマップで
    -- 受け止めて、vim標準の]f(E446: No file name under cursor)を出さないため
    event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },  -- カーソルが手前にあっても次のかたまりを掴む
        move = { set_jumps = true },    -- 移動をジャンプリストに積む(Ctrl+oで戻れる)
      })

      -- treesitterのパーサやtextobjectsのクエリが無いバッファ(No Name・プレーンテキスト・
      -- nvim-tree等)で実行すると、プラグイン内部でエラーになるため事前に弾く
      local function has_textobjects()
        local ok, parser = pcall(vim.treesitter.get_parser, 0, nil, { error = false })
        if not ok or not parser then return false end
        local q = pcall(vim.treesitter.query.get, parser:lang(), 'textobjects')
        return q and vim.treesitter.query.get(parser:lang(), 'textobjects') ~= nil
      end

      -- 選択・操作の対象にする(例: vaf=関数全体を選択 / dif=関数の中身だけ削除)
      local select = require('nvim-treesitter-textobjects.select')
      local objects = {
        ['af'] = '@function.outer', ['if'] = '@function.inner',   -- function
        ['ac'] = '@class.outer',    ['ic'] = '@class.inner',      -- class/struct
        ['aa'] = '@parameter.outer',['ia'] = '@parameter.inner',  -- argument
        ['a/'] = '@comment.outer',  ['i/'] = '@comment.inner',    -- comment
      }
      for key, obj in pairs(objects) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          if not has_textobjects() then return end
          pcall(select.select_textobject, obj, 'textobjects')
        end, { desc = 'textobject ' .. obj })
      end

      -- 関数・クラス単位で移動する(]cはgitsignsのhunk移動で使うため避ける)
      local move = require('nvim-treesitter-textobjects.move')
      local moves = {
        [']f'] = { 'goto_next_start', '@function.outer', '次の関数へ' },
        ['[f'] = { 'goto_previous_start', '@function.outer', '前の関数へ' },
        [']F'] = { 'goto_next_end', '@function.outer', '次の関数の終わりへ' },
        [']k'] = { 'goto_next_start', '@class.outer', '次のクラス/型へ' },
        ['[k'] = { 'goto_previous_start', '@class.outer', '前のクラス/型へ' },
      }
      for key, m in pairs(moves) do
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          if not has_textobjects() then return end
          pcall(move[m[1]], m[2], 'textobjects')
        end, { desc = m[3] })
      end
    end,
  },

  -- 定義をフローティングウィンドウで覗く(IntelliJのCmd+Y。今いる場所を失わない)
  {
    'rmagatti/goto-preview',
    keys = {
      -- IntelliJのQuick Definition(Cmd+Y)から y
      { 'sy', function() require('goto-preview').goto_preview_definition() end, desc = '定義を覗く(Cmd+Y相当)' },
      { 'sY', function() require('goto-preview').close_all_win() end, desc = 'プレビューを全部閉じる' },
    },
    opts = { default_mappings = false },
  },

  -- キーを押すと続きの候補と説明がポップアップ(s系が25キーあるため)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 500,  -- 押してから0.5秒で表示(すぐ打つ時は邪魔しない)
      spec = {
        { 's', group = 'メイン操作' },
        { '<leader>g', group = 'git' },
        { '<leader>t', group = 'テスト' },
        { '<leader>f', group = 'ファイル・検索' },
        { '<leader>d', group = 'デバッグ・削除' },
      },
    },
    keys = {
      { 's?', function() require('which-key').show({ keys = 's', loop = true }) end, desc = 's系のキー一覧' },
    },
  },

  -- fugitiveのGitHub連携(:GBrowseでカーソル行のGitHubパーマリンクを開く/コピー)
  { 'tpope/vim-rhubarb', dependencies = { 'tpope/vim-fugitive' }, event = 'VeryLazy' },

  -- quickfixウィンドウの強化(候補のプレビュー表示・絞り込み)
  { 'kevinhwang91/nvim-bqf', ft = 'qf', opts = {} },

  -- DBクライアント(nvim内からSQLを実行。接続の追加・実行は:DBUIの画面から)
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    cmd = { 'DB', 'DBUI', 'DBUIToggle' },
    keys = {
      { '<leader>db', '<Cmd>DBUIToggle<CR>', desc = 'DBクライアント(database)' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    config = function()
      -- SQLバッファでテーブル名・カラム名を補完
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
        end,
      })
    end,
  },

  -- Markdownをエディタ内で整形表示(見出し・表・チェックボックス等を装飾。ブログ執筆用)
  -- 通常はモード連動(ノーマル=装飾/挿入=生テキスト)。表を編集する時など生表示に固定したい場合はsmで切り替える
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    opts = {},
    keys = {
      { 'sm', '<Cmd>RenderMarkdown buf_toggle<CR>', ft = 'markdown', desc = 'Markdown装飾のON/OFF(Markdown)' },
      { 'sM', '<Cmd>RenderMarkdown preview<CR>', ft = 'markdown', desc = 'Markdownを横に並べてプレビュー(Markdown)' },
    },
  },

  -- undo履歴のツリー表示(IntelliJのLocal History相当。保存を跨いで任意の時点に戻れる)
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { 'sU', '<Cmd>UndotreeToggle<CR>', desc = 'undo履歴ツリー(Undo)' },
    },
  },

  -- DAPアダプタの自動インストール(delve等はLSPではないのでmason-lspconfigでは入らない)
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = { ensure_installed = { 'delve', 'js-debug-adapter' } },
  },

  -- デバッガ(ブレークポイント・ステップ実行・変数ウォッチ)
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
      'leoluz/nvim-dap-go',
    },
    keys = {
      { 'sB', function() require('dap').toggle_breakpoint() end, desc = 'ブレークポイント(Breakpoint)' },
      { '<F9>', function() require('dap').continue() end, desc = 'デバッグ開始/再開(IntelliJのResume)' },
      { '<F8>', function() require('dap').step_over() end, desc = 'ステップオーバー(IntelliJと同じ)' },
      { '<F7>', function() require('dap').step_into() end, desc = 'ステップイン(IntelliJと同じ)' },
      { '<S-F8>', function() require('dap').step_out() end, desc = 'ステップアウト(IntelliJと同じ)' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'デバッグUIの開閉' },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      -- デバッグの開始/終了でUIを自動開閉
      dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui'] = function() dapui.close() end

      -- Go(delve)
      require('dap-go').setup()

      -- Elixir(Masonのelixir-ls-debuggerを使う)
      dap.adapters.mix_task = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/bin/elixir-ls-debugger',
      }
      dap.configurations.elixir = {
        {
          type = 'mix_task',
          name = 'mix test(現在のファイル)',
          request = 'launch',
          task = 'test',
          taskArgs = { '--trace' },
          startApps = true,
          projectDir = '${workspaceFolder}',
          requireFiles = { 'test/**/test_helper.exs', '${file}' },
        },
      }

      -- Node/TypeScript(js-debug-adapter)
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }
      for _, lang in ipairs({ 'javascript', 'typescript' }) do
        dap.configurations[lang] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = '現在のファイルを実行',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = '実行中のプロセスにアタッチ',
            processId = function() return require('dap.utils').pick_process() end,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end,
  },

  -- テスト実行(カーソル下のテストを1キー実行、結果を行の横に✓✗表示。IntelliJのgutter実行相当)
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'jfpedroza/neotest-elixir',
      'fredrikaverpil/neotest-golang',
      'nvim-neotest/neotest-jest',
    },
    keys = {
      { 'sx', function() require('neotest').run.run() end, desc = 'カーソル下のテストを実行(execute)' },
      { 'sX', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'ファイル全体のテストを実行' },
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'カーソル下のテストをデバッグ実行' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'テスト出力を開く' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'テスト一覧パネル' },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-elixir'),
          require('neotest-golang'),
          require('neotest-jest')({}),
        },
      })
    end,
  },

  -- TODO/FIXME/HACKコメントのハイライトと横断一覧
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { 'sT', '<Cmd>TodoTelescope<CR>', desc = 'TODO一覧(TODO)' },
    },
    opts = {},
  },

  -- セッション自動保存(ディレクトリごとに前回のウィンドウ・タブ・ファイルを復元)
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    config = function(_, opts)
      require('persistence').setup(opts)
      -- セッション保存前にファイルツリーを閉じる(ツリーのバッファは復元に向かないため)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistenceSavePre',
        callback = function() pcall(vim.cmd, 'NvimTreeClose') end,
      })
      -- 引数なしで起動したときは前回のセッションを自動復元
      vim.api.nvim_create_autocmd('VimEnter', {
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 then pcall(require('persistence').load) end
        end,
      })
    end,
  },

  -- ファイルツリー(NERDTreeの置き換え)
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    keys = {
      { 's1', '<Cmd>NvimTreeToggle<CR>', desc = 'ファイルツリー(IntelliJのCmd+1)' },
      { '<leader>e', '<Cmd>NvimTreeToggle<CR>', desc = 'ファイルツリー' },
    },
    config = function()
      local api = require('nvim-tree.api')
      require('nvim-tree').setup({
        -- 開いているファイルにツリーを自動で追従・ハイライトする
        update_focused_file = { enable = true },
        -- ※ツリーのバッファローカルマップはグローバルより優先され、しかも完全一致した時点で
        --   即発火する(sを押した瞬間に確定し、sfのような長いグローバルマップを待たない)。
        --   そのためグローバル側と衝突するキーだけ外して、通常バッファと同じ操作感にする。
        on_attach = function(bufnr)
          api.map.on_attach.default(bufnr)
          -- s=既定アプリで開く / <C-k>=情報ポップアップ。前者はsプレフィックス25個、後者はウィンドウ移動を潰す
          for _, lhs in ipairs({ 's', '<C-k>' }) do
            pcall(vim.keymap.del, 'n', lhs, { buffer = bufnr })
          end
        end,
      })
      -- 起動時にツリーを自動で開く(カーソルは開いたファイル側に残す)
      -- ※`nvim .`のようにディレクトリを渡すと、VimEnterの時点でnvim-treeが既にツリーを
      --   開いており、data.fileもディレクトリではなくツリーのバッファ名になっている。
      --   ここでtoggleすると開いているツリーを閉じてしまうため、判定は起動引数で行い、
      --   「開く方向にしか作用しない」APIだけを使う。
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local api = require('nvim-tree.api')
          local arg = vim.fn.argc() > 0 and vim.fn.argv(0) or ''
          if type(arg) == 'string' and vim.fn.isdirectory(arg) == 1 then
            vim.cmd.cd(arg)
            api.tree.open()
          else
            api.tree.find_file({ open = true, focus = false })
          end
        end,
      })
    end,
  },

  -- 括弧・クオートの自動補完(旧inoremapの置き換え。賢く対応括弧を閉じる)
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- gitの変更行を左端に表示 + hunk操作(レビュー用)
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local o = { buffer = bufnr }
        -- 変更箇所(hunk)間をジャンプ
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
        end, o)
        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
        end, o)
        -- 変更前とのdiffをその場でポップアップ
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, o)
        -- カーソル行のblame(誰がいつなぜ変えたか)
        vim.keymap.set('n', '<leader>gb', function() gs.blame_line({ full = true }) end, o)
      end,
    },
  },

  -- ステータスライン(旧statuslineの置き換え)
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      sections = {
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
      },
    },
  },
})

-- ================================================================
-- 背景を暗い扱いに固定する(ターミナルがライトモードでも配色を維持)
-- ================================================================
-- Neovimは起動時にOSC 11でターミナルの背景色を問い合わせ、明るければ'background'をlightに
-- 書き換える。その副作用でカラースキームが解除され(colors_nameがnilに戻る)、組み込みの
-- ライト配色に落ちる。macOSをライトモードにするとiTermが白背景になるため、これが起きる。
--
-- 'background'を設定ファイルから明示設定すると、この自動判定のautocmdは削除される。
-- ただし判定は「最後に設定した主体がLuaチャンク(SID -8)でないこと」で行われるため、
-- 冒頭で設定するだけでは足りない。カラースキーム適用時にnightfoxのコンパイル済みキャッシュが
-- vim.o.backgroundを設定し直し、記録がSID -8で上書きされてしまうからである。
-- そのためlazy.setupの後に、この設定ファイルから設定し直す。
opt.background = 'dark'

-- 上記をすり抜けて'background'が変えられた場合の保険(配色を暗いものへ戻す)
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    if vim.o.background == 'dark' then return end
    vim.o.background = 'dark'
    pcall(vim.cmd.colorscheme, 'carbonfox')
  end,
})

-- ================================================================
-- LSPキーマップ(LSPがアタッチされたバッファでのみ有効)
-- ================================================================
-- LSP操作はnvim標準キー(0.11+)をそのまま使う:
--   grr(参照) / grn(リネーム) / gra(コードアクション) / gri(実装) / gO(シンボル一覧)
--   K(ホバー) / Ctrl+](定義へ。戻りはCtrl+oかCtrl+t) / [d ]d(診断間移動)
-- 自分定義は標準に無い(または死にキーの)ものだけに絞る
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- 標準のgd(ローカル宣言ジャンプ)はほぼ使わないのでLSP定義ジャンプに上書き
    map('n', 'gd', vim.lsp.buf.definition, opts)
    -- フォーマット(標準はgq+モーションだが全体フォーマットが面倒なので用意)
    map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
    -- inlay hints(引数名・型のインライン表示。対応サーバ: gopls/ts_ls/rust_analyzer等)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
    -- 表示が邪魔なときのトグル
    map('n', '<leader>ih', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end, opts)
  end,
})

-- 診断表示
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end) -- 前の診断へ
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)  -- 次の診断へ
