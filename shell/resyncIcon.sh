
ROOT_DIR="$1"
ICON_SRC="$ROOT_DIR/src/init/icon.png"
ICON_SVG_SRC="$ROOT_DIR/src/init/icon.svg"
ICON_DST_DIR="$ROOT_DIR/project/tauri/src-tauri/icons"
ICON_ICO="$ICON_DST_DIR/icon.ico"

# icon.pngからicon.icoを生成して同期
if command -v magick >/dev/null 2>&1; then
	echo "magick"
	magick "$ICON_SRC" -define icon:auto-resize=64,128,256 "$ICON_ICO"
	echo "$ICON_ICO を生成・同期しました。(magick)"
elif command -v convert >/dev/null 2>&1; then
	echo "convert"
	convert "$ICON_SRC" -define icon:auto-resize=64,128,256 "$ICON_ICO"
	echo "$ICON_ICO を生成・同期しました。(convert)"
else
	echo "ImageMagickのmagickまたはconvertコマンドが必要です。インストールしてください。"
fi


# icon.png から icon.icns を生成して同期
ICNS_OUT="$ICON_DST_DIR/icon.icns"
if command -v magick >/dev/null 2>&1; then
	magick "$ICON_SRC" "$ICNS_OUT"
	echo "$ICNS_OUT を生成・同期しました。(magick)"
elif command -v convert >/dev/null 2>&1; then
	convert "$ICON_SRC" "$ICNS_OUT"
	echo "$ICNS_OUT を生成・同期しました。(convert)"
else
	echo "ImageMagickのmagickまたはconvertコマンドが必要です。インストールしてください。"
fi


# src/svelte/src/lib/assets/favicon.svgもicon.pngから生成・同期
LIB_FAVICON_SVG="$ROOT_DIR/src/svelte/src/lib/assets/"
cp -f "$ICON_SVG_SRC" "$LIB_FAVICON_SVG/favicon.svg"

# project/tauri/staticのsvgも更新
SVG_DST_DIR="$ROOT_DIR/project/tauri/static"
for f in "$SVG_DST_DIR"/*.svg; do
	if [ -f "$f" ]; then
		cp -f "$ICON_SVG_SRC" "$f"
		echo "$f (svg) に同期しました。"
	fi

if [ ! -f "$ICON_SRC" ]; then
	echo "$ICON_SRC が存在しません。"
	exit 1
fi


# tauri用アイコン同期
for f in "$ICON_DST_DIR"/*.png; do
	if [ -f "$f" ]; then
		cp -f "$ICON_SRC" "$f"
		echo "$f に同期しました。"
	fi
done


# src/svelteのfavicon.pngにも同期
SVELTE_FAVICON="$ROOT_DIR/src/svelte/static/favicon.png"
if [ -d "$(dirname "$SVELTE_FAVICON")" ]; then
	cp -f "$ICON_SRC" "$SVELTE_FAVICON"
	echo "$SVELTE_FAVICON にfaviconを同期しました。"
fi

# src/svelteのfavicon.icoにも同期
SVELTE_FAVICON="$ROOT_DIR/src/svelte/static/favicon.ico"
if [ -d "$(dirname "$SVELTE_FAVICON")" ]; then
	magick "$ICON_SRC" -define icon:auto-resize=64,128,256 "$SVELTE_FAVICON"
	echo "$SVELTE_FAVICON にfaviconを同期しました。"
fi
