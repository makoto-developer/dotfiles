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

## キーマップ一覧

メインは**`s`プレフィックス**(sは上書きしてよいルール。標準のs=1文字置換は`cl`で代用)。
2ストロークで押せて、OS・アプリ(orca等)・iTermと絶対に競合しない。
IntelliJの機能名の頭文字で覚える。IntelliJ風(Cmd系)・vim標準・Space系も併用できる。

### ジャンプ・検索・LSP

| 操作 | メイン(s系) | 覚え方 | 併用できるキー |
|------|-----------|--------|--------------|
| ファイル名でジャンプ | `sf` | **f**ile | `Cmd+Shift+O` / `Space ff` |
| 全文検索(fuzzy: 多少typoしてもヒット) | `sg` | **g**rep | - |
| 全文検索(exact: 正規表現可) | `Space fg` | - | `Cmd+Shift+F` |
| シンボル(関数・型)検索 | `so` | IntelliJのCmd+**O** | `Cmd+O` / `Space fs` |
| 最近のファイル | `se` | IntelliJのCmd+**E** | `Cmd+E` / `Space fh` |
| バッファ一覧 | `sb` | **b**uffer | `Space fb` |
| カーソル下の単語を横断検索 | `sw` | **w**ord | リポジトリを跨ぐ呼び出し追跡に(`su`はリポジトリ内のみ) |
| 定義へ移動 | `sd` | **d**efinition | `Ctrl+]` / `gd` |
| ジャンプから戻る/進む | `Ctrl+o` / `Ctrl+i` | vim標準 | - |
| 使用箇所検索 | `su` | **u**sage | `grr` / `Opt+F7` |
| 実装へ移動 | `si` | **i**mplementation | `gri` |
| リネーム | `sr` | **r**ename | `grn` / `Shift+F6` |
| コードアクション | `sa` | **a**ction | `gra` |
| フォーマット(ファイル全体) | `sF` | **F**ormat | `Cmd+Opt+L` / `Space f` |
| ファイル内シンボル一覧 | `gO` | vim標準 | - |
| ドキュメント表示 | `K` | vim標準 | - |
| 前/次の診断へ | `[d` / `]d` | vim標準 | - |
| コメントトグル | `gcc`(行) / `gc`(選択) | vim標準 | `Cmd+/` |

### git・ファイルツリー・レビュー

| 操作 | キー | 覚え方 |
|------|------|--------|
| gitグラフ(Enterで差分) | `sG` | **G**it |
| diffビューア(ブランチ差分・レビュー用) | `sD` | **D**iff。`:DiffviewOpen main...HEAD`でブランチ比較、`:DiffviewFileHistory %`でファイル履歴、閉じるは`:DiffviewClose` |
| ファイルツリー開閉 | `s1` | IntelliJのCmd+**1** |
| git変更ファイル一覧 | `Space gs` | **s**tatus(レビュー開始の起点) |
| 変更箇所(hunk)間をジャンプ | `]c` / `[c` | **c**hange |
| 変更前とのdiffをポップアップ | `Space gp` | **p**review |
| カーソル行のblame | `Space gb` | **b**lame |
| git blame(ファイル全体) / 差分 | `:Git blame` / `:Gdiffsplit` | fugitive |
| TODO/FIXME一覧(プロジェクト横断) | `sT` | **T**ODO |
| Claude Codeをトグル(選択範囲を送るのはビジュアルモードで`sc`) | `sc` | **c**laude |

### テスト・デバッグ

| 操作 | キー | 備考 |
|------|------|------|
| カーソル下のテストを実行 | `sx` | e**x**ecute。結果は行の横に✓✗表示 |
| ファイル全体のテストを実行 | `sX` | |
| テスト一覧パネル / 出力 | `Space ts` / `Space to` | |
| ブレークポイント切替 | `sB` | **B**reakpoint |
| デバッグ開始/再開 | `F9` | IntelliJのResumeと同じ |
| ステップオーバー / イン / アウト | `F8` / `F7` / `Shift+F8` | IntelliJと同じ |
| テストをデバッグ実行 | `Space td` | ブレークポイントで止まる |
| デバッグUIの開閉 | `Space du` | 変数・コールスタック表示 |
| undo履歴ツリー(Local History相当) | `sU` | **U**ndo。保存を跨いで任意時点に復元 |
| inlay hints切替 | `Space ih` | 引数名・型のインライン表示(go/TS/rust。通常は自動ON) |

対応言語: テストはgo(go test) / Elixir(ExUnit) / TS・JS(jest)。デバッグはgo(delve) / Elixir(elixir-ls) / Node・TS(js-debug)。

- 長い関数の中では画面上部に「今いる関数・モジュールの宣言行」が自動で固定表示される(treesitter-context)
- 引数なしで`nvim`を起動すると、そのディレクトリの前回セッション(ウィンドウ・タブ・開いていたファイル)が自動復元される(persistence)

### 大規模リポジトリ・レビューのTips

- **検索結果をまとめて処理**: telescopeの結果一覧で`Ctrl+q`を押すと全ヒットがquickfixに入る。
  `:cnext`/`:cprev`で巡回、`:cfdo %s/old/new/g | update`で横断置換
- **マルチリポジトリ構成**: 親ディレクトリで開いてよい。LSPはファイルごとに最寄りのプロジェクトルートを検出してリポジトリ単位で起動する
- **検索の使い分け**: `sg`(fuzzy)は全行をメモリに載せるため巨大な横断リポジトリでは重い。
  その場合はexactの`Space fg`か`sw`(単語検索)を使う

### telescopeの操作(検索ウィンドウ内)

- `Esc` 1回でキャンセル(IntelliJと同じ)
- 候補の移動は `Ctrl+n` / `Ctrl+p`(または矢印キー)
- 決定は `Enter`

※IntelliJ風のCmd系を使う場合はiTerm2の設定が必要
(Settings -> Profiles -> Keys -> General でキーボードプロトコルをkittyにする)。
Cmd+B(orcaのサイドバーと競合)とCmd+1(タブ切替と競合)は定義していない。

### 編集・移動(すべて自分定義)

| 操作 | キー |
|------|------|
| Esc | `jj`(挿入モード) |
| 行末までコピー / redo | `Y` / `U` |
| レジスタを汚さない削除 | `x` / `Space d`(行) |
| 行の複製 | `Space y` / `Space Y` |
| 空行の挿入 | `Space o` / `Space O` |
| 行末にセミコロン/カンマ | `Space ;` / `Space ,` |
| カーソル下の単語を置換 | `Space s`(選択範囲も可) |
| デバッグ出力挿入(js/ts/py/go/elixir) | `Space cl` |
| ファイルパス/ファイル名をコピー | `Space fp` / `Space fn` |
| 日付/時刻を挿入 | `Space dt` / `Space tt` |
| 保存 / 終了 / 保存して終了 | `Space w` / `Space q` / `Space x` |
| 検索ハイライト消去 | `Esc Esc` |
| ウィンドウ移動 | `Ctrl+hjkl` / `sh sj sk sl` |
| 画面分割(横/縦) | `ss` / `sv` |
| タブ新規/次/前/閉じる | `st` / `sn` / `sp` / `sq` |
| バッファ移動 | `[b` / `]b` |
| タブ移動 | `[t` / `]t` |
| 括弧ジャンプ | `M` |
| インデント維持(ビジュアル) | `<` / `>` |

## トラブルシューティング

```shell
# プラグインを入れ直す
nvim --headless "+Lazy! sync" +qa

# 状態を全部リセットして再構築(設定ファイルは消えない)
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim
```
