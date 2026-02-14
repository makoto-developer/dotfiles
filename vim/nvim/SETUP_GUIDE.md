# nvim 開発環境セットアップガイド

このガイドでは、Go、React/Next.js、Elixir、Phoenix、Rust、Terraform、Helmの開発環境をnvimで構築する方法を説明します。

## 📋 前提条件

以下のツールがインストールされていること：

- **nvim** (Neovim 0.9.0以上)
- **mise** (バージョン管理ツール)
- **Node.js** 24.x以上
- **Go** 1.25以上
- **Rust** 1.90以上
- **Elixir** 1.18以上 (with Erlang/OTP 28)
- **Terraform** 1.14以上

## 🚀 クイックスタート

### 1. 自動セットアップ（推奨）

```bash
cd ~/.config/nvim
./setup-dev-tools.sh
```

このスクリプトは以下を実行します：
- Go開発ツール（gopls, goimports, golangci-lint）のインストール
- Rust開発ツール（rust-analyzer, rustfmt, clippy）のインストール
- Node.js開発ツール（TypeScript LSP, ESLint, Prettier）のインストール
- Terraform LSPのインストール
- Elixir LSPのインストール
- nvimプラグインとCoCエクステンションのインストール

### 2. nvim初回起動

```bash
nvim
```

初回起動時、deinが自動的にプラグインをインストールします。
完了後、nvimを再起動してください。

### 3. CoCの確認

nvim内で以下を実行：

```vim
:CocInfo
```

エラーがなければセットアップ完了です。

## 🔧 言語別設定詳細

### Go開発

#### LSP機能

- **自動補完**: `<Tab>`, `<S-Tab>`で候補選択
- **定義ジャンプ**: `gd` - Go to Definition
- **参照検索**: `gr` - Find References
- **リネーム**: `<leader>rn` - Rename
- **フォーマット**: `<leader>f` - Format (保存時自動実行)

#### インストールされるツール

```bash
gopls                  # Language Server
goimports              # Import管理
golangci-lint          # Linter
```

#### よく使うコマンド

```vim
" エラー診断の移動
[g  " 前のエラー
]g  " 次のエラー

" コードアクション
<leader>ca  " Code Action
```

### React/Next.js開発

#### LSP機能

- **TypeScript補完**: 完全な型サポート
- **自動import**: 未importの型を自動追加
- **JSX/TSXシンタックス**: カラフルな構文ハイライト
- **Styled Components**: CSS-in-JS サポート

#### インストールされるツール

```bash
typescript-language-server  # TypeScript LSP
eslint                      # JavaScript/TypeScript Linter
prettier                    # Code Formatter
```

#### Next.js固有の設定

```vim
" tsconfig.json または jsconfig.json が必要
" プロジェクトルートでLSPが起動
```

### Rust開発

#### LSP機能

- **rust-analyzer**: 高度な補完・診断
- **Inlay Hints**: 型情報の表示
- **Clippy統合**: 保存時にLint実行

#### インストールされるツール

```bash
rust-analyzer    # Language Server
rustfmt          # Code Formatter
clippy           # Linter
```

#### よく使うコマンド

```vim
" 型定義ジャンプ
gy  " Go to type definition

" 実装ジャンプ
gi  " Go to implementation
```

### Elixir/Phoenix開発

#### LSP機能

- **ElixirLS**: Elixir Language Server
- **mix format**: 保存時自動フォーマット（`.formatter.exs`に従う）
- **.heex/.leex**: Phoenix LiveViewテンプレート対応

#### インストールされるツール

```bash
elixir-ls    # Language Server (Homebrew経由)
hex          # Package Manager
rebar        # Build Tool
```

#### Phoenix固有の設定

```vim
" 保存時にmix formatを実行
let g:mix_format_on_save = 1
```

### Terraform開発

#### LSP機能

- **terraform-ls**: Terraform Language Server
- **保存時フォーマット**: 自動的に`terraform fmt`実行
- **構文検証**: リアルタイム診断

#### インストールされるツール

```bash
terraform-ls    # Language Server
tflint          # Linter
```

#### よく使うコマンド

```vim
" .tf ファイルは自動認識
" フォーマットは保存時に自動実行
```

### Helm開発

#### LSP機能

