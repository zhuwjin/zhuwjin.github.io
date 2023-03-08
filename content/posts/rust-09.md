---
title: "Rust迭代器与闭包"
date: 2021-06-05T18:51:13+08:00
draft: false
tags: ["Rust"]
---

### 闭包：可以捕获环境的匿名函数

Rust 的 **闭包**（*closures*）是可以保存进变量或作为参数传递给其他函数的匿名函数。可以在一个地方创建闭包，然后在不同的上下文中执行闭包运算。不同于函数，闭包允许捕获调用者作用域中的值。我们将展示闭包的这些功能如何复用代码和自定义行为。

#### 使用闭包创建行为的抽象

```rust
use std::thread;
use std::time::Duration;
fn simulated_expensive_calculation(intensity: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    intensity
}
```