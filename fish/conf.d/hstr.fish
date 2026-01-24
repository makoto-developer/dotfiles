alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
#shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=10000            # increase history size (default is 500)
# ensure synchronization between bash memory and history file
#export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# Ctrl + rでコマンドのヒストリを検索
#if bind -M insert >/dev/null ^/dev/null
  bind -M insert \cr hstr --
#end


