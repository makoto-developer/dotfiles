# dotfiles

macOSの設定を管理

# Getting start

## dotfilesリポジトリをクローン

```shell
# ホームディレクトリにdotfilesリポジトリを置く
cd ~
git clone git@github.com:makoto-developer/dotfiles.git
```

## git

シークレット情報をgit管理したくないので個別作成する

ファイルを作成する `vi ~/.git_user`

```shell
# githubのユーザ名を入れる
[user]
name = <<< your name >>>
email = <<< your email >>>
```

ファイルを作成する `vi ~/.git_github`

```shell
[github]
user = "<<< github account id >>>"
```

ファイルを作成する `vi ~/.git_globalignore`

- 本来は`~/.config/git/ignore`で十分だという意見がある
- しかし、macOSには存在しないディレクトリ
- なので結局手動で作るという点で変わらないのでこのままにしている)

```
[core] 
excludesFile = <<< ホームディレクトリの絶対パス/User/xxxxx >>>/.git_globalignore
```

シンボリックを配置

```shell
cd ~
ln -s ~/dotfiles/git/.gitconfig ~/
ln -s ~/dotfiles/git/.git_alias ~/
ln -s ~/dotfiles/git/.git_core ~/
ln -s ~/dotfiles/git/.git_delta ~/
ln -s ~/dotfiles/git/.gitignore_global ~/
```

## asdf

```shell
ln -s ~/dotfiles/asdf/.tool-versions ~/
```

## vim

`vim/`ディレクトリを参照

## fish

```shell
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/
ln -s ~/dotfiles/fish/init.fish ~/.config/omf/
ln -s ~/dotfiles/fish/conf.d/  ~/.config/fish/
```


# Tips

`rm`コマンドを使うとシンボリック元のファイルの中身が消えることがあるので、シンボリックリンクを削除するときは`unlink`を使うこと。

