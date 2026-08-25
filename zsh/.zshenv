# ~/.zshenv
# 対話・非対話を問わず全てのzshが読む。ssh経由のコマンド実行やエディタのタスク実行でも
# 効かせたい環境変数(PATH・ロケール・EDITOR)はここに置く。対話用の設定は.zshrcへ。

typeset -U path PATH                  # PATHの重複エントリを自動で除去
export PATH                           # PATHが環境に無い場合、typesetだけだとexport属性が付かない

# brew shellenvはforkが要るので非対話では呼ばず直接組む(FPATH等は対話時に.zshrcが入れ直す)
path=(
  "$HOME/.local/bin"                  # claude等のネイティブインストーラ系
  /opt/homebrew/bin                   # Apple版gitより/opt/homebrew/binのgitを優先させる
  /opt/homebrew/sbin
  $path
  "$HOME/.docker/bin"                 # Docker Desktop
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  "$HOME/opt/go/bin"
)

# ネストしたzshにも毎回読まれるので、`LANG=C zsh -c ...`のような一時的な上書きを潰さない
export LANG=${LANG:-ja_JP.UTF-8}      # LC_ALLは個別のLC_*を上書きしてしまうので使わない
export GOPATH=${GOPATH:-$HOME/opt/go}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export EDITOR=${EDITOR:-nvim}         # git commit等で使うエディタ
export VISUAL=${VISUAL:-$EDITOR}      # EDITORよりVISUALを優先するツール向け
