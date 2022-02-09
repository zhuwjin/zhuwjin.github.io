---
title: "Spring Bean"
date: 2022-02-08T14:45:56+08:00
draft: false
author: ["Jin"]
tags: ["Java", "Spring"]
---

### `IOC`控制反转

把对象创建和对象之间的调用交给`Spring`进行管理，降低耦合度。

`xml`解析、工厂模式、反射。

### 使用`Bean`创建对象

#### 使用`xml`方式

```java
public class User {
    private String name;
    private int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User() {}

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

```java
public class MainApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("Bean.xml");
        User user = (User) classPathXmlApplicationContext.getBean("user");
        System.out.println(user);
    }
}
```

使用无参构造和`setter`方法

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <property name="name" value="Jin"/>
        <property name="age" value="18"/>
    </bean>
</beans>
```

使用有参构造方法

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <constructor-arg name="name" value="Jin"/>
        <constructor-arg name="age" value="18"/>
    </bean>
</beans>
```

