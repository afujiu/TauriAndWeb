
# /project/tauriを「npm run tauri dev」で起動
# /src下のファイルが更新されることを監視する
# ファイルが更新されたら以下の処理を行う
# /project/tauri内のsvelteのファイルを/src/svelteの各種ファイル・フォルダに置き換え
# /project/tauri内のrustのファイル群を/src/rustのファイル群お設定に置き換え

#!/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"
SRC_DIR="$ROOT_DIR/src"
TAURI_DIR="$ROOT_DIR/project/tauri"

# 1. Tauriアプリをバックグラウンドで起動
(cd "$TAURI_DIR" && npm run tauri dev &)

TAURI_PID=$!
 # 1_1. Web起動 /project/webのrustをバックグラウンドで起動
(cd "$ROOT_DIR/project/web" && cargo run &)

TAURI_PID=$!


# 2. 初回同期
"$ROOT_DIR/shell/rsyncTauri.sh" "$ROOT_DIR"


# 3. /src配下の変更を監視し、変更があれば同期
# 終了時にTauriプロセスも終了
# fswatchがインストールされているか確認
if ! command -v fswatch >/dev/null 2>&1; then
  echo "fswatchがインストールされていません。インストールしてください。"
  [ -n "$TAURI_PID" ] && kill "$TAURI_PID" 2>/dev/null
  exit 1
fi

trap '[ -n "$TAURI_PID" ] && kill "$TAURI_PID" 2>/dev/null' EXIT

fswatch -o "$SRC_DIR" | while read; do
  echo "[dev.sh] /src配下の変更を検知、project/tauriに同期します..."
  "$ROOT_DIR/shell/rsyncTauri.sh" "$ROOT_DIR"
  # Svelteのビルドと成果物のコピー
  echo "[dev.sh] Svelteをビルドし、成果物を/project/web/frontにコピーします..."
  rsync -av --delete "$SRC_DIR/svelte/build/" "$ROOT_DIR/project/web/front/"
  (cd "$SRC_DIR/svelte" && npm run build)
done