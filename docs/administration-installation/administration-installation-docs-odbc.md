# ODBC

ODBC（Open Database Connectivity，开放数据库互连）是由Microsoft公司基于X/OPEN CLI提出的用于访问数据库的应用程序编程接口。应用程序通过ODBC提供的API与数据库进行交互，增强了应用程序的可移植性、扩展性和可维护性。

ODBC的系统结构参见[图1](#zh-cn_topic_0283137057_fig1255101034110)。

**图 1**  ODBC系统机构 ![](figures/ODBC-System-Organization.png)

openGauss目前在以下环境中提供对ODBC的支持。

**表 1**  ODBC支持平台

操作系统 CentOS 6.4/6.5/6.6/6.7/6.8/6.9/7.0/7.1/7.2/7.3/7.4 x86_64位 CentOS 7.6 ARM64位 EulerOS 2.0 SP2/SP3 x86_64位 EulerOS 2.0 SP8 ARM64位 windows 7/8/10 x86_32位

Windows系统自带ODBC驱动程序管理器，在控制面板-\>管理工具中可以找到数据源（ODBC）选项，可以参考odbc文档。

## Linux下的ODBC包

从发布包中获取，包名为openGauss-\*.\*.0-ODBC.tar.gz。Linux环境下，开发应用程序要用到unixODBC提供的头文件（sql.h、sqlext.h等）和库libodbc.so。这些头文件和库可从unixODBC-x.x.x的安装包中获得。

## 配置数据源

将openGauss提供的ODBC DRIVER（psqlodbcw.so）配置到数据源中便可使用。配置数据源需要配置“odbc.ini”和“odbcinst.ini”两个文件（在编译安装unixODBC过程中生成且默认放在“/usr/local/etc”目录下），并在服务器端进行配置。

1. 获取unixODBC-x.x.x码包。

获取参考地址：

2. 安装unixODBC。如果机器上已经安装了其他版本的unixODBC，可以直接覆盖安装。

目前不支持unixODBC-2.2.1版本。以unixODBC-2.3.9版本为例，在客户端执行如下命令安装unixODBC。默认安装到“/usr/local”目录下，生成数据源文件到 “/usr/local/etc”目录下，库文件生成在“/usr/local/lib”目录。

    ```
    tar zxvf unixODBC-2.3.9.tar.gz
    cd unixODBC-2.3.9
    #修改configure文件（如果不存在，那么请修改configure.ac），找到LIB_VERSION
    #将它的值修改为"1:0:0"，这样将编译出*.so.1的动态库，与psqlodbcw.so的依赖关系相同。
    vim configure

    ./configure --enable-gui=no #如果要在ARM服务器上编译，请追加一个configure参数： --build=aarch64-unknown-linux-gnu
    make
    #安装可能需要root权限
    make install
    ```

3. 替换客户端openGauss驱动程序。
  1. 将openGauss-x.x.x-ODBC.tar.gz解压到“/usr/local/lib”目录下。解压会得到“psqlodbcw.la”和“psqlodbcw.so”两个文件。
  2. 将openGauss-x.x.x-ODBC.tar.gz解压后lib目录中的库拷贝到“/usr/local/lib”目录下。

4. 配置数据源。
  1. 配置ODBC驱动文件。

在“/xxx/odbc/etc/odbcinst.ini”文件中追加以下内容。

        ```
        [GaussMPP]
        Driver64=/xxx/odbc/lib/psqlodbcw.so
        setup=/xxx/odbc/lib/psqlodbcw.so
        ```

odbcinst.ini文件中的配置参数说明如[表2](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_td564f21e7c8e458bbd741b09896f5d91)所示。

**表 2**  odbcinst.ini文件配置参数

[DriverName] 驱动器名称，对应数据源DSN中的驱动名。
[DRIVER_N] Driver64 驱动动态库的路径。
Driver64=/xxx/odbc/lib/psqlodbcw.so setup 驱动安装路径，与Driver64中动态库的路径一致。
setup=/xxx/odbc/lib/psqlodbcw.so

  2. 配置数据源文件。

在“/usr/local/etc/odbc.ini”文件中追加以下内容。

        ```
        [MPPODBC]
        Driver=GaussMPP
        Servername=10.145.130.26（数据库Server IP）
        Database=postgres  （数据库名）
        Username=omm  （数据库用户名）
        Password=  （数据库用户密码）
        Port=8000 （数据库侦听端口）
        Sslmode=allow
        ```

odbc.ini文件配置参数说明如[表3](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_t55845a6555f2454297b64ce47ad3d648)所示。

**表 3**  odbc.ini文件配置参数

[DSN] 数据源的名称。
[MPPODBC] Driver 驱动名，对应odbcinst.ini中的DriverName。
Driver=DRIVER_N Servername 服务器的IP地址。
Servername=10.145.130.26 Database 要连接的数据库的名称。
Database=postgres Username 数据库用户名称。
Username=omm Password 数据库用户密码。
Password= Port 服务器的端口号。
Port=8000 Sslmode 开启SSL模式 Sslmode=allow Debug 设置为1时，将会打印psqlodbc驱动的mylog，日志生成目录为/tmp/。设置为0时则不会生成。
Debug=1 UseServerSidePrepare 是否开启数据库端扩展查询协议。
可选值0或1，默认为1，表示打开扩展查询协议。
UseServerSidePrepare=1 UseBatchProtocol 是否开启批量查询协议（打开可提高DML性能）；可选值0或者1，默认为1。
当此值为0时，不使用批量查询协议（主要用于与早期数据库版本通信兼容）。
当此值为1，并且数据库support_batch_bind参数存在且为on时，将打开批量查询协议。
UseBatchProtocol=1 ForExtensionConnector 这个开关控制着savepoint是否发送，savepoint相关问题可以注意这个开关。
ForExtensionConnector=1 UnamedPrepStmtThreshold 每次调用SQLFreeHandle释放Stmt时，ODBC都会向server端发送一个Deallocate plan_name语句，业务中存在大量这类语句。为了减少这类语句的发送，我们将        stmt-&gt;plan_name置空，从而使得数据库识别这个为unamed stmt。增加这个参数对unamed stmt的阈值进行控制。
UnamedPrepStmtThreshold=100 ConnectionExtraInfo GUC参数connection_info中显示驱动部署路径和进程属主用户的开关。
ConnectionExtraInfo=1 BoolAsChar 设置为Yes是，Bools值将会映射为SQL_CHAR。如不设置将会映射为SQL_BIT。
BoolsAsChar = Yes RowVersioning 当尝试更新一行数据时，设置为Yes会允许应用检测数据有没有被其他用户进行修改。
RowVersioning=Yes ShowSystemTables 驱动将会默认系统表格为普通SQL表格。
ShowSystemTables=Yes connect_timeout 链接的最大等待时间，以秒计（用十进制整数字符串书写），0或者不声明表示无穷。不建议把链接超时的值设置得小于2秒。
connect_timeout=10 rw_timeout 设置客户端连接读写超时时间。
rw_timeout=5 target_session_attrs 设定连接的主机的类型。主机的类型和设定的值一致时才能连接成功。target_session_attrs的设置规则如下： any(默认值): 可以对所有类型的主机进行连接。read-write：当连接的主机允许可读可写时，才进行连接。read-only：仅对可读的主机进行连接。primary：仅对主备系统中的主机能进行连接。standby: 仅对主备系统中的备机进行连接。prefer-standby：首先尝试找到一个备机进行连接。如果对hosts列表的所有机器都连接失败，那么尝试“any”模式进行连接。
target_session_attrs=read-only keepalives_idle 在TCP应该发送一个保持激活的信息给服务器之后，控制不活动的秒数。0值表示使用系统缺省。通过Unix域套接字做的链接或者如果禁用了保持激活则忽略这个参数。
keepalives_idle=10 keepalives_interval 在TCP保持激活信息没有被应该传播的服务器承认之后，控制秒数。0值表示使用系统缺省。通过Unix域套接字做的链接或者如果禁用了保持激活则忽略这个参数。
keepalives_interval=20 keepalives_count 控制TCP发送保持激活信息的次数。0值表示使用系统缺省。通过Unix域套接字做的链接或者如果禁用了保持激活则忽略这个参数。
keepalives_count=5 client_encoding 为这个链接设置client_encoding配置参数。除了对应的服务器选项接受的值，你可以使用auto从客户端中的当前环境中确定正确的编码（Unix系统上是LC_CTYPE环境变量）。
client_encoding=utf8 application_name 为application_name配置参数指定一个值，表明当前用户身份。
application_name=test tcp_user_timeout 在支持TCP_USER_TIMEOUT套接字选项的操作系统上，指定传输的数据在TCP连接被强制关闭之前可以保持未确认状态的最大时长。0值表示使用系统缺省。通过Unix域套接字做的链接忽略这个参数。
tcp_user_timeout=10 sslcompression 如果设置为1（默认），SSL连接之上传送的数据将被压缩（这要求OpenSSL版本为0.9.8或更高）。如果设置为0，压缩将被禁用（这要求OpenSSL版本为1.0.0或更高）。如果建立的是一个没有SSL的连接，这个参数会被忽略。如果使用的OpenSSL版本不支持该参数，它也会被忽略。压缩会占用CUP时间，但是当瓶颈为网络时可以提高吞吐量。如果CPU性能是限制因素，禁用压缩能够改进响应时间和吞吐量。
sslcompression=0 sslcert 这个参数指定客户端SSL证书的文件名，它替换默认的~/.postgresql/postgresql.crt。如果没有建立SSL连接，这个参数会被忽略。
sslcert=postgresql.crt sslkey 这个参数指定用于客户端证书的密钥位置。它能指定一个会被用来替代默认的~/.postgresql/postgresql.key的文件名，或者它能够指定一个从外部“引擎”（引擎是OpenSSL的可载入模块）得到的密钥。一个外部引擎说明应该由一个冒号分隔的引擎名称以及一个引擎相关的关键标识符组成。如果没有建立SSL连接，这个参数会被忽略。
sslkey=postgresql.key sslrootcert 这个参数指定一个包含SSL证书机构（CA）证书的文件名称。如果该文件存在，服务器的证书将被验证是由这些机构之一签发。默认值是~/.postgresql/root.crt。
sslrootcert=root.crt sslcrl 这个参数指定SSL证书撤销列表（CRL）的文件名。列在这个文件中的证书如果存在，在尝试认证该服务器证书时会被拒绝。默认值是~/.postgresql/root.crl。
sslcrl=root.crl requirepeer 这个参数指定服务器的操作系统用户，例如requirepeer=postgres。当建立一个Unix域套接字连接时，如果设置了这个参数，客户端在连接开始时检查服务器进程是否运行在指定的用户名之下。如果发现不是，该连接会被一个错误中断。这个参数能被用来提供与TCP/IP连接上SSL证书相似的服务器认证（注意，如果Unix域套接字在/tmp或另一个公共可写的位置，任何用户能启动一个在那里侦听的服务器。使用这个参数来保证你连接的是一个由可信用户运行的服务器）。这个选项只在实现了peer认证方法的平台上受支持。
requirepeer=postgres krbsrvname 当用GSSAPI认证时，要使用的Kerberos服务名。为了让Kerberos认证成功，这必须匹配在服务器配置中指定的服务名。
krbsrvname=gssname gsslib 用于GSSAPI认证的GSS库。只用在Windows上。设置为gssapi可强制libpq用GSSAPI库来代替默认的SSPI进行认证。
gsslib=gssapi service 用于附加参数的服务名。它指定保持附加连接参数的pg_service.conf中的一个服务名。这允许应用只指定一个服务名，这样连接参数能被集中维护。
service=param_service_name remote_nodename 指定连接本地节点的远端节点名称。
remote_nodename=n1 localhost 指定在一个连接通道中的本地地址。
localhost=127.0.0.1 localport 指定在一个连接通道中的本地端口。
localport=5432 replication 这个选项决定是否该连接应该使用复制协议而不是普通协议。这是PostgreSQL的复制连接以及pg_basebackup之类的工具在内部使用的协议，但也可以被第三方应用使用。支持下列值，大小写无关： true、on、yes、1：连接进入到物理复制模式。
database：连接进入到逻辑复制模式，连接到dbname参数中指定的数据库。
false、off、no、0：该连接是一个常规连接，这是默认行为。
在物理或者逻辑复制模式中，仅能使用简单查询协议。
replication=on backend_version 传递到远端的后端版本号。
backend_version=1.0 prototype 设置当前协议级别，默认：PROTO_TCP。
prototype=PROTO_TCP enable_ce 控制是否允许客户端连接全密态数据库。默认0，如果需要开启，则修改为1。
enable_ce=1

其中关于Sslmode的选项的允许值，具体信息见下表：

**表 4**  Sslmode的可选项及其描述

Sslmode 是否会启用SSL加密 disable 不使用SSL安全连接。
allow 如果数据库服务器要求使用，则可以使用SSL安全加密连接，但不验证数据库服务器的真实性。
prefer 如果数据库支持，那么建议使用SSL安全加密连接，但不验证数据库服务器的真实性。
require 必须使用SSL安全连接，但是只做了数据加密，而并不验证数据库服务器的真实性。
verify-ca 必须使用SSL安全连接，并且验证数据库是否具有可信证书机构签发的证书。
verify-full 必须使用SSL安全连接，在verify-ca的验证范围之外，同时验证数据库所在主机的主机名是否与证书内容一致。openGauss不支持此模式。

>[!NOTE]说明
>SSL模式：
>保证client.key\*系列文件为600权限：
>退回根目录，创建.postgresql目录，并将root.crt，client.crt，client.key，client.key.cipher，client.key.rand，client.req，server.crt，server.key，server.key.cipher，server.key.rand，server.req放在此路径下。
>Unix系统下，server.crt、server.key的权限设置必须禁止任何外部或组的访问，请执行如下命令实现这一点。
>
>```
>chmod 0600 server.key
>```
>
>将root.crt以及server开头的证书相关文件全部拷贝进数据库install/data目录下（与postgresql.conf文件在同一路径）。
>修改postgresql.conf文件：
>
>```
>ssl = on
>ssl_cert_file = 'server.crt'
>ssl_key_file = 'server.key'
>ssl_ca_file = 'root.crt'
>```
>
>修改完参数后需重启数据库。
>修改配置文件odbc.ini中的sslmode参数（require或verify-ca）。

5. 配置数据库服务器。
  1. 以操作系统用户omm登录数据库主节点。
  2. 执行如下命令增加对外提供服务的网卡IP或者主机名（英文逗号分隔），其中NodeName为当前节点名称：

        ```
        gs_guc reload -N NodeName -I all -c "listen_addresses='localhost,192.168.0.100,10.11.12.13'"
        ```

在DR（Direct Routing，LVS的直接路由DR模式）模式中需要将虚拟IP地址（10.11.12.13）加入到服务器的侦听地址列表中。

listen\_addresses也可以配置为“\*”或“0.0.0.0”，此配置下将侦听所有网卡，但存在安全风险，不推荐用户使用，推荐用户按照需要配置IP或者主机名，打开侦听。

  3. 执行如下命令在数据库主节点配置文件中增加一条认证规则。（这里假设客户端IP地址为10.11.12.13，即远程连接的机器的IP地址）

        ```
        gs_guc reload -N all -I all -h "host all jack 10.11.12.13/32 sha256"
        ```

>[!NOTE]说明
>- -N all表示openGauss中的所有主机。
>- -I all表示主机中的所有实例。
>- -h表示指定需要在“pg\_hba.conf”增加的语句。
>- all表示允许客户端连接到任意的数据库。
>- jack表示连接数据库的用户。
>- 10.11.12.13/_32_表示只允许IP地址为10.11.12.13的主机连接。在使用过程中，请根据用户的网络进行配置修改。32表示子网掩码为1的位数，即255.255.255.255。
>- sha256表示连接时jack用户的密码使用sha256算法加密。

如果将ODBC客户端配置在和要连接的数据库主节点在同一台机器上，则可使用local trust认证方式，如下：

        ```
        local all all trust
        ```

如果将ODBC客户端配置在和要连接的数据库主节点在不同机器上，则需要使用sha256认证方式，如下：

        ```
        host all all xxx.xxx.xxx.xxx/32 sha256
        ```

  4. 重启openGauss。

        ```
        gs_om -t stop
        gs_om -t start
        ```

6. 在客户端配置环境变量。

    ```
    vim ~/.bashrc
    ```

在配置文件中追加以下内容。

    ```
    export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
    export ODBCSYSINI=/usr/local/etc
    export ODBCINI=/usr/local/etc/odbc.ini
    ```

7. 执行如下命令使设置生效。

    ```
    source ~/.bashrc
    ```

## 测试数据源配置

执行./isql -v MPPODBC（数据源名称）命令。

- 如果显示如下信息，表明配置正确，连接成功。

    ```
    +---------------------------------------+
    | Connected!                            |
    |                                       |
    | sql-statement                         |
    | help [tablename]                      |
    | quit                                  |
    |                                       |
    +---------------------------------------+
    SQL>
    ```

- 若显示ERROR信息，则表明配置错误。请检查上述配置是否正确。

## 开发流程

**图 2**  ODBC开发应用程序的流程 ![](figures/The-process-of-developing-application-programs-using-ODBC.png)

## 常用接口

**表 5**  相关API说明

API 申请句柄资源 SQLAllocHandle：申请句柄资源，可替代如下函数： SQLAllocEnv：申请环境句柄SQLAllocConnect：申请连接句柄SQLAllocStmt：申请语句句柄 设置环境属性 SQLSetEnvAttr 设置连接属性 SQLSetConnectAttr 设置语句属性 SQLSetStmtAttr 连接数据源 SQLConnect 绑定缓冲区到结果集的列中 SQLBindCol 绑定SQL语句的参数标志和缓冲区 SQLBindParameter 查看最近一次操作错误信息 SQLGetDiagRec 为执行SQL语句做准备 SQLPrepare 执行一条准备好的SQL语句 SQLExecute 直接执行SQL语句 SQLExecDirect 结果集中取行集 SQLFetch 返回结果集中某一列的数据 SQLGetData 获取结果集中列的描述信息 SQLColAttribute 断开与数据源的连接 SQLDisconnect 释放句柄资源 SQLFreeHandle：释放句柄资源，可替代如下函数： SQLFreeEnv：释放环境句柄SQLFreeConnect：释放连接句柄SQLFreeStmt：释放语句句柄

>[!NOTE]说明
>数据库中收到的一次执行请求（不在事务块中），如果含有多条语句，将会被打包成一个事务，同时如果其中有一个语句失败，那么整个请求都将会被回滚。

## 连接数据库

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHDBC       V_OD_hdbc;       // Handle connection
SQLINTEGER    V_OD_erg;
int main(int argc,char *argv[])
{
      // 1. 申请环境句柄
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }
      // 2. 设置环境属性（版本信息）
      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);
      // 3. 申请连接句柄
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }
      // 4. 设置连接属性
      SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);
      // 5. 连接数据源，这里的“userName”与“password”分别表示连接数据库的用户名和用户密码，请根据实际情况修改。
      // 如果odbc.ini文件中已经配置了用户名密码，那么这里可以留空（""）；但是不建议这么做，因为一旦odbc.ini权限管理不善，将导致数据库用户密码泄露。
      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");
      // 6. 断开数据源连接并释放句柄资源
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
}
```

## 创建表

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHSTMT      V_OD_hstmt;      // Handle statement
SQLHDBC       V_OD_hdbc;       // Handle connection
SQLINTEGER    V_OD_erg;
int main(int argc,char *argv[])
{
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }

      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);

      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }

      SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);

      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");
      // 1. 设置语句属性
      SQLSetStmtAttr(V_OD_hstmt,SQL_ATTR_QUERY_TIMEOUT,(SQLPOINTER *)3,0);
      // 2. 申请语句句柄
      SQLAllocHandle(SQL_HANDLE_STMT, V_OD_hdbc, &V_OD_hstmt);
      // 3. 创建表格。
      SQLExecDirect(V_OD_hstmt,"drop table IF EXISTS customer_t1",SQL_NTS);
      SQLExecDirect(V_OD_hstmt,"CREATE TABLE customer_t1(c_customer_sk INTEGER, c_customer_name VARCHAR(32));",SQL_NTS);
      printf("Done !\n");
      // 4. 断开数据源连接并释放句柄资源
      SQLFreeHandle(SQL_HANDLE_STMT,V_OD_hstmt);
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
 }
```

