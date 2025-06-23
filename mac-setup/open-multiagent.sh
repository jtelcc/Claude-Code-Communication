#!/bin/bash
# multiagent用ターミナル起動スクリプト

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$SCRIPT_DIR"
for i in {0..3}; do
  tmux send-keys -t multiagent.$i "cd $PARENT_DIR && claude --dangerously-skip-permissions" C-m
done
exec tmux attach-session -t multiagent
