# ~/.zprofile
# ログインシェルで一度だけ読まれる。macOSは/etc/zprofileのpath_helperがPATHを組み直し、
# システムパスを先頭に出してしまうので、.zshenvで決めた優先順をここで復元する。
# (PATHの中身自体は.zshenvが持つ。ここは順序の修復だけ)

path=("$HOME/.local/bin" /opt/homebrew/bin /opt/homebrew/sbin $path)
