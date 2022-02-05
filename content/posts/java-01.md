---
title: "Java 反射"
date: 2022-02-05T14:13:46+08:00
draft: false
---

### 准备

定义一个`User`类

```java
public class User {
    private String name;
    private int id;

    public User(String name, int id) {
        this.name = name;
        this.id = id;
    }

    public User() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", id=" + id +
                '}';
    }
}
```

### `Class`类

#### 获取`Class`类的三种方法

##### 1、使用`Class.forName()`方法

```java
Class c1 = Class.forName("life.jinjiang.User");
```

##### 2、使用`类名.class`方法

```java
Class c2 = User.class;
```

##### 3、使用`对象.getClass()`方法

```java
User user1 = new User();
Class c3 = user1.getClass();
```

