use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use actix_files::Files;

// apiを追加
mod api {
    pub mod greet;
}

// 任意のPOSTルートに対応するハンドラ
async fn dynamic_post_handler(root: web::Path<String>, body: web::Bytes) -> impl Responder {
    println!("[DEBUG] body raw: {:?}", body);
    if let Ok(body_str) = std::str::from_utf8(&body) {
        println!("[DEBUG] body as str: {}", body_str);
    }
    match root.as_str() {
        "greet" => {
            let req: api::greet::GreetRequest = serde_json::from_slice(&body).unwrap_or(api::greet::GreetRequest { name: "".to_string() });
            let msg = api::greet::main(&req.name);
            let json = serde_json::json!({ "result": msg });
            HttpResponse::Ok().content_type("application/json").body(json.to_string())
        }
        // 他のAPIルートもここに追加可能
        _ => HttpResponse::NotFound().body("Unknown route")
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/{root}", web::post().to(dynamic_post_handler)) // 任意POST
            .service(Files::new("/", "./front").index_file("index.html"))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
