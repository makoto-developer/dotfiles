---
name: retro
description: 直近1週間（デフォルト）の作業を git 履歴と Claude Code のセッションログから裏どりして分析し、週次レトロスペクティブのネタを生成する。「レトロ」「振り返り」「今週何やった」と言われた時や、週次の振り返り前に使う。
argument-hint: "[日数 or 開始日(YYYY-MM-DD)。省略時は7日]"
allowed-tools: Bash, Read, Grep, Glob, Write
---

# 週次レトロスペクティブ分析スキル

自分では意識せずに残っている「作業の痕跡」（git コミット、Claude Code のセッションログ）を裏どりし、
レトロの素材（完了したこと・詰まった点・うまくいった工夫・改善案）を客観的な証拠付きで生成する。

## 対象期間の決定

- 引数が数値なら「その日数前〜今日」。日付(YYYY-MM-DD)ならその日〜今日。省略時は **7日**。
- 以降、この期間を `SINCE`（例: `7 days ago` または `2026-07-18`）として使う。

## 1. git 履歴の裏どり（客観的な「やったこと」）

`ghq root` 配下の全リポジトリを対象に、ユーザー本人のコミットを集計する。

```bash
GHQ_ROOT="$(ghq root)"
AUTHOR="makoto-developer"        # git のユーザー名／メールに合わせる
SINCE="7 days ago"               # 引数に応じて置き換える

ghq list -p | while read -r repo; do
  cd "$repo" || continue
  logs=$(git log --author="$AUTHOR" --since="$SINCE" --pretty='%ad %h %s' --date=short 2>/dev/null)
  [ -n "$logs" ] && { echo "### $(basename "$repo")"; echo "$logs"; \
    echo "  (変更規模) $(git log --author="$AUTHOR" --since="$SINCE" --shortstat --pretty=oneline 2>/dev/null \
      | grep -Eo '[0-9]+ (insertion|deletion)' | awk '{s+=$1} END{print s" 行変更"}')"; }
done
```

ここから以下を読み取る：
- **リポジトリ別のコミット本数・変更行数** → どこに時間を使ったか
- **同一ファイルへの連続コミット / revert / "fix"・"wip"・"やり直し" を含むメッセージ** → 詰まった箇所の候補
- **稼働日数**（コミットのあった日）→ 稼働リズム

## 2. Claude Code セッションログの裏どり（「詰まり」と「工夫」）

git に残らない試行錯誤は Claude のログに出る。

- `~/.claude/history.jsonl` … ユーザー入力の履歴。期間内のプロンプトから**扱ったテーマ・繰り返し聞き直した論点**を拾う。
- `~/.claude/projects/<エンコードされたcwd>/*.jsonl` … セッション transcript。以下のシグナルを詰まりの証拠として数える：
  - 同種のツール呼び出しの連続リトライ、エラー出力（`Error`, `failed`, `Exit code` 等）
  - 同じ話題での長い往復（メッセージ数が多いセッション）
  - ユーザーからの訂正・「違う」「やり直して」等のフィードバック → うまくいかなかった指示の型

```bash
# 期間内に更新された transcript を対象にする（mtime ベース）
find ~/.claude/projects -name '*.jsonl' -mtime -7 2>/dev/null | while read -r f; do
  errs=$(grep -icE '"(is_error|isError)":true|Exit code [1-9]|Error:|failed' "$f" 2>/dev/null)
  echo "$errs  $f"
done | sort -rn | head -20
```

**注意:** transcript は量が多い。全文は読まず、上記で当たりを付けた上位ファイルだけを部分的に読む。トークンを浪費しない。

## 3. 分析して素材化

裏どりした事実だけを根拠に、以下を組み立てる。**推測で埋めず、証拠（コミットハッシュ／ファイル名／エラー種別）を添える。**

- **完了したこと** — git コミットを機能単位でまとめる（リポジトリ・件数付き）
- **詰まった点** — 証拠（連続リトライ／revert／エラー種別／訂正の往復）とセットで。なぜ詰まったかの仮説を1行添える
- **うまくいった工夫** — 少ない試行で解けた／再利用できた／自動化できた箇所
- **数値サマリ** — 稼働日数・総コミット数・変更行数・主戦場リポジトリ
- **来週への改善案** — 詰まりパターンから導ける具体的アクション（1〜3個）

## 4. 出力

- 上記を Markdown で `~/.claude/journal/retro-<今日の日付>.md` に書き出す（`journal/` が無ければ作成）。
- 同じ内容の要約を会話にも表示する。
- レトロ本番用に、そのまま話せる「3行サマリ（今週の一番の成果／一番の詰まり／来週の一手）」を末尾に付ける。

## ルール

- 事実の裏どりを最優先する。git・ログに根拠がない項目は「未確認」と明示し、断定しない。
- transcript の全文読み込み禁止。シグナルで絞ってから部分的に読む。
- ネガティブな指摘（詰まり）も、非難ではなく次の改善につながる形で書く。
