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
    
    # fish colors
    export LSCOLORS=gxfxcxdxbxegedabagacad

    # agnoster theme
    set -g theme_nerd_fonts yes

    # asdf
    source /usr/local/opt/asdf/libexec/asdf.fish

    # go installしたコマンドを認識させる
    set -g GOPATH (go env GOPATH)
    fish_add_path $GOPATH/bin

    # flutter
    set -g FLUTTERPATH $HOME/fvm/default
    fish_add_path $FLUTTERPATH/bin

    # pnpm
    set -gx PNPM_HOME "/Users/user/Library/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
      set -gx PATH "$PNPM_HOME" $PATH
    end

    # pnpm
    set -gx PNPM_HOME "/Users/user/Library/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
      set -gx PATH "$PNPM_HOME" $PATH
    end
end


