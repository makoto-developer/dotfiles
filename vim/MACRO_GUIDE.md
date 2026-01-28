# Vimマクロ・キーバインド完全ガイド

`vim/config/macro.vim`に設定されている便利なマクロとキーバインドの使い方を詳しく解説します。

---

## 📖 目次

- [Leaderキーについて](#leaderキーについて)
- [基本操作](#基本操作)
- [編集効率化](#編集効率化)
- [ビジュアルモード](#ビジュアルモード)
- [検索・置換](#検索置換)
- [ナビゲーション](#ナビゲーション)
- [ウィンドウ操作](#ウィンドウ操作)
- [プログラミング支援](#プログラミング支援)
- [Markdown支援](#markdown支援)
- [その他便利機能](#その他便利機能)
- [クリップボード](#クリップボード)
- [実践例](#実践例)
- [トラブルシューティング](#トラブルシューティング)

---

## Leaderキーについて

`<Leader>` はキーバインドのプレフィックスとして使われる特殊なキーです。

### デフォルト設定

**Leaderキー**: バックスラッシュ `\`

### 入力方法

`<Leader>cl` と書かれている場合の入力方法：

```
\ → c → l
```

（ノーマルモードで順番に押す）

### 例

```javascript
const userName = "太郎";
//     ↑ カーソルをここに置いて

\ → c → l と入力

const userName = "太郎";
console.log('userName:', userName);  // ← 自動挿入
```

---

## 基本操作

### Y - 行末までコピー

Vimのデフォルトでは`Y`は行全体をコピーしますが、`C`（行末まで削除）や`D`（行末まで削除）と一貫性を持たせるため、行末までコピーに変更されています。

**使い方:**
```vim
" カーソル位置から行末までコピー
Y
```

**例:**
```javascript
const userName = "太郎";
//     ↑ ここにカーソルを置いて Y を押すと "userName = "太郎";" がコピーされる
```

### U - Redo（やり直し）

Vimのデフォルトでは`U`は行全体をUndoしますが、`u`（Undo）との対称性を持たせるため、Redoに変更されています。

**使い方:**
```vim
u  " Undo
U  " Redo（<C-r> と同じ）
```

### x - レジスタを汚さない削除

通常の`x`は削除した文字をレジスタに保存しますが、この設定ではブラックホールレジスタ（`"_`）を使うため、レジスタを汚しません。

**使い方:**
```vim
x  " 1文字削除（レジスタに入らない）
```

**メリット:**
```vim
" 1. 重要なテキストをコピー
yiw

" 2. 別の場所で不要な文字を削除
xxx

" 3. コピーした内容を貼り付け（削除の影響を受けない）
p
```

---

## 編集効率化

### 行の複製

#### <Space>y - 下に複製

**使い方:**
```vim
" カーソル行を下に複製
<Space>y
```

**例:**
```javascript
const name = "太郎";
// ↓ <Space>y を押すと
const name = "太郎";
const name = "太郎";  // ← 複製された
```

#### <Space>Y - 上に複製

**使い方:**
```vim
" カーソル行を上に複製
<Space>Y
```

### 行末に記号追加

#### \; - セミコロン追加

**使い方:**
```vim
\;  " 行末にセミコロンを追加
```

**例:**
```javascript
const name = "太郎"
// ↓ \; を押すと
const name = "太郎";
```

#### \, - カンマ追加

**使い方:**
```vim
\,  " 行末にカンマを追加
```

**例:**
```javascript
const obj = {
  name: "太郎"
  // ↓ \, を押すと
  name: "太郎",
}
```

### 空行挿入

#### \o / \O - 空行挿入（インサートモードに入らない）

**使い方:**
```vim
\o  " 下に空行挿入
\O  " 上に空行挿入
```

**メリット:**
- 通常の`o`/`O`と違い、インサートモードに入らない
- 空行を入れてすぐに移動したい時に便利

**例:**
```javascript
function hello() {
  console.log("hello");
  // ↓ \o を2回押すと2行空く


  console.log("world");
}
```

### \d - 行全体を削除（レジスタを汚さない）

**使い方:**
```vim
\d  " 現在行を削除（レジスタに入らない）
```

---

## ビジュアルモード

### インデント調整

#### < / > - インデント調整（選択を維持）

**使い方:**
```vim
" 1. ビジュアルモードで複数行を選択（V で行選択）
" 2. > または < でインデント調整
" 3. 選択が維持されるので、連続で調整可能
```

**例:**
```python
# 以下の3行を選択して > を3回押す
def hello():
print("hello")
print("world")

# ↓ 結果
def hello():
      print("hello")
      print("world")
```

### y - コピー後カーソル位置を保持

**デフォルトの動作:**
```vim
" ビジュアルモードでyを押すと、カーソルが選択範囲の先頭に移動してしまう
```

**改善された動作:**
```vim
" コピー後もカーソル位置を保持
```

### * - 選択範囲で検索

**使い方:**
```vim
" 1. ビジュアルモードでテキストを選択
" 2. * を押すと、その内容で検索
```

**例:**
```javascript
const userName = "太郎";
const userAge = 20;
const userEmail = "taro@example.com";

// "user" を選択して * を押すと
// userName, userAge, userEmail がハイライトされる
```

### p - 連続ペースト（レジスタを保護）

**デフォルトの問題:**
```vim
" 1. "hello" をコピー
" 2. ビジュアルモードで "world" を選択してpで置換
" 3. もう一度ペーストしようとすると "world" が貼り付けられる（レジスタが上書きされた）
```

**改善された動作:**
```vim
" ビジュアルモードでのペーストはPを使うため、レジスタが保護される
```

**例:**
```javascript
const text = "hello";

const a = "world";
// "world" を選択してpで置換
const a = "hello";

const b = "foo";
// "foo" を選択してpで置換（"hello"がまだ使える）
const b = "hello";
```

---

## 検索・置換

### \s - カーソル下の単語を置換

**使い方:**
```vim
" 1. 置換したい単語の上にカーソルを置く
" 2. \s を押す
" 3. 置換後の文字列を入力してEnter
```

**例:**
```javascript
const userName = "太郎";
const userAge = 20;
const userEmail = "taro@example.com";

// "user" の上で \s を押すと
:%s/\<user\>//gc
// と入力された状態になる

// "member" と入力してEnterを押すと
const memberName = "太郎";
const memberAge = 20;
const memberEmail = "taro@example.com";
```

### ビジュアル選択範囲を置換

**使い方:**
```vim
" 1. ビジュアルモードで置換したい文字列を選択
" 2. \s を押す
" 3. 置換後の文字列を入力してEnter
```

### <Esc><Esc> - 検索ハイライトを消去

**使い方:**
```vim
" 検索後、ハイライトが邪魔な時に
<Esc><Esc>
```

### / - Very Magicモード

**デフォルトの問題:**
```vim
" 正規表現を使う場合、\が必要
/\d\+  " 数字1個以上
```

**改善された動作:**
```vim
" Very Magicモード（\v）が自動で有効
/\d+   " 数字1個以上（\が不要）
```

---

## ナビゲーション

### M - 対応する括弧にジャンプ

**使い方:**
```vim
M  " 対応する括弧にジャンプ（%と同じだが押しやすい）
```

**例:**
```javascript
function hello() {
//               ^ ここでMを押すと
  console.log("hello");
}
// ^ ここに移動
```

### <C-j> / <C-k> - 空行間の移動

**使い方:**
```vim
<C-j>  " 次の空行にジャンプ（}と同じ）
<C-k>  " 前の空行にジャンプ（{と同じ）
```

**メリット:**
- 関数やブロック間の移動が楽
- {/}より押しやすい

### バッファ移動

| キー | 動作 |
|------|------|
| `[b` | 前のバッファ |
| `]b` | 次のバッファ |

**使い方:**
```vim
]b  " 次のファイルに移動
[b  " 前のファイルに戻る
```

### タブ移動

| キー | 動作 |
|------|------|
| `[t` | 前のタブ |
| `]t` | 次のタブ |

---

## ウィンドウ操作

### ウィンドウ分割

| キー | 動作 |
|------|------|
| `\v` | 縦分割（`:vsplit`） |
| `\h` | 横分割（`:split`） |

**使い方:**
```vim
\v  " 画面を左右に分割
\h  " 画面を上下に分割
```

### ウィンドウサイズ調整

| キー | 動作 |
|------|------|
| `<C-w>+` | 高さを5行増やす |
| `<C-w>-` | 高さを5行減らす |
| `<C-w>>` | 幅を5列増やす |
| `<C-w><` | 幅を5列減らす |

**使い方:**
```vim
" 分割したウィンドウを調整
<C-w>+  " 現在のウィンドウを縦に広げる
<C-w>>  " 現在のウィンドウを横に広げる
```

---

## プログラミング支援

### JavaScript/TypeScript - console.log挿入

#### \cl - 変数をログ出力

**対象ファイル:**
- `.js`
- `.ts`
- `.jsx`
- `.tsx`

**使い方（ノーマルモード）:**
```vim
" 1. 変数名の上にカーソルを置く
" 2. \cl を押す
" 3. 次の行に自動挿入される
```

**例:**
```javascript
const userName = "太郎";
//     ↑ カーソルをここに置いて \cl

const userName = "太郎";
console.log('userName:', userName);  // ← 自動挿入
```

**使い方（ビジュアルモード）:**
```vim
" 1. ビジュアルモードで変数を選択
" 2. \cl を押す
```

**例:**
```javascript
const result = calculateTotal();
//     ^^^^^^ 選択して \cl

const result = calculateTotal();
console.log('result:', result);  // ← 自動挿入
```

#### \co - 空のconsole.logを挿入

**使い方:**
```vim
\co  " console.log(); を挿入（カーソルは括弧の中）
```

**例:**
```javascript
function hello() {
  // \co を押すと
  console.log();  // ← カーソルは括弧の中
}
```

### Python - print挿入

**使い方:**
```python
userId = get_user_id()
# ↑ カーソルをここに置いて \cl

userId = get_user_id()
print(f'userId: {userId}')  # ← 自動挿入
```

### Go - fmt.Println挿入

**使い方:**
```go
userName := getUserName()
// ↑ カーソルをここに置いて \cl

userName := getUserName()
fmt.Println("userName:", userName)  // ← 自動挿入
```

### Ruby - puts挿入

**使い方:**
```ruby
user_name = get_user_name
# ↑ カーソルをここに置いて \cl

user_name = get_user_name
puts "user_name: #{user_name}"  # ← 自動挿入
```

### セミコロン自動追加

**対象言語:**
- JavaScript
- TypeScript
- C
- C++
- Java
- Rust

**使い方:**
```javascript
const name = "太郎"
// ↓ \; を押すと
const name = "太郎";
```

### コメントトグル

#### \/ - 行頭にコメント記号追加

**言語別のコメント記号:**

| 言語 | コメント記号 |
|------|-------------|
| JavaScript, TypeScript, C, C++, Java, Rust, Go | `//` |
| Python, Bash, Fish, Ruby | `#` |
| Vim | `"` |

**使い方:**
```javascript
console.log("hello");
// ↓ \/ を押すと
// console.log("hello");
```

**Python例:**
```python
print("hello")
# ↓ \/ を押すと
# print("hello")
```

---

## Markdown支援

Markdownファイル（`.md`）専用のショートカット。

### ビジュアルモードでのテキスト装飾

#### \b - 太字にする

**使い方:**
```markdown
これは重要なテキストです
      ^^^^ 選択して \b

これは**重要な**テキストです
```

#### \i - イタリックにする

**使い方:**
```markdown
これは強調したいテキストです
      ^^^^^^ 選択して \i

これは*強調したい*テキストです
```

#### \c - インラインコードにする

**使い方:**
```markdown
変数nameを使います
   ^^^^ 選択して \c

変数`name`を使います
```

### \l - リンク挿入

**使い方:**
```vim
\l  " []() を挿入（カーソルは[]の中）
```

**例:**
```markdown
詳細はこちらを参照
// \l を押すと
詳細は[]()を参照
//     ^ カーソルはここ

// リンクテキストを入力してTab
詳細は[こちら]()を参照
//           ^ カーソルはここ（URLを入力）
```

---

## その他便利機能

### ファイル情報のコピー

#### \fp - ファイルパスをコピー

**使い方:**
```vim
\fp  " 現在のファイルの絶対パスをクリップボードにコピー
```

**例:**
```
/Users/user/project/src/main.js
```

#### \fn - ファイル名をコピー

**使い方:**
```vim
\fn  " 現在のファイル名をクリップボードにコピー
```

**例:**
```
main.js
```

### 日時挿入

#### \dt - 日付を挿入

**使い方:**
```vim
\dt  " 現在の日付を挿入（ノーマルモード）
```

**例:**
```
2026-01-28
```

#### \tt - 時刻を挿入

**使い方:**
```vim
\tt  " 現在の時刻を挿入（ノーマルモード）
```

**例:**
```
23:45:30
```

### インサートモードでの日時挿入

| キー | 動作 |
|------|------|
| `<C-d><C-d>` | 現在の日付を挿入 |
| `<C-t><C-t>` | 現在の時刻を挿入 |

**使い方:**
```vim
" インサートモードで
<C-d><C-d>  " 2026-01-28
<C-t><C-t>  " 23:45:30
```

### 保存・終了

| キー | 動作 |
|------|------|
| `\w` | 保存（`:w`） |
| `\q` | 終了（`:q`） |
| `\x` | 保存して終了（`:x`） |

---

## クリップボード

### レジスタからの貼り付け

#### \p - 最後にyankした内容を貼り付け

**使い方:**
```vim
" 1. 行をコピー: yy
" 2. 別の行を削除: dd（レジスタが上書きされる）
" 3. 最初にコピーした内容を貼り付け: \p
```

**0レジスタとは:**
- Vimでは`y`でコピーした内容は`"`（無名レジスタ）と`0`レジスタの両方に保存される
- `d`や`c`で削除/変更すると`"`は上書きされるが、`0`は上書きされない
- `\p`は`0`レジスタから貼り付けるため、削除の影響を受けない

### システムクリップボード連携

#### \y - システムクリップボードへコピー

**使い方:**
```vim
" ノーマルモード: \y で1行コピー
" ビジュアルモード: 選択して \y
```

**例:**
```javascript
const userName = "太郎";
// この行で \y を押すと、他のアプリケーションにも貼り付けられる
```

#### \p - システムクリップボードから貼り付け

**使い方:**
```vim
\p  " システムクリップボードの内容を貼り付け
```

---

## 実践例

### 例1: デバッグログを素早く追加

```javascript
function calculateTotal(items) {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  const tax = subtotal * 0.1;
  const total = subtotal + tax;
  return total;
}

// ↓ 各変数でデバッグログを追加したい

function calculateTotal(items) {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  console.log('subtotal:', subtotal);  // ← subtotalの上で \cl
  const tax = subtotal * 0.1;
  console.log('tax:', tax);            // ← taxの上で \cl
  const total = subtotal + tax;
  console.log('total:', total);        // ← totalの上で \cl
  return total;
}
```

### 例2: 複数行を一括コメントアウト

```python
def process_data():
    validate()
    transform()
    save()

# ↓ 3行を選択（Vで行選択）して各行で \/ を実行

def process_data():
    # validate()
    # transform()
    # save()
```

### 例3: Markdownドキュメント作成

```markdown
# Vimの便利機能

Vimはテキストエディタです。

## 特徴

高速な編集が可能
      ^^^^ 選択して \b → **高速な**

詳細はこちら
      ^^^^ 選択後 \l → [こちら](URL)

コマンド vim を実行
       ^^^ 選択して \c → `vim`

# 最終結果
Vimは**高速な**編集が可能なテキストエディタです。
詳細は[こちら](https://www.vim.org/)を参照してください。
コマンド`vim`を実行します。
```

### 例4: 連続置換

```javascript
const user_name = "太郎";
const user_age = 20;
const user_email = "taro@example.com";

// "user" の上で \s → "member" と入力

const member_name = "太郎";
const member_age = 20;
const member_email = "taro@example.com";
```

---

## トラブルシューティング

### Leaderキーが効かない

**確認方法:**
```vim
:echo mapleader
```

**表示される内容:**
- 空白または `\` → 正常

**解決方法:**
1. Vimを再起動
2. 設定ファイルを確認: `vim/config/main.vim`

### 日本語入力モードで効かない

**原因:**
- 日本語入力モードではキーバインドが動作しない

**解決方法:**
- ノーマルモードに戻る（`Esc`）
- 日本語入力をオフ（英数モード）

### ファイルタイプが認識されない

**確認方法:**
```vim
:set filetype?
```

**手動設定:**
```vim
:set filetype=javascript
:set filetype=python
:set filetype=markdown
```

### console.logが挿入されない

**原因:**
- ファイルタイプが正しく認識されていない

**確認:**
```vim
:set filetype?
" javascript, typescript, javascriptreact, typescriptreact のいずれか
```

**解決方法:**
```vim
" 手動でファイルタイプを設定
:set filetype=javascript
```

### 特定のキーバインドだけ効かない

**確認方法:**
```vim
" キーマッピングを確認
:verbose nmap \cl
:verbose nmap <Space>y
```

**競合している場合:**
- 他のプラグインとの競合の可能性
- `vim/config/macro.vim`を確認して調整

---

## カスタマイズ

### Leaderキーを変更したい

`vim/config/main.vim` に以下を追加：

```vim
" Leaderキーをスペースに変更
let mapleader = "\<Space>"
```

### キーバインドを変更したい

`vim/config/macro.vim` を編集：

```vim
" 例: 行複製を別のキーに変更
nnoremap <Leader>d yyp

" 例: console.logを別のキーに変更
autocmd FileType javascript,typescript
  \ nnoremap <buffer> <Leader>ll yiwoconsole.log('<C-r>":', <C-r>");<Esc>
```

### 新しい言語のデバッグログを追加

`vim/config/macro.vim` の`augroup ProgrammingShortcuts`に追加：

```vim
" Kotlin: println追加
autocmd FileType kotlin
  \ nnoremap <buffer> <Leader>cl yiwoprintln("<C-r>": $<C-r>")<Esc>

" Swift: print追加
autocmd FileType swift
  \ nnoremap <buffer> <Leader>cl yiwoprint("<C-r>": \(<C-r>)")<Esc>
```

---

## よく使うショートカット早見表

| カテゴリ | キー | 動作 |
|---------|------|------|
| **デバッグ** | `\cl` | console.log挿入 |
| **編集** | `<Space>y` | 行複製 |
| **編集** | `\;` | セミコロン追加 |
| **検索** | `\s` | 単語置換 |
| **ナビゲーション** | `M` | 括弧ジャンプ |
| **ナビゲーション** | `<C-j>`/`<C-k>` | 空行移動 |
| **ファイル** | `\fp` | パスコピー |
| **日時** | `\dt` | 日付挿入 |
| **コメント** | `\/` | コメント追加 |
| **保存** | `\w` | 保存 |

---

## 参考リンク

### 日本語記事
- [Vimで使っている簡単キーマッピングたちを共有](https://zenn.dev/vim_jp/articles/43d021f461f3a4)
- [慣れてきた頃に知りたいVimの便利機能](https://zenn.dev/sun_asterisk/articles/6b2bf762a7e510)
- [Vim キーマップをカスタマイズするとき考えていること](https://zenn.dev/vim_jp/articles/2023-05-19-vim-keybind-philosophy)
- [vim マクロで楽する！実践例あり](https://zenn.dev/abebe123000/articles/f5fd75017c3e08)

### 英語記事
- [Why You Should Finally Learn Vim (Yes, Even in 2025)](https://medium.com/quick-programming/why-you-should-finally-learn-vim-yes-even-in-2025-bf5ae142bc7d)
- [Vim keybindings for efficient text editing](https://dev.to/taraslis453/vim-keybindings-for-efficient-text-editing-ke2)
- [A Few of My Favourite Vim Keybindings](https://www.adamdrake.dev/blog/a-few-of-my-favourite-vim-keybindings)

---

## まとめ

このマクロ設定を使いこなすことで：

✅ デバッグログの挿入が超高速
✅ 検索・置換が直感的
✅ Markdownの執筆が快適
✅ コピペ作業が効率的
✅ ファイル情報の取得が簡単

まずは**\cl**（console.log）、**\s**（置換）、**<Space>y**（行複製）から試してみましょう！

慣れてきたら、他のショートカットも徐々に覚えていくと、Vimでの開発効率が飛躍的に向上します。
