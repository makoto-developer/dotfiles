# Alias

# basic
alias mk='mkdir'
alias v='vim'
alias vi='vim'
alias grep='grep --color=auto'
alias clip='pbcopy'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias gohome='cd ~'

# ls
alias l='ls -ltrG'
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

# パスワードジェネレータ
alias passgen='openssl rand -base64 16 | pbcopy'
alias passgenweak='openssl rand -hex 8 | pbcopy'
alias passgenw=passgenweak


# 便利
alias myip='curl https://ipinfo.io/json'    # ipアドレスを取得
alias myhttp='ruby -run -e httpd . -p 8000' # カレントディレクトリを基準にHTTPサーバを起動


# コマンドで話す
## 音声を予めダウンロードしておくこと!
alias alex='say -v Alex -r 200 -i @argv'
alias vicky='say -v Vicki -r 200 -i @argv'
alias kyoko='say -v Kyoko -r 200 -i @argv'

