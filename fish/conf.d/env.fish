# fish env

# go installしたコマンドを認識させる
set -g GOPATH (go env GOPATH)
fish_add_path $GOPATH/bin
