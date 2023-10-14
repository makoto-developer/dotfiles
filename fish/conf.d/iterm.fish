# itermをカスタマイズする関数

## [Warning] fish shellだとiterm2のタブタイトルを変えられない
## itermのタブに名前をつける
#function tab
#  echo -ne "\033]0;"$args"\007"
#end


## itermのタブのカラーを変更する
function tab_color
  echo -ne "\033]6;1;bg;red;brightness;$argv[1]\a"
  echo -ne "\033]6;1;bg;green;brightness;$argv[2]\a"
  echo -ne "\033]6;1;bg;blue;brightness;$argv[3]\a"
end

alias t_yellow='tab_color 255 255 0'
alias t_blue='tab_color 0 0  255'
alias t_green='tab_color 0 128 128'
alias t_aqua='tab_color 0 255  255'
alias t_red='tab_color 255 0 0'
alias t_pink='tab_color 255 0 255'
alias t_purple='tab_color 128 0 128'
alias t_olive='tab_color 128 128 0'


## バックグランドのカラーを変える
alias b_prod='echo -ne "\033]1337;SetColors=bg=330000\a"'
alias b_stg='echo -ne "\033]1337;SetColors=bg=003366\a"'
alias b_work='echo -ne "\033]1337;SetColors=bg=5B0066\a"'
alias b_work2='echo -ne "\033]1337;SetColors=bg=00665B\a"'


## itermのプロファイルを切り替えるコマンド
#alias changeprofile='echo -e "\033]1337;SetProfile=$argv[1]\a"'

## iterm専用
#alias office="changeprofile office"
#alias home="changeprofile home"
#alias cafe="changeprofile cafe"
#home