- **YAML LSP**: Kubernetes スキーマ対応
- **Helmテンプレート**: `templates/*.yaml`を自動認識
- **構文検証**: YAML文法チェック

#### インストールされるツール

```bash
yaml-language-server    # YAML Language Server
```

## ⌨️ キーバインド一覧

### 基本操作

| キー | 説明 |
|------|------|
| `<Tab>` | 補完候補を次へ |
| `<S-Tab>` | 補完候補を前へ |
| `<CR>` | 補完確定 |
| `K` | ドキュメント表示 |

### ナビゲーション

| キー | 説明 |
|------|------|
| `gd` | 定義ジャンプ |
| `gy` | 型定義ジャンプ |
| `gi` | 実装ジャンプ |
| `gr` | 参照検索 |
| `[g` | 前のエラー |
| `]g` | 次のエラー |

### コード編集

| キー | 説明 |
|------|------|
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>f` | フォーマット |
| `gcc` | 行コメントトグル |
| `gc{motion}` | モーション範囲コメントトグル |

### ファイル操作

| キー | 説明 |
|------|------|
| `sn` | NERDTree表示 |
| `sf` | ファイル検索（FZF） |
| `sw` | ウィンドウ切り替え |

### マルチカーソル

| キー | 説明 |
|------|------|
| `<C-g>` | カーソル下の単語を選択 |
| `<C-S-g>` | すべて選択 |
| `<C-x>` | 領域をスキップ |
| `<C-p>` | 領域を削除 |

### Git操作

| キー | 説明 |
|------|------|
| `<leader>gs` | Git status |
| `<leader>gb` | Git blame |
| `<leader>gd` | Git diff |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git log |

### ターミナル

| キー | 説明 |
|------|------|
| `<leader>t` | フローティングターミナル トグル |
| `<leader>tn` | 新しいターミナル |
| `<leader>tj` | 次のターミナル |
| `<leader>tk` | 前のターミナル |

## 🔍 トラブルシューティング

### CoCが動作しない

```vim
:CocInfo
```

でエラーを確認。Node.jsのパスが正しいか確認：

```vim
:echo coc#util#get_config_home()
```

### LSPが起動しない

各LSPサーバーがインストールされているか確認：

```bash
# Go
which gopls

# Rust
which rust-analyzer

# TypeScript
which typescript-language-server

# Terraform
which terraform-ls

# Elixir
ls /usr/local/Cellar/elixir-ls/
```

### プラグインが読み込まれない

```vim
:call dein#update()
```

でプラグインを更新。

### フォーマットが動作しない

`coc-settings.json`の`formatOnSaveFiletypes`に対象のfiletypeが含まれているか確認：

```vim
:set filetype?
```

## 📚 参考資料

### 公式ドキュメント

- [CoC.nvim](https://github.com/neoclide/coc.nvim)
- [gopls](https://pkg.go.dev/golang.org/x/tools/gopls)
- [rust-analyzer](https://rust-analyzer.github.io/)
- [ElixirLS](https://github.com/elixir-lsp/elixir-ls)
- [Terraform LSP](https://github.com/hashicorp/terraform-ls)

### LSP設定

すべてのLSP設定は`~/.config/nvim/coc-settings.json`で管理されています。

### プラグイン設定

プラグインの追加・削除は以下のファイルで行います：
- `~/.config/nvim/dein.toml` - 基本プラグイン
- `~/.config/nvim/dein_lazy.toml` - 遅延ロードプラグイン

## 🎯 推奨ワークフロー

### 新規プロジェクト開始時

1. プロジェクトルートで`nvim`を起動
2. LSPが自動的に起動（`go.mod`, `Cargo.toml`, `package.json`を検出）
3. `:CocInfo`でLSPの状態確認

### 開発中

- エラー診断は自動表示
- `[g`/`]g`でエラー間を移動
- `<leader>ca`でクイックフィックス実行

### コードレビュー前

- `:CocCommand`でフォーマット実行確認
- `<leader>f`で手動フォーマット

## 📝 メンテナンス

### 定期的な更新

```bash
# nvimプラグイン更新
nvim --headless "+call dein#update()" +qall

# CoCエクステンション更新
nvim --headless "+CocUpdate" +qall

# LSPツール更新
./setup-dev-tools.sh
```

---

**問題が発生した場合**は、`coc-settings.json`と`dein.toml`の設定を確認してください。
