# 前提環境作成
WindowsTAURI環境作成
```
nvm install 20.11.1
nvm use 20.11.1
```

RUST
```
winget install Rustlang.Rustup
rustc --version
cargo --version
```

Visual Studio Build Toolsをインストール
Visual Studio Installer
C++ によるデスクトップ開発
```
npm install -g @tauri-apps/cli
tauri -v
```

# tauriプロジェクト作成
```
npm create tauri-app@latest

cd tauri
npm install
npm run tauri dev
```

```
npm run tauri build
```

# web

```
cargo new web
```