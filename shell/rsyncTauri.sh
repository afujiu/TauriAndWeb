echo "Tauriを同期"
ROOT_DIR="$1"
SRC_DIR="$ROOT_DIR/src"
TAURI_DIR="$ROOT_DIR/project/tauri"

if [ -d "$SRC_DIR/svelte/src/" ]; then
  rsync -av --delete "$SRC_DIR/svelte/src/" "$TAURI_DIR/src/"
else
  echo "Error: Source directory $SRC_DIR/svelte/src/ does not exist."
  exit 1
fi

# Rustファイル同期
rsync -av --delete "$SRC_DIR/rust/api/" "$TAURI_DIR/src-tauri/src/"
rsync -av --delete "$ROOT_DIR/src/unshare/tauri/bridge.ts" "$ROOT_DIR/project/tauri/src/lib/bridge.ts"

# package.json devDependencies同期
# jq '.devDependencies' "$SRC_DIR/svelte/package.json" > /tmp/dev_deps.json
# jq --slurpfile devdeps /tmp/dev_deps.json '.devDependencies = $devdeps[0]' "$TAURI_DIR/package.json" > /tmp/package.json && mv /tmp/package.json "$TAURI_DIR/package.json"
rm /tmp/dev_deps.json
