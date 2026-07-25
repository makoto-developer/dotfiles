# dotfiles

macOSの開発環境設定ファイル。設定はこのリポジトリで管理し、各所へsymlinkを張って使う。

## チートシート(よく使う操作)

### ターミナル(zsh)

| やりたいこと | 操作 |
|------------|------|
| リポジトリへ移動 | `Ctrl+G`(一覧から選ぶ) / `z 名前の一部`(覚えてる時) |
| コマンド履歴を検索 | `Ctrl+R` |
| 配下の全リポジトリの状態を一覧 | `repos` |
| PRダッシュボード(全リポジトリ横断) | `gh dash` -> `Tab`でタブ切替 / `C`でcheckout / `Enter`で詳細 |
| nvimを開く | `v`(前回のセッションが自動復元) / `v ファイル名` |

### nvim: 探す

| やりたいこと | キー |
|------------|------|
| ファイル名でジャンプ | `sf` |
| 全文検索(typo許容) | `sg` ※巨大リポジトリでは`Space fg`(exact)が軽い |
| カーソル下の単語を横断検索 | `sw`(リポジトリを跨ぐ呼び出し追跡) |
| 関数・型名でジャンプ | `so` |
| 最近のファイル / バッファ | `se` / `sb` |
| TODO/FIXME一覧 | `sT` |
| 検索窓: 閉じる/移動/quickfixへ | `Esc` / `Ctrl+n` `Ctrl+p` / `Ctrl+q`(一覧はプレビュー付き) |
| DBクライアント(SQL実行) | `Space db` |
| Markdown整形表示の切替 | 自動(戻すのは`:RenderMarkdown toggle`) |

### nvim: 読む・直す

| やりたいこと | キー |
|------------|------|
| 定義へ飛ぶ -> 戻る | `sd` -> `Ctrl+o` |
| 使用箇所 / 実装 / ドキュメント | `su` / `si` / `K` |
| リネーム / コードアクション(波線の上で) | `sr` / `sa` |
| フォーマット | `sF` |
| 次のエラーへ / コメントトグル | `]d` / `gcc` |

### nvim: git・レビュー

| やりたいこと | キー |
|------------|------|
| 変更ファイル一覧(レビューの起点) | `Space gs` |
| 変更箇所を巡回 -> 変更前と比較 -> blame | `]c` -> `Space gp` -> `Space gb` |
| ブランチ差分ビューア | `sD`(`:DiffviewOpen main...HEAD`) |
| gitグラフ / PR一覧・レビュー | `sG` / `sP` |
| 横断検索置換 | `sR` |
| ファイルツリー | `s1` |

### nvim: テスト・デバッグ

| やりたいこと | キー |
|------------|------|
| カーソル下のテストを実行 / ファイル全体 | `sx` / `sX` |
| テスト一覧パネル / 失敗の出力を見る | `Space ts` / `Space to` |
| ブレークポイントを置く | `sB` |
| デバッグ開始・再開 / ステップ実行 | `F9` / `F8`(オーバー) `F7`(イン) ※IntelliJと同じ |
| カーソル下のテストをデバッグ実行 | `Space td` |
| デバッグUIの開閉 | `Space du` |
| undo履歴から復元(Local History相当) | `sU` |
| 型・引数名のインライン表示を切替 | `Space ih`(通常は自動表示。go/TS/rust対応) |

### nvim: Claude連携

| やりたいこと | キー |
|------------|------|
| Claudeを開く/閉じる | `sc` |
| 選択範囲をClaudeに渡して質問 | ビジュアル選択 -> `sc` |

### Claude Codeスキル

| やりたいこと | コマンド |
|------------|---------|
| マイクロサービス群のCLAUDE.mdを生成 | ルートで`claude` -> `/claude-md-init` |
| 新しいMacをセットアップ | pc-setupで`claude` -> `/setup` |

詳細は各READMEを参照: [zsh](./zsh/README.md) / [nvim](./vim/nvim/README.md)