## 插入操作

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHSTMT      V_OD_hstmt;      // Handle statement
SQLHDBC       V_OD_hdbc;       // Handle connection
SQLINTEGER    value = 100;
SQLINTEGER    V_OD_erg;
int main(int argc,char *argv[])
{
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }

      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);

      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }

      SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);

      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");

      SQLSetStmtAttr(V_OD_hstmt,SQL_ATTR_QUERY_TIMEOUT,(SQLPOINTER *)3,0);

      SQLAllocHandle(SQL_HANDLE_STMT, V_OD_hdbc, &V_OD_hstmt);

      // 1. 直接插入
      SQLExecDirect(V_OD_hstmt,"insert into customer_t1 values(25,li)",SQL_NTS);

      // 2. pbe方法插入
      // 2.1 插入占位符
      SQLPrepare(V_OD_hstmt,"insert into customer_t1 values(?)",SQL_NTS);
      // 2.2 绑定参数
      SQLBindParameter(V_OD_hstmt,1,SQL_PARAM_INPUT,SQL_C_SLONG,SQL_INTEGER,0,0,
                       &value,0,NULL);
      // 2.3 执行准备好的插入语句
      SQLExecute(V_OD_hstmt);

      // 3. 断开数据源连接并释放句柄资源
      SQLFreeHandle(SQL_HANDLE_STMT,V_OD_hstmt);
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
 }
