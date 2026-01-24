# itermをカスタマイズする関数

function changeBackgroundColor
  switch $argv
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

alias prd='changeBackgroundColor "prd"'
alias stg='changeBackgroundColor "stg"'
alias work='changeBackgroundColor "work"'
alias work2='changeBackgroundColor "work2"'
alias reset='changeBackgroundColor "default"'

# タイトルバーを設定する関数
# カスタムタイトル用のグローバル変数
set -g ITERM_CUSTOM_TITLE ""
set -g ITERM_CUSTOM_TAB_TITLE ""
set -g ITERM_CUSTOM_WINDOW_TITLE ""

# fish_titleをオーバーライド
function fish_title
  if test -n "$ITERM_CUSTOM_TITLE"
    echo $ITERM_CUSTOM_TITLE
  else if test -n "$ITERM_CUSTOM_TAB_TITLE" -o -n "$ITERM_CUSTOM_WINDOW_TITLE"
    # 個別設定がある場合はデフォルト動作を抑制
    return
  else
    # デフォルト: カレントディレクトリ名
    basename (pwd)
  end
end

function setTitle
  if test (count $argv) -eq 0
    echo "Usage: setTitle <title>"
    return 1
  end
  set -g ITERM_CUSTOM_TITLE "$argv"
  set -g ITERM_CUSTOM_TAB_TITLE ""
  set -g ITERM_CUSTOM_WINDOW_TITLE ""
  echo -ne "\033]0;$argv\a"
end

function setTabTitle
  if test (count $argv) -eq 0
    echo "Usage: setTabTitle <title>"
    return 1
  end
  set -g ITERM_CUSTOM_TAB_TITLE "$argv"
  echo -ne "\033]1;$argv\a"
end

function setWindowTitle
  if test (count $argv) -eq 0
    echo "Usage: setWindowTitle <title>"
    return 1
  end
  set -g ITERM_CUSTOM_WINDOW_TITLE "$argv"
  echo -ne "\033]2;$argv\a"
end

function resetTitle
  set -g ITERM_CUSTOM_TITLE ""
  set -g ITERM_CUSTOM_TAB_TITLE ""
  set -g ITERM_CUSTOM_WINDOW_TITLE ""
  echo -ne "\033]0;"(basename (pwd))"\a"
end
