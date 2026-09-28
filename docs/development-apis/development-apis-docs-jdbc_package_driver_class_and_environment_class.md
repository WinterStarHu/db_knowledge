# JDBC包、驱动类和环境类

## JDBC包

openGauss提供两种JDBCjar包：postgresql.jar和openGauss-jdbc-x.x.x.jar，两种jar包功能一致，仅仅是为了解决和PostgreSQL之间的JDBC驱动包名冲突。

在Linux服务器端源代码目录下执行build.sh，获得驱动jar包postgresql.jar和opengauss-jdbc-x.x.x.jar，包位置在源代码内output目录下。也可以从官网发布包中获取，包名为openGauss-x.x.x-JDBC.tar.gz。

- postgresql.jar：主类名为“org.postgresql.Driver”，数据库连接的url前缀为“jdbc:postgresql"，该驱动包与PostgreSQL保持兼容，其中类名、类结构与 PostgreSQL 驱动完全一致，曾经运行于 PostgreSQL 的应用程序可以直接移植到当前系统使用。
- opengauss-jdbc-x.x.x.jar：主类名为“org.opengauss.Driver”，数据库连接的url前缀为“jdbc:opengauss“，当同一JVM进程内需要同时访问 PostgreSQL 及 openGauss 时，使用 opengauss-jdbc-x.x.x.jar 可以避免类名冲突。

## 驱动类

>[!NOTE]说明
>
>+ openGauss在JDBC的使用上与PG的使用方法保持兼容。在同一个JVM虚拟机里加载PostgreSQL和openGauss的JDBC同名驱动时，可能存在org.postgresql.Driver驱动类冲突问题。
>
>+ 相比于PG驱动，openGauss JDBC驱动主要做了以下特性的增强：
>
>+ 支持SHA256加密方式登录。
>
>+ 支持对接实现sf4j接口的第三方日志框架。
>
>+ 支持容灾切换。

## 环境类

客户端需配置JDK1.8，配置方法如下：

1. DOS窗口输入“java -version”，查看JDK版本，确认为JDK1.8版本。如果未安装JDK，请从官方网站下载安装包并安装。

2. 根据如下步骤配置系统环境变量。

a. 右键单击“我的电脑”，选择“属性”。

b. 在“系统”页面左侧导航栏单击“高级系统设置”。

c. 在“系统属性”页面，“高级”页签上单击“环境变量”。

d. 在“环境变量”页面上，“系统变量”区域单击“新建”或“编辑”配置系统变量。变量说明请参见[表1](#zh-cn_topic_0237120378_zh-cn_topic_0213179123_table1625616152473)。

**表 1**  变量说明

变量名 变量值 JAVA_HOME 若存在，则单击“编辑”。若不存在，则单击“新建”。
JAVA的安装目录。
例如：C:\Program Files\Java\jdk1.8.0_131 Path 若配置了JAVA_HOME，则在变量值的最前面加上：“%JAVA_HOME%\bin;”若未配置JAVA_HOME，则在变量值的最前面加上JAVA安装的全路径：“C:\Program Files\Java\jdk1.8.0_131\bin;” CLASSPATH “.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar;”
