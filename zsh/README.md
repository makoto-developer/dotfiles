# zsh設定

fishから戻ってきたので現役。Prezto等のフレームワークは使わず軽量に保つ。
プロンプトは組み込みの`vcs_info`でgitブランチを表示するだけ。

| ファイル | 読まれるタイミング | 置くもの |
|---|---|---|
| `.zshenv` | 全てのzsh(非対話・`ssh host cmd`・cronから起動したzshを含む) | PATH・ロケール・`EDITOR`などの環境変数 |
| `.zprofile` | ログインシェルで一度だけ | `/etc/zprofile`の`path_helper`が崩したPATHの優先順の復元 |
| `.zshrc` | 対話シェル | `setopt`・`bindkey`・エイリアス・プロンプト・プラグイン |

環境変数を`.zshrc`に置くと非対話シェルで効かないため、`.zshenv`と分けている。

シェルはHomebrew版zshを使う(macOS標準の`/bin/zsh`は更新が遅いため)。
Homebrew版も`--enable-etcdir=/etc`でビルドされており、`/etc/zprofile`・`/etc/zshrc`は標準と同じく読まれる。

```shell
brew install zsh zsh-autosuggestions zsh-syntax-highlighting fzf fzf-tab zoxide hstr ghq
sudo sh -c 'echo /opt/homebrew/bin/zsh >> /etc/shells'
chsh -s /opt/homebrew/bin/zsh
```

前提: リポジトリはghq管理下に置き、`~/dotfiles`はシンボリックリンクにする。

```shell
git config --global ghq.root '~/work'  # 初回のみ(clone後はdotfilesの.gitconfigが引き継ぐ)
ghq get -p makoto-developer/dotfiles
ln -s ~/work/github.com/makoto-developer/dotfiles ~/dotfiles
```

設定ファイルをリンクする。

```shell
mv ~/.zshrc ~/.zshrc.original 2>/dev/null
mv ~/.zprofile ~/.zprofile.original 2>/dev/null
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/.zshenv ~/.zshenv
ln -s ~/dotfiles/zsh/.zprofile ~/.zprofile
```

APIキー等のシークレットとマシン固有の設定は、gitで追跡しない`~/.zshrc.local`に書く
(`.zshrc`の最後で読み込む。`.gitignore`で除外済み)。

反映

```shell
exec zsh
```

## キーバインド・コマンド

- `Ctrl + g` — ghq管理下のリポジトリをfzfで検索して移動
- `Ctrl + r` — hstrでコマンド履歴を検索(打ちかけの行は退避され、終了後のプロンプトに戻る)
- `Ctrl + p` / `Ctrl + n` — 入力途中の文字列でhistoryを前方/後方検索
- `Tab` — 補完候補をfzfで絞り込んで選択(fzf-tab)。`<` / `>`で候補の種類を切り替え
- `**` + `Tab` — ファイル・ディレクトリをfzfで再帰的に検索して補完
- `Ctrl + t` / `Alt + c` — ファイルをfzfで選んで挿入 / ディレクトリをfzfで選んで移動(`Alt`はiTerm2でOptionキーを`Esc+`にしておく)
- `Ctrl + x` `Ctrl + e` — 入力中のコマンドを`$EDITOR`(nvim)で編集
- `Ctrl + w` — 直前の単語を削除。パスは`/`ごとに1階層ずつ消える
- `z <名前の一部>` — 頻出ディレクトリへジャンプ(zoxide)。`zi`で一覧から選択
- `repos` — カレントディレクトリ直下の全gitリポジトリのstatusを一覧
- `gcl` / `gclf` — 未追跡ファイルの削除。`gcl`はdry-run、実際に消すのは`gclf`

## 中身の構成(.zshrc内のセクション)

Homebrew / 履歴 / 色 / 補完(fzf, fzf-tab) / ディレクトリ移動 / プロンプト /
ツール連携(mise, ghq+fzf, repos, zoxide, hstr) / エイリアス / iTerm2連携 /
プラグイン(zsh-autosuggestions) / ローカル設定 / コマンドの色付け(zsh-syntax-highlighting)

`zsh-syntax-highlighting`は他のzle widgetを拾うため、必ず最後に読み込む。
`fzf-tab`は`compinit`と`fzf --zsh`の後、`zsh-autosuggestions`より前に読み込む(直前のTabの割り当てを引き継ぐため)。