```

## SELECT操作

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHSTMT      V_OD_hstmt;      // Handle statement
SQLHDBC       V_OD_hdbc;       // Handle connection
char          typename[100];
SQLINTEGER    V_OD_erg, V_OD_buffer, V_OD_err, V_OD_id;
int main(int argc,char *argv[])
{
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }

      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);

      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }
          SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);

      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");

      SQLSetStmtAttr(V_OD_hstmt,SQL_ATTR_QUERY_TIMEOUT,(SQLPOINTER *)3,0);

      SQLAllocHandle(SQL_HANDLE_STMT, V_OD_hdbc, &V_OD_hstmt);

      // 1. 执行select语句
      SQLExecDirect(V_OD_hstmt,"select c_customer_sk from customer_t1",SQL_NTS);
      // 2. 获取结果集某一列的属性
      SQLColAttribute(V_OD_hstmt,1,SQL_DESC_TYPE,typename,100,NULL,NULL);
      printf("SQLColAtrribute %s\n",typename);
      // 3. 绑定结果集
      SQLBindCol(V_OD_hstmt,1,SQL_C_SLONG, (SQLPOINTER)&V_OD_buffer,150,
                (SQLLEN *)&V_OD_err);
      // 4. 通过SQLFetch取结果集中数据
      V_OD_erg=SQLFetch(V_OD_hstmt);
      // 5. 通过SQLGetData获取并返回数据。
      while(V_OD_erg != SQL_NO_DATA)
      {
          SQLGetData(V_OD_hstmt,1,SQL_C_SLONG,(SQLPOINTER)&V_OD_id,0,NULL);
          printf("SQLGetData ----ID = %d\n",V_OD_id);
          V_OD_erg=SQLFetch(V_OD_hstmt);
      };
      printf("Done !\n");
      // 6. 断开数据源连接并释放句柄资源
      SQLFreeHandle(SQL_HANDLE_STMT,V_OD_hstmt);
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
 }
```

