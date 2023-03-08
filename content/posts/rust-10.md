---
title: "Rust智能指针"
date: 2021-06-05T18:51:39+08:00
draft: false
tags: ["Rust"]
---

### 使用`Box<T>`指向堆上的数据

使用`box`在堆上储存一个`i32`

`b`是一个指向被分配在堆上的值`5`的`Box`

```rust
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);
}
```

用`Box<T>`可以实现类似链表的结构

```rust
#[derive(Debug)]
enum List {
    Cons(i32, Box<List>),
    Nil,
}
use crate::List::{Cons, Nil};
fn main() {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
    println!("{:?}", list)
}
```

------

### 通过`Deref trait`将智能指针当作常规引用处理

#### 通过解引用运算符追踪指针的值

常规引用是一个指针类型，一种理解指针的方式是将其看成指向储存在其他某处值的箭头。

```rust
fn main() {
    let x = 5;
    let y = &x;
    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

如果使用下面的代码则会出错

```rust
fn main() {
    let x = 5;
    let y = &x;
    assert_eq!(5, x);
    assert_eq!(5, y);
}
```

不允许比较数字的引用与数字，因为它们是不同的类型。必须使用解引用运算符追踪引用所指向的值。

#### 像引用一样使用`Box<T>`

```rust
fn main() {
    let x = 5;
    let y = Box::new(x);
    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

#### 自定义智能指针

```rust
#[derive(Debug)]
struct MyBox<T>(T);
impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
fn main() {
    let a = 5;
    let b = MyBox::new(a);
    assert_eq!(5, a);
    assert_eq!(5, *b);
}
```

这里我们定义了一个智能指针`MyBox`，并尝试使用`Box`的解引用方法，但是会出错，因为`rust`不知道怎么解引用`MyBox`，需要实现`deref`方法才行

```rust
use std::ops::Deref;
#[derive(Debug)]
struct MyBox<T>(T);
impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
impl<T> Deref for MyBox<T> {
    type Target = T;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
fn main() {
    let a = 5;
    let b = MyBox::new(a);
    assert_eq!(5, a);
    assert_eq!(5, *b);
}
```

#### 函数和方法的隐式解引用强制多态

解引用强制多态的加入使得 Rust 程序员编写函数和方法调用时无需增加过多显式使用 `&` 和 `*` 的引用和解引用。

如下面代码

```rust
fn main() {
    let m = Box::new(String::from("murphy"));
    hello(&(*m));
}
fn hello(name: &str) {
    println!("hello, {}", name);
}
```

可以直接写成

```rust
fn main() {
    let m = Box::new(String::from("murphy"));
    hello(&m);
}
fn hello(name: &str) {
    println!("hello, {}", name);
}
```

------

### 使用`Drop Trait`运行清理代码

------

### `Rc<T>`引用计数智能指针

大部分情况下所有权是非常明确的：可以准确地知道哪个变量拥有某个值。然而，有些情况单个值可能会有多个所有者。例如，在图数据结构中，多个边可能指向相同的节点，而这个节点从概念上讲为所有指向它的边所拥有。节点直到没有任何边指向它之前都不应该被清理。

#### 使用`Rc<T>`共享数据

如下代码是无法运行的，因为`a`的所有权已经移动给`b`了

```rust
fn main() {
    let a = Box::new(String::from("hello, world"));
    let b = Box::new(a);
    let c = Box::new(a);
    println!("{},{}", b, c)
}
```

如果要有多个所有者就要使用引用计数`Rc<T>`

```rust
use std::rc::Rc;
fn main() {
    let a = Rc::new(String::from("hello, world"));
    let b = Rc::clone(&a);
    let c = Rc::clone(&a);
    println!("b:{},c:{}", b, c)
}
```

------

### `RefCell<T>`和内部可变性模式