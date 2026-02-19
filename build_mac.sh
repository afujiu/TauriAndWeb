#!/bin/bash
# tauri と web の両方をビルドするシェルスクリプト
ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"

echo "macのアプリを作成"

cd "$ROOT_DIR/project/tauri/"
npm run tauri build
rm -rf "$ROOT_DIR/dist/app/mac/*"
mv "$ROOT_DIR/project/tauri/src-tauri/target/release/bundle/dmg/tauri_0.1.0_aarch64.dmg" "$ROOT_DIR/dist/app/mac/app.dmg"

echo "docker作成"
rm -rf "$ROOT_DIR/dist/web/*"
mkdir "$ROOT_DIR/dist/web/docker"
cp -rfp "$ROOT_DIR/project/web/" "$ROOT_DIR/dist/web/docker"
cp -rfp "$ROOT_DIR/dist/docker-compose.yml" "$ROOT_DIR/dist/web/docker/docker-compose.yml"
echo "zip化"
if [ -d "$ROOT_DIR/dist/web/docker" ]; then
	zip -r "$ROOT_DIR/dist/web/docker.zip" "$ROOT_DIR/dist/web/docker"
	rm -rf "$ROOT_DIR/dist/web/docker"
else
	echo "$ROOT_DIR/dist/web/docker フォルダが存在しません。"
fi

