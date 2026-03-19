# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal blog and site for John Marion (@jmariondev) at https://jmarion.dev. Built with Zola (Rust-based static site generator), packaged via Nix flake, deployed to GitHub Pages.

## Commands

```bash
just serve       # Local dev server with drafts visible
just build       # Production build (no drafts)
just update-pgp  # Update PGP key material from local GPG keyring
zola build       # Direct build (prefer `just build`)
```

All posts are currently `draft = true`. Use `just serve` (which passes `--drafts`) to see them locally.

## Architecture

**Content → Templates → Output:**
- `content/` has markdown with TOML frontmatter. Blog posts live in `content/blog/`.
- `templates/` uses Tera (Jinja2-like). All templates extend `base.html`.
- `sass/style.scss` is the single stylesheet — dark-first, light via `prefers-color-scheme`.
- `static/` is copied verbatim to output root.

**Template hierarchy:**
- `base.html` — master layout, imports `macros/icons.html` for SVG icons. Has nav, sidebar (hidden on mobile, visible at 860px+), footer, and inline copy-button JS.
- `blog/page.html` — individual post (TOC, reading time, prev/next nav)
- `blog/section.html` — blog archive grouped by year with tag filter bar
- `index.html` — homepage with avatar intro callout + latest 5 posts
- `tags/list.html` and `tags/single.html` — taxonomy pages

**PGP key system:**
- Key data lives in `static/pgp-key.asc` and `static/pgp-info.txt` (not in markdown)
- `templates/shortcodes/pgp_info.html` and `pgp_key.html` load these via `load_data()`
- `content/pgp.md` calls the shortcodes — template doesn't know about key content
- `scripts/update-pgp.sh` updates all key locations (page data, WKD binary, security.txt expiry) from the local GPG keyring
- WKD hash for `john@`: `wwq7w9d96wfsd4zkytndq84kpkjod3eb`

**.well-known resources:**
- `openpgpkey/` — WKD for PGP key discovery
- `webfinger` — Mastodon account discovery (static, no query string handling)
- `security.txt` — PGP-signed, expiry tracks key expiry

## Code Blocks

Zola supports per-block attributes in fenced code:
- Line numbers: ` ```rust,linenos `
- Highlight lines: ` ```rust,hl_lines=2-4 8 `
- Start offset: ` ```rust,linenos,linenostart=10 `
- Filename: ` ```rust,name=main.rs `

Syntax highlighting uses `ayu-dark` theme with inline styles (Giallo renderer). Line number elements use `.giallo-ln` class.

## Styling

Single file: `sass/style.scss`. Purple accent (`--accent: #a78bfa` dark, `#7c3aed` light). CSS custom properties for all colors. Layout is a CSS grid that widens to 960px with a 200px sidebar column on desktop.

Icon brand colors are defined per-icon class (`.icon-github svg`, etc.) with separate light-mode overrides.

## Deploy

GitHub Actions (`.github/workflows/deploy.yml`): pushes to `master` trigger `zola build` and deploy to GitHub Pages. The branch is `master`, not `main`.
