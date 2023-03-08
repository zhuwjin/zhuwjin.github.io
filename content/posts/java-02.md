---
title: "Java 注解"
date: 2022-02-05T16:57:54+08:00
draft: false
author: ["Jin"]
tags: ["Java"]
---

### `JAVA`内置注解

#### 1、`@Override`注解

`@Override`注解在重写父类方法时使用。

```java
@Override
public String toString() {
    return "User{" +
            "name='" + name + '\'' +
            ", id=" + id +
            '}';
}
```

`@Deprecated`注解表示已弃用

```java
@Deprecated
public void eat() {
    System.out.println("eating...");
}
```

`@SuppressWarnings("all")`表示忽略所有警告

```java
@SuppressWarnings("all")
public void eat() {
    System.out.println("eating...");
}
```

### 自定义注解和使用自定义注解

```java
public @interface MyAnno {}
@MyAnno
public void eat() {
    System.out.println("eating...");
}
```

### 自定义注解的属性

注解的属性类型限制：基本数据类型、String、枚举、注解、和前面类型的数组。

```java
enum Person {
    P1, P2
}

public @interface MyAnno {
    String name();
    int age();
    Person per();
    MyAnno2 an();
    String[] str();
}

@MyAnno(name="jin", age = 18, per = Person.P1, an = @MyAnno2, str = {"aaa", "bbb"})
public void eat() {
    System.out.println("eating...");
}
```

注解可以使用默认值

```java
public @interface MyAnno {
    String name();
    int age() default 18;
}

@MyAnno(name="jin")
public void eat() {
System.out.println("eating...");
}
```

如果属性只有一个`value`则可以省略

```java
public @interface MyAnno {
    String value();
}

@MyAnno("jin")
public void eat() {
    System.out.println("eating...");
}
```

### 自定义注解的元注解

#### 1、`@Target`元注解表示注解生效的位置

`ElementType.TYPE`在类上生效

`ElementType.METHOD`在方法上生效

`ElementType.FIELD`在成员变量上生效

```java
@Target({ElementType.TYPE, ElementType.METHOD, ElementType.FIELD})
public @interface MyAnno {
    String value();
}
```

#### 2、`@Retention`元注解表示注解保留的阶段

`RetentionPolicy.SOURCE`源码阶段

`RetentionPolicy.CLASS`字节码阶段

`RetentionPolicy.RUNTIME`运行时阶段

#### 3、`@Documented`元注解表示注解是否提取到`API`文档

#### 4、`@Inherited`元注解表示注解是否被子类继承

### 解析注解

```java
Target({ElementType.TYPE, ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnno {
    String className();
    String methodName();
}


public static void run(Class<MainApplication> mainApplicationClass) throws Exception {
    MyAnno annotation = mainApplicationClass.getAnnotation(MyAnno.class);
    String className = annotation.className();
    String methodName = annotation.methodName();
    Class cls = Class.forName(className);
    Constructor constructor = cls.getConstructor();
    Object obj = constructor.newInstance();
    Method method = cls.getMethod(methodName);
    method.invoke(obj);
}


@MyAnno(className = "com.jin.learnjava.User", methodName = "eat")
public class MainApplication {
    public static void main(String[] args) throws Exception {
        Runner.run(MainApplication.class);
    }
}
```

