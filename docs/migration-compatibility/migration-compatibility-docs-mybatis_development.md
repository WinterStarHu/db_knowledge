# Mybatis 连接示例

openGauss 完成 MySQL 协议兼容配置后，即可使用 Mybatis 框架配合 MySQL JDBC 连接 openGauss B 兼容模式数据库。

## 准备工作

### 准备业务表结构

1. 通过 openGauss 命令行工具 gsql 连接 openGauss 数据库

   ```bash
   gsql -d postgres -p 5432 -r
   ```

2. 切换至 MySQL 协议兼容配置的 B 库下

   ```sql
   \c proto_test_db
   ```

3. 创建 MySQL JDBC url 连接串中指定的 database。在B库下，openGauss 的 schema 等价于 MySQL 的 database

   ```sql
   CREATE SCHEMA mysql_test_db;
   ```

4. 切换 schema，并创建业务表结构

   ```sql
   SET current_schema to mysql_test_db;

   CREATE TABLE `user` (
       `id`      INT AUTO_INCREMENT PRIMARY KEY,
       `name`    VARCHAR(50)  NOT NULL COMMENT '用户名',
       `age`     INT COMMENT '年龄'
   ) DEFAULT CHARSET=utf8mb4;

   INSERT INTO `user` (`name`, `age`) VALUES
       ('张三',  18),
       ('李四',  19),
       ('王五',  20);
   ```

5. 退出 gsql 连接

   ```sql
   \q
   ```

### 准备连接用户

1. 通过 gsql 命令，重新连接 openGauss 数据库

   ```bash
   gsql -d postgres -p 5432 -r
   ```

2. 创建与业务表所在 schema 同名的用户

   ```sql
   CREATE USER mysql_test_db WITH PASSWORD '******';
   ```

> [!TIP]须知
> 不要在 schema 所在 B 库下创建同名用户，会创建失败。

3. 切换至 MySQL 协议兼容配置的 B 库下

   ```sql
   \c proto_test_db
   ```

4. 新用户设置 MySQL native 密码

   ```sql
   SELECT set_native_password('mysql_test_db', '******', '');
   ```

5. 修改业务表所在 schema 的所属用户

   ```sql
   alter schema mysql_test_db owner to mysql_test_db;
   ```

6. 赋予用户所有历史表的操作权限

   ```sql
   GRANT ALL ON ALL TABLES IN SCHEMA mysql_test_db to mysql_test_db;
   GRANT ALL ON ALL SEQUENCES IN SCHEMA mysql_test_db to mysql_test_db;
   ```

> [!TIP]须知
> 如果有新创建的表，不需要对新表重新赋权，因为 schema 所属用户已修改，新创建的表所属用户与 schema 所属用户一致。

7. 退出 gsql 连接

   ```sql
   \q
   ```

### 配置客户端接入认证

openGauss 需配置客户端接入认证后，才允许通过指定用户远程连接数据库，否则连接会报错。配置方式如下：

```bash
gs_guc set -N all -I all -h "host all mysql_test_db 0.0.0.0/0 sha256"
# 其中 mysql_test_db 为数据库用户名，此处远程连接禁止使用“omm”用户（即数据库初始化用户）

gs_om -t restart
```

