function ghq_fzf_repo -d 'Repository search'
  ghq list --full-path | fzf --reverse --height=100% | read select
  [ -n "$select" ]; and cd "$select"
  echo " $select "
  commandline -f repaint
end


if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__ghq_repository_search'
end

bind \cg 'ghq_fzf_repo'

