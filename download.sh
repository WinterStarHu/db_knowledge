#!/bin/bash
BRANCH=$1
REPO="git@github.com:WinterStarHu/db-knowledge.git"
if [ "$BRANCH" = "all" ]; then
  for b in $(git ls-remote --heads $REPO | awk '{print $2}' | sed 's|refs/heads/||'); do
    git clone -b "$b" --depth 1 "$REPO" "db-knowledge-$b"
  done
else
  git clone -b "$BRANCH" --depth 1 "$REPO" "db-knowledge-$BRANCH"
fi
