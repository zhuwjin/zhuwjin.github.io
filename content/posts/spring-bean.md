---
title: "Spring Bean"
date: 2022-02-08T14:45:56+08:00
draft: false
author: ["Jin"]
tags: ["Java", "Spring"]
---

### 〇、`IOC`控制反转

把对象创建和对象之间的调用交给`Spring`进行管理，降低耦合度。

`xml`解析、工厂模式、反射。

### 一、`Bean`（使用`xml`）

#### 1.0、使用`Bean`创建对象

##### 1.0.0、准备对象

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

##### 1.0.1、使用无参构造和`setter`方法

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

##### 1.0.2、使用有参构造方法

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <constructor-arg name="name" value="Jin"/>
        <!--  <constructor-arg index="0" value="Jin"/>  -->
        <constructor-arg name="age" value="18"/>
    </bean>
</beans>
```

##### 1.0.3、使用`p`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd"
       xmlns:p="http://www.springframework.org/schema/p">
    <bean id="user" class="life.jinjiang.User" p:name="Jin" p:age="18"/>
</beans>
```

##### 1.0.4、设置空值

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <property name="name"><null/></property>
        <property name="age" value="18"/>
    </bean>
</beans>
```



#### 1.1、注入

##### 准备对象

```java
public class UserService {
    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "UserService{" +
                "user=" + user +
                '}';
    }
}
```

```java
public class MainApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("Bean.xml");
        UserService userService = (UserService) classPathXmlApplicationContext.getBean("userService");
        System.out.println(userService);
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <property name="name" value="Jin"/>
        <property name="age" value="18"/>
    </bean>
    <bean id="userService" class="life.jinjiang.UserService">
        <property name="user" ref="user"/>
    </bean>
</beans>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
<!--        <property name="name" value="Jin"/>-->
<!--        <property name="age" value="18"/>-->
    </bean>
    <bean id="userService" class="life.jinjiang.UserService">
        <property name="user" ref="user"/>
        <property name="user.name" value="Jin"/>
        <property name="user.age" value="18"/>
    </bean>
</beans>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
<!--        <property name="name" value="Jin"/>-->
<!--        <property name="age" value="18"/>-->
    </bean>
    <bean id="userService" class="life.jinjiang.UserService">
        <property name="user">
            <bean id="user" class="life.jinjiang.User">
                <property name="name" value="Jin"/>
                <property name="age" value="18"/>
            </bean>
        </property>
    </bean>
</beans>
```



#### 1.2、作用域

单实例：`singleton`默认，读取配置文件时就创建

多实例：`prototype`，创建对象时才创建

```java
public class MainApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("Bean.xml");
        User user = (User) classPathXmlApplicationContext.getBean("user");
        User user2 = (User) classPathXmlApplicationContext.getBean("user");
        System.out.println(user==user2);
    }
}
```

默认单实例输出`true`

更改配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User" scope="prototype">
        <property name="name" value="Jin"/>
        <property name="age" value="18"/>
    </bean>
</beans>
```

多实例输出`false`



#### 1.3、生命周期

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
        System.out.println("执行setter方法");
    }

    public User() {
        System.out.println("执行构造方法");
    }

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

    public void initMethod() {
        System.out.println("执行init方法");
    }

    public void destroyMethod() {
        System.out.println("执行destroy方法");
    }
}
```



```java
public class MainApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("Bean.xml");
        User user = (User) classPathXmlApplicationContext.getBean("user");
        classPathXmlApplicationContext.close();
    }
}
```



输出

```
执行构造方法
执行setter方法
执行init方法
执行destroy方法
```

##### 后置处理器

```java
public class MyBeanPost implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("执行postProcessBeforeInitialization方法");
        return BeanPostProcessor.super.postProcessBeforeInitialization(bean, beanName);
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("执行postProcessAfterInitialization方法");
        return BeanPostProcessor.super.postProcessAfterInitialization(bean, beanName);
    }
}
```



```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User" init-method="initMethod" destroy-method="destroyMethod">
        <property name="name" value="Jin"/>
        <property name="age" value="18"/>
    </bean>
    <bean id="myBeanPost" class="life.jinjiang.MyBeanPost"/>
</beans>
```



```
执行构造方法
执行setter方法
执行postProcessBeforeInitialization方法
执行init方法
执行postProcessAfterInitialization方法
执行destroy方法
```



#### 1.4、自动装配

`autowire`属性有两种常用的值：`ByName`和`ByType`

`ByName`：根据对象名称来匹配

`ByType`：根据对象类型来匹配

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
public class UserService {
    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "UserService{" +
                "user=" + user +
                '}';
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="user" class="life.jinjiang.User">
        <property name="name" value="Jin"/>
        <property name="age" value="18"/>
    </bean>
    <bean id="userService" class="life.jinjiang.UserService" autowire="byName"/>
</beans>
```

```java
public class MainApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext classPathXmlApplicationContext = new ClassPathXmlApplicationContext("Bean.xml");
        UserService userService = (UserService) classPathXmlApplicationContext.getBean("userService");
        System.out.println(userService);
    }
}
```



### 二、`Bean`（使用注解）

#### 使用`Bean`创建对象

注解有四种

`@Component`：

`@Service`：

`@Controller`：

`@Repository`：

功能都一样

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    <context:component-scan base-package="life.jinjiang"/>
</beans>
```

```java
import org.springframework.stereotype.Component;

@Component
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

#### 组件扫描配置

扫描`life.jinjiang`下的所有包和子包

```xml
<context:component-scan base-package="life.jinjiang"/>
```

只扫描`life.jinjiang`下的`@Component`注解标注的类

```xml
<context:component-scan base-package="life.jinjiang" use-default-filters="false">
    <context:include-filter type="annotation" expression="org.springframework.stereotype.Component"/>
</context:component-scan>
```

扫描`life.jinjiang`下的除了`@Controller`下的包

```xml
<context:component-scan base-package="life.jinjiang">
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
```

#### 注入

