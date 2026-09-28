# CopyManager

CopyManager是openGauss JDBC驱动中提供的一个API接口类，用于批量向openGauss中导入数据。

## CopyManager的继承关系

CopyManager类位于org.postgresql.copy Package中，继承自java.lang.Object类，该类的声明如下：

```
public class CopyManager
extends Object
```

## 构造方法

public CopyManager\(BaseConnection connection\)

throws SQLException

## 常用方法

**表 1**  CopyManager常用方法

返回值 throws CopyIn copyIn(String sql) SQLException long copyIn(String sql, InputStream from) 使用COPY FROM STDIN从InputStream中快速向数据库中的表加载数据。
SQLException,IOException long copyIn(String sql, InputStream from, int bufferSize) 使用COPY FROM STDIN从InputStream中快速向数据库中的表加载数据。
SQLException,IOException long copyIn(String sql, Reader from) 使用COPY FROM STDIN从Reader中快速向数据库中的表加载数据。
SQLException,IOException long copyIn(String sql, Reader from, int bufferSize) 使用COPY FROM STDIN从Reader中快速向数据库中的表加载数据。
SQLException,IOException CopyOut copyOut(String sql) SQLException long copyOut(String sql, OutputStream to) 将一个COPY TO STDOUT的结果集从数据库发送到OutputStream类中。
SQLException,IOException long copyOut(String sql, Writer to) 将一个COPY TO STDOUT的结果集从数据库发送到Writer类中。
SQLException,IOException
