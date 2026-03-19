+++
title = "Hello, World"
date = 2026-03-17
draft = true
description = "First post on the new site — built with Zola."

[taxonomies]
tags = ["zola", "nix", "meta"]

[extra]
+++

Welcome to the new site! I finally got around to ripping out the ancient Jekyll setup and replacing it with [Zola](https://www.getzola.org/) — a static site generator written in Rust.

<!-- more -->

## Why Zola?

A few reasons:

- **Single binary** — no Ruby, no Bundler, no Gemfile nightmares
- **Fast** — rebuilds in milliseconds
- **Sass built-in** — no separate pipeline
- **Tera templates** — Jinja2-like, intuitive

The whole thing fits neatly into a Nix flake, which means `nix develop` gives you everything you need.

## The Stack

Here's the full setup:

| Layer      | Tool           |
|------------|----------------|
| Generator  | Zola           |
| Styles     | Sass (built-in)|
| Deploy     | GitHub Actions |
| Dev env    | Nix flake      |
| Task runner| just           |

## What's Next

Probably writing about things I find interesting — Rust, Nix, infrastructure, cryptography. We'll see.

```rust
fn main() {
    println!("let's see if I actually post anything");
}
```
