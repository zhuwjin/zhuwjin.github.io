---
title: "Rust结构体"
date: 2021-05-15T12:33:56+08:00
draft: false
tags: ["Rust"]
---

### 结构体

定义结构体

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
```

创建结构体实例

```rust
let mut user1 = User {
    email: String::from("Murphy.W.Zhu@aliyun.com"),
    username: String::from("Murphy.W.Zhu"),
    active: true,
    sign_in_count: 1,
};
```

改变实例属性

```rust
user1.email = String::from("Murphy.W.Zhu@aliyun.com");
```

返回结构体

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}
```

变量与字段同名是的字段初始化简写语法

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

使用结构体更新语法从其他实例创建实例

```rust
let user2 = User {
    email: String::from("Murphy.W.Zhu@aliyun.com"),
    username: String::from("Murphy.W.Zhu"),
    active: user1.active,
    sign_in_count: user1.sign_in_count,
};
```

相同的部分可以简写

```rust
let user2 = User {
    email: String::from("Murphy.W.Zhu1@aliyun.com"),
    username: String::from("Murphy.W.Zhu1"),
    ..user1
};
```

### 元组结构体

元组结构体相当于没有字段名的结构体

```rust
struct Color(i32, i32, i32);
let mut black = Color(0, 1, 0);
black.1 = 0;//可以使用.的方式访问
println!("{},{},{}", black.0,black.1,black.2);
```

### 在函数中使用结构体

结构体也是有所有权的，所以要借用

```rust
struct Rectangle {
    width: u32,
    height: u32,
}
fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    println!(
        "The area of the rectangle is {} square pixels.",
        area(&rect1)
    );
}
fn area(rectangle: &Rectangle) -> u32 {
    rectangle.width * rectangle.height
}
```

### 结构体方法

方法与函数类似，像其他面向对象的语言中一样，方法的第一个参数是`self`

定义方法

```rust
struct Rectangle {
    width: u32,
    height: u32,
}
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}
fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```

带有更多参数的方法

```rust
struct Rectangle {
    width: u32,
    height: u32,
}
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    let rect2 = Rectangle { width: 10, height: 40 };
    let rect3 = Rectangle { width: 60, height: 45 };
    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    println!("Can rect1 hold rect3? {}", rect1.can_hold(&rect3));
}
```

关联函数

参数不包含`self`，关联函数经常被用作返回一个结构体新实例的构造函数。

```rust
impl Rectangle {
    fn square(size: u32) -> Rectangle {
        Rectangle { width: size, height: size }
    }
}
let sq = Rectangle::square(3);
```