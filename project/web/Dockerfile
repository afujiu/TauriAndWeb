FROM debian:bullseye-slim

# 必要なパッケージをインストール
RUN apt-get update \
    && apt-get install -y curl build-essential pkg-config libssl-dev \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && . "$HOME/.cargo/env" \
    && rustc --version

WORKDIR /app
COPY . .

# Rustサーバをビルド
RUN . "$HOME/.cargo/env" && cargo build --release

EXPOSE 8080
CMD ["/app/target/release/rust_web"]