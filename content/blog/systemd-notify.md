+++
title = "Type=notify in Rust with sd-notify"
date = 2026-03-14
draft = true
description = "Using systemd's notify protocol from Rust services."

[taxonomies]
tags = ["rust", "linux"]

[extra]
+++

If you're writing a long-running Rust service on Linux, you should be using `Type=notify` in your systemd unit. Here's why and how.

<!-- more -->

## The Problem with Type=simple

Most Rust services use `Type=simple` by default — systemd considers the service "started" the moment the process is spawned. But your service probably isn't *ready* yet. It might be loading config, opening sockets, running migrations.

With `Type=simple`, anything that depends on your service via `After=` might race against your startup:

```bash
$ systemctl start my-service
$ systemctl status my-service
● my-service.service - My Rust Service
     Active: active (running) since Wed 2026-03-14 10:00:01 UTC
   Main PID: 4821 (my-service)

$ curl http://localhost:8080/health
curl: (7) Failed to connect to localhost port 8080: Connection refused
```

The service is "active" but not actually listening yet. Not great.

## Type=notify to the Rescue

With `Type=notify`, your service explicitly tells systemd when it's ready. Systemd waits until it gets the signal before marking the service as active.

The [`sd-notify`](https://docs.rs/sd-notify) crate makes this trivial:

```rust,linenos,name=main.rs
use sd_notify::NotifyState;
use std::net::TcpListener;

fn main() -> anyhow::Result<()> {
    // Do your startup work
    let config = load_config()?;
    let db = connect_database(&config)?;
    let listener = TcpListener::bind(&config.listen_addr)?;

    // NOW tell systemd we're ready
    sd_notify::notify(true, &[NotifyState::Ready])?;

    // Start accepting connections
    for stream in listener.incoming() {
        handle_connection(stream?, &db)?;
    }

    Ok(())
}
```

Line 11 is the key — `NotifyState::Ready` sends `READY=1` over the notification socket. Systemd won't consider the service active until this fires.

## The Unit File

```ini,linenos,name=my-service.service
[Unit]
Description=My Rust Service
After=network-online.target postgresql.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/my-service
WatchdogSec=30
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Note `WatchdogSec=30` on line 9 — this enables the systemd watchdog. Your service needs to ping systemd periodically or it gets killed. The `sd-notify` crate handles this too:

```rust,linenos,hl_lines=3-8
// Spawn a watchdog thread
let watchdog_usec = sd_notify::watchdog_enabled(false);
if let Some(usec) = watchdog_usec {
    let interval = Duration::from_micros(usec / 2);
    std::thread::spawn(move || loop {
        sd_notify::notify(true, &[NotifyState::Watchdog]).ok();
        std::thread::sleep(interval);
    });
}
```

Ping at half the watchdog interval (line 4) — standard practice so you have margin for jitter.

## Checking It Works

Now startup behaves correctly:

```bash
$ systemctl start my-service
$ systemctl status my-service
● my-service.service - My Rust Service
     Active: active (running) since Wed 2026-03-14 10:00:03 UTC
     Status: "READY=1"
   Main PID: 4821 (my-service)

$ curl http://localhost:8080/health
{"status": "ok"}
```

Notice the 2-second gap between start and active — that's real startup time, and nothing that depends on this service will race against it.

## Cargo.toml

```toml,linenos,name=Cargo.toml
[dependencies]
sd-notify = "0.4"
anyhow = "1"
```

Three lines in your `Cargo.toml`, one line in your code, and your service is a proper systemd citizen. No excuses.
