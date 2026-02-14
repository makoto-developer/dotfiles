# 関数名・変数名の色付け（セマンティックハイライト）ガイド

## 🎨 現在の状態

### ✅ 動作しているハイライト
- **キーワード**: `defmodule`, `def`, `defp`, `do`, `end` など（青色）
- **文字列**: `"hello"` など（緑色）
- **アトム**: `:atom`, `:prod`, `:test` など
- **コメント**: `#` で始まる行（灰色）

### 🔄 追加で色付けできるもの
- **関数名**: `project`, `application`, `deps` など
- **変数名**: `conn`, `params`, `user` など
- **モジュール名**: `Blog.MixProject`, `Mix.Project` など
- **関数呼び出し**: `IO.puts()`, `Enum.map()` など

## 🚀 セマンティックハイライトの有効化

### 方法1: Treesitter（推奨）

Treesitterを使用すると、構文解析ベースの高度なハイライトが可能になります。

#### インストール手順

1. nvimを再起動:
   ```bash
   pkill nvim
   nvim
   ```

2. nvim内でTreesitterのパーサーをインストール:
   ```vim
   :TSInstall elixir
   :TSInstall heex
   :TSInstall eex
   ```

3. インストール確認:
   ```vim
   :TSInstallInfo
   ```

4. Treesitterが動作しているか確認:
   ```vim
   :echo nvim_treesitter#statusline()
   ```

5. ファイルを再読み込み:
   ```vim
   :e
   ```

これで、関数名や変数名にも色が付くようになります。

### 方法2: CoCのセマンティックトークン（LSPベース）

ElixirLS（Language Server）経由でセマンティックハイライトを有効にします。

#### 確認手順

1. nvim内でCoCの状態を確認:
   ```vim
   :CocInfo
   ```

2. ElixirLSが起動しているか確認:
   ```vim
   :CocCommand workspace.showOutput elixirLS
   ```

3. セマンティックトークンが有効か確認:
   ```vim
   :CocCommand semanticTokens.inspect
   ```

#### トラブルシューティング

ElixirLSが起動しない場合:

```vim
" LSPを再起動
:CocRestart

" ElixirLSを手動起動
:CocCommand elixir.restart
```

## 🎨 期待されるハイライト例

### Treesitter有効化後:

```elixir
defmodule Blog.MixProject do          # defmodule: キーワード色
                                      # Blog.MixProject: モジュール名色

  def project do                      # def: キーワード色
                                      # project: 関数名色
    [
      app: :blog,                     # app: キー色、:blog: アトム色
      version: "0.1.0",               # version: キー色、"0.1.0": 文字列色
      deps: deps()                    # deps: 関数呼び出し色
    ]
  end

  defp deps do                        # defp: キーワード色
                                      # deps: プライベート関数名色
    [
      {:phoenix, "~> 1.8.1"}          # :phoenix: アトム色、文字列色
    ]
  end
end
```

### カラーマッピング

| 要素 | Treesitterなし | Treesitterあり |
|------|---------------|---------------|
| `defmodule` | 青（キーワード） | 青（キーワード） |
| `Blog.MixProject` | 白（デフォルト） | 黄色（モジュール） |
| `def` | 青（キーワード） | 青（キーワード） |
| `project` | 白（デフォルト） | シアン（関数） |
| `:blog` | 色付き（アトム） | 色付き（アトム） |
| `"0.1.0"` | 緑（文字列） | 緑（文字列） |
| `deps()` | 白（デフォルト） | シアン（関数呼び出し） |

## 🔧 カラースキームによる違い

### Gruvbox（推奨）
- 関数名: シアン/青緑
- 変数名: オレンジ
- モジュール名: 黄色
- キーワード: 赤

### Desert
- 関数名: 白/明るい灰色
- 変数名: 白
- モジュール名: 明るい緑
- キーワード: 黄色

### Kanagawa（要termguicolors）
- 関数名: 紫/ラベンダー
- 変数名: 白
- モジュール名: オレンジ
- キーワード: ピンク

## 📋 診断コマンド

### Treesitterの確認

```vim
" インストール済みパーサーの確認
:TSInstallInfo

" 現在のバッファでTreesitterが有効か
:TSBufToggle highlight

" Treesitterのハイライトグループを表示
:TSHighlightCapturesUnderCursor
```

### CoCセマンティックトークンの確認

```vim
" セマンティックトークンの状態
:CocCommand semanticTokens.inspect

" CoCの全体状態
:CocInfo
```

## 🎯 推奨設定

### ベストな組み合わせ

1. **Treesitter** → 構文解析ベースの高速ハイライト
2. **ElixirLS（CoC）** → セマンティック情報（補完・定義ジャンプなど）
3. **Gruvboxカラースキーム** → 見やすいコントラスト

### 設定例

```vim
" init.vimまたはnvim内で実行
set termguicolors
colorscheme gruvbox
TSEnable highlight
```

## 🚨 よくある問題

### Q1: Treesitterをインストールしたが色が変わらない

**A**: `:TSUpdate`を実行してパーサーを更新:

```vim
:TSUpdate elixir
:e  " ファイルを再読み込み
```

### Q2: 関数名が一部しか色付かない

**A**: Treesitterのハイライトが部分的に動作しています。以下を確認:

```vim
" Treesitterのハイライトが有効か
:TSBufEnable highlight

" エラーがないか確認
:messages
```

### Q3: LSPとTreesitterの両方が必要？

**A**:
- **Treesitter**: シンタックスハイライト専用（高速）
- **LSP（ElixirLS）**: 補完、定義ジャンプ、エラー診断など

両方を併用するのが推奨です。

## 📚 参考

### Treesitterハイライトグループ

- `@function.call` → 関数呼び出し
- `@function.method` → メソッド呼び出し
- `@variable` → 変数
- `@parameter` → 関数パラメータ
- `@module` → モジュール名
- `@constant` → 定数
- `@keyword.function` → 関数定義キーワード（def/defp）

### カスタマイズ

より細かくカラーをカスタマイズする場合、init.vimに追加:

```vim
" 関数呼び出しを明るい青に
highlight @function.call guifg=#61AFEF

" 変数をオレンジに
highlight @variable guifg=#D19A66

" モジュール名を黄色に
highlight @module guifg=#E5C07B
```

---

**問題が解決しない場合**は、以下の情報を確認:

```vim
:checkhealth nvim-treesitter
:TSInstallInfo
:CocInfo
```
