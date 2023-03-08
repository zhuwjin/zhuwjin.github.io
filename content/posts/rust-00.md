---
title: "Rust初试"
date: 2021-04-21T13:58:22+08:00
draft: false
tags: ["Rust"]
cover:
    image: "https://mublog.oss-cn-beijing.aliyuncs.com/ec16e275a07709bf0043bda9608de846.jpeg"
    alt: "Rust"
    # caption: "ArchLinux"
    relative: false # To use relative path for cover image, used in hugo Page-bundles
---

### Rust

据官网说介绍`rust`是一门高性能，高可靠的编程语言，最主要的特点就是安全可靠，据悉`Linux`内核都在考虑是否用`rust`代替`C`

### Rust安装

可以使用官方的`rustup`来安装`rust`以及其他工具

```bash
sudo pacman -S rustup
```

设置`rustup`的下载源

```bash
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
```

安装`rust`

```bash
rustup install stable
rustup component add rust-src
```

`Helloworld`

```bash
Code % cargo new hello-world
     Created binary (application) `hello-world` package
Code % cd hello-world 
hello-world[master*] % ls
Cargo.toml  src
hello-world[master*] % cargo run
   Compiling hello-world v0.1.0 (/home/murphy/Code/hello-world)
    Finished dev [unoptimized + debuginfo] target(s) in 1.15s
     Running `target/debug/hello-world`
Hello, world!
```

### Rust IDE

`rust`还没有官方的`IDE`，我使用`Clion`的`rust`插件来写

![clion](https://mublog.oss-cn-beijing.aliyuncs.com/rust_clion.png)

