# Hibernate 连接示例

本文介绍 Hibernate 连接示例，并测试几个常用功能。

## 配置依赖

```java
com.alipay.oceanbase
oceanbase-client
3.2.3
org.hibernate
hibernate-core
5.0.7.Final
```

## hibernate.cfg.xml 文件

内容如下：

```xml
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
com.alipay.oceanbase.jdbc.Driver
jdbc:oceanbase://10.100.xxx.xxx:18815/test
admin
admin

org.hibernate.dialect.MySQLDialect

true
update-->
create-->

```

## 测试准备

### 实体类

```java
public class User implements Serializable {
    private Integer id;
    private String username;
    private Date birthday;
    private String sex;
    private String address;
    //先注释一个字段，以便验证使用框架建表后，自动根据实体类新增属性修改表
    //private String tel;
    //。。。。。。构造器、get、set方法此处省略。。。。。。。。
}
```

### 实体类映射表 xml 文件

```java
<!DOCTYPE hibernate-mapping PUBLIC
        '-//Hibernate/Hibernate Mapping DTD 3.0//EN'
        'http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd'>

-->
```

## 示例代码

### 连接

```java
@Test
    public void testConnection(){
     //加载配置信息
     Configuration conf = new Configuration().configure();
     //基于配置信息,创建SessionFactory对象
     SessionFactory sessionFactory = conf.buildSessionFactory();
     //打开一个与数据库相关的session对象
     Session session = sessionFactory.openSession();
        System.out.println(session);
    }
```

成功建立连接：![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600334267555-430fe94d-342b-448a-959f-587d285a0d9c.png)

### 自动建表

将配置文件本行注释打开：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600334333681-7e956040-34fd-40ed-85e6-ba379ed15060.png)

将数据库中user表删除后，执行如下测试方法：

```java
@Test
    public void testCreateTableAndInsertData(){
        //创建要测试的对象
        User user = new User();
        user.setUsername("hibernateTest");
        user.setSex("女");
        user.setBirthday(new Date());
        user.setAddress("北京");

        //开启事务,基于session得到
        Transaction transaction = session.beginTransaction();
        //通过session保存数据
        session.save(user);
        //提交事务
        transaction.commit();
        //操作完毕,关闭session连接对象
        session.close();
    }
```

查看控制台打印出来的所执行 sql 语句以及 oceanbase 数据库中的结果：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600334511137-0b794fa3-7082-40fe-b25a-2c050919ab9e.png) ![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600334613237-b717b18a-d093-4bd0-92ae-dc867de21252.png)

从结果上看 OceanBase 对于 hibernate 的 create table 功能支持良好。

### 修改表(增加字段)

首先修改配置文件，如下：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600334810529-dff5eb3b-bcd9-497f-bb40-e5392635e764.png)

将实体类和 xml 文件中关于 tel 属性的注释打开，执行如下方法：

```java
@Test
    public void testAlterTable(){
        //创建要测试的对象
        User user = new User();
        user.setUsername("hibernateTest");
        user.setSex("女");
        user.setBirthday(new Date());
        user.setAddress("北京");
        user.setTel("12345678911");

        //开启事务,基于session得到
        Transaction transaction = session.beginTransaction();
        //通过session保存数据

        session.save(user);
        //提交事务
        transaction.commit();
        //操作完毕,关闭session连接对象
        session.close();
    }
```

执行语句及数据库结果显示如下：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600335112775-fdba3420-9da3-49e5-bb72-9146a951741d.png) ![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600335140287-adc296c9-06f1-43b4-b60d-d27b70ab69ee.png)

在原有表的基础上，框架根据实体类及 xml 文件，自动对表进行了新增字段处理。

从结果上来看，OceanBase 对于 hibernate 的 alert table 功能支持良好。

### 持久化数据

测试方法：

```java
@Test
    public void testInsert() {
        User u1 = new User("asd", new Date(), "男", "漳州");
        User u2 = new User("qwe", new Date(), "女", "杭州");
        User u3 = new User("zxc", new Date(), "男", "上海");
        User u4 = new User("xcv", new Date(), "女", "杭州");
        User u5 = new User("sdf", new Date(), "男", "杭州");
        User u6 = new User("wer", new Date(), "女", "杭州");
        User u7 = new User("ert", new Date(), "男", "漳州");
        User u8 = new User("rty", new Date(), "女", "上海");
        User u9 = new User("tyu", new Date(), "男", "杭州");
        ArrayList users = new ArrayList<>();
        users.add(u1);
        users.add(u2);
        users.add(u3);
        users.add(u4);
        users.add(u5);
        users.add(u6);
        users.add(u7);
        users.add(u8);
        users.add(u9);
        //开启事务,基于session得到
        Transaction transaction = session.beginTransaction();
        //通过session保存数据
        for (User user : users) {
            session.save(user);
        }
        //提交事务
        transaction.commit();
        //操作完毕,关闭session连接对象
        session.close();
    }
```

执行结果如下：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600337129410-c1a3d5e7-e37e-4d73-a5bd-3ec9117c85bc.png)

从结果上来看，OceanBase 对于 hibernate 的 Insert 功能支持良好，且支持 Hibernate 自增主键生成策略。

### HQL 模式和 SQL 模式查询

测试方法：

```java
@Test
    public void testQuery() {
       //SQL模式
  //SQLQuery query = sessionFactory.openSession().createSQLQuery("select * from user where sex = '男'").addEntity(User.class);
        //HQL模式
        //Query query = sessionFactory.openSession().createQuery("select User from User User where User.sex = '男'");
        List list = query.list();
        list.forEach(System.out::println);
    }
```

执行结果如下：

SQL 模式：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600337476100-a1f73d65-80eb-4503-870e-3d22ff03624a.png)

HQL 模式：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600337565981-0e865414-fd86-46d0-a444-fa89ecc9715c.png)

从结果上来看，OceanBase 对于 hibernate 的 query 功能支持良好。

### 修改操作

测试方法：

```java
@Test
    public void testChange(){
        User user = (User) session.createSQLQuery("select * from user where id = 1").addEntity(User.class).list().get(0);
        System.out.println("修改前："+user);
        user.setAddress("杭州");
        session.update(user);
        user = (User) session.createSQLQuery("select * from user where id = 1").addEntity(User.class).list().get(0);
        System.out.println("修改后："+user);
    }
```

执行结果如下：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600399282326-3cbc5c25-b863-4bb2-8c18-8705eb76a94e.png)

从结果上来看，OceanBase 对于 hibernate 的 update 功能支持良好。

### 删除操作

测试方法：

```java
@Test
    public void testDelete(){
        Transaction transaction = session.beginTransaction();
        List list = session.createSQLQuery("select * from user").addEntity(User.class).list();
        System.out.println(list);
        int i = session.createSQLQuery("delete from user where id = " + list.get(0).getId()).executeUpdate();
        list = session.createSQLQuery("select * from user").addEntity(User.class).list();
        System.out.println(list);
        //提交事务
        transaction.commit();
        //操作完毕,关闭session连接对象
        session.close();
    }
```

执行结果如下：

![1](https://intranetproxy.alipay.com/skylark/lark/0/2020/png/328295/1600414457985-75fe0463-769d-44cc-822f-42ab20b55969.png)

从结果上来看，OceanBase 对于 hibernate 的 delete 功能支持良好。
