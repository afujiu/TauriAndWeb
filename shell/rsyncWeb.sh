echo "webを同期"
ROOT_DIR="$1"
SRC_DIR="$ROOT_DIR/src/svelte/"
SVELTE_DIR="$ROOT_DIR/project/svelte/"
WEB_DIR="$ROOT_DIR/project/web/"

echo "rust更新"
rsync -av --delete "$ROOT_DIR/src/rust/api/" "$ROOT_DIR/project/web/src/api/" 
echo "svelte更新"
rsync -av --delete "$SRC_DIR" "$SVELTE_DIR"
echo "svelte ビルド"
(cd "$SVELTE_DIR" && npm run build)
echo "WEB起動"
(cd "$WEB_DIR" && cargo run &)
echo "起動済み"
