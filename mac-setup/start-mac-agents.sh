#!/bin/bash

# 自動セットアップスクリプト

# スクリプトの実行を停止する条件
set -e

# 環境構築
# ../setup.sh を実行して環境を構築
../setup.sh

# president画面を開いてAIを起動
# president用セッションを新規作成
if ! tmux has-session -t president 2>/dev/null; then
  tmux new-session -d -s president
fi

# AppleScriptでpresident画面（tmux attach-session -t president）を開く
osascript <<EOF
  tell application "Terminal"
    activate
    do script "tmux attach-session -t president"
  end tell
EOF

# presidentセッションでClaudeを起動（Claude-Code-Communicationディレクトリで起動）
tmux send-keys -t president 'cd .. && claude --dangerously-skip-permissions' C-m

# multiagentたちを一括起動
# multiagent用セッションを新規作成し、各ウィンドウでClaudeを起動（Claude-Code-Communicationディレクトリで起動）
if ! tmux has-session -t multiagent 2>/dev/null; then
  tmux new-session -d -s multiagent
fi
for i in {0..3}; do
  if [ $i -ne 0 ]; then
    tmux new-window -t multiagent
  fi
  tmux send-keys -t multiagent:$i 'cd .. && claude --dangerously-skip-permissions' C-m
done

# AppleScriptでmultiagent画面（tmux attach-session -t multiagent）を開く
osascript <<EOF
  tell application "Terminal"
    activate
    do script "tmux attach-session -t multiagent"
  end tell
EOF

# 自動セットアップ完了

# このスクリプトを実行していたターミナルウィンドウを自動で閉じる（macOS Terminal専用）
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
  osascript -e 'tell application "Terminal" to close (every window whose frontmost is true and visible is true)'
fi
