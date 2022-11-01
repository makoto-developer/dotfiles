# .zsh_profile_alias
# Aliasコマンドを管理


# Alias
## base command
alias _="sudo"
alias mk="mkdir"
alias v='vim'
alias vi='vim'
alias grep='grep --color=auto'


## Library command
alias vn='nvim'
alias nv='nvim'
alias el="elixir"
alias iex="iex" # 省略しない
alias erl="erl" # 省略しない
alias n="npm"
alias y="yarn"
alias fire="firebase"
alias fr="firebase"
#alias nb="nodebrew"    # asdfへ移管されたので廃止
#alias nodeb="nodebrew" # asdfへ移管されたので廃止
alias k="kubectl"
alias dr="docker"
alias dc="docker-compose"
alias clip='pbcopy'
alias tel='telepresence'
alias fz='fzf'


## cd系
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias gohome='cd ~'


## ls系
alias l='ls -ltrG'
alias ll="ls -la"
alias ls='ls -G'


## git系
alias g="git"
alias gf="git fetch"
alias gfp="git fetch -p"
alias ga="git add -A"
alias gb="git branch"
alias gs="git status"
alias gpl="git pull"
alias gcm="git commit -m $@"
alias gps="git push"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gd="git diff"
alias gitbranchnameclip="git branch --show-current | clip" # ブランチ名をクリップボードにコピー
alias gbn=gitbranchnameclip
alias gcl="git clean -fd"                                  # 未追跡のファイル/ディレクトリを一撃で削除する


## twty コマンドラインでtwitterに投稿したり見たりする
alias tt=twty


## Jetbrains
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'
alias webs='open -na "WebStorm.app" --args "$@"'
alias rubym='open -na "RubyMine.app" --args "$@"'
alias phps='open -na "PhpStorm.app" --args "$@"'
alias goland='open -na "GoLand.app" --args "$@"'
alias rubym='open -na "RubyMine.app" --args "$@"'
alias clion='open -na "CLion.app" --args "$@"'
alias pych='open -na "PyCharm.app" --args "$@"'
alias appcode='open -na "AppCode.app" --args "$@"'


## パスワードジェネレータ
alias passgen='openssl rand -base64 16 | pbcopy'
alias passgenweak='openssl rand -hex 8 | pbcopy'
alias passgenw=passgenweak


## その他
alias myip="curl https://ipinfo.io/json"    # ipアドレスを取得
alias myhttp="ruby -run -e httpd . -p 8000" # カレントディレクトリを基準にHTTPサーバを起動


## コマンドで話す
### WARNING! 音声を予めダウンロードしておく
alias alex='say -v Alex -r 200 -i '
alias vicky='say -v Vicki -r 200 -i '
alias kyoko='say -v Kyoko -r 200 -i '


## wasp
export PATH=$PATH:$HOME/.local/bin
export WASP_TELEMETRY_DISABLE=1


## libql postgresql client
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"


## add...
