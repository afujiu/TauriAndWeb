use serde::Deserialize;

/// greet用のリクエストデータ構造体
#[derive(Deserialize)]
pub struct GreetRequest {
    pub name: String,
}

/// 挨拶メッセージ生成の共通ロジック
pub fn main(name: &str) -> String {
    format!("こんにちは{}! RUST共有", name)
}
