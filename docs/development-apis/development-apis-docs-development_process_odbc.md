# 开发流程

**图 1**  ODBC开发应用程序的流程 ![](figures/The-process-of-developing-application-programs-using-ODBC.png)

## 开发流程中涉及的API

**表 1**  相关API说明

API 申请句柄资源 SQLAllocHandle：申请句柄资源，可替代如下函数： SQLAllocEnv：申请环境句柄SQLAllocConnect：申请连接句柄SQLAllocStmt：申请语句句柄 设置环境属性 SQLSetEnvAttr 设置连接属性 SQLSetConnectAttr 设置语句属性 SQLSetStmtAttr 连接数据源 SQLConnect 绑定缓冲区到结果集的列中 SQLBindCol 绑定SQL语句的参数标志和缓冲区 SQLBindParameter 查看最近一次操作错误信息 SQLGetDiagRec 为执行SQL语句做准备 SQLPrepare 执行一条准备好的SQL语句 SQLExecute 直接执行SQL语句 SQLExecDirect 结果集中取行集 SQLFetch 返回结果集中某一列的数据 SQLGetData 获取结果集中列的描述信息 SQLColAttribute 断开与数据源的连接 SQLDisconnect 释放句柄资源 SQLFreeHandle：释放句柄资源，可替代如下函数： SQLFreeEnv：释放环境句柄SQLFreeConnect：释放连接句柄SQLFreeStmt：释放语句句柄

>[!NOTE]说明
>数据库中收到的一次执行请求（不在事务块中），如果含有多条语句，将会被打包成一个事务，同时如果其中有一个语句失败，那么整个请求都将会被回滚。

> [!WARNING]注意
>
> ODBC为应用程序与数据库的中心层，负责把应用程序发出的SQL指令传到数据库当中，自身并不解析SQL语法。故在应用程序中写入带有保密信息的SQL语句时（如明文密码），保密信息会被暴露在驱动日志中。

## 测试用例编译及执行

1. 测试用例编译

下载的odbc驱动包解压后包含两个文件夹：lib与odbc。编译测试用例需要依赖odbc/lib中的文件，假设测试用例文件为test.c，则编译测试用例方式如下：

    ```
    gcc test.c -L odbc/lib -l odbc -o test.o
    ```

2. 执行测试用例

编译测试用例生成test.o文件，执行用例：

    ```
    ./test.o
    ```
