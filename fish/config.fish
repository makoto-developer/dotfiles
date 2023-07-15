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
