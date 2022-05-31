---
title: "Rust集合"
date: 2021-05-23T11:48:49+08:00
draft: false
tags: ["Rust"]
---

### `vector`

`vector`在内存中是连续的，只能存储相同类型的值

新建`vector`

```rust
let v: Vec<i32> = Vec::new();
```

或者使用`rust`提供的`vec!`宏来新建一个`vector`

```rust
let v = vec![1, 2, 3];
```

更新`vector`

```rust
let mut v = Vec::new();//需要可变才能改变
v.push(5);
```

读取`vector`的元素

```rust
let v = vec![1, 2, 3, 4, 5];
let third: &i32 = &v[2];
println!("The third element is {}", third);
match v.get(2) {
    Some(third) => println!("The third element is {}", third),
    None => println!("There is no third element."),
}
```

下面代码会报错

```rust
let mut v = vec![1, 2, 3, 4, 5];
let first = &v[0];
v.push(6);//加入一个元素会使v重新分配一块连续的地址，所以原来的引用就无效了，rust不允许无效引用
println!("The first element is: {}", first);
```

遍历`vector`

```rust
let v = vec![1, 2, 3, 4, 5];
for i in &v {
    println!("{}", i);
}
```

使用枚举来存储多种类型

`vector`只能存储一种类型，而枚举算一种类型，可以用枚举来存储多种类型

```rust
#![allow(unused)]
fn main() {
enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}
let row = vec![
    SpreadsheetCell::Int(3),
    SpreadsheetCell::Text(String::from("blue")),
    SpreadsheetCell::Float(10.12),
];
}
```

### 字符串

新建字符串

```rust
let mut s = String::new();//新建空字符串
let s = "initial contents".to_string();//用to_string新建字符串
let s = String::from("initial contents");//用from新建字符串
```

更新字符串

```rust
let mut s = String::from("hello");
s.push_str("world");//将字符串添加到string
s.push('!');//将字符添加到string
```

使用`+`或`format!`拼接字符串

```rust
let s1 = String::from("Hello,");
let s2 = String::from("world!");
let s3 = s1 + &s2;//s1 被移动了，不能继续使用
```

```rust
let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");
let s = format!("{}-{}-{}", s1, s2, s3);//会获取任何参数的所有权
```

遍历字符串

```rust
for c in "你好，世界".chars() {
	println!("{}", c);
}
```

### 哈希`map`键值对

新建一个哈希`map`

```rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
```

哈希`map`所有的键必须是相同类型，所有的值也必须是相同类型

也可以使用下面的方法构建一个哈希`map`

```rust
use std::collections::HashMap;
let teams  = vec![String::from("Blue"), String::from("Yellow")];
let initial_scores = vec![10, 50];
let scores: HashMap<_, _> = teams.iter().zip(initial_scores.iter()).collect();
```

访问哈希`map`

```rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
let team_name = String::from("Blue");
let score = scores.get(&team_name);
```

遍历哈希`map`

```rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
for (key, value) in &scores {
    println!("{}: {}", key, value);
}
```

更新哈希`map`

```rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 25);
println!("{:?}", scores);
```

在没有值时更新哈希`map`

```rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.entry(String::from("Yellow")).or_insert(50);
scores.entry(String::from("Blue")).or_insert(50);
println!("{:?}", scores);
```