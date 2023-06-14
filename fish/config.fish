function fish_user_key_bindings
    bind \cw peco_select_history
end

if status is-interactive
    #view
    set -g theme_display_date yes
    set -g theme_date_format "+%F %H:%M"
    set -g theme_display_git_default_branch yes
    set -g theme_color_scheme terminal-dark
    set -g fish_prompt_pwd_dir_length 0 # プロンプトのディレクトリ名を省略させない
    set -g fish_prompt_pwd_full_dirs 0 # プロンプトのディレクトリ名を省略させない
    
    #path
    source /usr/local/opt/asdf/libexec/asdf.fish
    set PATH ~/.asdf/shims $PATH

    # Alias
    ## base command
    alias mk="mkdir"
    alias v='vim'
    alias vi='vim'
    alias grep='grep --color=auto'
    alias clip='pbcopy'
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
    alias gcm="git commit -m $argv"
    alias gps="git push"
    alias gco="git checkout"
    alias gcob="git checkout -b"
    alias gd="git diff"
    alias gitbranchnameclip="git branch --show-current | clip" # ブランチ名をクリップボードにコピー
    alias gbn=gitbranchnameclip
    alias gcl="git clean -fd"                                  # 未追跡のファイル/ディレクトリを一撃で削除する
    
    ## パスワードジェネレータ
    alias passgen='openssl rand -base64 16 | pbcopy'
    alias passgenweak='openssl rand -hex 8 | pbcopy'
    alias passgenw=passgenweak
    
    
    ## その他
    alias myip="curl https://ipinfo.io/json"    # ipアドレスを取得
    alias myhttp="ruby -run -e httpd . -p 8000" # カレントディレクトリを基準にHTTPサーバを起動
    
    
    ## コマンドで話す
    ### 音声を予めダウンロードしておくこと!
    alias alex='say -v Alex -r 200 -i @argv'
    alias vicky='say -v Vicki -r 200 -i @argv'
    alias kyoko='say -v Kyoko -r 200 -i @argv'

    # fish colors
    export LSCOLORS=gxfxcxdxbxegedabagacad

    # agnoster theme
    set -g theme_nerd_fonts yes


end

function ghq_fzf_repo -d 'Repository search'
  ghq list --full-path | fzf --reverse --height=100% | read select
  [ -n "$select" ]; and cd "$select"
  echo " $select "
  commandline -f repaint
end

# fish key bindings
function fish_user_key_bindings
  bind \cg ghq_fzf_repo
end


function ghq_fzf_repo -d 'Repository search'
  ghq list --full-path | fzf --reverse --height=100% | read select
  [ -n "$select" ]; and cd "$select"
  echo " $select "
  commandline -f repaint
end

# fish key bindings
function fish_user_key_bindings
  bind \cg ghq_fzf_repo
end
