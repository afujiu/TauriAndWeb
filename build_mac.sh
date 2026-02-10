#!/bin/bash
# tauri と web の両方をビルドするシェルスクリプト
ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"
echo "macのdistファイルを生成"
cd "$ROOT_DIR/project/tauri/"
npm run tauri build
rm -rf "$ROOT_DIR/dist/app/mac/*"
echo "圧縮"
mv "$ROOT_DIR/project/tauri/src-tauri/target/release/bundle/dmg/tauri_0.1.0_aarch64.dmg" "$ROOT_DIR/dist/app/mac/app.dmg"