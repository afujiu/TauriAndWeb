use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use actix_files::Files;
use serde::Deserialize;

#[derive(serde::Deserialize)]
struct MyPostData {
    name: String,
    age: u32,
}



async fn post_handler(item: web::Json<MyPostData>) -> impl Responder {
    let response = format!("Received: name={}, age={}", item.name, item.age);
    HttpResponse::Ok().body(response)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(Files::new("/", "./front").index_file("index.html"))
            .route("/post", web::post().to(post_handler))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