更多详细内容请参考，[配置客户端接入认证](https://docs.opengauss.org/zh/docs/latest/database_administration_guide/configuring_client_access_authentication.html)。

## Mybatis 项目搭建

### 创建 Maven 项目

使用 IDE 工具创建 Maven quickstart 项目，Java 版本指定为 1.8 及以上，项目可以命名为 mybatis-connect-opengauss-b。如果没有 Maven/Java，请先完成安装。

### 添加依赖

在 Maven 项目 pom.xml 文件中，添加 MySQL JDBC 和 Mybatis 相关依赖：

```xml
org.mybatis
mybatis
3.5.13

mysql
mysql-connector-java
8.0.28

org.slf4j
slf4j-simple
1.7.36
```

### 项目目录参考

```tex
mybatis-connect-opengauss-b
├── pom.xml
└── src
    └── main
        ├── java
        │   └── org
        │       └── opengauss
        │           ├── MybatisConnectDemo.java          # 主启动类/测试类
        │           ├── entity
        │           │   └── User.java                    # 实体类
        │           └── mapper
        │               └── UserMapper.java              # MyBatis Mapper接口
        └── resources
            ├── mapper
            │   └── UserMapper.xml                       # SQL映射文件（对应UserMapper接口）
            └── mybatis-config.xml                       # MyBatis 主配置文件
```

### 准备 Mybatis 配置文件

在 src/main/resources 目录下创建 mybatis-config.xml：

```xml
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-config.dtd">
-->

```

### 创建实体类

创建与数据库表对应的实体类 User.java ：

```java
package org.opengauss.entity;

public class User {
    private Integer id;
    private String name;
    private Integer age;

    public User() {
    }

    public User(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

### 创建 Mapper 接口

创建 UserMapper.java 接口：

```java
package org.opengauss.mapper;

import org.opengauss.entity.User;

import java.util.List;

public interface UserMapper {
    /**
     * 根据ID查询用户
     *
     * @param id 用户ID
     * @return 用户对象
     */
    User selectById(Integer id);

    /**
     * 查询所有用户
     *
     * @return 所有用户列表
     */
    List selectAll();

    /**
     * 根据用户名模糊查询
     *
     * @param name 用户名模糊查询参数
     * @return 符合用户名模糊查询的用户列表
     */
    List selectByName(String name);

    /**
     * 新增用户
     *
     * @param user 新增用户对象
     * @return 新增的行数
     */
    int insert(User user);

    /**
     * 更新用户信息
     *
     * @param user 更新用户对象
     * @return 更新的行数
     */
    int update(User user);

    /**
     * 根据ID删除用户
     *
     * @param id 用户ID
     * @return 删除的行数
     */
    int deleteById(Integer id);
}
```

### 创建 XML 映射文件

在 src/main/resources/mapper 目录下创建 UserMapper.xml：

```xml
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">

        id, name, age

        SELECT
        FROM user
        WHERE id = #{id}

        SELECT
        FROM user

        SELECT
        FROM user
        WHERE name LIKE CONCAT('%', #{name}, '%')

        INSERT INTO user (name, age)
        VALUES (#{name}, #{age})

        UPDATE user
        SET name = #{name},
        age = #{age}
        WHERE id = #{id}

        DELETE FROM user WHERE id = #{id}
```

## MyBatis 数据库操作示例

### 示例代码

```java
package org.opengauss;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.opengauss.entity.User;
import org.opengauss.mapper.UserMapper;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class MybatisConnectDemo {
    private static final SqlSessionFactory sqlSessionFactory;

    static {
        try {
            InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) {
        try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

            System.out.println("=== 查询所有用户 ===");
            List users = userMapper.selectAll();
            for (User user : users) {
                System.out.println(user);
            }

            System.out.println("=== 新增用户 ===");
            User insertUser = new User("zhaoliu", 18);
            int insertCount = userMapper.insert(insertUser);
            sqlSession.commit();
            System.out.println("新增行数：" + insertCount);

            System.out.println("=== 模糊查询用户名包含zhao的用户 ===");
            List zhaoUsers = userMapper.selectByName("zhao");
            for (User user : zhaoUsers) {
                System.out.println(user);
            }

            if (!zhaoUsers.isEmpty()) {
                User zhaoUser = zhaoUsers.get(0);
                zhaoUser.setName("zhaoliuliuliu");
                zhaoUser.setAge(28);

                System.out.println("=== 更新用户信息 ===");
                int updateCount = userMapper.update(zhaoUser);
                sqlSession.commit();
                System.out.println("更新行数：" + updateCount);

                System.out.println("=== 根据ID查询用户 ===");
                User userById = userMapper.selectById(zhaoUser.getId());
                System.out.println(userById);

                System.out.println("=== 删除用户 ===");
                int deleteCount = userMapper.deleteById(zhaoUser.getId());
                System.out.println("删除行数：" + deleteCount);
                sqlSession.commit();
            }

            System.out.println("=== 查询所有用户 ===");
            users = userMapper.selectAll();
            for (User user : users) {
                System.out.println(user);
            }
        }
    }
}
```

### 示例运行日志

```tex
=== 查询所有用户 ===
User{id=1, username='张三', age=18}
User{id=2, username='李四', age=19}
User{id=3, username='王五', age=20}
=== 新增用户 ===
新增行数：1
=== 模糊查询用户名包含zhao的用户 ===
User{id=4, username='zhaoliu', age=18}
=== 更新用户信息 ===
更新行数：1
=== 根据ID查询用户 ===
User{id=4, username='zhaoliuliuliu', age=28}
=== 删除用户 ===
删除行数：1
=== 查询所有用户 ===
User{id=1, username='张三', age=18}
User{id=2, username='李四', age=19}
User{id=3, username='王五', age=20}
```
