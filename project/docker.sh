cd web
docker build -t rust-web .
docker run -p 8080:8080 rust-web