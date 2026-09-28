# Linux下配置数据源

将openGauss提供的ODBC DRIVER（psqlodbcw.so）配置到数据源中便可使用。配置数据源需要配置“odbc.ini”和“odbcinst.ini”两个文件（在编译安装unixODBC过程中生成且默认放在“/usr/local/etc”目录下），并在服务器端进行配置。

## 操作步骤

1. 获取unixODBC源码包。

获取参考地址：

下载后请先按照社区提供的完整性校验算法进行完整性校验。

2. 安装unixODBC。如果机器上已经安装了其他版本的unixODBC，可以直接覆盖安装。

目前不支持unixODBC-2.2.1版本。以unixODBC-2.3.0版本为例，在客户端执行如下命令安装unixODBC。默认安装到“/usr/local”目录下，生成数据源文件到 “/usr/local/etc”目录下，库文件生成在“/usr/local/lib”目录。

    ```
    tar zxvf unixODBC-2.3.0.tar.gz
    cd unixODBC-2.3.0
    #修改configure文件（如果不存在，那么请修改configure.ac），找到LIB_VERSION
    #将它的值修改为"1:0:0"，这样将编译出*.so.1的动态库，与psqlodbcw.so的依赖关系相同。
    vim configure

    ./configure --enable-gui=no #如果要在ARM服务器上编译，请追加一个configure参数： --build=aarch64-unknown-linux-gnu
    make
    #安装可能需要root权限
    make install
    ```

3. 替换客户端openGauss驱动程序。
  1. 将openGauss-x.x.x-ODBC.tar.gz解压。解压后会得到两个文件夹：lib与odbc，在odbc文件夹中还会有一个lib文件夹。/odbc/lib中会有“psqlodbca.la”，“psqlodbca.so”，“psqlodbcw.la”和“psqlodbcw.so”四个文件，将这四个文件拷贝到“/usr/local/lib”目录下。
  2. 将openGauss-x.x.x-ODBC.tar.gz解压后lib目录中的库拷贝到“/usr/local/lib”目录下。

4. 配置数据源。
  1. 配置ODBC驱动文件。

在“/usr/local/etc/odbcinst.ini”文件中追加以下内容。

        ```
        [GaussMPP]
        Driver64=/usr/local/lib/psqlodbcw.so
        setup=/usr/local/lib/psqlodbcw.so
        ```

odbcinst.ini文件中的配置参数说明如[表1](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_td564f21e7c8e458bbd741b09896f5d91)所示。

**表 1**  odbcinst.ini文件配置参数

[DriverName] 驱动器名称，对应数据源DSN中的驱动名。
[DRIVER_N] Driver64 驱动动态库的路径。
Driver64=/usr/local/lib/psqlodbcw.so setup 驱动安装路径，与Driver64中动态库的路径一致。
setup=/usr/local/lib/psqlodbcw.so

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

odbc.ini文件配置参数说明如[表2](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_t55845a6555f2454297b64ce47ad3d648)所示。

**表 2**  odbc.ini文件配置参数

[DSN] 数据源的名称。
[MPPODBC] Driver 驱动名，对应odbcinst.ini中的DriverName。
Driver=DRIVER_N Servername 服务器的IP地址。可配置多个IP地址。
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
UnamedPrepStmtThreshold=100 ConnectionExtraInfo GUC参数connection_info（参见connection_info）中显示驱动部署路径和进程属主用户的开关。
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

**表 3**  Sslmode的可选项及其描述

Sslmode 是否会启用SSL加密 disable 不使用SSL安全连接。
allow 如果数据库服务器要求使用，则可以使用SSL安全加密连接，但不验证数据库服务器的真实性。
prefer 如果数据库支持，那么建议使用SSL安全加密连接，但不验证数据库服务器的真实性。
require 必须使用SSL安全连接，但是只做了数据加密，而并不验证数据库服务器的真实性。
verify-ca 必须使用SSL安全连接，并且验证数据库是否具有可信证书机构签发的证书。
verify-full 必须使用SSL安全连接，在verify-ca的验证范围之外，同时验证数据库所在主机的主机名是否与证书内容一致。openGauss不支持此模式。

5. （可选）生成SSL证书，具体请参见[证书生成](../database_administration_guide/ssl_certificate_management.md)。此步骤和6在服务端与客户端通过ssl方式连接的情况下需要执行。非ssl方式连接情况下可以跳过。
6. （可选）替换SSL证书，具体请参见[证书替换](../database_administration_guide/ssl_certificate_management.md)。
7. SSL模式：

声明如下环境变量，同时保证client.key\*系列文件为600权限：

    ```
    退回根目录，创建.postgresql目录，并将root.crt，client.crt，client.key，client.key.cipher，client.key.rand，client.req，server.crt，server.key，server.key.cipher，server.key.rand，server.req放在此路径下。
    Unix系统下，server.crt、server.key的权限设置必须禁止任何外部或组的访问，请执行如下命令实现这一点。
    chmod 600 server.key
    将root.crt以及server开头的证书相关文件全部拷贝进数据库install/data目录下（与postgresql.conf文件在同一路径）。
    修改postgresql.conf文件：
        ssl = on
        ssl_cert_file = 'server.crt'
        ssl_key_file = 'server.key'
        ssl_ca_file = 'root.crt'
    修改完参数后需重启数据库。
    修改配置文件odbc.ini中的sslmode参数（require或verify-ca）。
    ```

8. 配置数据库服务器。
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
>
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

9. 在客户端配置环境变量。

    ```
    vim ~/.bashrc
    ```

