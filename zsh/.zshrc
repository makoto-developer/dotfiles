# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

## Customize to your needs...

#**自分のカスタマイズしたプロファイルをロード**
ZSH_MY_PROFILE=~/.zshrc.profile.zsh
if [[ -s ${ZSH_MY_PROFILE} ]]; then
  source ${ZSH_MY_PROFILE}
fi


# #や^が使えなくなる問題が発生しているので一旦無効
setopt NO_EXTENDED_GLOB


# コマンドの結果が出力されなくなる問題を修正
setopt prompt_cr
setopt prompt_sp

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
