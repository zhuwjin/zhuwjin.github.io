---
title: "Rust并发"
date: 2021-06-06T17:28:35+08:00
draft: false
tags: ["Rust"]
---

### 线程

使用`spawn`创建新线程

```rust
use std::thread;
use std::time::Duration;
fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });
    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

程序会输出

```
hi number 1 from the main thread!
hi number 1 from the spawned thread!
hi number 2 from the main thread!
hi number 2 from the spawned thread!
hi number 3 from the main thread!
hi number 3 from the spawned thread!
hi number 4 from the main thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
```

这里`spawn`的线程到`4`就结束了，因为`main`线程提前结束了

#### 使用`join`等待所有线程结束

```rust
use std::thread;
use std::time::Duration;
fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });
    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
    handle.join().unwrap();
}
```

大致会产生如下输出

```
hi number 1 from the main thread!
hi number 2 from the main thread!
hi number 1 from the spawned thread!
hi number 3 from the main thread!
hi number 2 from the spawned thread!
hi number 4 from the main thread!
hi number 3 from the spawned thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
hi number 6 from the spawned thread!
hi number 7 from the spawned thread!
hi number 8 from the spawned thread!
hi number 9 from the spawned thread!
```

#### 线程与`move`闭包

闭包可以使用环境中的变量

下面代码无法编译，因为不知道`v`是否一直有效

```rust
use std::thread;
fn main() {
    let v = vec![1, 2, 3];
    let handle = thread::spawn(|| {
        println!("Here's a vector: {:?}", v);
    });
    handle.join().unwrap();
}
```

可以使用`move`获取`v`的所有权来解决，保证`v`不会在线程结束前失效

```rust
use std::thread;
fn main() {
    let v = vec![1, 2, 3];
    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
    });
    handle.join().unwrap();
}
```

------

### 消息传递

`rust`是通过通道来传递消息的，通道有两部分组成，一部分是发送者，一部分是接收者

创建通道

```rust
use std::sync::mpsc;
fn main() {
    let (tx, rx) = mpsc::channel();//返回一个元组，tx是发送者，rx是接收者
}
```

#### 发送消息

```rust
use std::thread;
use std::sync::mpsc;
fn main() {
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
}
```

#### 接收消息

接收消息有两种方式，`recv`和`try_recv`，`recv`会阻塞线程，而`try_recv`不会

```rust
use std::thread;
use std::sync::mpsc;
fn main() {
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

程序会输出

```
Got: hi
```

#### 通道与所有权转移

发送消息后所有权就没有了，再使用变量会出错

```rust
use std::thread;
use std::sync::mpsc;
fn main() {
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
        println!("val is {}", val);//错误
    });
    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

#### 通过克隆发送者来创建多个生产者

```rust
use std::thread;
use std::sync::mpsc;
fn main() {
    let (tx, rx) = mpsc::channel();
    let tx1 = tx.clone();
    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];
        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });
    thread::spawn(move || {
        let vals = vec![
            String::from("more"),
            String::from("messages"),
            String::from("for"),
            String::from("you"),
        ];
        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });
    for received in rx {
        println!("Got: {}", received);
    }
}
```

------

### 共享状态

#### 互斥器

互斥器在任何时候，只允许一个线程访问，为了访问互斥器中的数据，线程首先需要通过获取互斥器的锁

在单线程上下文使用互斥器

```rust
use std::sync::Mutex;
fn main() {
    let m = Mutex::new(5);
    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }
    println!("m = {:?}", m);//输出6
}
```

使用`lock()`来获取锁，当一个线程获取锁后，其他线程就无法在获取了，会产生`panic`

#### 在线程间共享`Mutex<T>`

尝试使用mutex<T>在多个线程间共享值

```rust
use std::sync::Mutex;
use std::thread;
fn main() {
    let counter = Mutex::new(0);
    let mut handles = vec![];
    for _ in 0..10 {
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }
    for handle in handles {
        handle.join().unwrap();//等待每个线程结束
    }
    println!("Result: {}", *counter.lock().unwrap());
}
```

会出现如下错误

```rust
error[E0382]: use of moved value: `counter`
  --> smart_pointers/src/main.rs:9:36
   |
5  |     let counter = Mutex::new(0);
   |         ------- move occurs because `counter` has type `Mutex<i32>`, which does not implement the `Copy` trait
...
9  |         let handle = thread::spawn(move || {
   |                                    ^^^^^^^ value moved into closure here, in previous iteration of loop
10 |             let mut num = counter.lock().unwrap();
   |                           ------- use occurs due to use in closure
```

编译器告诉我们`counter`被移动了，不能在多个线程中使用

那如果使用之前的`Rc<T>`来创建引用计数的值，以便拥有多个所有者

```rust
use std::rc::Rc;
use std::sync::Mutex;
use std::thread;
fn main() {
    let counter = Rc::new(Mutex::new(0));
    let mut handles = vec![];
    for _ in 0..10 {
        let counter = Rc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }
    for handle in handles {
        handle.join().unwrap();
    }
    println!("Result: {}", *counter.lock().unwrap());
}
```

不幸的是这样也不行，编译器会告诉你不安全

不过还有一种`Arc<T>`可以安全的实现这个功能

```rust
use std::sync::{Mutex, Arc};
use std::thread;
use std::rc::Rc;
fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];
    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }
    for handle in handles {
        handle.join().unwrap();//等待每个线程结束
    }
    println!("Result: {}", *counter.lock().unwrap());
}
```

程序终于能够成功运行，并输出如下内容

```
Result: 10
```

------

使用`Sync`和`Send trait`的可扩展并发