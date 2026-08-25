# ~/.zshrc
# 1ファイル構成(旧.zshrc.profile.*.zshを統合)
# 方針: プラグインマネージャ・フレームワーク(Prezto等)は使わず軽量に保つ

# ================================================================
# Homebrew
# ================================================================
# PATH・ロケール・EDITORは非対話シェルでも要るので.zshenvに置いた。
# ここで再度呼ぶのはFPATH(補完)とHOMEBREW_PREFIX等を入れるためと、
# path_helperが並べ替えたPATHの順序を戻すため。
eval "$(/opt/homebrew/bin/brew shellenv)"
path=("$HOME/.local/bin" $path)        # shellenv内のpath_helperに後ろへ回されるので先頭に戻す

# ================================================================
# 履歴
# ================================================================
HISTFILE=${HOME}/.zsh_history        # 履歴ファイルの保存先(zsh内部変数なのでexportしない)
HISTSIZE=100000                      # メモリに保存される履歴の件数(SAVEHISTと揃える)
SAVEHIST=100000                      # 履歴ファイルに保存される履歴の件数
setopt share_history                 # 同時に起動したzshの間でヒストリを共有
setopt hist_reduce_blanks            # 余分な空白は詰めて記録
setopt hist_ignore_space             # 先頭スペースのコマンドは履歴に残さない
setopt hist_ignore_all_dups          # 同じコマンドは履歴に重複させない
setopt extended_history              # 実行時刻・所要時間も履歴に記録
setopt interactive_comments          # コマンドラインでも # 以降をコメントと見なす

## コマンドを途中まで入力後、Ctrl+p/nでhistoryから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ================================================================
# 色 (LS_COLORSは下の補完のlist-colorsが参照するので、補完より先に定義する)
# ================================================================
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced" # BSD ls用
export LS_COLORS='di=33:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:' # zsh補完/GNU ls用

# ================================================================
# 補完
# ================================================================
# brewの補完(site-functions)は上のbrew shellenvがfpathに入れてくれる
autoload -Uz compinit
# -i: group/other書き込み可の補完ディレクトリは読み込まない(-uは危険な方も全部読む)
compinit -i

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # 大文字小文字を区別せずマッチさせる
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # 補完候補をlsと同じ色分けで表示
setopt list_packed                                  # 補完候補を詰めて表示
setopt no_beep                                      # ビープ音消去

# ================================================================
# ディレクトリ移動
# ================================================================
setopt auto_cd                       # ディレクトリ名だけでcd
setopt auto_pushd                    # cdで移動履歴をスタックに積む(cd - + Tabで遡れる)
setopt pushd_ignore_dups             # 移動履歴の重複は積まない

# ================================================================
# プロンプト (Prezto/agnosterは廃止。gitブランチ表示だけの軽量構成)
# ================================================================
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}(%b|%a)%f'
add-zsh-hook precmd vcs_info         # precmd()を直接定義すると同名を定義する他ツールと潰し合う
setopt prompt_subst
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# ================================================================
# ツール連携
# ================================================================
## mise (バージョン管理ツール)
if command -v mise >/dev/null; then
  eval "$(mise activate zsh)"
fi

