// From: https://lib.rs/crates/warp
use warp::Filter;

#[tokio::main]
async fn main() {
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String).map(|name| format!("Hello, {}!", name));

    // We want the frontend to call this endpoint; so we allow that.
    let cors = warp::cors().allow_any_origin();
    let route = hello.with(cors);

    println!("Listening on http://0.0.0.0:3030");

    warp::serve(route).run(([0, 0, 0, 0], 3030)).await;
}
