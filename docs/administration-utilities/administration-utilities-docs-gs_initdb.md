# gs\_initdb

## 简介

**背景信息**

gs\_initdb初始化数据库时，会创建数据库目录、生成系统表、创建默认数据库和模板数据库。

工具运行产生的日志位于$GAUSSLOG/bin/gs\_initdb目录下，每个日志最大16MB，最多保留50个。如果环境变量GAUSSLOG没有配置，则不会产生日志文件。

**系统表**

初始化数据库时会生成大量的系统表和视图，其中绝大部分都对任何数据库用户开放查看权限。

>[!NOTE]说明
>pg\_user\_status、pg\_auth\_history系统表权限只对初始化数据库用户和sysadmin用户开放。

**生成的数据库**

- template1：是一个模板数据库，当以后再创建一个新的数据库时，template1数据库里的所有内容都会拷贝到新数据库中。通过gs\_initdb的参数可以决定template1数据库的设置。
- template0：是openGauss提供的最初始的备份数据库，当需要时可用template0作为模板生成“干净”的数据库。
- postgres：是一个提供给用户、工具和第三方应用的缺省数据库。

## 使用指导

**背景信息**

在安装时，推荐使用-D参数调用gs\_initdb初始化数据库。如果由于故障恢复等原因，需要重新初始化一个数据库，可以通过执行gs\_initdb来完成。

- 尽管gs\_initdb会尝试创建相应的数据目录，但可能没有权限执行此操作，因为要创建目录的父目录通常被root所拥有。如果要创建数据目录，首先用root用户创建一个空数据目录，然后用chown把该目录的所有权交给数据库用户。
- gs\_initdb决定template1数据库的设置，而该设置将会成为其他数据库的默认设置。
- gs\_initdb初始化数据库的缺省区域和字符集编码。字符集编码、字符编码排序（LC\_COLLATE）和字符集类（LC\_CTYPE，如大写、小写数字等）可以在创建数据库时独立设置。

**语法**

```
gs_initdb [OPTION]... [DATADIR]
```

**操作步骤**

1. 以操作系统用户omm登录数据库主节点。
2. 规划数据库目录。
  - 切换到root用户。

     ```
     su - root
     ```

  - 根据提示输入用户名和密码。

3. 进入“/opt/gaussdb”目录，并创建“data1”目录。

    ```
    cd /opt/gaussdb
    mkdir data1
    ```

  - 将data1目录的所有权分配给数据库用户omm，dbgrp是omm所属的用户组。

      ```
      chown omm:dbgrp data1
      ```

  - 退出root用户。

      ```
      exit
      ```

4. 执行gs\_initdb命令初始化数据库。

    ```
    gs_initdb -D /opt/gaussdb/data1 -w "******" --nodename='data1'
    ```

## 命令参考

