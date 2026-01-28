# Neovim Configuration

このディレクトリにはNeovimの設定ファイルが含まれています。

## 📁 ファイル構成

```
nvim/
├── init.vim                          # メイン設定ファイル
├── dein.toml                         # 通常ロードプラグイン
├── dein_lazy.toml                    # 遅延ロードプラグイン
├── dein.toml.recommended             # 推奨プラグイン追加版（サンプル）
├── coc-settings.json                 # CoC設定
├── coc-settings.json.recommended     # CoC推奨設定（サンプル）
├── RECOMMENDATIONS.md                # プラグイン・設定の詳細な提案
├── config/
│   ├── main.vim                      # 基本設定
│   └── macro.vim                     # マクロ
└── plugins/
    └── ...                           # プラグイン別設定
```

## 🚀 クイックスタート

### 1. 基本セットアップ

```bash
# nvimディレクトリを ~/.config にコピー
cp -r nvim ~/.config/

# nvimを起動（プラグインが自動インストールされる）
nvim
```

### 2. 推奨プラグインの導入

詳細な提案は [RECOMMENDATIONS.md](./RECOMMENDATIONS.md) を参照してください。

最小限の推奨プラグインを導入する場合：

```bash
# 推奨版のdein.tomlを使用
cp dein.toml.recommended dein.toml

# nvimを起動してプラグインをインストール
nvim
:call dein#install()

# CoCエクステンションをインストール
:CocInstall coc-tsserver coc-json coc-python coc-go coc-prettier
```

### 3. CoC設定の拡張

```bash
# 推奨版のcoc-settings.jsonを使用
cp coc-settings.json.recommended coc-settings.json
```

## ⚙️ 主な機能

### クリップボード共有

- `set clipboard+=unnamedplus` により、`y`でヤンクした内容がシステムクリップボードにコピーされます
- VSCodeと同様のクリップボード動作を実現

### 基本設定

- **エンコーディング**: UTF-8
- **インデント**: 2スペース（Goは4スペース、タブ文字）
- **Undo**: ファイルを閉じても復元可能（`~/.vim/undo` に保存）
- **シェル**: fish
- **行番号**: 表示
- **検索**: インクリメンタルサーチ、大文字小文字を区別しない

### ショートカット（init.vim）

| キー | 動作 |
|------|------|
| `sn` | NERDTreeを開く |
| `sf` | ファイル検索（fzf） |
| `sw` | ウィンドウ一覧 |
| `Ctrl+n` | 複数キーワード選択（IntelliJ風） |
| `Ctrl+h/j/k/l` | ウィンドウ移動 |
| `Esc Esc` | 検索ハイライトクリア |

## 📚 プラグイン一覧

### 現在導入済み

| プラグイン | 用途 |
|-----------|------|
| dein.vim | プラグインマネージャー |
| vim-surround | テキスト囲み |
| denite.nvim | ファイル検索・バッファ管理 |
| vim-anzu | 検索結果表示 |
| nerdtree | ファイルツリー |
| ale | Linter |
| vim-autoclose | 括弧自動補完 |
| fzf, fzf.vim | あいまい検索 |
| vim-multiple-cursors | マルチカーソル |
| deoplete.nvim | 自動補完エンジン |

### 推奨プラグイン（RECOMMENDATIONS.md参照）

優先度の高いものから：

1. **CoC (coc.nvim)** - LSP統合で開発効率が劇的に向上
2. **vim-fugitive** - Git操作がvim内で完結
3. **vim-commentary** - コメントアウトが超快適
4. **gruvbox** - 見やすいカラースキーム
5. **vim-airline** - ステータスラインが見やすい

詳細は [RECOMMENDATIONS.md](./RECOMMENDATIONS.md) を参照してください。

## 🎨 カラースキーム

現在はコメントされていますが、以下のカラースキームが利用可能です：

```vim
" init.vim で有効化
colorscheme molokai
" または推奨のgruvbox
colorscheme gruvbox
```

## 📖 ショートカットリファレンス

### NERDTree

#### ファイル操作

file 

|key|value|
|:---:|:---|
|m|show nerdtree menu|
|I|Toggle hidden files|
|R|Refresh|
|?|show help|
|o|open file|
|t|open file tab|
|T|open file background tab|
|i|open file split display(holizon)|
|gi|open file preview(holizon)|
|s|open file split display(vertical)|
|gs|open file preview(vertical)|

directory

|key|value|
|:---:|:---|
|O|open directory recursive|
|x|close directory|
|X|close directory recursive|
|P|move cursor to root direwctory|
|p|move cursor to parent directry|
|K|move cursor to root same directory|
|J|move cursor to last same directory|
|ctrl +j/k|move cursor to next/previous item|
|C|change root on this cursor|
|u|move up directory, change root|
|F/FF|switch show files, show only directory|
|q|quit nerdtree|
|||

Bookmark

|key|value|
|:---:|:---|
|o|開く|
|t|別タブで開く|
|T|別タブにてバックグラウンドで開く|
|D|ブックマークから削除|
|:Bookmark <name>|ブックマークに登録|
|:OpenBookmark <name>|ブックマークを指定して開く|
|:ClearBookmark <name>|ブックマークを削除|
|:ClearAllBookmark|全部のブックマークを削除|