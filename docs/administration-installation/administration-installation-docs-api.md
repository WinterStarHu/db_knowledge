# 应用程序接口

用户可以使用标准的数据库应用程序接口（如ODBC和JDBC），开发基于openGauss的应用程序。

## 支持的应用程序接口

每个应用程序是一个独立的openGauss开发项目。应用程序通过API与数据库进行交互，在避免了应用程序直接操作数据库系统的同时，增强了应用程序的可移植性、扩展性和可维护性。[表1](#zh-cn_topic_0283136775_zh-cn_topic_0237120293_zh-cn_topic_0059777757_tc44f4815cb564ea182d5864daa2709b4)为openGauss所支持的应用程序接口及其下载地址。

**表 1**  数据库应用程序接口

API 下载地址 ODBC Linux下：驱动程序：openGauss-x.x-ODBC.tar.gz unixODBC源码包：http://sourceforge.net/projects/unixodbc/files/unixODBC/2.3.7/unixODBC-2.3.7.tar.gz/download JDBC 驱动程序：openGauss-x.x-EULER-64bit-Jdbc.tar.gz驱动包：postgresql.jar、opengauss-jdbc-x.x.x.jar驱动类：org.postgresql.Driver、org.openGauss.Driver

使用JDBC和ODBC接口连接数据库属远程连接，因此需要openGauss已经做了支持[远程连接的配置](configuring_remote_connections_to_the_server.md)。
