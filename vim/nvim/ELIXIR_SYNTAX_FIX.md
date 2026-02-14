# Elixir/Phoenixシンタックスハイライト修正ガイド

## 🎯 実施した修正

### 1. init.vimの更新
- `filetype plugin indent on`を追加
- `syntax enable`を追加
- Elixir/Phoenixファイルタイプの明示的な認識を追加
- カラースキーム変更時もシンタックスを維持

### 2. dein.tomlの更新
- `vim-elixir`の遅延ロード（`on_ft`）を削除 → 常時読み込みに変更
- `vim-mix-format`の遅延ロードを削除
- `elixir-ctags`を追加（定義ジャンプ改善）
- KanagawaカラースキームでElixirシンタックスを保持する設定を追加

### 3. 対応ファイルタイプ
- `.ex` → `filetype=elixir`
- `.exs` → `filetype=elixir`
- `.eex` → `filetype=eelixir`（Embedded Elixir）
- `.heex` → `filetype=eelixir`（Phoenix LiveView）
- `.leex` → `filetype=eelixir`（Legacy LiveView）
- `mix.lock` → `filetype=elixir`

## 🚀 確認方法

### 1. nvimを再起動
まず、nvimを完全に終了してから再起動してください：

```bash
# すべてのnvimプロセスを終了
pkill nvim

# テストファイルを開く
nvim /tmp/test_syntax.ex
```

### 2. nvim内で確認

#### ファイルタイプの確認
```vim
:set filetype?
```
→ `filetype=elixir` と表示されればOK

#### シンタックスの確認
```vim
:syntax list
```
→ 以下のようなElixir関連のシンタックスグループが表示されればOK：
- `elixirModuleDefine`
- `elixirDefine`
- `elixirKeyword`
- `elixirAtom`
- `elixirString`
など

#### ハイライトの確認
```vim
:highlight
```
→ Elixir関連のハイライトグループが定義されているか確認

### 3. 手動でシンタックスを再読み込み

もしシンタックスが表示されない場合、以下を試してください：

```vim
" シンタックスを再読み込み
:syntax on

" または
:set syntax=elixir

" または
:source ~/.config/nvim/init.vim
```

## 🔧 トラブルシューティング

### ケース1: filetypeは認識されているが、シンタックスが表示されない

**原因**: カラースキームがシンタックスを上書きしている

**解決策**:
```vim
" nvim内で実行
:colorscheme default
:syntax on
```

その後、もう一度Elixirファイルを開く。

### ケース2: filetypeが`conf`や`text`になる

**原因**: ファイルタイプ検出が正しく動作していない

**解決策**:
```vim
" 手動でfiletypeを設定
:set filetype=elixir
```

または、init.vimに以下を追加（既に追加済み）：
```vim
autocmd BufRead,BufNewFile *.ex set filetype=elixir
```

### ケース3: シンタックスが一部だけ表示される

**原因**: vim-elixirプラグインが完全に読み込まれていない

**解決策**:
```vim
" nvim内でプラグインを更新
:call dein#update()

" nvimを再起動
```

### ケース4: Phoenixテンプレート（.heex）のシンタックスが表示されない

**原因**: eelixirファイルタイプが認識されていない

**解決策**:
```vim
" .heexファイル内で実行
:set filetype=eelixir
:set syntax=eelixir
```

## 📋 診断コマンド

問題が解決しない場合、以下のコマンドで診断：

```bash
# 診断スクリプトを実行
~/.config/nvim/check-elixir-syntax.sh
```

または、nvim内で：

```vim
" runtimepathを確認（vim-elixirのパスが含まれているか）
:echo &runtimepath

" シンタックスファイルの存在確認
:echo globpath(&runtimepath, 'syntax/elixir.vim')

" ファイルタイプ検出スクリプトの存在確認
:echo globpath(&runtimepath, 'ftdetect/elixir.vim')

" CoCのElixir LSP確認
:CocInfo
```

## ✅ 期待される結果

正しく設定されている場合、以下のようにハイライトされます：

```elixir
defmodule MyApp.UserController do  # ← defmodule, do がキーワード色
  use MyApp.Web, :controller       # ← use がキーワード色、:controller がアトム色

  alias MyApp.User                 # ← alias がキーワード色
  alias MyApp.Repo

  def index(conn, _params) do      # ← def, do がキーワード色
    users = Repo.all(User)         # ← 関数呼び出しが関数色
    render(conn, "index.html", users: users)  # ← 文字列が文字列色
  end

  defp authenticate_user(conn, _opts) do  # ← defp がプライベート関数キーワード色
    if get_session(conn, :user_id) do     # ← if, do がキーワード色
      conn
    else                           # ← else がキーワード色
      conn
      |> put_flash(:error, "Error")  # ← |> がパイプ演算子色
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
```

## 🎨 カラーテーマを変更する場合

もし現在のKanagawaテーマでシンタックスが見づらい場合：

```vim
" 他のテーマを試す
:colorscheme desert
:colorscheme gruvbox
:colorscheme onedark

" シンタックスを再読み込み
:syntax on
```

## 📝 参考情報

### インストール済みプラグイン
- **vim-elixir**: Elixir基本シンタックス
- **vim-mix-format**: 保存時の自動フォーマット
- **elixir-ctags**: 定義ジャンプ改善

### CoCエクステンション
ElixirLS（Language Server）が設定されており、以下の機能が使えます：
- 自動補完
- 定義ジャンプ (`gd`)
- 参照検索 (`gr`)
- ドキュメント表示 (`K`)
- リネーム (`<leader>rn`)

### LSPの確認
```vim
:CocInfo
```
で、ElixirLSが正しく動作しているか確認できます。

---

**それでも解決しない場合**は、以下の情報を確認してください：

```vim
:version
:echo has('syntax')
:echo exists('g:syntax_on')
:echo &filetype
:scriptnames | grep elixir
```

これらの出力を共有していただければ、さらに詳しく診断できます。
