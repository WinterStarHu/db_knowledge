# psycopg2.connect\(\)

## 功能描述

此方法创建新的数据库会话并返回新的connection对象。

## 原型

```
conn=psycopg2.connect(dbname="test",user="postgres",password="secret",host="127.0.0.1",port="5432")
```

## 参数

**表 1**  psycopg2.connect参数

关键字 参数说明 dbname 数据库名称。
user 用户名。
password 密码。
host 数据库IP地址，默认为UNIX socket类型。
port 连接端口号，默认为5432。
sslmode ssl模式，ssl连接时用。
sslcert 客户端证书路径，ssl连接时用。
sslkey 客户端密钥路径，ssl连接时用。
sslrootcert 根证书路径，ssl连接时用。

## 返回值

connection对象（连接openGauss数据库实例的对象）。

## 示例

请参见[示例：常用操作](example_common_operations_psycopg.md)。