在配置文件中追加以下内容。

    ```
    export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
    export ODBCSYSINI=/usr/local/etc
    export ODBCINI=/usr/local/etc/odbc.ini
    ```

10. 执行如下命令使设置生效。

    ```
    source ~/.bashrc
    ```

## 测试数据源配置

安装后/usr/bin下面会存放生成的二进制，可执行./isql -v MPPODBC（数据源名称）命令。

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

## 常见问题处理

- \[UnixODBC\]\[Driver Manager\]Can't open lib 'xxx/xxx/psqlodbcw.so' : file not found.

此问题的可能原因：

  - odbcinst.ini文件中配置的路径不正确

确认的方法：'ls'一下错误信息中的路径，以确保该psqlodbcw.so文件存在，同时具有执行权限。

  - psqlodbcw.so的依赖库不存在，或者不在系统环境变量中

确认的办法：ldd一下错误信息中的路径，如果是缺少libodbc.so.1等UnixODBC的库，那么按照“操作步骤”中的方法重新配置UnixODBC，并确保它的安装路径下的lib目录添加到了LD\_LIBRARY\_PATH中；如果是缺少其他库，请将ODBC驱动包中的lib目录添加到LD\_LIBRARY\_PATH中。

- \[UnixODBC\]connect to server failed: no such file or directory

此问题可能的原因：

  - 配置了错误的/不可达的数据库地址，或者端口

请检查数据源配置中的Servername及Port配置项。

  - 服务器侦听不正确

如果确认Servername及Port配置正确，请根据“操作步骤”中数据库服务器的相关配置，确保数据库侦听了合适的网卡及端口。

  - 防火墙及网闸设备

请确认防火墙设置，将数据库的通信端口添加到可信端口中。

如果有网闸设备，请确认一下相关的设置。

- \[unixODBC\]The password-stored method is not supported.

此问题可能原因：

数据源中未配置sslmode配置项。

解决办法：

请配置该选项至allow或以上选项。此配置的更多信息，见[表3](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_table22136585143846)。

- Server common name "xxxx" does not match host name "xxxxx"

此问题的原因：

使用了SSL加密的“verify-full”选项，驱动程序会验证证书中的主机名与实际部署数据库的主机名是否一致。

解决办法：

碰到此问题可以使用“verify-ca”选项，不再校验主机名；或者重新生成一套与数据库所在主机名相同的CA证书。

- Driver's SQLAllocHandle on SQL\_HANDLE\_DBC failed

此问题的可能原因：

可执行文件（比如UnixODBC的isql，以下都以isql为例）与数据库驱动（psqlodbcw.so）依赖于不同的odbc的库版本：libodbc.so.1或者libodbc.so.2。此问题可以通过如下方式确认：

    ```
    ldd `which isql` | grep odbc
    ldd psqlodbcw.so | grep odbc
    ```

这时，如果输出的libodbc.so最后的后缀数字不同或者指向不同的磁盘物理文件，那么基本就可以断定是此问题。isql与psqlodbcw.so都会要求加载libodbc.so，这时如果它们加载的是不同的物理文件，便会导致两套完全同名的函数列表，同时出现在同一个可见域里（UnixODBC的libodbc.so.\*的函数导出列表完全一致），产生冲突，无法加载数据库驱动。

解决办法：

确定一个要使用的UnixODBC，然后卸载另外一个（比如卸载库版本号为.so.2的UnixODBC），然后将剩下的.so.1的库，新建一个同名但是后缀为.so.2的软链接，便可解决此问题。

- FATAL: Forbid remote connection with trust method!

由于安全原因，数据库主节点禁止openGauss内部其他节点无认证接入。

如果要在openGauss内部访问数据库主节点，请将ODBC程序部署在数据库主节点所在机器，服务器地址使用"127.0.0.1"。建议业务系统单独部署在openGauss外部，否则可能会影响数据库运行性能。

- \[unixODBC\]\[Driver Manager\]Invalid attribute value

有可能是unixODBC的版本并非推荐版本，建议通过“odbcinst --version”命令排查环境中的unixODBC版本。

- authentication method 10 not supported.

使用开源客户端碰到此问题，可能原因：

数据库中存储的口令校验只存储了SHA256格式哈希，而开源客户端只识别MD5校验，双方校验方法不匹配报错。

>[!NOTE]说明
>
>- 数据库并不存储用户口令，只存储用户口令的哈希码。
>- 数据库当用户更新用户口令或者新建用户时，会同时存储两种格式的哈希码，这时将兼容开源的认证协议。
>- 但是当老版本升级到新版本时，由于哈希的不可逆性，所以数据库无法还原用户口令，进而生成新格式的哈希，所以仍然只保留了SHA256格式的哈希，导致仍然无法使用MD5做口令认证。
>- MD5加密算法安全性低，存在安全风险，建议使用更安全的加密算法。

要解决该问题，可以更新用户口令（参见[ALTER USER](../sql_reference/alter_user.md)；或者新建一个用户（参见[CREATE USER](../sql_reference/create_user.md)，赋于同等权限，使用新用户连接数据库。

- unsupported frontend protocol 3.51: server supports 1.0 to 3.0

目标数据库版本过低，或者目标数据库为开源数据库。请使用对应版本的数据库驱动连接目标数据库。

- FATAL:  GSS authentication method is not allowed because XXXX user password is not disabled.

目标数据库主节点的pg\_hba.conf里配置了当前客户端IP使用"gss"方式来做认证，该认证算法不支持用作客户端的身份认证，请修改到"sha256"后再试。配置方法见[8](#zh-cn_topic_0283136654_zh-cn_topic_0237120407_zh-cn_topic_0059778464_l4c0173b8af93447e91aba24005e368e5)。
