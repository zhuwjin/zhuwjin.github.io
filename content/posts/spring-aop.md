---
title: "Spring Aop"
date: 2022-02-10T14:01:50+08:00
draft: false
author: ["Jin"]
tags: ["Java", "Spring"]
---

### 〇、`AOP`

面向切面编程。利用`AOP`可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。不修改原代码添加新功能。

### 一、`AOP`底层原理

`AOP`底层使用动态代理。

#### 1、`JDK`动态代理

```java
public interface Student {
    void say_hello();
    int add(int a, int b);
}
```

```java
public class StudentImpl implements Student{
    @Override
    public void say_hello() {
        System.out.println("Hello");
    }

    @Override
    public int add(int a, int b) {
        return a + b;
    }
}
```

```java
public class MainApplication {
    public static void main(String[] args) {
        Student student = new StudentImpl();
        Class[] interfaces = {Student.class};
        Student student1 = (Student) Proxy.newProxyInstance(MainApplication.class.getClassLoader(), interfaces, new MyStudentProxy(student));
        student1.add(1, 2);
    }
}

class MyStudentProxy implements InvocationHandler {

    private Object obj;

    public MyStudentProxy(Object obj) {
        this.obj = obj;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("aaaaa");
        Object res =  method.invoke(obj, args);
        System.out.println("bbbbb");
        System.out.println(res);
        return res;
    }
}
```

```
aaaaa
bbbbb
3
```

