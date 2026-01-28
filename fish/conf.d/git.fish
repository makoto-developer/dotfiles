# conf.d/git.fish

# gitconfigのAlias設定で引数が複数ある時の対応方法が分からないので関数を用意
function git_commit_option_m
  git commit -m "$argv"
end

alias gcm='git_commit_option_m'

# Gistをクローンする関数
function gistclone
    # gitclone gist-url gist-name

    set gist_base_dir "$HOME/work/repositories/github.com/makoto-developer/gist"

    # ベースディレクトリが存在しない場合は作成
    test -d "$gist_base_dir"; or mkdir -p "$gist_base_dir"

    # https://gist.github.com/username/${gist_id} という形式のURLからgist_idを抜き取る
    set gist_id (basename "$argv[1]")
    set gist_name "$argv[2]"

    # URLからusernameを抽出（必要に応じて）
    set gist_url "$argv[1]"
    if string match -q "*/gist.github.com/*" "$gist_url"
        # URLから直接クローン
        set clone_url "$gist_url.git"
    else
        # gist_idのみの場合は、デフォルトのユーザー名を使用
        set clone_url "https://gist.github.com/$gist_id.git"
    end

    # ベースディレクトリに移動
    cd "$gist_base_dir"

    git clone "$clone_url" "$gist_name"
    cd "$gist_name"/

    # ignore .swp & .gitignore
    test -f .gitignore; or begin
        echo "# ignore on $argv[1]" >.gitignore
        echo '*.swp' >>.gitignore
        echo ".gitignore" >>.gitignore
    end
end

