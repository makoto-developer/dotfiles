# conf.d/git.fish

# gitconfigのAlias設定で引数が複数ある時の対応方法が分からないので関数を用意
function git_commit_option_m
  git commit -m "($argv)"
end

alias gcm='git_commit_option_m'