---

## セットアップ

前提

- ツール類(ghq, fzf, mise, neovim等)は[pc-setup](https://github.com/makoto-developer/pc-setup)の手順でインストールする
- ssh設定が済んでいること(cloneはssh経由のため)

## 1. リポジトリを取得

リポジトリはghq管理下に置き、`~/dotfiles`はシンボリックリンクにする。

```shell
# ghqのクローン先を設定(このdotfilesの.gitconfigにも同じ設定があるが、初回はまだ無いので手で設定する)
git config --global ghq.root '~/work'

ghq get -p makoto-developer/dotfiles
ln -s ~/work/github.com/makoto-developer/dotfiles ~/dotfiles
```

## 2. Git設定

まず個人用の設定ファイル`~/.git_user`を作る。
(名前・メールアドレス・署名鍵はマシンやアカウントごとに違うため、リポジトリに含めずこのファイルに分離している)

**~/.git_user:**
```
[user]
name = Your Name
email = your.email@example.com
# 署名付きコミット用。ssh設定で作った鍵の「公開鍵」を指定する
signingkey = ~/.ssh/id_github_YYYYMMDD_ed25519.pub
```

次に設定ファイルをリンクする。

```shell
cd ~/dotfiles
ln -sf $PWD/git/.gitconfig ~/.gitconfig
ln -sf $PWD/git/.git_alias ~/.git_alias
ln -sf $PWD/git/.git_core ~/.git_core
ln -sf $PWD/git/.git_delta ~/.git_delta
ln -sf $PWD/git/.gitignore_global ~/.gitignore_global
```

※署名付きコミットの共通設定(`gpg.format ssh`等)は`.gitconfig`に含まれている。GitHubへのSigning Key登録などの残り手順は[pc-setup](https://github.com/makoto-developer/pc-setup)の「署名付きコミットの設定」を参照。

## 3. シェル(Zsh)

[zsh/README.md](./zsh/README.md)を参照。

## 4. バージョン管理(mise)

miseはグローバル設定を`~/.config/mise/config.toml`から読むため、このリンクは必須。

```shell
ln -sn ~/dotfiles/mise ~/.config/mise
mise install
```

## 5. Vim/Neovim

[vim/README.md](./vim/README.md)を参照。

## 6. VSCode

```shell
cd ~/dotfiles/vscode
./setup.sh
```

詳細は[vscode/SETUP.md](./vscode/SETUP.md)を参照。

## 7. Karabiner-Elements

キーマッピング設定(fn⇔Esc入替、右Cmd→英数、右Opt→かな)。
GUIでの設定変更がファイルを置き換えるため、ディレクトリごとsymlinkする。

```shell
# 既存の設定があれば退避
mv ~/.config/karabiner ~/.config/karabiner.bak 2>/dev/null
ln -sn ~/dotfiles/karabiner ~/.config/karabiner
```

## 8. gh-dash(PRダッシュボード)

複数リポジトリのPR・Issueを1画面で俯瞰するghの拡張。
レビュー依頼・アサイン・自分のPRをタブ分けした設定を使う。

```shell
gh extension install dlvhdr/gh-dash
ln -sn ~/dotfiles/gh-dash ~/.config/gh-dash

# 起動
gh dash
```

## 9. Claude Code(個人スキル)

どのマシン・どのディレクトリでも使える個人スキルをdotfilesで管理する。

```shell
ln -sn ~/dotfiles/claude/skills ~/.claude/skills
```

入っているスキル:

- `/claude-md-init` — マイクロサービス群のルートで実行すると、配下のリポジトリを調査して
  CLAUDE.md(サービスマップ)を生成する
- `/update-env` — brew/mise/nvimプラグイン/gh拡張をまとめて更新し、動作検証してから
  コミットを提案する(月次メンテ用)

※`~/.claude/settings.json`はツール(orca等)が自動管理するためdotfilesには含めない

## 10. 反映

```shell
exec $SHELL
```
