#!/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"
SRC_DIR="$ROOT_DIR/src"
WEB_DIR="$ROOT_DIR/project/web"
TAURI_DIR="$ROOT_DIR/project/tauri"

echo "1. tauri同期"
"$ROOT_DIR/shell/rsyncTauri.sh" "$ROOT_DIR"

echo "3.tauri起動"
(cd "$TAURI_DIR" && npm run tauri dev &)
TAURI_PID=$!

echo "4. web同期"
"$ROOT_DIR/shell/rsyncWeb.sh" "$ROOT_DIR"

# fswatchがインストールされているか確認
if ! command -v fswatch >/dev/null 2>&1; then
	[ -n "$TAURI_PID" ] && kill "$TAURI_PID" 2>/dev/null
	exit 1
fi

trap '[ -n "$TAURI_PID" ] && kill "$TAURI_PID" 2>/dev/null' EXIT
echo "src検知"

# srcの変更を検知
fswatch -o "$SRC_DIR" | while read; do
	echo "更新検知"
	"$ROOT_DIR/shell/rsyncTauri.sh" "$ROOT_DIR"
	"$ROOT_DIR/shell/rsyncWeb.sh" "$ROOT_DIR"
done
