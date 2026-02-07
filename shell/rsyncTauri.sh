echo "tauriの更新処理"



ROOT_DIR="$1"
SRC_DIR="$ROOT_DIR/src"
TAURI_DIR="$ROOT_DIR/project/tauri"

# Svelteファイル同期
rsync -av --delete "$SRC_DIR/svelte/src/" "$TAURI_DIR/src/"

# Rustファイル同期
rsync -av --delete "$SRC_DIR/rust/" "$TAURI_DIR/src-tauri/"

# bridge.ts同期
UNSHARE_BRIDGE="$ROOT_DIR/src/unshare/tauri/"
TAURI_BRIDGE="$ROOT_DIR/project/tauri/src/lib/"
rsync -av --delete "$UNSHARE_BRIDGE" "$TAURI_BRIDGE"

# package.json devDependencies同期
jq '.devDependencies' "$SRC_DIR/svelte/package.json" > /tmp/dev_deps.json
jq --slurpfile devdeps /tmp/dev_deps.json '.devDependencies = $devdeps[0]' "$TAURI_DIR/package.json" > /tmp/package.json && mv /tmp/package.json "$TAURI_DIR/package.json"
if cmp -s "$SRC_DIR/svelte/package.json" "$TAURI_DIR/package.json"; then
  echo "package.jsonに変更はありません。"
else
  echo "package.jsonが変更されました。npm installを実行します..."
  (cd "$TAURI_DIR" && npm install)
fi
rm /tmp/dev_deps.json
