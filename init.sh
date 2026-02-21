# 変数
ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"
PROJECT_NAME="rename"
PROJECT_VERSION="0.0.1"
DESCRIPTION="description"
chmod +x "$ROOT_DIR/shell/resyncIcon.sh"
"$ROOT_DIR/shell/resyncIcon.sh" "$ROOT_DIR"


# package.json (tauri, svelte)
jq --arg name "$PROJECT_NAME" --arg version "$PROJECT_VERSION" --arg desc "$DESCRIPTION" \
  '.name=$name | .version=$version | .description=$desc' \
  project/tauri/package.json > tmp && mv tmp project/tauri/package.json

jq --arg name "$PROJECT_NAME" --arg version "$PROJECT_VERSION" --arg desc "$DESCRIPTION" \
  '.name=$name | .version=$version | .description=$desc' \
  src/svelte/package.json > tmp && mv tmp src/svelte/package.json



# Cargo.toml (tauri, web)
sed -i '' "s/^name = .*/name = \"$PROJECT_NAME\"/" project/tauri/src-tauri/Cargo.toml
sed -i '' "s/^version = .*/version = \"$PROJECT_VERSION\"/" project/tauri/src-tauri/Cargo.toml
sed -i '' "s/^description = .*/description = \"$DESCRIPTION\"/" project/tauri/src-tauri/Cargo.toml
# project/tauri/src-tauri/src/main.rsのtauri?libをnameに置換
# Cargo.tomlからlib nameとpackage nameを取得
PKG_NAME=$(grep '^name = ' project/tauri/src-tauri/Cargo.toml | head -n 1 | sed 's/name = \"\\(.*\\)\"/\\1/')
# main.rsのtauri_libをpackage nameに置換
sed -i '' "s/tauri_lib/$PROJECT_NAME/g" project/tauri/src-tauri/src/main.rs



sed -i '' "s/^name = .*/name = \"$PROJECT_NAME\"/" project/web/Cargo.toml
sed -i '' "s/^version = .*/version = \"$PROJECT_VERSION\"/" project/web/Cargo.toml
# webのCargo.tomlにはdescriptionがない場合、追記する
grep -q '^description = ' project/web/Cargo.toml || sed -i '' "/^version = .*/a\\\ndescription = \"$DESCRIPTION\"" project/web/Cargo.toml



# svelte.config.js（必要ならコメントや変数で反映）
# 例：先頭にコメント追加
for f in project/tauri/svelte.config.js src/svelte/svelte.config.js; do
  sed -i '' "1i\\\n// $PROJECT_NAME $PROJECT_VERSION $DESCRIPTION\n" \"$f\"
done

# tauriのprojectnaem変更
sed -i '' "s/\"productName\": *\"[^\"]*\"/\"productName\": \"$PROJECT_NAME\"/" project/tauri/src-tauri/tauri.conf.json
sed -i '' "s/\"identifier\": *\"[^\"]*\"/\"identifier\": \"com.taw.$PROJECT_NAME\"/" project/tauri/src-tauri/tauri.conf.json
sed -i '' "s/\"title\": *\"[^\"]*\"/\"title\": \"$PROJECT_NAME\"/" project/tauri/src-tauri/tauri.conf.json