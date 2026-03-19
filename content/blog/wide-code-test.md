+++
title = "Wide Code Block Test"
date = 2026-03-13
draft = true
description = "Testing code block rendering at various widths."

[taxonomies]
tags = ["meta"]

[extra]
+++

Testing how code blocks handle wide content.

<!-- more -->

## 80 Columns

Standard terminal width — this should fit comfortably:

```rust,linenos,name=lib.rs
use std::collections::HashMap;

/// Process a batch of items and return a summary of the results.
fn process_batch(items: &[Item], config: &Config) -> Result<Summary, Error> {
    let mut results: HashMap<String, Vec<Output>> = HashMap::new();

    for item in items {
        let output = item.process(config)?;
        results.entry(item.category.clone()).or_default().push(output);
    }

    Ok(Summary::from_results(&results))
}
```

## 120 Columns

This is where things get interesting — wider than the content column:

```rust,linenos,name=handler.rs
use axum::{extract::State, http::StatusCode, response::IntoResponse, Json};

/// Handle an incoming webhook, validate the signature, parse the payload, and dispatch to the appropriate handler.
async fn handle_webhook(State(app): State<AppState>, headers: HeaderMap, body: Bytes) -> Result<impl IntoResponse, StatusCode> {
    let signature = headers.get("X-Signature-256").ok_or(StatusCode::UNAUTHORIZED)?.to_str().map_err(|_| StatusCode::BAD_REQUEST)?;
    let payload: WebhookPayload = serde_json::from_slice(&body).map_err(|_| StatusCode::UNPROCESSABLE_ENTITY)?;

    app.verify_signature(signature, &body).map_err(|_| StatusCode::UNAUTHORIZED)?;

    match payload.event_type.as_str() {
        "push" => app.handle_push(payload.into()).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?,
        "pull_request" => app.handle_pr(payload.into()).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?,
        _ => return Ok((StatusCode::OK, Json(json!({"status": "ignored"})))),
    }

    Ok((StatusCode::OK, Json(json!({"status": "processed"}))))
}
```

## Wide Shell Output

Long command output that shouldn't wrap:

```bash
$ cargo build --release --target x86_64-unknown-linux-musl 2>&1 | head -5
   Compiling libc v0.2.155 (/home/john/.cargo/registry/src/index.crates.io-6f17d22bba15001f/libc-0.2.155)
   Compiling cfg-if v1.0.0 (/home/john/.cargo/registry/src/index.crates.io-6f17d22bba15001f/cfg-if-1.0.0)
   Compiling autocfg v1.3.0 (/home/john/.cargo/registry/src/index.crates.io-6f17d22bba15001f/autocfg-1.3.0)
   Compiling proc-macro2 v1.0.86 (/home/john/.cargo/registry/src/index.crates.io-6f17d22bba15001f/proc-macro2-1.0.86)
   Compiling unicode-ident v1.0.12 (/home/john/.cargo/registry/src/index.crates.io-6f17d22bba15001f/unicode-ident-1.0.12)
```

## Wide Table in Code

```rust,linenos
// Routes table — these lines are intentionally wide to test horizontal scrolling in code blocks
let router = Router::new()
    .route("/api/v1/webhooks/:provider",          post(handlers::webhooks::handle))           // Incoming webhooks from GitHub/GitLab
    .route("/api/v1/deployments/:id/status",      get(handlers::deployments::status))         // Deployment status check
    .route("/api/v1/deployments/:id/logs",        get(handlers::deployments::logs))           // Stream deployment logs
    .route("/api/v1/deployments/:id/rollback",    post(handlers::deployments::rollback))      // Rollback a deployment
    .route("/api/v1/health",                      get(handlers::health::check));              // Health check endpoint
```
