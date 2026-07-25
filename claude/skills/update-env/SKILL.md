---
name: update-env
description: 開発環境(brew/mise/nvimプラグイン/gh拡張)をまとめて更新し、動作検証してからコミットを提案する。「環境を更新して」と言われた時や月次メンテで使う。
---

# 開発環境の一括アップデート

brew・mise・nvimプラグイン・gh拡張を更新し、壊れていないことを検証した上で、
dotfilesに入るべき差分(lazy-lock.json等)のコミットを提案する。

## 原則

- **更新 → 検証 → 報告**をワンセットにする。検証せずに「更新しました」で終わらない
- 何をどのバージョンからどのバージョンへ上げたかを最後にまとめて報告する
- 検証で問題が見つかったら、そこで止めて報告する(勝手に先へ進まない)
- sudoやパスワード入力が必要なもの(一部のcask等)はユーザー自身のターミナルでの実行を依頼する

## 手順

### 1. 更新

```shell
# Homebrew(何が上がるか先に確認してから実行)
brew update && brew outdated
brew upgrade
brew cleanup

# mise管理のツール(elixir/erlang/node/go/rust等)
mise upgrade

# nvimプラグイン(lazy-lock.jsonが更新される)
nvim --headless "+Lazy! sync" +qa

# treesitterパーサ
nvim --headless "+TSUpdate" +qa

# gh拡張(gh-dash等)
gh extension upgrade --all
```

### 2. 検証(必ずやる)

```shell
# zshが正常に起動するか
zsh -ic 'echo ok'

# nvimがエラーなく起動するか(エラーがあれば標準エラーに出る)
nvim --headless "+lua vim.defer_fn(function() print('boot ok'); vim.cmd('qa!') end, 3000)"

# 言語ツールチェーンが生きているか
elixir --version && node -v && go version

# git署名が生きているか(gitはbrewで上がることがある)
git -C ~/dotfiles log --show-signature -1 --oneline
```

- nvimの起動でエラーが出たら`:checkhealth`相当の調査をして原因を特定する
- プラグイン更新で壊れた場合は`~/dotfiles/vim/nvim/lazy-lock.json`をgitで戻し、
  `nvim --headless "+Lazy! restore" +qa`で更新前の状態にロールバックできる

### 3. コミット提案

```shell
cd ~/dotfiles && git status --short
```

- `lazy-lock.json`等に差分があれば内容を要約して見せ、コミットするか確認する
- コミットメッセージ例: `プラグイン・ツールの定期更新`

### 4. 報告

- 更新されたもの(主要なバージョン変化)
- 検証結果(すべてOKか、問題と対処)
- ユーザー対応が必要な残件(sudoが必要だったcask等)
