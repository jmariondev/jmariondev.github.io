+++
title = "Rust Error Handling Patterns I Actually Use"
date = 2026-03-15
draft = true
description = "A tour of error handling in Rust — from simple to production-grade."

[taxonomies]
tags = ["rust"]

[extra]
+++

Error handling is one of those things that separates "I wrote some Rust" from "I *ship* Rust." Here's a quick rundown of patterns I reach for depending on the context.

<!-- more -->

## The Basics: `Result` and `?`

If you're not using the `?` operator yet, start here:

```rust
use std::fs;
use std::io;

fn read_config(path: &str) -> Result<String, io::Error> {
    let contents = fs::read_to_string(path)?;
    Ok(contents)
}
```

The `?` operator propagates errors up the call stack. Clean, simple, no `unwrap()` in sight.

## Custom Error Types with `thiserror`

For libraries, I almost always reach for [`thiserror`](https://docs.rs/thiserror):

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ConfigError {
    #[error("failed to read config file: {0}")]
    Io(#[from] std::io::Error),

    #[error("invalid config format: {0}")]
    Parse(#[from] toml::de::Error),

    #[error("missing required field: {field}")]
    MissingField { field: String },
}
```

This gives you:
1. `Display` impl for free
2. Automatic `From` conversions
3. Proper `source()` chain for debugging

## `anyhow` for Applications

In binaries where you don't need typed errors at the boundary, [`anyhow`](https://docs.rs/anyhow) is king:

```rust
use anyhow::{Context, Result};

fn setup() -> Result<()> {
    let config = std::fs::read_to_string("config.toml")
        .context("failed to read config.toml")?;

    let parsed: Config = toml::from_str(&config)
        .context("failed to parse config")?;

    Ok(())
}
```

The `.context()` method is *chef's kiss* — it wraps errors with human-readable messages without losing the underlying cause.

## The Rule of Thumb

> - **Library?** → `thiserror` with a typed enum
> - **Binary?** → `anyhow` with `.context()`
> - **Prototype?** → `.unwrap()` is fine, just don't ship it

That's it. No need to overthink it.
