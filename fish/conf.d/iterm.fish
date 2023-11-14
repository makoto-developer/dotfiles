# itermをカスタマイズする関数

function changeBackgroundColor
  switch $argv
    case 'prod'
    case 'prd'
      echo -ne "\033]1337;SetColors=bg=330000\a"
    case 'stg'
      echo -ne "\033]1337;SetColors=bg=003366\a"
    case 'work'
      echo -ne "\033]1337;SetColors=bg=5B0066\a"
    case 'work2'
      echo -ne "\033]1337;SetColors=bg=00665B\a"
    case 'default'
      echo -ne "\033]1337;SetColors=bg=000000\a"
  end
end

alias prod='changeBackgroundColor "prod"'
alias stg='changeBackgroundColor "stg"'
alias work='changeBackgroundColor "work"'
alias work2='changeBackgroundColor "work2"'
alias reset='changeBackgroundColor "default"'

