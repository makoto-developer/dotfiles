# Neovim設定

`lazy.nvim` + 組み込みLSP + treesitterによる自己完結構成。

- プラグインマネージャ(lazy.nvim)は初回起動時に自動でインストールされる
- LSPサーバ(Elixir/TypeScript/Go/Rust/Lua等)はMasonが自動でインストールする
- **NodeもPythonも不要**(旧構成のdein/deoplete/CoCはすべて廃止)

## セットアップ

```shell
# ripgrepはtelescopeの全文検索、tree-sitter-cliはtreesitterパーサのビルドで使用
brew install neovim ripgrep tree-sitter-cli
cd ~/dotfiles/vim/nvim
./setup.sh                    # ~/.config/nvim へのsymlinkを張るだけ
nvim                          # 初回起動で全部自動インストールされる
```

動作確認

```
:checkhealth
:Lazy      " プラグインの状態
:Mason     " LSPサーバの状態
```

## 構成ファイル

- `init.lua` — 設定はこの1ファイルのみ
- `lazy-lock.json` — プラグインのバージョンロック(自動生成。コミットして環境間で揃える)

## 主なキーマップ

リーダーキーは`Space`。

| キー | 動作 |
|------|------|
| `Space ff` | ファイル検索 (telescope) |
| `Space fg` | テキスト全文検索 (ripgrep) |
| `Space fb` | バッファ一覧 |
| `Space e` | ファイルツリー (nvim-tree) |
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ドキュメント表示 |
| `Space rn` | リネーム |
| `Space ca` | コードアクション |
| `Space f` | フォーマット |
| `[d` / `]d` | 前/次の診断へ |
| `ss` / `sv` | 画面分割(横/縦) |
| `st` / `sn` / `sp` | タブ新規/次/前 |
| `Ctrl-hjkl` | ウィンドウ移動 |
| `Esc Esc` | 検索ハイライト消去 |

## トラブルシューティング

```shell
# プラグインを入れ直す
nvim --headless "+Lazy! sync" +qa

# 状態を全部リセットして再構築(設定ファイルは消えない)
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim
```
