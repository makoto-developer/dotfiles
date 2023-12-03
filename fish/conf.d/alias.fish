# Alias

# basic
alias vim='vim'
alias vi='nvim'
alias v=vi
alias mk='mkdir'
alias grep='grep --color=auto'
alias clip='pbcopy'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# ls
alias l='ls -ltraG' # 最新ファイルが下に表示される
alias ll='ls -la'
alias ls='ls -G'

# git
# 引数が必要なコマンドはgit.aliasで管理
alias g='git'
alias gf='git fetch'
alias gfp='git fetch -p'
alias ga='git add -A'
alias gb='git branch'
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
alias gitbranchnameclip='git branch --show-current | clip' # ブランチ名をクリップボードにコピー
alias gbnc=gitbranchnameclip
alias gcl='git clean -df'                                  # 未追跡のファイル/ディレクトリを一撃で削除する

# Node.js,npm,yarn,pnpm
alias p='pnpm'
alias y='yarn'

# password generater
alias passgen='openssl rand -base64 16 | pbcopy'
alias passgenweak='openssl rand -hex 8 | pbcopy'
alias passgenw=passgenweak


# terraform
alias terr='terraform'
alias tf=terr

# docker
alias dr='docker'
alias d=dr

# kubernets
alias kubec='kubectl'
alias kc=kubec
alias kubex='kubectx'
alias kx=kubex

# GCP
alias gl='gcloud'
alias fire='firebase'
alias fi=fire

# Jetbrains
alias ws=webstorm
alias gol=goland
alias pyc=pycharm
alias rover=rustrover
alias rov=rover

