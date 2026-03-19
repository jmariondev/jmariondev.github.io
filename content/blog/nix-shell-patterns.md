+++
title = "Nix Shell Patterns I Keep Reaching For"
date = 2026-03-16
draft = true
description = "Practical nix develop workflows for Rust projects."

[taxonomies]
tags = ["nix", "rust"]

[extra]
+++

Every Rust project I start gets a `flake.nix` before it gets a `README`. Here are the patterns I keep copy-pasting.

<!-- more -->

## The Minimal Flake

This is my starting point for any Rust project. Nothing fancy — just make sure `cargo`, `rustc`, and common native deps are available:

```nix,linenos,name=flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            pkg-config
            openssl
          ];
        };
      });
}
```

Drop in, `nix develop`, and you're building. No `rustup`, no system package conflicts.

## Checking Your Environment

After entering the shell, I always sanity-check what I've got:

```bash
$ nix develop
$ rustc --version
rustc 1.82.0 (f6e511eec 2024-10-15)

$ cargo --version
cargo 1.82.0 (8f40fc59f 2024-10-08)

$ pkg-config --list-all | grep openssl
openssl        OpenSSL - Secure Sockets Layer and cryptography libraries
```

The versions are pinned by your `flake.lock` — no surprises across machines.

## Adding Rust Toolchain Overlay

When you need a specific Rust version or nightly, bring in `rust-overlay`:

```nix,linenos,hl_lines=3 10-14,name=flake.nix
{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ rust pkgs.pkg-config pkgs.openssl ];
        };
      });
}
```

Lines 3 and 10–14 are the interesting bits — the overlay gives you `pkgs.rust-bin` which is a much nicer API than dealing with `rustup` targets manually.

## The `justfile` Pattern

I pair every flake with a `justfile` for common tasks:

```makefile,linenos,name=Justfile
check:
    cargo clippy --all-targets -- -D warnings

test:
    cargo test

fmt:
    cargo fmt --check

ci: fmt check test

dev:
    cargo watch -x 'clippy --all-targets'
```

Then the workflow is just:

```bash
$ nix develop
$ just ci
   Compiling my-project v0.1.0
    Checking my-project v0.1.0
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 2.34s
    Running `target/debug/my-project`
running 12 tests
test result: ok. 12 passed; 0 failed; 0 ignored
```

## direnv Integration

The final piece: add `.envrc` so you don't even need to type `nix develop`:

```bash,name=.envrc
use flake
```

That's it. `cd` into the project and your shell is ready. Combined with `nix-direnv` for caching, re-entry is near-instant:

```bash
$ cd my-project
direnv: loading .envrc
direnv: using flake
direnv: nix develop shell is ready

$ cargo build
   Compiling my-project v0.1.0
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.42s
```

No activation delay, no stale environments, reproducible everywhere.
