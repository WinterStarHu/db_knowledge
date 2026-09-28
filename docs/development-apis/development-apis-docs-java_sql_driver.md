# java.sql.Driver

java.sql.Driver是数据库驱动接口。

**表 1**  对java.sql.Driver的支持情况

方法名 返回值类型 支持JDBC 4 acceptsURL(String url) Boolean Yes connect(String url, Properties info) Connection Yes jdbcCompliant() Boolean Yes getMajorVersion() int Yes getMinorVersion() int Yes getParentLogger() Logger Yes getPropertyInfo​(String url, Properties info) DriverPropertyInfo[] Yes
