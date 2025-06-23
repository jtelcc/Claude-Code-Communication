#!/bin/bash
# 自動セットアップスクリプト

set -e

# 作業ディレクトリの絶対パスを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# tmuxセッションの作成
if ! tmux has-session -t president 2>/dev/null; then
  tmux new-session -d -s president
fi
if ! tmux has-session -t multiagent 2>/dev/null; then
  tmux new-session -d -s multiagent
fi

# multiagentのウィンドウを4つ作成
for i in {0..3}; do
  if [ $i -ne 0 ]; then
    tmux new-window -t multiagent
  fi
done

# AppleScriptで新規Terminalウィンドウを2つ開き、自動でセットアップ・起動まで行う
osascript <<EOF
  tell application "Terminal"
    activate
    do script "cd '$PARENT_DIR' && ./setup.sh && tmux send-keys -t president 'cd $PARENT_DIR && claude --dangerously-skip-permissions' C-m && tmux attach-session -t president"
    delay 1
    do script "cd '$PARENT_DIR' && for i in {0..3}; do tmux send-keys -t multiagent.\$i 'cd $PARENT_DIR && claude --dangerously-skip-permissions' C-m; done && tmux attach-session -t multiagent"
  end tell
EOF
