# SpringBoot 连接示例

本文介绍 SpringBoot 连接示例。

## 环境配置

JDK1.8 和 OceanBase 3.x

## 示例代码

### Pom.xml 文件

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
4.0.0

com.alipay.test
SpringBootOracleJPA
1.0-SNAPSHOT
org.springframework.boot
spring-boot-starter-parent
2.0.1.RELEASE

org.springframework.boot
spring-boot-starter-web
spring-boot-starter-json
org.springframework.boot

javax.validation
validation-api
2.0.1.Final
com.oracle
ojdbc6
12.1.0.1
com.alipay.oceanbase
oceanbase-client
3.2.3
org.springframework.boot
spring-boot-starter-data-jpa
junit
junit
3.8.1
test
com.alibaba
fastjson
1.2.47
com.fasterxml.jackson.core
jackson-databind
2.8.5
org.codehaus.jackson
jackson-core-asl
1.9.4
org.apache.tomcat
tomcat-juli
9.0.37

```

### application.yml 文件

```java
server:
  port: 8081
spring:
  jpa:
    database: oracle
    show-sql: true
  datasource:
      driver-class-name: com.alipay.oceanbase.jdbc.Driver
      url: jdbc:oceanbase://host:port/test?characterEncoding=UTF-8
      username: ****@****
      password: ******
#spring.jpa.hibernate.ddl-auto=update
jackson:
  serialization:
    indent_output: true
```

### 测试类

相关代码如下：

```java
package com.alipay;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Date;

/*
 * CREATE TABLE A(id integer, flightNo varchar2(50))
 *
 */
@Entity
@Table( name = "A" )
public class A implements Serializable {
    public Integer getFlightId() {
        return flightId;
    }

    public void setFlightId(Integer flightId) {
        this.flightId = flightId;
    }

    public String getFlightNo() {
        return flightNo;
    }

    public void setFlightNo(String flightNo) {
        this.flightNo = flightNo;
    }

    @Id
//    @GeneratedValue
// oracle 没有自增策略，添加该注解可以自动生成一个序列，提供自增主键，若数据库已有相关序列，可以忽 //略该注解。
    @Column(name = "id")
    private Integer flightId;

    @Column( name = "flightNo" )
    private String flightNo;

}
```

```java
package com.alipay;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AMapper extends JpaRepository {

}
```

```java
package com.alipay;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/")
public class Test {
    @Autowired
    private AMapper a;
    @GetMapping("/{id}")
    public String getOne(@PathVariable int id) {

        Optional obj = a.findById(id);
        String result = "A.id is:" + obj.get().getFlightId() + ", no is :" + obj.get().getFlightNo();
        System.out.println(result);
        return result;
    }
}
```

```java
package com.alipay;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class App
{
    public static void main( String[] args )
    {
        SpringApplication.run(App.class, args);
    }
}
```

然后运行：

如下日志表示启动成功![SpringBoot 连接示例](https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/4902751561/p416901.png)然后通过 `http://localhost:8081/xxxxx` 就可以访问 `xxxxx` 就是对应的 id 字段，如果数据库存在就可以查询到结果。
