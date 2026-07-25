---
name: go-workspace
description: 複数のGoモジュール(マイクロサービス)があるディレクトリでgo.workを生成し、goplsを1インスタンスに統合してサービス横断の定義ジャンプを可能にする。「サービスをまたいでコードを読みたい」「goplsが重い」時に使う。
---

# Goマルチモジュールworkspaceのセットアップ

サービスごとに`go.mod`が分かれているリポジトリで、**goplsを1インスタンスに統合**する。

## なぜ必要か

go.modごとにgoplsが別インスタンスで起動する。サービスが40個あれば最大40プロセス(各数百MB〜1GB)。
さらに深刻なのは**サービスAからサービスBの定義へジャンプできない**こと。各サービスが孤島になる。

`go.work`を置くと、goplsが全モジュールを1つのワークスペースとして扱い、
**1インスタンスでサービス横断の定義ジャンプ・参照検索が通る**ようになる。

## 手順

### 1. 現状を確認する

```shell
# モジュール数を数える(vendorは除く)
find . -name go.mod -not -path "*/vendor/*" | wc -l
find . -name go.mod -not -path "*/vendor/*" | head -20

# 既にgo.workがあれば何もしなくてよい
ls go.work 2>/dev/null
```

- モジュールが1個しかなければこのスキルは不要。その旨を伝えて終了する
- Goのバージョンが1.18未満ならgo.workは使えない(`go version`で確認)

### 2. go.workを生成する

```shell
go work init
go work use $(find . -name go.mod -not -path "*/vendor/*" -exec dirname {} \;)
```

- モジュール数が多い(50超)場合は、全部入れるとgoplsのインデックスが重くなる。
  その時は**実際に読むサービスだけ**を選んで`go work use`するようユーザーに確認する

### 3. リポジトリを汚さないようにする

`go.work`はローカル開発用なのでコミットしない。**リポジトリの`.gitignore`は書き換えず**、
グローバルのgitignoreに追加する(他人・他社のリポジトリでも安全)。

```shell
# dotfilesのグローバルgitignoreに追記(既に入っていれば何もしない)
grep -q '^go.work' ~/dotfiles/git/.gitignore_global || \
  printf 'go.work\ngo.work.sum\n' >> ~/dotfiles/git/.gitignore_global

# 反映確認(untrackedに出ないこと)
git status --short | grep go.work
```

### 4. 動作確認

```shell
go work edit -json | head -20   # 登録されたモジュール一覧
go build ./... 2>&1 | head      # ビルドが壊れていないか(エラーが出たら報告する)
```

nvimで確認する場合は、異なるサービスのGoファイルを2つ開いて
LSPクライアントが**1つ**になっていること(統合前は2つ)を確認する。

### 5. 報告

- 統合したモジュール数
- goplsが1インスタンスになったこと
- サービス横断の定義ジャンプ(`sd`)が使えるようになったこと
- `go.work`はグローバルgitignoreで除外済み(コミットされない)であること

## 注意

- `go work use`したモジュール同士は、ローカルのコードが優先される(依存の実体が変わる)。
  **ビルドやテストの結果がCIと変わる可能性**があるので、挙動が怪しい時は`GOWORK=off`を付けて確認する
- サービスを追加・削除したら`go work use <dir>` / `go work edit -dropuse <dir>`で更新する
