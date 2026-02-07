use serde::Deserialize;

#[derive(Deserialize)]
pub struct MyPostData {
    pub name: String,
    pub age: u32,
}

pub fn post_like_response(data: &MyPostData) -> String {
    format!("Received: name={}, age={}", data.name, data.age)
}
