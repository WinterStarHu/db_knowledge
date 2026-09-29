#!/bin/bash
# setup-worktree.sh — 按需拉取单个分支到 worktree(不全量 fetch,避免索引灾难)
# 用法: bash setup-worktree.sh oracle-19c
set -e
BRANCH="$1"
[ -z "$BRANCH" ] && { echo "用法: bash setup-worktree.sh <分支名>"; exit 1; }
[ "$BRANCH" = "main" ] && { echo "main 不需要 worktree"; exit 1; }
[ "$BRANCH" = "all" ] && { echo "不支持全量(避免索引灾难)。逐个拉: bash setup-worktree.sh oracle-19c"; exit 1; }
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DIR="$REPO_DIR/../db-knowledge-${BRANCH}"
[ -d "$DIR" ] && { echo "已存在: $DIR"; exit 0; }
git fetch origin "$BRANCH" --depth 1
git worktree add --no-track "$DIR" "FETCH_HEAD" -B "$BRANCH"
echo "完成: $DIR (分支 $BRANCH)"
git worktree list
