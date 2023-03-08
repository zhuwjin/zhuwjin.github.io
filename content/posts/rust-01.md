---
title: "Rust常见编程概念"
date: 2021-04-21T14:55:05+08:00
draft: false
tags: ["Rust"]
# cover:
    # image: "https://mublog.oss-cn-beijing.aliyuncs.com/ec16e275a07709bf0043bda9608de846.jpeg"
    # alt: "Rust"
    # caption: "ArchLinux"
    # relative: false # To use relative path for cover image, used in hugo Page-bundle
---



### 不变变量

以下程序理所当然的输出`5`

```rust
fn main() {
    let a = 5;
    println!("{}", a);
}
```

而当你尝试改变`a`的值时

```rust
fn main() {
    let a = 5;
    a = 6;
    println!("{}", a);
}
```

则会出现错误

```rust
error[E0384]: cannot assign twice to immutable variable `a`
 --> src/main.rs:3:5
  |
2 |     let a = 5;
  |         -
  |         |
  |         first assignment to `a`
  |         help: make this binding mutable: `mut a`
3 |     a = 6;
  |     ^^^^^ cannot assign twice to immutable variable
```

`rust`会很人性化的提示你哪里错了，还会给出建议

这就是因为`rust`变量默认是不可改变的，要改变的话需要声明他是可变的，就像他提示的那样

```rust
fn main() {
    let mut a = 5;
    a = 6;
    println!("{}", a);
}
```

------

### 常量

`rust`变量默认不可变，那好像和常量一样，常量不光默认不能变，它总是不能变。常量只能被设置为常量表达式，而不能是函数调用的结果，或任何其他只能在运行时计算出的值。

```rust
const MAX_POINTS: u32 = 100_000;
```

------

### 数据类型

#### 声明

```rust
let x: i64 = 10;
let x = 5.5;
```

#### `char`类型

`rust`的`char`为四个字节，代表一个`unicode`标量值，所以可以使用`emoji`、中文字符等等

```rust
let c = 'z';
let z = 'ℤ';
let heart_eyed_cat = '😻';
```

#### 元组`(tup)`

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
let tup = (500, 6.4, 1);
println!("{}", tup.0);
```

元组默认也是不可变的，也需要加`mut`声明可变才可改变

```rust
let mut tup = (50, 6.1, 5);
tup.0 = 55;
```

#### 数组`(array)`

数组是固定长度的，一旦声明，它们的长度不能增长或缩小。

```rust
let a = [1, 2, 3, 4, 5];
let b: [i32; 5] = [1, 2, 3, 4, 5];
let c = [3; 5];//[3,3,3,3,3]
println!("{}", a[0]);
```

数组同样也是不可变的啦，也要加`mut`才可改变

```rust
let mut list = [5, 5, 5, 5];
```

------

### 函数

函数是面向过程的语言里非常重要的一个东西

在`rust`里的函数的定义如下

```rust
fn func_name(x: i32) -> i32 {
	x*2
}
fn func_name(x: i32) -> i32 {
	return x*2
}
```

`rust`函数的最后一条`表达式`的值当作返回值，也可以使用`return`返回

`rust`里只有表达式才有值，函数调用也是表达式

------

### 控制流

#### `if`表达式

`if`语句也是表达式所以也有值

一下程序会输出`20`

```rust
fn main() {
    let a = 10;
    let b = if a > 10 {
        a
    } else {
        a*2
    };
    println!("{}", b);
}
```

`rust`的`if`语句中的条件只能是值为`bool`型的表达式

#### `loop`循环

```rust
fn main() {
    loop {
        println!("again!");
    }
}
```

可以用`break`退出循环，`loop`表达式的值，即是`break`后面的表达式的值

下面程序会输出`20`

```rust
fn main() {
    let mut counter = 0;
    let result = loop {
        counter += 1;
        if counter == 10 {
            break counter * 2;
        }
    };
    println!("The result is {}", result);
}
```

#### `while`条件循环

```rust
fn main() {
    let mut number = 3;
    while number != 0 {
        println!("{}!", number);
        number = number - 1;
    }
    println!("LIFTOFF!!!");
}
```

#### `for`循环

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];
    for element in a.iter() {
        println!("the value is: {}", element);
    }
}
```



```rust
fn main() {
    for number in (1..4).rev() {
        println!("{}!", number);
    }
    println!("LIFTOFF!!!");
}
```
