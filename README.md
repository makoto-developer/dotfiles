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


ファイルを作成する(シークレット情報をgit管理したくないので手動で作成する)
```shell
vi ~/.git_user


# githubのユーザ名を入れる
[user]
name = <<< your name >>>
email = <<< your email >>>


vi ~/.git_github

[github]
user = "<<< github account id >>>"


# global ignoreの設定ファイルを追加
vi ~/.git_globalignore


[core] 
excludesFile = <<< ホームディレクトリの絶対パズ /User/xxxxx >>>/git_globalignore

```

シンボリックを配置

```shell
cd ~
ln -s dotfiles/git/.gitconfig ~/
ln -s dotfiles/git/.git_alias ~/
ln -s dotfiles/git/.git_core ~/
ln -s dotfiles/git/.git_delta ~/
ln -s dotfiles/git/.gitignore_global ~/
```

Gitの設定をする

```shell
git config --global core.excludesFile ~/.gitignore_global
git config --global user.name "<<<user name>>>"
git config --global user.email "<<<email address>>>"
```

### vim

```shell
cd ~
ln -s dotfiles/vim/nvim/init.vim ~/.vimrc
ln -s dotfiles/vim/nvim/init.vim ~/.ideavimrc
```

### nvim

```shell
cd ~
ln -s dotfiles/vim/nvim ~/.config/
```

### zsh

```shell
cd ~

# .zshrcがすでに存在する場合はバックアップ
cp -p .zshrc .zshrc.origin

# シンボリックリンクを貼って行く
ln -s dotfiles/zsh/.zshrc ~/
ln -s dotfiles/zsh/.zshrc.profile.zsh ~/
ln -s dotfiles/zsh/.zshrc.profile.alias.zsh ~/
ln -s dotfiles/zsh/.zshrc.profile.iterm.zsh ~/
```

### ターミナルのテーマを変更(zprezto)

```shell
# ファイルが存在することを確認
ll ~/.zprezto/modules/prompt/external/agnoster/agnoster.zsh-theme

mv ~/.zprezto/modules/prompt/external/agnoster/agnoster.zsh-theme ~/.zprezto/modules/prompt/external/agnoster/agnoster.zsh-theme-original
ln -s ~/dotfiles/zsh/agnoster.zsh-theme-custom ~/.zprezto/modules/prompt/external/agnoster/agnoster.zsh-theme
```


## Warning

シンボリックリンクを削除するときは`unlink`を使うこと。rmを使うとシンボリック元のファイルの中身が消えることがあるので。

