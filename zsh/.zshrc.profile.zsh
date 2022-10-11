# .zsh_profile
# 個人用のzsh環境を構築

## 初期化
echo "start initializing zsh profile..."

export ZSH_ENV_ALIAS=${HOME}/.zshrc.profile.alias.zsh
export ZSH_ENV_ITERM=${HOME}/.zshrc.profile.iterm.zsh

## Aliasを読み込み
if [ -e ${ZSH_ENV_ALIAS} ]; then
  source ${ZSH_ENV_ALIAS}
else
  echo "${ZSH_ENV_ALIAS} is not found."
fi

## iterm2用の設定を読み込み
if [ -e ${ZSH_ENV_ITERM} ]; then
  source ${ZSH_ENV_ITERM}
else
  echo "${ZSH_ENV_ITERM} is not found."
fi

## zsh設定
export LANG=ja_JP.UTF-8              # 言語設定
export LC_ALL=ja_JP.UTF-8
export HISTFILE=${HOME}/.zsh_history # 履歴ファイルの保存先
export HISTSIZE=1000                 # メモリに保存される履歴の件数
export SAVEHIST=100000               # 履歴ファイルに保存される履歴の件数
setopt share_history                 # 同時に起動したzshの間でヒストリを共有
#setopt auto_param_slash             # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
#setopt mark_dirs                    # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt interactive_comments          # コマンドラインでも # 以降をコメントと見なす
setopt hist_reduce_blanks            # 余分な空白は詰めて記録
setopt hist_expand                   # 補完時にヒストリを自動的に展開

### コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

### zshの補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # zsh補完で小文字でも大文字にマッチさせる
setopt list_packed                                  # zsh補完候補を詰めて表示
setopt no_beep                                      # ビープ音消去

### zsh補完候補一覧をカラー表示
autoload colors
zstyle ':completion:*' list-colors ''

## asdf
. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/libexec/asdf.sh

## brew
# eval "$(/opt/homebrew/bin/brew shellenv)" # 不要になったのでコメントアウト

## kubernetes
#source <(kubectl completion zsh)

## golang
export GOPATH=$HOME/opt/go
if [ ! -e $GOPATH ]; then
  mkdir $GOPATH
fi
export GOPATH=`$(go env GOROOT)/bin`
export PATH="$PATH:$GOPATH"

## lima + docker
export DOCKER_HOST=unix://$HOME/.lima/docker/sock/docker.sock


## nvim
export XDG_CONFIG_HOME="$HOME/.config"

## ghq + peco
export GHQ_ROOT="$HOME/work/"
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src
