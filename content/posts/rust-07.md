---
title: "Rust泛型、trait与生命周期"
date: 2021-05-25T13:35:57+08:00
draft: false
tags: ["Rust"]
---

### 泛型数据类型

在函数定义中使用泛型

下面代码有两个函数，找出最大的数字和字母的

```rust
fn largest_i32(list: &[i32]) -> i32 {
    let mut largest = list[0];
    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }
    largest
}
fn largest_char(list: &[char]) -> char {
    let mut largest = list[0];
    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }
    largest
}
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];
    let result = largest_i32(&number_list);
    println!("The largest number is {}", result);
    let char_list = vec!['y', 'm', 'a', 'q'];
    let result = largest_char(&char_list);
    println!("The largest char is {}", result);
}
```

这两个函数实现的功能都是一样的

所以可以使用泛型来把他们整合到一起

```rust
fn largest<T>(list: &[T]) -> T {
    let mut largest = list[0];
    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }
    largest
}
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];
    let result = largest(&number_list);
    println!("The largest number is {}", result);
    let char_list = vec!['y', 'm', 'a', 'q'];
    let result = largest(&char_list);
    println!("The largest char is {}", result);
}
```

结构体中的泛型

```rust
struct Point<T> {
    x: T,
    y: T,
}
fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}
```

下面代码是错误的，类型都是`T`说明`xy`类型一样

```rust
struct Point<T> {
    x: T,
    y: T,
}
fn main() {
    let wont_work = Point { x: 5, y: 4.0 };
}
```

```rust
struct Point<T, U> {
    x: T,
    y: U,
}
fn main() {
    let both_integer = Point { x: 5, y: 10 };
    let both_float = Point { x: 1.0, y: 4.0 };
    let integer_and_float = Point { x: 5, y: 4.0 };
}
```

枚举定义中的泛型

```rust
enum Option<T> {
    Some(T),
    None,
}
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

方法定义中的泛型

```rust
struct Point<T> {
    x: T,
    y: T,
}
impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}
fn main() {
    let p = Point { x: 5, y: 10 };
    println!("p.x = {}", p.x());
}
```

```rust
struct Point<T, U> {
    x: T,
    y: U,
}
impl<T, U> Point<T, U> {
    fn mixup<V, W>(self, other: Point<V, W>) -> Point<T, W> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}
fn main() {
    let p1 = Point { x: 5, y: 10.4 };
    let p2 = Point { x: "Hello", y: 'c'};
    let p3 = p1.mixup(p2);
    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
}
```

还可以只对一种类型提供方法

```rust
struct Point<T> {
    x: T,
    y: T,
}
impl<T> Point<T> {
    fn get_x(&self) -> &T {
        &self.x
    }
}
impl Point<String> {
    fn x_add(&mut self, str: &String) {
        self.x = format!("{}{}", self.x, str)
    }
}
fn main() {
    let a1 = Point { x: 5, y: 10 };
    println!("{}", a1.get_x());
    let mut a2 = Point { x: String::from("Hello"), y: String::from("world") };
    let str = String::from("world");
    a2.x_add(&str);
    println!("{}", a2.get_x());
}
```

### `trait`:定义共享的行为

`trait`类似于其他语言的接口功能

定义`trait`