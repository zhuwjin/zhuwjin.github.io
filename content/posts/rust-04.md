---
title: "Rust枚举和模式匹配"
date: 2021-05-22T20:03:35+08:00
draft: false
tags: ["Rust"]
---

### 枚举

定义枚举

```rust
enum IpAddrKind {
    V4,
    V6,
}
```

枚举值

```rust
let four = IpAddrKind::V4;
let six = IpAddrKind::V6;
```

他们的类型都是`IpAddrKind`

如函数：

```rust
fn rout(ip_type: IpAddrKind) { }
```

可以向下面一样调用

```rust
route(IpAddrKind::V4);
route(IpAddrKind::V6);
```

### `match`控制流运算符

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}
let a = Coin::Penny;
let b = match a {
    Coin::Penny => 1,
    Coin::Nickel => 5,
    Coin::Dime => 10,
    Coin::Quarter => 25,
};
println!("{}", b);
let c = match a {
    Coin::Penny => {
        println!("Lucky penny!");
        1
    },
    Coin::Nickel => 5,
    Coin::Dime => 10,
    Coin::Quarter => 25,
}
```

绑定值的模式

可以用来获取枚举绑定的值

```rust
enum Ip {
    V4(u8, u8, u8, u8),
    V6(String),
}
fn print_ip(ip: &Ip) {
    match ip {
        Ip::V4(a, b, c, d) => println!("{}.{}.{}.{}", a, b, c, d),
        Ip::V6(a) => println!("{}", a),
    }
}
fn main() {
    let ip4 = Ip::V4(127, 0, 0, 1);
    let ip6 = Ip::V6(String::from("::1"));
    print_ip(&ip4);
    print_ip(&ip6);
}
```

通配符

`rust`的`match`必须列出所有可能，有时候只需要几个匹配，其他的可以用通配符`_`来匹配

```rust
let some_u8_value = 0u8;
match some_u8_value {
    1 => println!("one"),
    3 => println!("three"),
    5 => println!("five"),
    7 => println!("seven"),
    _ => (),
}
```