---
title: "Java 反射"
date: 2022-02-05T14:13:46+08:00
draft: false
author: ["Jin"]
tags: ["Java"]
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



### 使用`Class`类获取类的成员变量

#### 1、使用`getFields()`获取所有的`public`成员变量

```java
Class c1 = User.class;
Field[] fields = c1.getFields();
for(Field field : fields) {
    System.out.Println(field);
}
```

#### 2、使用`getField()`获取指定的`public`成员变量

```java
Class c1 = User.class;
Field field = c1.getField("name");
```

#### 3、使用`getDeclaredFields()`获取所有的成员变量

```java
Class c1 = User.class;
Field[] fields = c1.getDeclaredFields();
for(Field field : fields) {
    System.out.Println(field);
}
```

#### 4、使用`getDeclaredField()`获取指定的成员变量

```java
Class c1 = User.class;
Field field = c1.getDeclaredField("name");
```

#### 5、获取和设置成员变量的值

```java
User user1 = new User();
Class c1 = User.class;
Field name = c1.getDeclaredField("name");
name.setAccessible(true);//不检测可见性
System.out.println(name.get(user1));
name.set(user1, "jin");
System.out.println(user1.getName());
```

### 使用`Class`类获取类的构造方法

```java
Class c1 = User.class;
Constructor constructor = c1.getConstructor(String.class, int.class);
Object user1 = constructor.newInstance("jin", 1);
System.out.println(user1);
```

```java
Class c1 = User.class;
Constructor constructor = c1.getDeclaredConstructor(String.class);
constructor.setAccessible(true);
Object user1 = constructor.newInstance("jin");
System.out.println(user1);
```

------

### 使用`Class`类获取类的成员方法

```java
Class c1 = User.class;
User user1 = new User("jin", 1);
Method getName = c1.getMethod("getName");
Object str = getName.invoke(user1);
System.out.println(str);
```



### 反射的使用

```java
ClassLoader classLoader = MainApplication.class.getClassLoader();
InputStream inputStream = classLoader.getResourceAsStream("pro.properties");
Properties pro = new Properties();
pro.load(inputStream);
String className = pro.getProperty("className");
String methodName = pro.getProperty("methodName");
Class cls = Class.forName(className);
Constructor constructor = cls.getConstructor();
Object obj = constructor.newInstance();
Method method = cls.getMethod(methodName);
method.invoke(obj);
```

```properties
className = com.jin.learnjava.User
methodName = eat
```

