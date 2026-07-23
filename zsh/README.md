# zsh設定

fishから戻ってきたので現役。設定は`.zshrc`の1ファイルのみ(旧`.zshrc.profile.*.zsh`は統合済み)。
Prezto等のフレームワークは使わず軽量に保つ。プロンプトは組み込みの`vcs_info`でgitブランチを表示するだけ。

前提: リポジトリはghq管理下に置き、`~/dotfiles`はシンボリックリンクにする。

```shell
git config --global ghq.root '~/work'  # 初回のみ(clone後はdotfilesの.gitconfigが引き継ぐ)
ghq get -p makoto-developer/dotfiles
ln -s ~/work/github.com/makoto-developer/dotfiles ~/dotfiles
```

設定ファイルをリンクする。

```shell
mv ~/.zshrc ~/.zshrc.original 2>/dev/null
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
```

反映

```shell
exec zsh
```

## キーバインド

- `Ctrl + g` — ghq管理下のリポジトリをfzfで検索して移動
- `Ctrl + r` — hstrでコマンド履歴を検索
- `Ctrl + p` / `Ctrl + n` — 入力途中の文字列でhistoryを前方/後方検索

## 中身の構成(.zshrc内のセクション)

PATH / 言語 / 履歴 / 補完 / プロンプト / ツール連携(mise, ghq+fzf, ghq+peco, hstr, golang, libpq) / エイリアス / iTerm2連携
