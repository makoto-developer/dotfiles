# tools.fish

# 強いパスワードを生成
function genpass
  openssl rand -base64 16 | pbcopy
end

# 弱いパスワードを生成
function genpassweak
  openssl rand -hex 8 | pbcopy
end

# ipアドレスを取得
alias myip='curl https://ipinfo.io/json'

# カレントディレクトリを基準にHTTPサーバを起動
alias myhttp='ruby -run -e httpd . -p 8000'

