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
opt.title = true
opt.showmatch = true
opt.matchtime = 1
opt.belloff = 'all'
opt.history = 1000

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

  -- カラースキーム
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      vim.o.background = 'dark'
      vim.cmd.colorscheme('gruvbox')
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
            'elixirls',        -- Elixir
            'ts_ls',           -- TypeScript/JavaScript
            'gopls',           -- Go
            'rust_analyzer',   -- Rust
            'lua_ls',          -- Lua
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
      -- 補完エンジンのcapabilitiesを全サーバに適用
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
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
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'ファイル検索' },
      { '<leader>fg', '<Cmd>Telescope live_grep<CR>',  desc = 'テキスト検索(rg)' },
      { '<leader>fb', '<Cmd>Telescope buffers<CR>',    desc = 'バッファ一覧' },
      { '<leader>fh', '<Cmd>Telescope oldfiles<CR>',   desc = '最近開いたファイル' },
    },
  },

  -- ファイルツリー(NERDTreeの置き換え)
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '<leader>e', '<Cmd>NvimTreeToggle<CR>', desc = 'ファイルツリー' },
    },
    opts = {},
  },

  -- 括弧・クオートの自動補完(旧inoremapの置き換え。賢く対応括弧を閉じる)
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- gitの変更行を左端に表示
  { 'lewis6991/gitsigns.nvim', opts = {} },

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
-- LSPキーマップ(LSPがアタッチされたバッファでのみ有効)
-- ================================================================
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gd', vim.lsp.buf.definition, opts)          -- 定義へジャンプ
    map('n', 'gr', vim.lsp.buf.references, opts)          -- 参照一覧
    map('n', 'K', vim.lsp.buf.hover, opts)                -- ドキュメント表示
    map('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- リネーム
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- コードアクション
    map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts) -- フォーマット
  end,
})

-- 診断表示
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end) -- 前の診断へ
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)  -- 次の診断へ
