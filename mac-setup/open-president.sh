#!/bin/bash
# president用ターミナル起動スクリプト

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PARENT_DIR"
./setup.sh
exec tmux attach-session -t president
