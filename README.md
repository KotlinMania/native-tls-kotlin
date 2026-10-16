# native-tls-kotlin in Kotlin

[![GitHub link](https://img.shields.io/badge/GitHub-KotlinMania%2Fnative-tls-kotlin-blue.svg)](https://github.com/KotlinMania/native-tls-kotlin)
[![Maven Central](https://img.shields.io/maven-central/v/io.github.kotlinmania/native-tls-kotlin)](https://central.sonatype.com/artifact/io.github.kotlinmania/native-tls-kotlin)
[![Build status](https://img.shields.io/github/actions/workflow/status/KotlinMania/native-tls-kotlin/ci.yml?branch=main)](https://github.com/KotlinMania/native-tls-kotlin/actions)

This is a Kotlin Multiplatform line-by-line transliteration port of [`rust-native-tls/rust-native-tls`](https://github.com/rust-native-tls/rust-native-tls) (crate `native-tls`).

**Original Project:** This port is based on [`rust-native-tls/rust-native-tls`](https://github.com/rust-native-tls/rust-native-tls). All design credit and project intent belong to the upstream authors; this repository is a faithful port to Kotlin Multiplatform with no behavioural changes intended.

### Porting status

This is an **in-progress port**. The goal is feature parity with the upstream Rust crate while providing a native Kotlin Multiplatform API. Every Kotlin file carries a `// port-lint: source <path>` header naming its upstream Rust counterpart so the AST-distance tool can track provenance.

---

## Upstream README — `rust-native-tls/rust-native-tls`

> The text below is reproduced from [`https://github.com/rust-native-tls/rust-native-tls`](https://github.com/rust-native-tls/rust-native-tls). It is the upstream project's own description and remains under the upstream authors' authorship; links have been rewritten to absolute upstream URLs where appropriate so they continue to resolve from this repository.

# native-tls crate

[Documentation](https://docs.rs/native-tls)

An abstraction over platform-specific TLS implementations.

Specifically, this crate uses SChannel on Windows (via the [`schannel`] crate),
Secure Transport on macOS (via the [`security-framework`] crate), and OpenSSL (via
the [`openssl`] crate) on all other platforms.

Using platform-native TLS library can reduce binary sizes, compilation times,
and improve compatibility with system-wide proxies and CA certificate stores.

[`schannel`]: https://crates.io/crates/schannel
[`security-framework`]: https://crates.io/crates/security-framework
[`openssl`]: https://crates.io/crates/openssl

## Installation

`cargo add native-tls` or

```toml
# Cargo.toml
[dependencies]
native-tls = "0.2"
```

## Usage

An example client looks like:

```rust,ignore
use native_tls::TlsConnector;
use std::io::{Read, Write};
use std::net::TcpStream;

fn main() {
    let connector = TlsConnector::new().unwrap();

    let stream = TcpStream::connect("google.com:443").unwrap();
    let mut stream = connector.connect("google.com", stream).unwrap();

    stream.write_all(b"GET / HTTP/1.0\r\n\r\n").unwrap();
    let mut res = vec![];
    stream.read_to_end(&mut res).unwrap();
    println!("{}", String::from_utf8_lossy(&res));
}
```

To accept connections as a server from remote clients:

```rust,ignore
use native_tls::{Identity, TlsAcceptor, TlsStream};
use std::fs::File;
use std::io::{Read};
use std::net::{TcpListener, TcpStream};
use std::sync::Arc;
use std::thread;

fn main() {
    let mut file = File::open("identity.pfx").unwrap();
    let mut identity = vec![];
    file.read_to_end(&mut identity).unwrap();
    let identity = Identity::from_pkcs12(&identity, "hunter2").unwrap();

    let acceptor = TlsAcceptor::new(identity).unwrap();
    let acceptor = Arc::new(acceptor);

    let listener = TcpListener::bind("0.0.0.0:8443").unwrap();

    fn handle_client(stream: TlsStream<TcpStream>) {
        // ...
    }

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                let acceptor = acceptor.clone();
                thread::spawn(move || {
                    let stream = acceptor.accept(stream).unwrap();
                    handle_client(stream);
                });
            }
            Err(e) => { /* connection failed */ }
        }
    }
}
```

## Supported features

This crate supports the following features out of the box:
* TLS/SSL client communication
* TLS/SSL server communication
* PKCS#12 encoded identities
* X.509/PKCS#8 encoded identities
* Secure-by-default for client and server
    * Includes hostname verification for clients
* Supports asynchronous I/O for both the server and the client

## License

`native-tls` is primarily distributed under the terms of both the MIT
license and the Apache License (Version 2.0), with portions covered by various
BSD-like licenses.

See LICENSE-APACHE, and LICENSE-MIT for details.

---

## About this Kotlin port

### Installation

```kotlin
dependencies {
    implementation("io.github.kotlinmania:native-tls-kotlin:0.1.0")
}
```

### Building

```bash
./gradlew build
./gradlew test
```

### Targets

- macOS arm64
- Linux x64
- Windows mingw-x64
- iOS arm64 / simulator-arm64 (Swift export + XCFramework)
- JS (browser + Node.js)
- Wasm-JS (browser + Node.js)
- Android (API 24+)

### Porting guidelines

See [AGENTS.md](AGENTS.md) and [CLAUDE.md](CLAUDE.md) for translator discipline, port-lint header convention, and Rust → Kotlin idiom mapping.

### License

This Kotlin port is distributed under the same license terms as the upstream [`rust-native-tls/rust-native-tls`](https://github.com/rust-native-tls/rust-native-tls). See [LICENSE](LICENSE) (and any sibling `LICENSE-*` / `NOTICE` files mirrored from upstream) for the full text.

Original work copyrighted by the native-tls authors.  
Kotlin port: Copyright (c) 2026 Sydney Renee and The Solace Project.

### Acknowledgments

Thanks to the [`rust-native-tls/rust-native-tls`](https://github.com/rust-native-tls/rust-native-tls) maintainers and contributors for the original Rust implementation. This port reproduces their work in Kotlin Multiplatform; bug reports about upstream design or behavior should go to the upstream repository.
