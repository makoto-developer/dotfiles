# dotfiles


macOSで使っている設定を管理

## 導入手順

### dotfilesリポジトリをクローン

```shell
# ホームディレクトリにdotfilesリポジトリを置く
cd ~
git clone git@github.com:makoto-developer/dotfiles.git
```

### iterm用のプロファイルを読み込む

```shell
./iterm/Profiles.json
```

### git


ファイルを作成する `vi ~/.git_user`(シークレット情報をgit管理したくないので手動で作成する)

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

### vim

```shell
cd ~
ln -s ~/dotfiles/vim/nvim/init.vim ~/.vimrc
ln -s ~/dotfiles/vim/nvim/init.vim ~/.ideavimrc
```

### nvim

```shell
cd ~
ln -s ~/dotfiles/vim/nvim ~/.config/
```

# fish

準備中...

```shell
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/

```

## Warning

シンボリックリンクを削除するときは`unlink`を使うこと。rmを使うとシンボリック元のファイルの中身が消えることがあるので。

