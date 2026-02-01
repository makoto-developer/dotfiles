# NeoVim/VimでIntelliJ風のマルチカーソル機能を実現する（Ctrl+G）

## 概要

IntelliJやVSCodeのように、**Ctrl+G**（または**Ctrl+D**）で同じ単語を複数選択し、一括編集できる機能をNeoVim/Vimに追加する方法を解説します。

使用するプラグイン: **[vim-visual-multi](https://github.com/mg979/vim-visual-multi)**

## デモ

```elixir
# 変更前
user_name = "Alice"
puts user_name
Logger.info(user_name)

# user_name にカーソルを置いて Ctrl+G を3回押す
# → 3箇所すべて選択 → account_name と入力

# 変更後
account_name = "Alice"
puts account_name
Logger.info(account_name)
```

---

## インストール

### 1. dein.vim の場合

`dein.toml` に追加：

```toml
[[plugins]]
repo = 'mg979/vim-visual-multi'
```

### 2. vim-plug の場合

`init.vim` に追加：

```vim
call plug#begin()
Plug 'mg979/vim-visual-multi'
call plug#end()
```

### 3. lazy.nvim の場合

`lua/plugins/vim-visual-multi.lua` を作成：

```lua
return {
  'mg979/vim-visual-multi',
  event = 'VeryLazy',
  init = function()
    vim.g.VM_maps = {
      ['Find Under'] = '<C-g>',
      ['Find Subword Under'] = '<C-g>',
    }
  end,
}
```

---

## キーマッピング設定

### Ctrl+G にマッピング（IntelliJ風）

プラグイン読み込み**前**に設定する必要があります。

`init.vim` の**先頭付近**に追加：

```vim
""""""""""""""""""""""""""""""""""""""""""""""
" vim-visual-multi settings
""""""""""""""""""""""""""""""""""""""""""""""
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-g>'     " 次の同じ単語を選択
let g:VM_maps['Find Subword Under'] = '<C-g>'     " 部分一致選択
let g:VM_maps['Select All']         = '<C-S-g>'   " すべて選択
let g:VM_maps['Skip Region']        = '<C-x>'     " 現在の選択をスキップ
let g:VM_maps['Remove Region']      = '<C-p>'     " 選択を解除
let g:VM_maps['Visual Cursors']     = '<C-g>'     " ビジュアルモードでも使用

" テーマとスタイル（オプション）
let g:VM_theme = 'iceblue'
let g:VM_highlight_matches = 'underline'
```

### Ctrl+D にマッピング（VSCode風）

VSCodeと同じキーにしたい場合：

```vim
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:VM_maps['Select All']         = '<C-S-d>'
let g:VM_maps['Skip Region']        = '<C-x>'
```

---

## 使い方

### 基本操作

| キー | 動作 |
|------|------|
| **Ctrl+G** | 次の同じ単語を追加選択 |
| **Ctrl+Shift+G** | すべての同じ単語を一括選択 |
| **Ctrl+X** | 現在の選択をスキップして次へ |
| **Ctrl+P** | 最後の選択を解除 |
| **Esc** | マルチカーソルモード終了 |

### 実践例

#### 1. 変数名の一括変更

```typescript
// userId にカーソルを置く
const userId = 1
const userName = getUserName(userId)
logActivity(userId)

// Ctrl+G を3回押す → 3箇所選択
// accountId と入力 → 一括変更

const accountId = 1
const userName = getUserName(accountId)
logActivity(accountId)
```

#### 2. すべて一括選択

```python
# user にカーソルを置く
user = get_user()
print(user)
validate(user)
save(user)

# Ctrl+Shift+G → すべて選択
# account と入力

account = get_user()
print(account)
validate(account)
save(account)
```

#### 3. 選択的に編集

```ruby
# count にカーソル
count = 0
count += 1
total_count = count  # ← これは変更したくない
puts count

# Ctrl+G → 1つ目選択
# Ctrl+G → 2つ目選択
# Ctrl+X → 3つ目（total_count）をスキップ
# Ctrl+G → 4つ目選択
# num と入力

num = 0
num += 1
total_count = count  # ← 変更されない
puts num
```

---

## トラブルシューティング

### Ctrl+Gが動作しない

#### 原因1: 設定のタイミング

`g:VM_maps`の設定は、プラグイン読み込み**前**に書く必要があります。

**❌ 間違い（dein.toml内）:**
```toml
[[plugins]]
repo = 'mg979/vim-visual-multi'
hook_add = '''
  let g:VM_maps = {}
  let g:VM_maps['Find Under'] = '<C-g>'
'''
```

**✅ 正しい（init.vim の先頭）:**
```vim
" プラグイン読み込み前に設定
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-g>'

" その後にプラグイン読み込み
call dein#begin('~/.cache/dein')
  call dein#add('mg979/vim-visual-multi')
call dein#end()
```

#### 原因2: プラグインが読み込まれていない

プラグインが正しくインストールされているか確認：

```vim
:echo g:VM_maps
" → 辞書が表示されればOK

:PluginInstall   " vim-plugの場合
:call dein#install()  " deinの場合
```

#### 原因3: キャッシュの問題

キャッシュをクリアして再起動：

```vim
" deinの場合
:call dein#clear_state()
:call dein#update()
```

---

## おすすめの追加設定

### カーソルスタイルのカスタマイズ

```vim
" 選択中の単語をハイライト
let g:VM_highlight_matches = 'underline'

" カラーテーマ
let g:VM_theme = 'iceblue'  " または 'ocean', 'sand', 'purplegray'

" 選択カウントを表示
let g:VM_show_warnings = 1
```

### その他の便利なキーマッピング

```vim
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-g>'
let g:VM_maps['Find Subword Under'] = '<C-g>'
let g:VM_maps['Select All']         = '<C-S-g>'
let g:VM_maps['Skip Region']        = '<C-x>'
let g:VM_maps['Remove Region']      = '<C-p>'
let g:VM_maps['Undo']               = 'u'
let g:VM_maps['Redo']               = '<C-r>'
let g:VM_maps['Add Cursor Down']    = '<C-Down>'  " 下に新しいカーソル
let g:VM_maps['Add Cursor Up']      = '<C-Up>'    " 上に新しいカーソル
```

---

## まとめ

- **vim-visual-multi**で IntelliJ/VSCode 風のマルチカーソル機能を実現
- **Ctrl+G**で次の同じ単語を選択
- **Ctrl+Shift+G**ですべて選択
- 設定は**プラグイン読み込み前**に`init.vim`の先頭で行う

これで快適なマルチカーソル編集が可能になります！

---

## 参考リンク

- [vim-visual-multi GitHub](https://github.com/mg979/vim-visual-multi)
- [vim-visual-multi ドキュメント](https://github.com/mg979/vim-visual-multi/blob/master/doc/vm-tutorial.txt)

---

## 補足: デフォルトのキーマッピング

カスタマイズせずにデフォルトを使う場合：

| キー | 動作 |
|------|------|
| **Ctrl+N** | 次の同じ単語を選択 |
| **Ctrl+Down/Up** | カーソルを追加 |
| **n/N** | 次/前の選択へ移動 |
| **q** | 現在の選択をスキップ |
| **Q** | 選択を解除 |

デフォルトでも十分使えますが、IntelliJ/VSCodeユーザーは**Ctrl+G**へのカスタマイズがおすすめです。
