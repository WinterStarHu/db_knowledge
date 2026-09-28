#!/bin/bash
set -e
BRANCH="$1"
[ -z "$BRANCH" ] && { echo "用法: bash setup-worktree.sh <分支名>"; exit 1; }
[ "$BRANCH" = "main" ] && { echo "main 不需要 worktree"; exit 1; }
[ "$BRANCH" = "all" ] && { echo "不支持全量(避免索引灾难)。逐个拉: bash setup-worktree.sh oracle-23ai"; exit 1; }
cd "$(dirname "$0")"
DIR="../db-knowledge-${BRANCH}"
[ -d "$DIR" ] && { echo "已存在: $DIR"; exit 0; }
git fetch origin "$BRANCH" --depth 1
git worktree add --no-track "$DIR" "FETCH_HEAD" -B "$BRANCH"
echo "完成: $DIR"
git worktree list
