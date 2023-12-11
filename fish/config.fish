function fish_user_key_bindings
    bind \cw peco_select_history
end

if status is-interactive
    #view
    set -g fish_prompt_pwd_dir_length 0 # プロンプトのディレクトリ名を省略させない
    set -g fish_prompt_pwd_full_dirs 0 # プロンプトのディレクトリ名を省略させない
    
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

    # dotnetは一旦使わなくなったので除外
    #set -gx DOTNET_ROOT "$HOME/dotnet"
    #set -gx PATH "$DOTNET_ROOT" $PATH
end


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/user/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

