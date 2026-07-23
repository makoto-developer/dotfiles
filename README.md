# dotfiles

macOSの開発環境設定ファイル。設定はこのリポジトリで管理し、各所へsymlinkを張って使う。

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

## 8. 反映

```shell
exec $SHELL
```