gs\_initdb支持的常用参数和不常用参数请分别参见[表 1](#zh-cn_topic_0237152414_zh-cn_topic_0059778168_t7527cd2e8e304b64bec55dcd38b701bb)和[表 2](#zh-cn_topic_0237152414_zh-cn_topic_0059778168_t2f464cb1775044808eceb29e25d6d37f)。

**表 1**  常用参数说明

参数说明 取值范围 -A, --auth=METHOD 指定本地用户连接数据库时的认证方法，即“pg_hba.conf”配置文件中host和local所在行的认证方法。
除非用户对本地用户都是信任的，否则不要使用默认值trust。
METHOD的取值： trustrejectmd5（不安全的算法，为了兼容老版本而存在）sha256sm3 默认值：trust --auth-host=METHOD 指定本地用户通过TCP/IP连接数据库时的认证方法，即：“pg_hba.conf”配置文件中host所在行的认证方法。
指定此参数则会覆盖-A参数的值。
METHOD的取值： trustrejectmd5（不安全的算法，为了兼容老版本而存在）sha256sm3 默认值：trust --auth-local=METHOD 指定本地用户通过Unix域套接字连接数据库时的认证方法，即“pg_hba.conf”配置文件中local所在行的认证方法。
指定此参数则会覆盖-A参数的值。
METHOD的取值： trustrejectmd5（不安全的算法，为了兼容老版本而存在）sha256sm3peer（仅用于local模式） 默认值：trust -c, --enable-dcf 设置安装的节点为DCF模式 [-D, --pgdata=]DATADIR 指定数据目录的位置。
DATADIR的取值：用户自定义。不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
--nodename=NODENAME 初始化的节点名称。
节点的命名需要遵守如下规范： 节点名称必须为小写字母（a-z）、下划线（_）、特殊符号#、数字（0-9）。节点名称必须以小写字母（a-z）或下划线（_）开头。节点名称不能为空，且最大的长度为64个字符 。
-E, --encoding=ENCODING 为新数据库设置编码格式。
如果使用此参数，需要加上--locale选项指定支持此编码格式的区域。如果不加--locale选项，则采用系统默认的区域，如果系统默认区域的编码格式和用此参数指定的编码格式不匹配则会导致数据库初始化失败。如果不指定此参数，则使用系统默认区域的编码格式。系统默认区域和编码格式可以使用locale命令查看，如下：omm@linux:~&gt; locale|grep LC_CTYPE LC_CTYPE="en_US.UTF-8" 其中UTF-8表示系统默认区域的编码格式。
不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
--locale=LOCALE 为新数据库设置缺省的区域。可以用locale -a查看可用的区域，如zh_CN.gbk等。如果不希望指定特定的区域，则可以用C。
不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
例如用户要将数据库编码格式初始化为GBK，可以采用如下步骤： 用locale -a |grep gbk命令查看系统支持gbk编码的区域，如下：omm@linux:~&gt;  locale -a|grep gbk zh_CN.gbk zh_SG.gbk 初始化数据库时加入--locale=zh_CN.gbk选项。
--dbcompatibility=DBCOMPATIBILITY 指定兼容的数据库的类型。
取值范围：A、B、C、PG。分别表示兼容O、MY、TD和POSTGRES。
--lc-collate=LOCALE --lc-ctype=LOCALE --lc-messages=LOCALE --lc-monetary=LOCALE --lc-numeric=LOCALE --lc-time=LOCALE 为新数据库设置指定范畴的区域。
各参数的取值必须是操作系统支持的值。不能包括不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
--no-locale 和--locale=C等价。
--pwfile=FILE gs_initdb时从文件FILE中读取数据库中系统管理员的密码。该文件的第一行将被当作密码使用。
FILE可以是“相对路径+文件”的形式，也可以是“绝对路径+文件”的形式。相对路径是相对当前路径的。不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
-T, --text-search-config=CFG 设置缺省的文本搜索方式。此配置项的值不会做正确性校验，配置成功后，有日志记录提醒当前配置项的取值。
text-search-config的取值： english全文搜索simple普通文本搜索 默认值：simple -U, --username=NAME 选择数据库系统管理员的用户名。
取值范围：正常的数据库用户。不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
默认值：运行gs_initdb的操作系统用户。
-W, --pwprompt gs_initdb时强制交互式输入数据库管理员的密码。
-w, --pwpasswd=PASSWD gs_initdb时通过命令行指定的管理员用户的密码，而不是交互式输入。
设置的密码要符合复杂度要求： 最少包含8个字符，不能超过32个字符；不能和用户名和当前密码（ALTER）相同，或和当前密码反序；至少包含大写字母（A-Z）、小写字母（a-z）、数字、非字母数字字符（限定为~!@#$%^&amp;*()-_=+\|[{}];:,&lt;.&gt;/?）四类字符中的三类字符。
-C, --enpwdfiledir=DIR gs_initdb时指定的经AES128加密算法加密过的密码文件所在目录。gs_initdb会将该目录下密码文件进行解密，同时把解密后的密码做密码复杂度校验，校验通过的话会将此密码作为用户的密码。
不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
-X, --xlogdir=XLOGDIR 声明事务日志存储的目录。
所设置的目录，必须满足运行openGauss的用户有读写权限。
只支持绝对路径。不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
-S, --security 安全方式初始化数据库。
以-S方式初始化的数据库后，创建的数据库用户权限受到限制，默认不再具有public schema的使用权限。

**表 2**  不常用参数说明

参数说明 取值范围 -d, --debug 从初始化后端打印调试输出信息。初始化后端是gs_initdb用于创建系统表的程序。
-L DIRECTORY gs_initdb初始化数据库所需要的输入文件的路径。通常是不必要的。如果需要明确声明的话，程序会提示输入。因该参数意为创建指定配置信息的数据库，建议将share/postgresql下的所有涉及启动相关的子目录及文件全部复制过来，避免其他因素的影响。
初始化数据库所需的输入文件路径。不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
-n, --noclean 不指定该参数时，当gs_initdb发现一些错误妨碍它完成创建数据库的工作时，它将在检测到不能结束工作之前将其创建的所有文件删除。这个选项禁止任何清理动作，因而对调试很有用。
-s, --show 显示内部设置。
-H, --host-ip 初始化openGauss节点node_host。
不能包括“|”, “;”，“&amp;”，“$”，“&lt;”，“&gt;”，“`”，“\\”，“!”这几个字符。
-V, --version 打印gs_initdb版本信息，然后退出。
-?, --help 显示关于gs_initdb命令行参数的帮助信息，然后退出。

**表 3**  资源池化参数说明

参数说明 取值范围 指定节点ID，初始化资源池化参数ss_instance_id。
[0-63]，  需要从0开始指定。
--enable-dss 开启ss_enable_dss功能。
--vgname 卷组名。
数据类型：字符串 。
例如：一个卷组“+data”或者两个卷组中间用“，”连接“+data,+log”。
--socketpath dss实例进程使用的socket文件路径。
支持绝对路径。
--dms_url 节点之间mes通信url。
数据类型：字符串。格式为“节点id:ip:port,节点id:ip:port,.......” 例如：“0:127.0.0.1:1611,1:127.0.0.1:1711”

> [!NOTE]说明
> 资源池化下系统表存放在段页式中，unlogging表保持页式存储。
