# Alias

# basic
alias vim='vim'
alias vi='nvim'
alias grep='grep --color=auto'
alias clip='pbcopy'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# ls
alias l='ls -ltraG' # 最新ファイルが下に表示される
alias ll='ls -la'
alias ls='ls -G'

# password generater
alias passgen='openssl rand -base64 16 | pbcopy'
alias passgenweak='openssl rand -hex 8 | pbcopy'
alias passgen2='cat /dev/urandom | base64 | fold -w 16 | head -n 1'

