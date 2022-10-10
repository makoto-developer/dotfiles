# zsh iterm

## 環境設定
export CLICOLOR=1
export TERM=xterm-256color
export LSCOLORS="GxFxCxDxBxegedabagaced"
export LS_COLORS='di=33;:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'


## itermのタブに名前をつける
functio tab() {
  echo -ne "\e]1;$@ \a"
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

## iterm専用
alias office="changeprofile office"
alias home="changeprofile home"
alias cafe="changeprofile cafe"
home

