# MyBatis 连接示例

本文介绍 MyBatis 连接示例的配置依赖和配置文件。

## 配置依赖

```java
com.alipay.oceanbase
oceanbase-client
3.2.3
org.mybatis
mybatis
3.5.4
```

## 配置文件

### mybatis-config.xml 文件

内容如下：

```xml
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

```

### mapper.xml 文件

内容如下：

```xml
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
        select * from user;

        delete from user;
```
