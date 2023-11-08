# tools.fish

# 強いパスワードを生成
function genpass
  openssl rand -base64 16 | pbcopy
end

# 弱いパスワードを生成
function genpassweak
  openssl rand -hex 8 | pbcopy
end