## ghq + fzf: Ctrl+g でリポジトリを検索して移動(ghq管理下 + orcaのプロジェクト)
function ghq-fzf() {
  local root selected
  root=$(ghq root)
  selected=$(
    {
      ghq list | while read -r r; do printf '%s\t%s\n' "$r" "$root/$r"; done
      for d in ~/orca/projects/*(N/); do printf 'orca/%s\t%s\n' "${d:t}" "$d"; done
    } | fzf --reverse --prompt="repo > " --delimiter=$'\t' --with-nth=1 --preview 'ls -1 {2}' | cut -f2
  )
  if [ -n "$selected" ]; then
    BUFFER="cd ${(q)selected}"        # スペースを含むパスでcdが壊れないようクォートする
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

## repos: 配下の全gitリポジトリのstatusを一覧(マルチリポジトリの俯瞰用)
function repos() {
  local dir st dirty
  local -a lines
  for dir in */.git(N); do            # worktree/submoduleの.gitはファイルなので(N/)で絞らない
    dir=${dir%/.git}
    lines=(${(f)"$(git -C "$dir" status -sb 2>/dev/null)"}) || continue
    st=${lines[1]}                    # -sbの1行目がブランチ行
    dirty=$(( ${#lines} - 1 ))        # 残りの行数が変更ファイル数
    printf '%-36s %s' "$dir" "$st"
    (( dirty > 0 )) && printf '  [変更%s件]' "$dirty"
    printf '\n'
  done
}

## zoxide: cdの強化版(z <名前の一部>で頻出ディレクトリへジャンプ、ziで一覧から選択)
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

## hstr: Ctrl+r でコマンド履歴を検索
if command -v hstr >/dev/null; then
  alias hh=hstr
  export HSTR_CONFIG=hicolor
  # bindkey -s だと打ちかけの入力がhstrの引数として実行されるので、push-lineで退避する
  hstr-widget() { zle push-line; BUFFER=' hstr --'; zle accept-line }  # 先頭スペースで履歴に残さない
  zle -N hstr-widget
  bindkey '^r' hstr-widget
fi

# ================================================================
# エイリアス
# ================================================================
## base command
alias _='sudo '                      # 末尾スペースで次の語もエイリアス展開させる
alias mk="mkdir"
alias v='nvim'
alias vi='nvim'
alias grep='grep --color=auto'

## Library command
alias nv='nvim'
alias el="elixir"
alias n="npm"
alias k="kubectl"
alias dr="docker"
alias clip='pbcopy'
alias fz='fzf'

## cd系
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

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
alias gcm="git commit -m"
alias gitbranchnameclip="git branch --show-current | clip" # ブランチ名をクリップボードにコピー
alias gbn=gitbranchnameclip
alias gcl="git clean -nd"                                  # 消える対象を確認するだけ(dry-run)
alias gclf="git clean -fd"                                 # 実際に削除する。復元できないのでgclで確認してから

## Jetbrains
# open(1) は LaunchServices 経由の起動になり LANG/LC_ALL を引き継がない。
# 環境変数なしで起動した IDE の launcher は日本語を含むパスの UTF-8 を復号できず、
# "Cannot set current directory to ..." で起動に失敗する。
# アプリのバイナリを直接叩いてシェルの環境をそのまま渡すことで回避する。
_jetbrains() {
  local app=$1 bin=$2 dir
  shift 2
  for dir in "$HOME/Applications" "/Applications"; do
    if [[ -x "$dir/$app.app/Contents/MacOS/$bin" ]]; then
      "$dir/$app.app/Contents/MacOS/$bin" "${@:-$PWD}" >/dev/null 2>&1 &!
      return 0
    fi
  done
  print -u2 "$app.app が見つかりません（~/Applications と /Applications を検索）"
  return 1
}

alias idea='_jetbrains "IntelliJ IDEA" idea'
alias webs='_jetbrains WebStorm webstorm'
alias goland='_jetbrains GoLand goland'
alias datagrip='_jetbrains DataGrip datagrip'
alias rustrover='_jetbrains RustRover rustrover'
alias rubym='_jetbrains RubyMine rubymine'
alias phps='_jetbrains PhpStorm phpstorm'
alias clion='_jetbrains CLion clion'
alias pych='_jetbrains PyCharm pycharm'

## パスワードジェネレータ
# pipefailが無いとopensslの失敗をpbcopyの成功が隠し、空をコピーしたまま成功と表示される
passgen() {
  setopt localoptions pipefail
  openssl rand -base64 16 | pbcopy && echo "パスワードをクリップボードにコピーしました"
}
passgenweak() {
  setopt localoptions pipefail
  openssl rand -hex 8 | pbcopy && echo "パスワード(弱)をクリップボードにコピーしました"
}
alias passgenw=passgenweak

## その他
alias myip="curl https://ipinfo.io/json"    # ipアドレスを取得
alias myhttp="ruby -run -e httpd . -p 8000 --bind-address=127.0.0.1" # カレントディレクトリを配信(LANに露出しないようloopback限定)

## コマンドで話す
### WARNING! 音声を予めダウンロードしておく
alias alex='say -v Alex -r 200 -i '
alias vicky='say -v Vicki -r 200 -i '
alias kyoko='say -v Kyoko -r 200 -i '

# ================================================================
# iTerm2
# ================================================================
## itermのタブに名前をつける
function tab() {
  printf '\e]1;%s \a' "$*"
}

## itermのタブのカラーを変更する
function tab-color() {
  echo -ne "\033]6;1;bg;red;brightness;$1\a"
  echo -ne "\033]6;1;bg;green;brightness;$2\a"
  echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}

alias t_yellow='tab-color 255 255 0'
alias t_blue='tab-color 0 0  255'
alias t_green='tab-color 0 128 128'
alias t_aqua='tab-color 0 255  255'
alias t_red='tab-color 255 0 0'
alias t_pink='tab-color 255 0 255'
alias t_purple='tab-color 128 0 128'
alias t_olive='tab-color 128 128 0'

## バックグランドのカラーを変える
alias b_prod='echo -ne "\033]1337;SetColors=bg=330000\a"'
alias b_stg='echo -ne "\033]1337;SetColors=bg=003366\a"'
alias b_work='echo -ne "\033]1337;SetColors=bg=5B0066\a"'
alias b_work2='echo -ne "\033]1337;SetColors=bg=00665B\a"'

## itermのプロファイルを切り替えるコマンド
alias changeprofile='(){echo -e "\033]1337;SetProfile=$1\a"}'
alias office="changeprofile office"
alias home="changeprofile home"
alias cafe="changeprofile cafe"

## iterm起動時はhomeプロファイルを適用
# ※エイリアスはifブロック内(同一解釈単位)では展開されないため、直接エスケープシーケンスを出す
if [ -n "$ITERM_SESSION_ID" ]; then
  printf '\033]1337;SetProfile=home\a'
fi

# ================================================================
# プラグイン (brew install zsh-autosuggestions zsh-syntax-highlighting)
# ================================================================
## fish風の入力候補表示(→キーで確定)
if [ -e /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ================================================================
# ローカル設定
# ================================================================
# このリポジトリは公開しているため、APIキー等のシークレットとマシン固有の設定は
# gitで追跡しない~/.zshrc.localに書く(.gitignoreで除外済み)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ================================================================
# コマンドの色付け (存在しないコマンドは赤く表示)
# ================================================================
# ※.zshrc.localで定義したbindkey/zle widgetも拾えるよう、必ず最後にsourceする
if [ -e /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

