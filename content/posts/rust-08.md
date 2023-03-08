---
title: "Rust测试"
date: 2021-05-27T17:47:08+08:00
draft: false
tags: ["Rust"]
---

### 编写测试

先创建一个新的库项目

```
cargo new adder --lib
```

会自动生成`src/lib.rs`

```rust
#[cfg(test)]
mod tests {
	#[test]
	fn it_works() {
		assert_eq!(2 + 2, 4);
	}
}
```