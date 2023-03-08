---
title: "Rust错误处理"
date: 2021-05-25T11:22:11+08:00
draft: false
tags: ["Rust"]
---

### `panic!`与不可恢复的错误

调用`panic!`

```rust
fn main() {
    panic!("crash and burn");
}
```

### `Result`与可恢复的错误

```rust
use std::fs::File;
fn main() {
    let f = File::open("hello.txt");
    let f = match f {
        Ok(file) => file,
        Err(error) => {
            panic!("Problem opening the file: {:?}", error)
        },
    };
}
```

匹配不同的错误

```rust
use std::fs::File;
use std::io::ErrorKind;
fn main() {
    let f = File::open("hello.txt");
    let f = match f {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => panic!("Problem opening the file: {:?}", other_error),
        },
    };
}
```

失败时`panic`的简写

```rust
use std::fs::File;
fn main() {
    let f = File::open("hello.txt").unwrap();
}
```

```rust
use std::fs::File;
fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

传播错误

```rust
use std::io;
use std::io::Read;
use std::fs::File;
fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");
    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };
    let mut s = String::new();
    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

传播错误的简写

```rust
use std::io;
use std::io::Read;
use std::fs::File;
fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```