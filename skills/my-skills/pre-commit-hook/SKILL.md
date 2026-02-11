---
name: pre-commit-hook
description: Safely introduce or update pre-commit hooks with minimal checks, respect existing hook setups, and provide clear failure remediation.
---

# Pre-Commit Hook

## 目的
リポジトリの pre-commit hook を安全に導入・更新し、コミット前の品質チェックを自動化する。

## 期待する動作
- 既存の運用（`.pre-commit-config.yaml`、`core.hooksPath`、独自フック）を確認してから作業する。
- 追加するチェックは最小限・低コストに留め、既存の lint/test 方針と整合させる。
- 失敗時は原因と修正手順を短く提示する。

## 典型タスク
- `pre-commit` 導入・更新
- `.pre-commit-config.yaml` の作成/整理
- `pre-commit run --all-files` の実行
- 失敗した hook の原因調査と修正提案

## 手順（推奨）
1. 既存設定の有無を確認  
   - `.pre-commit-config.yaml` / `.git/hooks/pre-commit` / `.git/config` の `core.hooksPath`
2. 依存の確認  
   - `pre-commit --version` が通るか  
   - ない場合は導入手順を提示（macOS: `brew install pre-commit` など）
3. 設定が無い場合は最小構成から追加  
   - 使われている言語・ツールに合わせて選定  
4. インストール  
   - `pre-commit install`  
5. 初回実行  
   - `pre-commit run --all-files`  
6. 失敗時の対応  
   - どの hook が失敗したか、修正箇所、再実行コマンドを明示  
7. 更新  
   - `pre-commit autoupdate` を必要時に案内

## 最小構成例（必要時のみ）
```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: a0b1c2d3... # v4.6.0
    hooks:
      - id: end-of-file-fixer
      - id: trailing-whitespace
```

## 注意点
- 既存フックや CI と重複する重いチェック（長時間のテスト等）は避ける。
- repo に合わせて `language_version` や `files` の範囲を最小化する。
- 導入前に必ずユーザーの意図（品質チェックの範囲）を確認する。
- 可能な限り repo-based hooks を優先し、local hooks は必要最小限に留める。
- すべての hooks で `rev` はコミットハッシュにタグのコメントをつけたものにすること。 `git ls-remote` などを使用して取得できる。
