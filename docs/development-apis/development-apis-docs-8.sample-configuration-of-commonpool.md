# CommonPool 配置示例

本文介绍 CommonPool 连接池配置依赖、配置文件和示例代码。

## 配置依赖

结合 hibernate 及 commonpool 对 oceanbase 数据库进行操作。

```xml
org.apache.commons
commons-pool2
2.7.0
org.hibernate
hibernate-core
5.0.7.Final
org.hibernate
hibernate-ehcache
4.3.11.Final
com.alipay.oceanbase
oceanbase-client
3.2.3
```

### 实体类

```java
import javax.persistence.*;

@Entity
@Table(name = "user_test")
public class User {

 public User() { }

 @Id

 private Integer id;

 @Column
 private String username;

 @Column
 private String birthday;

 public User(Integer id, String username, String birthday) {
  this.id = id;
  this.username = username;
  this.birthday = birthday;
 }

 public Integer getId() {
  return id;
 }

 public void setId(Integer id) {
  this.id = id;
 }

 public String getUsername() {
  return username;
 }

 public void setUsername(String username) {
  this.username = username;
 }

 public String getBirthday() {
  return birthday;
 }

 public void setBirthday(String birthday) {
  this.birthday = birthday;
 }

 @Override
 public String toString() {
  return "User{" +
    "id=" + id +
    ", username='" + username + '\'' +
    ", birthday='" + birthday + '\'' +
    '}';
 }
}
```

### hibernate

实体类映射文件

```xml
<!DOCTYPE hibernate-mapping PUBLIC
        '-//Hibernate/Hibernate Mapping DTD 3.0//EN'
        'http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd'>
```

hibernate 配置文件：

```xml
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

com.alipay.oceanbase.jdbc.Driver
jdbc:oceanbase://10.100.xxx.xxx:18815/test
admin@mysql
admin
org.hibernate.dialect.MySQLDialect-->

true

update-->
create-->

```

## 示例代码

实现 CommonPool 管理 Hibernate。

因 Hibernate 操作数据库的方式为 `Session.xxxx();`，所以此处选择实现一个 SessionPool。具体步骤如下。

1. 首先创建几个必要的类：SessionPool(会话池)，SessionFactory(会话工厂)，SessionPoolConfig(会话池配置类)。

   ```java
   package sess;

   import org.apache.commons.pool2.PooledObjectFactory;
   import org.apache.commons.pool2.impl.GenericObjectPool;
   import org.apache.commons.pool2.impl.GenericObjectPoolConfig;
   import org.hibernate.Session;

   import java.io.Closeable;

   public class SessionPool implements Closeable {

       //通用对象池，此处泛型决定了池中对象类型为org.hibernate.Session
       private GenericObjectPool internalPool;

       public SessionPool(GenericObjectPoolConfig poolConfig, PooledObjectFactory factory){
           if (this.internalPool != null) {
               try {
                   closeInternalPool();
               } catch (Exception e) {
               }
           }
           this.internalPool = new GenericObjectPool(factory, poolConfig);
       }

       // 获取连接会话
       public Session getSession(){
           Session session = null;
           try {
               session = internalPool.borrowObject();
           } catch (Exception e) {
               throw new RuntimeException("Could not get session from the pool", e);
           }
           return session;
       }

       // 返还连接会话（将使用完毕的对象返回到池）
       public void returnSession(Session session){
           internalPool.returnObject(session);
       }

       @Override
       public void close(){
           this.closeInternalPool();
       }

       private void closeInternalPool() {
           try {
               internalPool.close();
           } catch (Exception e) {
               throw new RuntimeException("Could not destroy the pool", e);
           }
       }
   }
   ```

   ```java
   package sess;

   import org.apache.commons.pool2.BasePooledObjectFactory;
   import org.apache.commons.pool2.PooledObject;
   import org.apache.commons.pool2.impl.DefaultPooledObject;
   import org.hibernate.Session;
   import org.hibernate.cfg.Configuration;

   public class SessionFactory extends BasePooledObjectFactory {

       // 创建新的数据库连接会话
       @Override
       public Session create() throws Exception {
           //加载配置信息
           Configuration conf = new Configuration().configure();
           //基于配置信息,创建SessionFactory对象
           org.hibernate.SessionFactory sessionFactory = conf.buildSessionFactory();
           //打开一个与数据库相关的session对象
           Session session = sessionFactory.openSession();
           return session;
       }

       // 使用PooledObject对数据库连接会话进行包装
       @Override
       public PooledObject wrap(Session session) {
           return new DefaultPooledObject(session);
       }

       // 由于validateObject失败或其它什么原因，对象实例从对象池中移除时调用
       // 不能保证对象实例被移除时所处的状态
       public void destroyObject(PooledObject pooledConnection) throws Exception {
           Session session = pooledConnection.getObject();
           session.close();
       }

       // 仅能被active状态的对象实例调用
       // 从对象池获取对象实例，在对象池返回该对象实例前，调用该方法校验其状态
       // 对象实例归还给对象池时，在调用passivateObject方法前，使用该方法校验其状态
       public boolean validateObject(PooledObject pooledConnection) {
           Session session = pooledConnection.getObject();
           try {
   //            if (session.isValid(1))
               if (session.isOpen())
                   return true;
               else
                   return false;
           }catch(Exception e){
               return false;
           }
       }

       // 对象实例在归还给对象池时调用了passivateObject方法，通过对象池再次取到该对象实例
       // 在对象池返回该对象实例前，需要调用该方法
       public void activateObject(PooledObject pooledConnection) throws Exception {
     //。。。。。。。。。
       }

       // 对象实例归还给对象池时调用
       public void passivateObject(PooledObject pooledConnection) throws Exception {
     //。。。。。。。。。
       }
   }
   ```

   ```java
   package sess;

   import org.apache.commons.pool2.impl.GenericObjectPoolConfig;

   public class SessionPoolConfig extends GenericObjectPoolConfig {

       public SessionPoolConfig(){
           setMaxTotal(10);
           setMaxIdle(5);
           setMinIdle(2);
       }
   }
   ```

2. 进行测试。

   ```java
       @Test
       public void test() throws Exception {
           //创建公共池配置类
           SessionPoolConfig sessionPoolConfig = new SessionPoolConfig();
           //创建会话工厂
           SessionFactory sessionFactory = new SessionFactory();

           //配置会话池属性
           sessionPoolConfig.setMaxTotal(4);
           sessionPoolConfig.setMaxIdle(3);
           sessionPoolConfig.setMinIdle(2);
           sessionPoolConfig.setMaxWaitMillis(200);
           sessionPoolConfig.setTestOnBorrow(false);
           sessionPoolConfig.setTestOnReturn(false);

           //构建会话池
           SessionPool sessionPool = new SessionPool(sessionPoolConfig,sessionFactory);

           //测试
           for (int i = 1; i <= 10; i++) {
               User user = new User();
               user.setId(i);
               user.setUsername("Test");
               user.setBirthday("test");

               Session session = sessionPool.getSession();
               Transaction transaction = session.beginTransaction();
               session.save(user);

               System.out.println("第"+i+"次数据库操作，会话对象哈希值为："+session.hashCode());
               transaction.commit();
               //将该session返回到池
               sessionPool.returnSession(session);
           }
       }
   ```
