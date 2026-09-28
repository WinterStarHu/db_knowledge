# javax.sql.DataSource

javax.sql.DataSource是数据源接口。

**表 1**  对javax.sql.DataSource接口的支持情况

方法名 返回值类型 支持JDBC 4 getConneciton() Connection Yes getConnection(String username,String password) Connection Yes getLoginTimeout() int Yes getLogWriter() PrintWriter Yes setLoginTimeout(int seconds) void Yes setLogWriter(PrintWriter out) void Yes
