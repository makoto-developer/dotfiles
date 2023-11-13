# Alias

# basic
alias mk='mkdir'
alias vim='vim'
alias vi='nvim'
alias v=vi
alias n='nvim'
alias grep='grep --color=auto'
alias clip='pbcopy'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# ls
alias l='ls -ltraG'
alias ll='ls -la'
alias ls='ls -G'

# git
alias g='git'
alias gf='git fetch'
alias gfp='git fetch -p'
alias ga='git add -A'
alias gb='git branch'
alias gs='git status'
alias gpl='git pull'
alias gcm='git commit -m $argv'
alias gps='git push'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gitbranchnameclip='git branch --show-current | clip' # ブランチ名をクリップボードにコピー
alias gbn=gitbranchnameclip
alias gcl='git clean -fd'                                  # 未追跡のファイル/ディレクトリを一撃で削除する

# Node.js,npm,yarn,pnpm
alias p="pnpm"

# その他
alias dr='docker'

# password generater
alias passgen='openssl rand -base64 16 | pbcopy'
alias passgenweak='openssl rand -hex 8 | pbcopy'
alias passgenw=passgenweak


# useful
alias myip='curl https://ipinfo.io/json'    # ipアドレスを取得
alias myhttp='ruby -run -e httpd . -p 8000' # カレントディレクトリを基準にHTTPサーバを起動

# terraform
alias terr='terraform'

# docker
alias d='docker'
alias dr='docker'

# kubernets
alias k='kubectl'
alias kx='kubectx'