## 更新操作

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHSTMT      V_OD_hstmt;      // Handle statement
SQLHDBC       V_OD_hdbc;       // Handle connection
SQLINTEGER    V_OD_erg;
int main(int argc,char *argv[])
{
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }

      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);

      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }

      SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);

      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");

      SQLSetStmtAttr(V_OD_hstmt,SQL_ATTR_QUERY_TIMEOUT,(SQLPOINTER *)3,0);

      SQLAllocHandle(SQL_HANDLE_STMT, V_OD_hdbc, &V_OD_hstmt);

      // 1. 执行更新操作
      SQLExecDirect(V_OD_hstmt,"update customer_t1 set c_customer_sk = 1000 where c_customer_name = 'li' ",SQL_NTS);
      // 16. 断开数据源连接并释放句柄资源
      SQLFreeHandle(SQL_HANDLE_STMT,V_OD_hstmt);
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
 }
```

## 删除操作

```
#include
#include
#include
#ifdef WIN32
#include
#endif
SQLHENV       V_OD_Env;        // Handle ODBC environment
SQLHSTMT      V_OD_hstmt;      // Handle statement
SQLHDBC       V_OD_hdbc;       // Handle connection
SQLINTEGER    V_OD_erg;
int main(int argc,char *argv[])
{
      V_OD_erg = SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&V_OD_Env);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           printf("Error AllocHandle\n");
           exit(0);
      }

      SQLSetEnvAttr(V_OD_Env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);

      V_OD_erg = SQLAllocHandle(SQL_HANDLE_DBC, V_OD_Env, &V_OD_hdbc);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
           SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
           exit(0);
      }

      SQLSetConnectAttr(V_OD_hdbc, SQL_ATTR_AUTOCOMMIT, SQL_AUTOCOMMIT_ON, 0);

      V_OD_erg = SQLConnect(V_OD_hdbc, (SQLCHAR*) "gaussdb", SQL_NTS,
                           (SQLCHAR*) "userName", SQL_NTS,  (SQLCHAR*) "password", SQL_NTS);
      if ((V_OD_erg != SQL_SUCCESS) && (V_OD_erg != SQL_SUCCESS_WITH_INFO))
      {
          printf("Error SQLConnect %d\n",V_OD_erg);
          SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
          exit(0);
      }
      printf("Connected !\n");

      SQLSetStmtAttr(V_OD_hstmt,SQL_ATTR_QUERY_TIMEOUT,(SQLPOINTER *)3,0);

      SQLAllocHandle(SQL_HANDLE_STMT, V_OD_hdbc, &V_OD_hstmt);

      // 1. 执行删除操作
      SQLExecDirect(V_OD_hstmt,"delete from customer_t1 where c_customer_name = 'li'",SQL_NTS);

      // 2. 断开数据源连接并释放句柄资源
      SQLFreeHandle(SQL_HANDLE_STMT,V_OD_hstmt);
      SQLDisconnect(V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_DBC,V_OD_hdbc);
      SQLFreeHandle(SQL_HANDLE_ENV, V_OD_Env);
      return(0);
 }
```
