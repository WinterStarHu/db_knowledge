# gsql

gsql是openGauss提供在命令行下运行的数据库连接工具，可以通过此工具连接服务器并对其进行操作和维护，除了具备操作数据库的基本功能，gsql还提供了若干高级特性，便于用户使用。

## gsql概述

**基本功能**

- **连接数据库**：详细操作请参见《快速入门》中“访问openGauss \> 使用gsql访问openGauss”章节。

>[!NOTE]说明
>
>gsql创建连接时，数据库默认设置会有5分钟超时时间。如果在这个时间内，数据库未正确地接受连接并对身份进行认证，gsql将超时退出。
>针对此问题，可以参考[常见问题处理](#section1780814211263)。

- **执行SQL语句**：支持交互式地键入并执行SQL语句，也可以执行一个文件中指定的SQL语句。
- **执行元命令**：元命令可以帮助管理员查看数据库对象的信息、查询缓存区信息、格式化SQL输出结果、以及连接到新的数据库等。元命令的详细说明请参见[元命令参考](#section17631544132716)。

**高级特性**

gsql的高级特性如[表1](#zh-cn_topic_0237152142_zh-cn_topic_0059778819_t88d6eef25b234de4b4b0f7854aafa35d)所示。

**表 1**  gsql高级特性

特性名称 gsql提供类似于Linux的shell命令的变量特性，可以使用gsql的原命令\set设置一个变量，格式如下： \set varname value 要删除一个变量请使用如下方式： \unset varname 变量的示例和详细说明请参见变量。
SQL代换 利用gsql的变量特性，可以将常用的SQL语句设置为变量，以简化操作。
SQL代换的示例和详细说明请参见SQL代换。
自定义提示符 gsql使用的提示符支持用户自定义。可以通过修改gsql预留的三个变量PROMPT1、PROMPT2、PROMPT3来改变提示符。
这三个变量的值可以用户自定义，也可以使用gsql预定义的值。详细请参见提示符。
命令自动补齐 根据openGauss语法规则，gsql支持使用Tab键进行命令的自动补齐，当编译时指定了选项--with-readline，且客户端连接时指定“-r”参数，此功能被打开。例如，crea后键入Tab，gsql会将其补齐为create。
客户端操作历史记录 gsql支持客户端操作历史记录，当客户端连接时指定“-r”参数，此功能被打开。可以通过\set设置记录历史的条数，例如，\set HISTSIZE 50，将记录历史的条数设置为50，\set HISTSIZE 0，不记录历史。

- 变量

可以使用gsql元命令\\set设置一个变量。例如把变量foo的值设置为bar：

    ```
    openGauss=# \set foo bar
    ```

要引用变量的值，在变量前面加冒号。例如查看变量的值：

    ```
    openGauss=# \echo :foo
    bar
    ```

这种变量的引用方法适用于正规的SQL语句和元命令。

gsql预定义了一些特殊变量，同时也规划了变量的取值。为了保证和后续版本最大限度地兼容，请避免以其他目的使用这些变量。所有特殊变量见[表2](#zh-cn_topic_0237152142_zh-cn_topic_0059778819_zh-cn_topic_0058968129_table45814285)。

>[!NOTE]说明
>
>- 所有特殊变量都由大写字母、数字和下划线组成。
>- 要查看特殊变量的默认值，请使用元命令 **\\echo :**_varname_（例如\\echo :DBNAME）。

**表 2**  特殊变量设置

设置方法 变量说明 DBNAME \set DBNAME dbname 当前连接的数据库的名称。每次连接数据库时都会被重新设置。
ECHO \set ECHO all | queries 如果设置为all，只显示查询信息。设置为all等效于使用gsql连接数据库时指定-a参数。如果设置为queries，显示命令行和查询信息。等效于使用gsql连接数据库时指定-e参数。
ECHO_HIDDEN \set ECHO_HIDDEN  on | off | noexec 当使用元命令查询数据库信息（例如\dg）时，此变量的取值决定了查询的行为： 设置为on，先显示元命令实际调用的查询语句，然后显示查询结果。等效于使用gsql连接数据库时指定-E参数。设置为off，则只显示查询结果。设置为noexec，则只显示查询信息，不执行查询操作。
ENCODING \set ENCODING   encoding 当前客户端的字符集编码。
FETCH_COUNT \set FETCH_COUNT variable 如果该变量的值为大于0的整数，假设为n，则执行SELECT语句时每次从结果集中取n行到缓存并显示到屏幕。如果不设置此变量，或设置的值小于等于0，则执行SELECT语句时一次性把结果都取到缓存。
HOST \set HOST hostname 已连接的数据库主机名称。
IGNOREEOF \set IGNOREEOF variable 若设置此变量为数值，假设为10，则在gsql中输入的前9次EOF字符（通常是Ctrl+D组合键）都会被忽略，在第10次按Ctrl+D才能退出gsql程序。若设置此变量为非数值，则缺省为10。若删除此变量，则向交互的gsql会话发送一个EOF终止应用。
LASTOID \set LASTOID oid 最后影响的oid值，即为从一条INSERT或lo_import命令返回的值。此变量只保证在下一条SQL语句的结果显示之前有效。
ON_ERROR_ROLLBACK \set  ON_ERROR_ROLLBACK  on | interactive | off 如果是on，当一个事务块里的语句产生错误的时候，这个错误将被忽略而事务继续。如果是interactive，这样的错误只是在交互的会话里忽略。如果是off（缺省），事务块里一个语句生成的错误将会回滚整个事务。on_error_rollback-on模式是通过在一个事务块的每个命令前隐含地发出一个SAVEPOINT的方式工作的，在发生错误的时候回滚到该事务块。
ON_ERROR_STOP \set ON_ERROR_STOP on | off on：命令执行错误时会立即停止，在交互模式下，gsql会立即返回已执行命令的结果。off（缺省）：命令执行错误时将会跳过错误继续执行。
PORT \set PORT port 正连接数据库的端口号。
USER \set USER username 当前用于连接的数据库用户。
VERBOSITY \set VERBOSITY   terse | default | verbose 这个选项可以设置为值terse、default、verbose之一以控制错误报告的冗余行。
terse：仅返回严重且主要的错误文本以及文本位置（一般适合于单行错误信息）。default：返回严重且主要的错误文本及其位置，还包括详细的错误细节、错误提示（可能会跨越多行）。verbose：返回所有的错误信息。

- SQL代换

像元命令的参数一样，gsql变量的一个关键特性是可以把gsql变量替换成正规的SQL语句。此外，gsql还提供为变量更换新的别名或其他标识符等功能。使用SQL代换方式替换一个变量的值可在变量前加冒号。例如：

    ```
    openGauss=# \set foo 'HR.areaS'
    openGauss=# select * from :foo;
     area_id |       area_name
    ---------+------------------------
           4 | Middle East and Africa
           3 | Asia
           1 | Europe
           2 | Americas
    (4 rows)
    ```

执行以上命令，将会查询HR.areaS表。

>[!TIP]须知
>变量的值是逐字复制的，甚至可以包含不对称的引号或反斜杠命令。所以必须保证输入的内容有意义。

- 提示符

通过[表3](#zh-cn_topic_0237152142_zh-cn_topic_0059778819_tfd36c27a76294b92ad194d20beeaac7f)的三个变量可以设置gsql的提示符，这些变量是由字符和特殊的转义字符所组成。

**表 3**  提示符变量

PROMPT1 gsql请求一个新命令时使用的正常提示符。
PROMPT1的默认值为： %/%R%# 使用变量PROMPT1切换提示符： 提示符变为[local]：postgres=&gt; \set PROMPT1 %M [local:/tmp/gaussdba_mppdb] 提示符变为name：postgres=&gt; \set PROMPT1 name name 提示符变为=：postgres=&gt; \set PROMPT1 %R = PROMPT2 在一个命令输入期待更多输入时（例如，查询没有用一个分号结束或者引号不完整）显示的提示符。
使用变量PROMPT2显示提示符： openGauss=# \set PROMPT2 TEST openGauss=# select * from HR.areaS TEST;
area_id |       area_name
---------+--------------------
1 | Europe 2 | Americas 4 | Middle East and Africa 3 | Asia (4 rows)) PROMPT3 当执行COPY命令，并期望在终端输入数据时（例如，COPY FROM STDIN），显示提示符。
使用变量PROMPT3显示COPY提示符： openGauss=#  \set PROMPT3 '&gt;&gt;&gt;&gt;' openGauss=#  copy HR.areaS from STDIN;
Enter data to be copied followed by a newline.
End with a backslash and a period on a line by itself.
&gt;&gt;&gt;&gt;1 aa &gt;&gt;&gt;&gt;2 bb &gt;&gt;&gt;&gt;\.

提示符变量的值是按实际字符显示的，但是，当设置提示符的命令中出现“%”时，变量的值根据“%”后的字符，替换为已定义的内容，已定义的提示符请参见[表4](#zh-cn_topic_0237152142_zh-cn_topic_0059778819_zh-cn_topic_0058968129_table55443487)。

**表 4**  已定义的替换

符号说明 主机的全名（包含域名），若连接是通过Unix域套接字进行的，则全名为[local]，若Unix域套接字不是编译的缺省位置，就是[local:/dir/name]。
主机名删去第一个点后面的部分。若通过Unix域套接字连接，则为[local]。
%&gt;
主机正在侦听的端口号。
数据库会话的用户名。
当前数据库名称。
类似 %/，如果数据库是缺省数据库时输出的是波浪线~。
如果会话用户是数据库系统管理员，使用#，否则用&gt;。
对于PROMPT1通常是“=”，如果是单行模式则是“^”，如果会话与数据库断开（如果\connect失败可能发生）则是“!”。对于PROMPT2该序列被“ -”、单引号、双引号或“$”（取决于gsql是否等待更多的输入：查询没有终止、正在一个 / ... / 注释里、正在引号或者美元符扩展里）代替。
事务状态： 如果不在事务块里，则是一个空字符串。如果在事务块里，则是“*”。如果在一个失败的事务块里则是“!”。如果无法判断事务状态时为“?”（比如没有连接）。
%digits 指定字节值的字符将被替换到该位置。
%:name gsql变量“name”的值。
%command command的输出，类似于使用“^”替换。
%[ . . . %] 提示可以包含终端控制字符，这些字符可以改变颜色、背景、提示文本的风格、终端窗口的标题。例如， potgres=&gt; \set PROMPT1 '%[%033[1;33;40m%]%n@%/%R%[%033[0m%]%#' 这个句式的结果是在VT100兼容的可显示彩色的终端上的一个宽体（1;）黑底黄字（33;40）。

**环境变量**

**表 5**  与gsql相关的环境变量

COLUMNS 如果\set columns为0，则由此参数控制wrapped格式的宽度。这个宽度用于决定在自动扩展的模式下，是否要把宽输出模式变成竖线的格式。
PAGER 如果查询结果无法在一页显示，它们就会被重定向到这个命令。可以用\pset命令关闭分页器。典型的是用命令more或less来实现逐页查看。缺省值是平台相关的。
PSQL_EDITOR \e和\ef命令使用环境变量指定的编辑器。变量是按照列出的先后顺序检查的。在Unix系统上默认的编辑工具是vi。
EDITOR VISUAL PSQL_EDITOR_LINENUMBER_ARG Unix系统默认的是+。
PSQLRC 用户的.gsqlrc文件的交互位置。
SHELL 使用\!命令跟shell执行的命令是一样的效果。
TMPDIR 存储临时文件的目录。缺省是/tmp。

### 使用指导

**前提条件**

连接数据库时使用的用户需要具备访问数据库的权限。

**背景信息**

使用gsql命令可以连接远程数据库服务。连接远程数据库服务时，需要在服务器上设置允许远程连接，详细操作请参见[使用gsql访问openGauss](../getting_started/gsql_connection_and_usage.md)。

**操作步骤**

1. 使用gsql连接到openGauss服务器。

gsql工具使用-d参数指定目标数据库名、-U参数指定数据库用户名、-h参数指定主机名、-p参数指定端口号信息。

>[!NOTE]说明
>
>- 若未指定数据库名称，则使用初始化时默认生成的数据库名称；
>- 若未指定数据库用户名，则默认使用当前操作系统用户作为数据库用户名；
>- 当某个值没有前面的参数（-d、-U等）时，若连接的命令中没有指定数据库名（-d）则该参数会被解释成数据库名；
>- 如果已经指定数据库名（-d）而没有指定数据库用户名（-U）时，该参数则会被解释成数据库用户名。

示例1，使用omm用户连接到本机postgres数据库的15400端口。

    ```
    gsql -d postgres -p 15400
    ```

示例2，使用jack用户连接到远程主机postgres数据库的15400端口。

    ```
    gsql -h 10.180.123.163 -d postgres -U jack -p 15400
    ```

示例3，参数postgres和omm不属于任何选项时，分别被解释成了数据库名和用户名。

    ```
    gsql postgres omm -p 15400
    ```

**等效于**

    ```
    gsql -d postgres -U omm -p 15400
    ```

详细的gsql参数请参见[命令参考](#section5729181711)。

2. 执行SQL语句。

以创建数据库human\_staff为例。

    ```
    CREATE DATABASE human_staff;
    ```

通常，输入的命令行在遇到分号的时候结束。如果输入的命令行没有错误，结果就会输出到屏幕上。

3. 执行gsql元命令。

以列出openGauss中所有的数据库和描述信息为例。

    ```
    openGauss=#  \l
                                    List of databases
          Name      |  Owner   | Encoding  | Collate | Ctype |   Access privileges
    ----------------+----------+-----------+---------+-------+-----------------------
     human_resource | omm | SQL_ASCII | C       | C     |
     postgres       | omm | SQL_ASCII | C       | C     |
     template0      | omm | SQL_ASCII | C       | C     | =c/omm         +
                    |          |           |         |       | omm=CTc/omm
     template1      | omm | SQL_ASCII | C       | C     | =c/omm          +
                    |          |           |         |       | omm=CTc/omm
     human_staff    | omm | SQL_ASCII | C       | C     |
    (5 rows)
    ```

更多gsql元命令请参见[元命令参考](#section17631544132716)。

**示例**

首先要创建一个表空间EXAMPLE：

```
openGauss=# CREATE TABLESPACE EXAMPLE RELATIVE LOCATION 'tablespace1/tablespace_1';
CREATE TABLESPACE
```

表空间创建成功后，创建schema HR：

```
openGauss=# CREATE schema HR;
CREATE SCHEMA
```

以把一个查询分成多行输入为例。注意提示符的变化：

```
openGauss=# CREATE TABLE HR.areaS(
openGauss(# area_ID   NUMBER,
openGauss(# area_NAME VARCHAR2(25)
openGauss(# )tablespace EXAMPLE;
CREATE TABLE
```

查看表的定义：

```
openGauss=# \d HR.areaS
               Table "hr.areas"
  Column   |         Type          | Modifiers
-----------+-----------------------+-----------
 area_id   | numeric               |
 area_name | character varying(25) |
Tablespace: "example"
```

向HR.areaS表插入四行数据：

```
openGauss=# INSERT INTO HR.areaS (area_ID, area_NAME) VALUES (1, 'Europe');
INSERT 0 1
openGauss=# INSERT INTO HR.areaS (area_ID, area_NAME) VALUES (2, 'Americas');
INSERT 0 1
openGauss=# INSERT INTO HR.areaS (area_ID, area_NAME) VALUES (3, 'Asia');
INSERT 0 1
openGauss=# INSERT INTO HR.areaS (area_ID, area_NAME) VALUES (4, 'Middle East and Africa');
INSERT 0 1
```

切换提示符：

```
openGauss=# \set PROMPT1 '%n@%m %~%R%#'
omm@[local] openGauss=#
```

查看表：

```
omm@[local] openGauss=#SELECT * FROM HR.areaS;
 area_id |       area_name
---------+------------------------
       1 | Europe
       4 | Middle East and Africa
       2 | Americas
       3 | Asia
(4 rows)
```

可以用\\pset命令以不同的方法显示表：

```
omm@[local] openGauss=#\pset border 2
Border style is 2.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
+---------+------------------------+
| area_id |       area_name        |
+---------+------------------------+
|       1 | Europe                 |
|       2 | Americas               |
|       3 | Asia                   |
|       4 | Middle East and Africa |
+---------+------------------------+
(4 rows)
```

```
omm@[local] openGauss=#\pset border 0
Border style is 0.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
area_id       area_name
------- ----------------------
      1 Europe
      2 Americas
      3 Asia
      4 Middle East and Africa
(4 rows)
omm@[local] openGauss=#\pset border 2
Border style is 2.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
+---------+------------------------+
| area_id |       area_name        |
+---------+------------------------+
|       1 | Europe                 |
|       2 | Americas               |
|       3 | Asia                   |
|       4 | Middle East and Africa |
+---------+------------------------+
(4 rows)
omm@[local] openGauss=#\pset border 0
Border style is 0.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
area_id       area_name
------- ----------------------
      1 Europe
      2 Americas
      3 Asia
      4 Middle East and Africa
(4 rows)
omm@[local] openGauss=#\pset border 2
Border style is 2.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
+---------+------------------------+
| area_id |       area_name        |
+---------+------------------------+
|       1 | Europe                 |
|       2 | Americas               |
|       3 | Asia                   |
|       4 | Middle East and Africa |
+---------+------------------------+
(4 rows)
omm@[local] openGauss=#\pset border 0
Border style is 0.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
area_id       area_name
------- ----------------------
      1 Europe
      2 Americas
      3 Asia
      4 Middle East and Africa
(4 rows)
```

使用元命令：

```
omm@[local] openGauss=#\a \t \x
Output format is unaligned.
Showing only tuples.
Expanded display is on.
omm@[local] openGauss=#SELECT * FROM HR.areaS;
area_id|2
area_name|Americas

area_id|1
area_name|Europe

area_id|4
area_name|Middle East and Africa

area_id|3
area_name|Asia
omm@[local] openGauss=#
```

### 获取帮助

**操作步骤**

- 连接数据库时，可以使用如下命令获取帮助信息。

    ```
    gsql --help
    ```

显示如下帮助信息：

    ```
    ......
    Usage:
      gsql [OPTION]... [DBNAME [USERNAME]]

    General options:
      -c, --command=COMMAND    run only single command (SQL or internal) and exit
      -d, --dbname=DBNAME      database name to connect to (default: "omm")
      -f, --file=FILENAME      execute commands from file, then exit
    ......
    ```

- 连接到数据库后，可以使用如下命令获取帮助信息。

    ```
    help
    ```

显示如下帮助信息：

    ```
    You are using gsql, the command-line interface to gaussdb.
    Type:  \copyright for distribution terms
           \h for help with SQL commands
           \? for help with gsql commands
           \g or terminate with semicolon to execute query
           \q to quit
    ```

**任务示例**

1. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 15400
    ```

postgres为需要连接的数据库名称，15400为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql ((openGauss x.x build 290d125f) compiled at 2020-05-08 02:59:43 commit 2143 last mr 131
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

2. 查看gsql的帮助信息。具体执行命令请参见[表6 使用gsql联机帮助](#zh-cn_topic_0237152144_zh-cn_topic_0059778941_zh-cn_topic_0058968146_table52020644)。

**表 6**  使用gsql联机帮助

查看版权信息 \copyright 查看openGauss支持的SQL语句的帮助 查看openGauss支持的SQL语句的帮助 例如，查看openGauss支持的所有SQL语句： openGauss=# \h Available help:
ABORT ALTER APP WORKLOAD GROUP ... ...
例如，查看CREATE DATABASE命令的参数可使用下面的命令： openGauss=# \help CREATE DATABASE Command:     CREATE DATABASE Description: create a new database Syntax:
CREATE DATABASE database_name [ [ WITH ] {[ OWNER [=] user_name ]| [ TEMPLATE [=] template ]| [ ENCODING [=] encoding ]| [ LC_COLLATE [=] lc_collate ]| [ LC_CTYPE [=] lc_ctype ]| [ DBCOMPATIBILITY [=] compatibility_type ]| [ TABLESPACE [=] tablespace_name ]| [ CONNECTION LIMIT [=] connlimit ]}[...] ];
查看gsql命令的帮助 例如，查看gsql支持的命令： openGauss=# \?
General \copyright             show FusionInsight LibrA usage and distribution terms \g [FILE] or ;         execute query (and send results to file or |pipe) \h(\help) [NAME]              help on syntax of SQL commands, * for all commands \parallel [on [num]|off] toggle status of execute (currently off) \q                     quit gsql ... ...

### 命令参考

详细的gsql参数请参见[表7 常用参数](#zh-cn_topic_0237152145_zh-cn_topic_0059779319_t5f35328143ec419983a1c23d13c46e49)、[表8 输入和输出参数](#zh-cn_topic_0237152145_zh-cn_topic_0059779319_t0233128ab394456c80e339179cb56739)、[表9 输出格式参数](#zh-cn_topic_0237152145_zh-cn_topic_0059779319_t47c174e145784f16ac251d3c6aea8ea8)和[表10 连接参数](#zh-cn_topic_0237152145_zh-cn_topic_0059779319_td7e646abbf6a4d85bc54cd9741c80b68)。

**表 7**  常用参数

参数说明 取值范围 -c, --command=COMMAND 声明gsql要执行一条字符串命令然后退出。该选项可以重复，并可以按任意顺序与-f选项组合，选项指定的命令和文件按输入顺序执行并输出结果。
-d, --dbname=DBNAME 指定想要连接的数据库名称。另外，gsql允许使用扩展的DBNAME，即'postgres[ql]://[user[:password]@][netloc][:port][,...][/dbname][?param1=value1&...]'或'[key=value] [...]'形式的连接串作为DBNAME，gsql将从连接串中解析连接信息，并优先使用这些信息。
字符串。
-f, --file=FILENAME 使用文件作为命令源而不是交互式输入。该选项可以重复，且可以按任意顺序与-c选项组合。gsql将在处理完文件和命令后结束。如果FILENAME是-（连字符），则从标准输入读取。
绝对路径或相对路径，且满足操作系统路径命名规则。
-l, --list 列出所有可用的数据库，然后退出。
-v, --set, --variable=NAME=VALUE 设置gsql变量NAME为VALUE。
变量的示例和详细说明请参见变量。
-X, --no-gsqlrc 不读取启动文件（系统范围的gsqlrc或者用户的~/.gsqlrc都不读取）。
-1 ("one"), --single-transaction 当gsql使用-1选项执行脚本时，会在脚本的开头和结尾分别加上START TRANSACTION/COMMIT用以把整个脚本当作一个事务执行。这将保证该脚本完全执行成功，或者脚本无效。
-?, --help 显示关于gsql命令行参数的帮助信息然后退出。
-V, --version 打印gsql版本信息然后退出。
-C, --enable-client-encryption 当使用-C参数连接本地数据库或者远程连接数据库时，可通过该选项打开全密态数据库开关。
--with-decryption 指定解密算法，软件只支持AES128，第三方接口库支持AES128_CBC、AES128_CTR、AES128_GCM、AES256_CBC、AES256_CTR、AES256_GCM、SM4_CBC、SM4_CTR、AES128_CBC_HMAC_SHA256、AES128_CTR_HMAC_SHA256、AES128_GCM_HMAC_SHA256、AES256_CBC_HMAC_SHA256、AES256_CTR_HMAC_SHA256、AES256_GCM_HMAC_SHA256、SM4_CBC_HMAC_SM3、SM4_CTR_HMAC_SM3。如果不带HMAC，表示只做加密。带HMAC表示需要带HMAC运算做完整性校验。
--with-module-params 指定第三方接口库参数 MODULE_TYPE=TYPE,MODULE_LIB_PATH=path,MODULE_CONFIG_FILE_PATH=path type:GDACCARD,JNTAKMS,SWXAKMS;
MODULE_LIB_PATH:包含库文件名称的绝对路径;
MODULE_CONFIG_FILE_PATH:GDACCARD不需要,JNTAKMS 不包含文件名称的绝对路径,SWXA 包含文件名称的绝对路径。
--with-salt 指定IV，16字节。

**表 8**  输入和输出参数

参数说明 取值范围 -a, --echo-all 在读取行时向标准输出打印所有内容。
-e, --echo-queries 把所有发送给服务器的查询同时回显到标准输出。
-E, --echo-hidden 回显由\d和其他反斜杠命令生成的实际查询。
-k, --with-key=KEY 使用gsql对导入的加密文件进行解密。
-L, --log-file=FILENAME 除了正常的输出源之外，把所有查询输出记录到文件FILENAME中。
绝对路径或相对路径，且满足操作系统路径命名规则。
-m, --maintenance 允许在两阶段事务恢复期间连接openGauss。
-n, --no-libedit 关闭命令行编辑。
-o, --output=FILENAME 将所有查询输出重定向到文件FILENAME。
绝对路径或相对路径，且满足操作系统路径命名规则。
-q, --quiet 安静模式，执行时不会打印出额外信息。
缺省时gsql将打印许多其他输出信息。
-s, --single-step 单步模式运行。意味着每个查询在发往服务器之前都要提示用户，用这个选项也可以取消执行。此选项主要用于调试脚本。
-S, --single-line 单行运行模式，这时每个命令都将由换行符结束，像分号那样。
-C, --enable-client-encryption当使用-C参数连接本地数据库或者远程连接数据库时，可通过该选项打开全密态数据库开关。-

**表 9**  输出格式参数

参数说明 取值范围 -A, --no-align 切换为非对齐输出模式。
缺省为对齐输出模式。
-F, --field-separator=STRING 设置域分隔符（默认为“|”）。
-H, --html 打开HTML格式输出。
-P, --pset=VAR[=ARG] 在命令行上以\pset的风格设置打印选项。
-R, --record-separator=STRING 设置记录分隔符。
开启在客户端操作中可以进行编辑的模式。
缺省为关闭。
-t, --tuples-only 只打印行。
-T, --table-attr=TEXT 允许声明放在HTML table标签里的选项。
使用时请搭配参数“-H,--html”，指定为HTML格式输出。
-x, --expanded 打开扩展表格式模式。
-z, --field-separator-zero 设置非对齐输出模式的域分隔符为空。
使用时请搭配参数“-A, --no-align”，指定为非对齐输出模式。
-0, --record-separator-zero 设置非对齐输出模式的记录分隔符为空。
使用时请搭配参数“-A, --no-align”，指定为非对齐输出模式。
-2, --pipeline使用管道传输密码，禁止在终端使用，必须和-c或者-f参数一起使用。- -g,打印来自文件的所有SQL，且只在debug或memcheck模式下生效。指定该选项必须同时指定-f选项。如果指定该选项的同时还指定了多个-f和-c选项，则只有-f选项指定的文件中的SQL会被打印，-c选项指定的命令会正常执行。-

**表 10**  连接参数

参数说明 取值范围 -h, --host=HOSTNAME 指定正在运行服务器的主机名或者Unix域套接字的路径。
如果省略主机名，gsql将通过Unix域套接字与本地主机的服务器相联，或者在没有Unix域套接字的机器上，通过TCP/IP与localhost连接。
-p, --port=PORT 指定数据库服务器的端口号。
可以通过port参数修改默认端口号。
默认为5432。
-U, --username=USERNAME 指定连接数据库的用户。
字符串。默认使用与当前操作系统用户同名的用户。
-W, --password=PASSWORD 当使用-U参数连接远端数据库时，可通过该选项指定密码。
符合密码复杂度要求。

### 元命令参考

介绍使用openGauss数据库命令行交互工具登录数据库后，gsql所提供的元命令。所谓元命令就是在gsql里输入的任何以不带引号的反斜杠开头的命令。

#### **注意事项**

- 一个gsql元命令的格式是反斜杠后面紧跟一个动词，然后是任意参数。参数命令动词和其他参数以任意个空白字符间隔。

- 要在参数里面包含空白，必须用单引号把它引起来。要在这样的参数里包含单引号，可以在前面加一个反斜杠。任何包含在单引号里的内容都会被进一步进行类似C语言的替换：\\n（新行）、\\t（制表符）、\\b（退格）、\\r（回车）、\\f（换页）、\\digits（八进制表示的字符）、\\xdigits（十六进制表示的字符）。
- ""包围的内容被当做一个命令行传入shell。该命令的输出（删除了结尾的新行）被当做参数值。
- 如果不带引号的参数以冒号（:）开头，它会被当做一个gsql变量，并且该变量的值最终会成为真正的参数值。
- 有些命令以一个SQL标识的名称（比如一个表）为参数。这些参数遵循SQL语法关于双引号的规则：不带双引号的标识强制转换成小写，而双引号保护字母不进行大小写转换，并且允许在标识符中使用空白。在双引号中，成对的双引号在结果名称中分析成一个双引号。比如，FOO“BAR”BAZ解析成fooBARbaz；而“A weird”“name”解析成“A weird”name。
- 对参数的分析在遇到另一个不带引号的反斜杠时停止。这里会认为是一个新的元命令的开始。特殊的双反斜杠序列（\\\\）标识参数的结尾并将继续分析后面的SQL语句（如果存在）。这样SQL和gsql命令可以自由的在一行里面混合。但是在任何情况下，一条元命令的参数不能延续超过行尾。
- 启动文件（即环境变量PSQLRC指定的文件，默认为~/.gsqlrc）中的设置对-c选项指定的字符串命令的执行通常不生效，仅当-c与-f选项混用时，该文件中的设置才对-c指定的字符串命令生效。

#### **元命令**

元命令的详细说明请参见[表11 一般的元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table23103470)、[表12 查询缓存区元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table8624338)、[表13 输入/输出元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table62130565)、[表14 显示信息元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table44907299)、[表16 格式化元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table53911699)、[表18 连接元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table37189353)、[表19 操作系统元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table32146234)、[表20 变量元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table50076468)和[表22 大对象元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table55465693)。

>[!TIP]须知
>以下命令中所提到的FILE代表文件路径。此路径可以是绝对路径（如/home/gauss/file.txt），也可以是相对路径（file.txt，file.txt会默认在用户执行gsql命令所在的路径下创建）。

**表 11**  一般的元命令

参数说明 取值范围 \copyright 显示openGauss的版本和版权信息。
\g [FILE] or ;
执行查询（并将结果发送到文件或管道）。

注意： 不能在并行模式下使用\g。

```sql
\parallel on
Parallel is on with scale default 1024.
select 1 as a \g
Sending the query buffer by a meta-command is not supported in parallel mode.
```
\h(\help) [NAME] 给出指定SQL语句的语法帮助。
如果没有给出NAME，gsql将列出可获得帮助的所有命令。如果NAME是一个星号（*），则显示所有SQL语句的语法帮助。
\parallel [on [num]|off] 控制并发执行开关。
on：打开控制并发执行开关，且最大并发数为num。off：关闭控制并发执行开关。
num的默认值：1024。
退出gsql程序。在一个脚本文件里，只在脚本终止的时候执行。

**表 12**  查询缓存区元命令

参数说明 \e  [FILE]   [LINE] 使用外部编辑器编辑查询缓冲区（或者文件）。
\ef [FUNCNAME [LINE]] 使用外部编辑器编辑函数定义。如果指定了LINE（即行号），则光标会指到函数体的指定行。
打印当前查询缓冲区到标准输出。
重置（或清空）查询缓冲区。
\w FILE 将当前查询缓冲区输出到文件。

**表 13**  输入/输出元命令

参数说明 \copy { table [ ( column_list ) ] | ( query ) } { from | to } { filename | stdin | stdout | pstdin | pstdout } [parallel integer] [ with ] [ binary ] [ oids ] [ delimiter [ as ] 'character' ] [ null [ as ] 'string' ] [ csv [ header ] [ quote [ as ] 'character' ] [ escape [ as ] 'character' ] [ force quote column_list | * ] [ force not null column_list ] [ force null column_list ] ] 在任何psql客户端登录数据库成功后可以执行导入导出数据， 这是一个运行SQL COPY命令的操作，但不是读取或写入指定文件的服务器，而是读取或写入文件，并在服务器和本地文件系统之间路由数据。 这意味着文件的可访问性和权限是本地用户的权限，而不是服务器的权限，并且不需要数据库初始化用户权限。
\echo   [STRING] 把字符串写到标准输出。
\i FILE 从文件FILE中读取内容，并将其当作输入，执行查询。
\i+ FILE KEY 执行加密文件中的命令。
\ir FILE 和\i类似，只是相对于存放当前脚本的路径。
\ir+ FILE KEY 和\i+类似，只是相对于存放当前脚本的路径。
\o   [FILE] 把所有的查询结果发送到文件里。
\qecho   [STRING] 把字符串写到查询结果输出流里。

>[!NOTE]说明
>[表14 显示信息元命令](#zh-cn_topic_0237152146_zh-cn_topic_0059778645_zh-cn_topic_0058968158_table44907299)中的选项S表示显示系统对象，PATTERN表示显示对象附加的描述信息。用来指定要被显示的对象名称。

**表 14**  显示信息元命令

参数说明 取值范围 \d[S+] 列出当前search_path中模式下所有的表、视图和序列。当search_path中不同模式存在同名对象时，只显示search_path中位置靠前模式下的同名对象。
列出当前search_path中模式下所有的表、视图和序列。
openGauss=# \d \d[S+]     NAME 列出指定表、视图和索引的结构。
假设存在表a，列出指定表a的结构。
openGauss=#  \dtable+ a \d+      [PATTERN] 列出所有表、视图和索引。
如果声明了PATTERN，只显示名称匹配PATTERN的表、视图和索引。
列出所有名称以f开头的表、视图和索引。
openGauss=# \d+ f* \da[S]     [PATTERN] 列出所有可用的聚集函数以及它们操作的数据类型和返回值类型。
如果声明了PATTERN，只显示名称匹配PATTERN的聚集函数。
列出所有名称以f开头可用的聚集函数以及它们操作的数据类型和返回值类型。
openGauss=# \da f* \db[+]     [PATTERN] 列出所有可用的表空间。
如果声明了PATTERN，只显示名称匹配PATTERN的表空间。
列出所有名称以p开头的可用表空间。
openGauss=# \db p* \dc[S+]   [PATTERN] 列出所有字符集之间的可用转换。
如果声明了PATTERN，只显示名称匹配PATTERN的转换。
列出所有字符集之间的可用转换。
openGauss=# \dc * \dC[+]    [PATTERN] 列出所有类型转换。
如果声明了PATTERN，只显示名称匹配PATTERN的转换。
列出所有名称以c开头的类型转换。
openGauss=# \dC c* \dd[S]    [PATTERN] 显示所有匹配PATTERN的描述。
如果没有给出参数，则显示所有可视对象。“对象”包括：聚集、函数、操作符、类型、关系（表、视图、索引、序列、大对象）、规则。
列出所有可视对象。
openGauss=# \dd \ddp       [PATTERN] 显示所有默认的使用权限。
如果指定了PATTERN，只显示名称匹配PATTERN的使用权限。
列出所有默认的使用权限。
openGauss=# \ddp \dD[S+]  [PATTERN] 列出所有可用域。
如果声明了PATTERN，只显示名称匹配PATTERN的域。
列出所有可用域。
openGauss=# \dD \ded[+] [PATTERN] 列出所有的Data Source对象。
如果声明了PATTERN，只显示名称匹配PATTERN的对象。
列出所有的Data Source对象。
openGauss=# \ded \det[+]    [PATTERN] 列出所有的外部表。
如果声明了PATTERN，只显示名称匹配PATTERN的表。
列出所有的外部表。
openGauss=# \det \des[+]   [PATTERN] 列出所有的外部服务器。
如果声明了PATTERN，只显示名称匹配PATTERN的服务器。
列出所有的外部服务器。
openGauss=# \des \deu[+]    [PATTERN] 列出用户映射信息。
如果声明了PATTERN，只显示名称匹配PATTERN的信息。
列出用户映射信息。
openGauss=# \deu \dew[+]   [PATTERN] 列出封装的外部数据。
如果声明了PATTERN，只显示名称匹配PATTERN的数据。
列出封装的外部数据。
openGauss=# \dew \df[antw][S+]   [PATTERN] 列出所有可用函数以及它们的参数和返回的数据类型。a代表聚集函数，n代表普通函数，t代表触发器，w代表窗口函数。
如果声明了PATTERN，只显示名称匹配PATTERN的函数。
列出所有可用函数以及它们的参数和返回的数据类型。
openGauss=# \df \dF[+]     [PATTERN] 列出所有的文本搜索配置信息。
如果声明了PATTERN，只显示名称匹配PATTERN的配置信息。
列出所有的文本搜索配置信息。
openGauss=# \dF+ \dFd[+]   [PATTERN] 列出所有的文本搜索字典。
如果声明了PATTERN，只显示名称匹配PATTERN的字典。
列出所有的文本搜索字典。
openGauss=# \dFd \dFp[+]   [PATTERN] 列出所有的文本搜索分析器。
如果声明了PATTERN，只显示名称匹配PATTERN的分析器。
列出所有的文本搜索分析器。
openGauss=# \dFp \dFt[+]    [PATTERN] 列出所有的文本搜索模板。
如果声明了PATTERN，只显示名称匹配PATTERN的模板。
列出所有的文本搜索模板。
openGauss=# \dFt \dg[+]    [PATTERN] 列出所有数据库角色。
如果指定了PATTERN，只显示名称匹配PATTERN的角色。
列出名称为‘j_e’所有数据库角色。
openGauss=# \dg j?e \dl \lo_list的别名，显示一个大对象的列表。
列出所有的大对象。
openGauss=# \dl \dL[S+]   [PATTERN] 列出可用的程序语言。
如果指定了PATTERN，只列出名称匹配PATTERN的语言。
列出可用的程序语言。
openGauss=# \dL \dm[S+]   [PATTERN] 列出物化视图。
如果指定了PATTERN，只列出名称匹配PATTERN的物化视图。
列出物化视图。
openGauss=#  \dm \dn[S+]   [PATTERN] 列出所有的模式（名称空间）。
如果声明了PATTERN，只列出名称匹配PATTERN的模式名。缺省时，只列出用户创建的模式。
列出所有名称以d开头的模式以及相关信息。
openGauss=#  \dn+ d* \do[S]     [PATTERN] 列出所有可用的操作符以及它们的操作数和返回的数据类型。
如果声明了PATTERN，只列出名称匹配PATTERN的操作符。缺省时，只列出用户创建的操作符。
列出所有可用的操作符以及它们的操作数和返回的数据类型。
openGauss=# \do \dO[S+]  [PATTERN] 列出排序规则。
如果声明了PATTERN，只列出名称匹配PATTERN的规则。缺省时，只列出用户创建的规则。
列出排序规则。
openGauss=# \dO \dp [PATTERN] 列出一列可用的表、视图以及相关的权限信息。
\dp显示结果如下： rolename=xxxx/yyyy  --赋予一个角色的权限 =xxxx/yyyy  --赋予public的权限 xxxx表示赋予的权限，yyyy表示授予这个权限的角色。权限的参数说明请参见表 权限的参数说明。
如果指定了PATTERN，只列出名称匹配PATTERN的表、视图。
列出一列可用的表、视图以及相关的权限信息。
openGauss=# \dp \drds [PATTERN1 [PATTERN2]] 列出所有修改过的配置参数。这些设置可以是针对角色的、针对数据库的或者同时针对两者的。PATTERN1和PATTERN2表示要列出的角色PATTERN和数据库PATTERN。
如果声明了PATTERN，只列出名称匹配PATTERN的规则。缺省或指定*时，则会列出所有设置。
列出postgres数据库所有修改过的配置参数。
openGauss=# \drds * postgres \dT[S+]  [PATTERN] 列出所有的数据类型。
如果指定了PATTERN，只列出名称匹配PATTERN的类型。
列出所有的数据类型。
openGauss=# \dT \du[+] [PATTERN] 列出所有数据库角色。
如果指定了PATTERN，则只列出名称匹配PATTERN的角色。
列出所有数据库角色。
openGauss=# \du \dE[S+]   [PATTERN] \di[S+]    [PATTERN] \ds[S+]   [PATTERN] \dt[S+]    [PATTERN] \dv[S+]   [PATTERN] 这一组命令，字母E、i、s、t和v分别代表着外部表、索引、序列、表和视图。可以以任意顺序指定其中一个或者它们的组合来列出这些对象。例如：\dit列出所有的索引和表。在命令名称后面追加+，则每一个对象的物理尺寸以及相关的描述也会被列出。
如果指定了PATTERN，只列出名称匹配该PATTERN的对象。默认情况下只会显示用户创建的对象。通过PATTERN或者S修饰符可以把系统对象包括在内。
列出所有的索引和视图。
openGauss=# \div \dx[+]      [PATTERN] 列出安装数据库的扩展信息。
如果指定了PATTERN，则只列出名称匹配PATTERN的扩展信息。
列出安装数据库的扩展信息。
openGauss=# \dx \l[+] 列出服务器上所有数据库的名称、所有者、字符集编码以及使用权限。
列出服务器上所有数据库的名称、所有者、字符集编码以及使用权限。
openGauss=#  \l \sf[+]   FUNCNAME 显示函数的定义。
假设存在函数function_a和函数名带圆括号的函数func()name，列出函数的定义。
openGauss=# \sf function_a openGauss=# \sf "func()name"(argtype1, argtype2) \z      [PATTERN] 列出数据库中所有表、视图和序列以及它们相关的访问特权。
如果给出任何pattern ，则被当成一个正则表达式，只显示匹配的表、视图、序列。
列出数据库中所有表、视图和序列以及它们相关的访问特权。
openGauss=# \z

**表 15**  权限的参数说明

参数说明 SELECT：允许对指定的表、视图读取数据。
UPDATE：允许对指定表更新字段。
INSERT：允许对指定表插入数据。
DELETE：允许删除指定表中的数据。
TRUNCATE：允许清理指定表中的数据。
REFERENCES：允许创建外键约束。由于当前不支持外键，所以该参数暂不生效。
TRIGGER：允许在指定表上创建触发器。
EXECUTE：允许使用指定的函数以及利用这些函数实现的操作符。
USAGE： 对于过程语言，允许用户在创建函数时，指定过程语言。对于模式，允许访问包含在指定模式中的对象。对于序列，允许使用nextval函数。
CREATE： 对于数据库，允许在该数据库里创建新的模式。对于模式，允许在该模式中创建新的对象。对于表空间，允许在其中创建表以及允许创建数据库和模式的时候把该表空间指定为其缺省表空间。
CONNECT：允许用户连接到指定的数据库。
TEMPORARY：允许创建临时表。
ALTER：允许用户修改指定对象的属性。
DROP：允许用户删除指定的对象。
COMMENT：允许用户定义或修改指定对象的注释。
INDEX：允许用户在指定表上创建索引。
VACUUM：允许用户对指定的表执行ANALYZE和VACUUM操作。
给前面权限的授权选项。

**表 16**  格式化元命令

参数说明 对齐模式和非对齐模式之间的切换。
\C   [STRING] 把正在打印的表的标题设置为一个查询的结果或者取消这样的设置。
\f     [STRING] 对于不对齐的查询输出，显示或者设置域分隔符。
若当前模式为文本格式，则切换为HTML输出格式。若当前模式为HTML格式，则切换回文本格式。
\pset NAME  [VALUE] 设置影响查询结果表输出的选项。NAME的取值见表 可调节的打印选项。
\t    [on|off] 切换输出的字段名的信息和行计数脚注。
\T   [STRING] 指定在使用HTML输出格式时放在table标签里的属性。如果参数为空，不设置。
\x   [on|off|auto] 切换扩展行格式。

**表 17**  可调节的打印选项

选项说明 取值范围 border value必须是一个数字。通常这个数字越大，表的边界就越宽线就越多，但是这个取决于特定的格式。
在HTML格式下，取值范围为大于0的整数。在其他格式下，取值范围：0：无边框1：内部分隔线2：台架 expanded (或x) 在正常和扩展格式之间切换。
当打开扩展格式时，查询结果用两列显示，字段名称在左、数据在右。这个模式在数据无法放进通常的“水平”模式的屏幕时很有用。在正常格式下，当查询输出的格式比屏幕宽时，用扩展格式。正常格式只对aligned和wrapped格式有用。
fieldsep 声明域分隔符来实现非对齐输出。这样就可以创建其他程序希望的制表符或逗号分隔的输出。要设置制表符域分隔符，键入\pset fieldsep '\t'。缺省域分隔符是 '|' (竖条符)。
fieldsep_zero 声明域分隔符来实现非对齐输出到零字节。
footer 用来切换脚注。
format 设置输出格式。允许使用唯一缩写（这意味着一个字母就够了）。
取值范围： unaligned：写一行的所有列在一条直线上中，当前活动字段分隔符分隔。aligned：此格式是标准的，可读性最好的文本输出。wrapped：类似aligned，但是包装跨行的宽数据值，使其适应目标字段的宽度输出。html：把表输出为可用于文档里的对应标记语言。输出不是完整的文档。latex：把表输出为可用于文档里的对应标记语言。输出不是完整的文档。troff-ms：把表输出为可用于文档里的对应标记语言。输出不是完整的文档。
null 打印一个字符串，用来代替一个null值。
缺省是什么都不打印，这样很容易和空字符串混淆。
numericlocale 切换分隔小数点左边的数值的区域相关的分组符号。
on：显示指定的分隔符。off：不显示分隔符。
忽略此参数，显示默认的分隔符。
pager 控制查询和gsql帮助输出的分页器。如果设置了环境变量PAGER，输出将被指向到指定程序，否则使用系统缺省。
on：当输出到终端且不适合屏幕显示时，使用分页器。off：不使用分页器。always：当输出到终端无论是否符合屏幕显示时，都使用分页器。
recordsep 声明在非对齐输出格式时的记录分隔符。
recordsep_zero 声明在非对齐输出到零字节时的记录分隔符。
tableattr（或T） 声明放在html输出格式中HTML table标签的属性（例如：cellpadding或bgcolor）。注意：这里可能不需要声明border，因为已经在\pset border里用过了。如果没有给出value，则不设置表的属性。
title
为随后打印的表设置标题。这个可以用于给输出一个描述性标签。如果没有给出value，不设置标题。
tuples_only （或者t） 在完全显示和只显示实际的表数据之间切换。完全显示将输出像列头、标题、各种脚注等信息。在tuples_only模式下，只显示实际的表数据。
feedback 切换是否输出结果行数。

**表 18**  连接元命令

参数说明 取值范围 \c[onnect]    [DBNAME|- USER|- HOST|- PORT|-] 连接到一个新的数据库（当前数据库为postgres）。当数据库名称长度超过63个字节时，默认前63个字节有效，连接到前63个字节对应的数据库，但是gsql的命令提示符中显示的数据库对象名仍为截断前的名称。
\encoding [ENCODING] 设置客户端字符编码格式。
不带参数时，显示当前的编码格式。
\conninfo 输出当前连接的数据库的信息。

**表 19**  操作系统元命令

参数说明 取值范围 \cd       [DIR] 切换当前的工作目录。
绝对路径或相对路径，且满足操作系统路径命名规则。
\setenv NAME    [VALUE] 设置环境变量NAME为VALUE，如果没有给出VALUE值，则不设置环境变量。
\timing   [on|off] 以毫秒为单位显示每条SQL语句的执行时间（不包括屏显打印时间）。
on表示打开显示。off表示关闭显示。
\!      [COMMAND] 返回到一个单独的Unix shell或者执行Unix命令COMMAND。

**表 20**  变量元命令

参数说明 \prompt     [TEXT] NAME 提示用户用文本格式来指定变量名称。
\set     [NAME [VALUE]] 设置内部变量NAME为VALUE或者如果给出了多于一个值，设置为所有这些值的连接结果。如果没有给出第二个参数，只设变量不设值。
有一些常用变量被gsql特殊对待，它们是一些选项设置，通常所有特殊对待的变量都是由大写字母组成(可能还有数字和下划线)。  表21是一个所有特殊对待的变量列表。
\unset NAME 不设置（或删除）gsql变量名。
\gset 将查询结果存储到变量中。查询语句末尾无分号，直接接\gset。

1. 无前缀

	```sql
	select 'hello' as var1, 10 as var2 \gset
	\echo :var1 :var2
	hello 10
	```
2. 有前缀

	```sql
	select 'hello' as var1, 10 as var2 \gset result_
	\echo :result_var1 :result_var2
	hello 10
	```
3. 查询结果必须有列名，且必须是合法列名，否则会赋值失败

	```sql
	select 1 as b \gset ;
	attempt to \gset set variable ";b" to 1 failed.
    select 1 \gset
    attempt to \gset set variable "?column?" to 1 failed.
	```
4. 不可给特殊控制变量赋值

	```sql
 	-- 由于opengauss会自动转小写，这个报错一般不会被触发，除非加上单引号
 	select '%o' as 'PROMPT1' \gset
 	attempt to \gset into specially treated variable "PROMPT1" ignored.
 	select '%o' as PROMPT1 \gset
 	\echo :PROMPT1
 	%o%R%#
 	\echo :prompt1
 	%o
	```
5. 不能在并行模式下使用\gset

    ```sql
    \parallel on
    Parallel is on with scale default 1024.
    select 1 as a \gset
    Sending the query buffer by a meta-command is not supported in parallel mode.
    ```
特殊控制变量列表： AUTOCOMMITON_ERROR_STOPQUIETSINGLELINESINGLESTEPFETCH_COUNTECHOECHO_HIDDENON_ERROR_ROLLBACKHISTCONTROLPROMPT1PROMPT2PROMPT3VERBOSITYRETRY

**表 21**  \\set常用命令

命令说明 取值范围 \set VERBOSITY value 这个选项可以设置为值default， verbose，terse之一以控制错误报告的冗余行。
value取值范围：default， verbose，terse \set ON_ERROR_STOP value 如果设置了这个变量，脚本处理将马上停止。如果该脚本是从另外一个脚本调用的，那个脚本也会按同样的方式停止。如果最外层的脚本不是从一次交互的gsql会话中调用的而是用-f选项调用的，gsql将返回错误代码3，以示这个情况与致命错误条件的区别（错误代码为1）。
value取值范围为：on/off，true/false，yes/no，1/0 \set RETRY [retry_times] 用于控制是否开启语句出错场景下的重试功能，参数retry_times用来指定最大重试次数，缺省值为5，取值范围为5-10。当重试功能已经开启时，再次执行\set RETRY可以关闭该功能。
使用配置文件retry_errcodes.conf列举需要重试的错误码列表，该文件和gsql可执行程序位于同一级目录下。该配置文件为系统配置，非用户定义，不允许用户直接修改。
当前支持以下出错场景的重试： YY001：TCP通信错误，Connection reset by peerYY002：TCP通信错误，Connection reset by peerYY003：锁超时，Lock wait timeout.../wait transaction xxx sync time exceed xxxYY004：TCP通信错误，Connection timed outYY005：SET命令发送失败，ERROR SET queryYY006：内存申请失败，memory is temporarily unavailableYY007：通信库错误，Memory allocate errorYY008：通信库错误，No data in bufferYY009：通信库错误，Close because release memoryYY010：通信库错误，TCP disconnectYY011：通信库错误，SCTP disconnectYY012：通信库错误，Stream closed by remoteYY013：通信库错误，Wait poll unknown errorYY014,YY015,53200,08006,08000,57P01,XX003,XX009等 同时，出错时gsql会查询数据库节点的连接状态，当状态异常时会sleep 1分钟再进行重试，能够覆盖大部分主备切换场景下的出错重试。
retry_times取值范围为：5-10

**表 22**  大对象元命令

参数说明 \lo_list 显示一个目前存储在该数据库里的所有openGauss大对象和提供给他们的注释。
\lo_import [FILEPATH] 导入一个大对象openGauss 显示一个目前存储在该数据库里的所有openGauss大对象和提供给他们的注释。
\lo_export oid filePath 导出一个大对象openGauss 显示一个目前存储在该数据库里的所有openGauss大对象和提供给他们的注释。

#### **PATTERN**

很多\\d命令都可以用一个PATTERN参数来指定要被显示的对象名称。在最简单的情况下，PATTERN正好就是该对象的准确名称。在PATTERN中的字符通常会被变成小写形式（就像在SQL名称中那样），例如\\dt FOO将会显示名为foo的表。就像在SQL名称中那样，把PATTERN放在双引号中可以阻止它被转换成小写形式。如果需要在一个PATTERN中包括一个真正的双引号字符，则需要把它写成两个相邻的双引号，这同样是符合SQL引用标识符的规则。例如，\\dt "FOO""BAR"将显示名为FOO"BAR（不是foo"bar）的表。和普通的SQL名称规则不同，不能只在PATTERN的一部分周围放上双引号，例如\\dt FOO"FOO"BAR将会显示名为fooFOObar的表。

不使用PATTERN参数时，\\d命令会显示当前schema搜索路径中可见的全部对象——这等价于用\*作为PATTERN。所谓对象可见是指可以直接用名称引用该对象，而不需要用schema来进行限定。要查看数据库中所有的对象而不管它们的可见性，可以把\*.\*用作PATTERN。

如果放在一个PATTERN中，\*将匹配任意字符序列（包括空序列），而?会匹配任意的单个字符（这种记号方法就像 Unix shell 的文件名PATTERN一样）。例如，\\dt int\*会显示名称以int开始的表。但是如果被放在双引号内，\*和?就会失去这些特殊含义而变成普通的字符。

包含一个点号（.）的PATTERN被解释为一个schema名称模式后面跟上一个对象名称模式。例如，\\dt foo\*.\*bar\*会显示名称以foo开始的schema中所有名称包括bar的表。如果没有出现点号，那么模式将只匹配当前schema搜索路径中可见的对象。同样，双引号内的点号会失去其特殊含义并且变成普通的字符。

高级用户可以使用字符类等正则表达式记法，如\[0-9\]可以匹配任意数字。所有的正则表达式特殊字符都按照POSIX正则表达式所说的工作。以下字符除外：

- .会按照上面所说的作为一种分隔符。
- \*会被翻译成正则表达式记号.\*。
- ?会被翻译成.。
- $则按字面意思匹配。

根据需要，可以通过书写?、\(_R_+|\)、\(_R_|\)和_R_?来分别模拟PATTERN字符.、_R_\*和_R_?。$不需要作为一个正则表达式字符，因为PATTERN必须匹配整个名称，而不是像正则表达式的常规用法那样解释（换句话说，$会被自动地追加到PATTERN上）。如果不希望该PATTERN的匹配位置被固定，可以在开头或者结尾写上\*。注意在双引号内，所有的正则表达式特殊字符会失去其特殊含义并且按照其字面意思进行匹配。另外，在操作符名称PATTERN中（即\\do的PATTERN参数），正则表达式特殊字符也按照字面意思进行匹配。

#### DELIMITER

更改SQL语句之间分隔符命令，分隔符默认值为“;”。

DELIMITER命令为为客户端设置一个分隔符。当用户设置分隔符后，gsql客户端识别到分隔符时，会立即将SQL语句发送到服务端执行，但是服务端仍然将“;”看做SQL语句分隔符，并相应的处理SQL语句。

注意事项：

- delimiter符号目前不是自由设定的，结束符范围有限制，目前接受大小写字母组合或特殊字符组合（\~/!/@/\#/^/&/\`/?/+/-/\*//（除号）/%//=），其中常见的用法是"//"。
- 符号组合中尽量使用无歧义符号组合，特殊符号组合（注释符："\\\*"、"--"等）目前不支持用于delimiter命名。
- delimiter长度范围：0\~15。
- 设置的结束符的级别是会话级别的，当切换数据库时delimiter\_name会设置为默认值‘;’。
- 用户如果想使用其他字符组合例如"adbc  $$"，可以使用引号包含，例如delimiter "adbc  $$"，但使用时也需要使用引号包含，例如：select 1"adbc  $$"。
- delimiter分隔符只有sql\_compatibility = 'B'时支持。

### 常见问题处理

**连接性能问题**

- 开启了log\_hostname，但是配置了错误的DNS导致的连接性能问题。

在连接上数据库，通过“show log\_hostname”语句，检查数据库中是否开启了log\_hostname参数。

如果开启了相关参数，那么数据库内核会通过DNS反查客户端所在机器的主机名。这时如果数据库主节点配置了不正确的/不可达的DNS服务器，那么会导致数据库建立连接过程较慢。此参数的更多信息，详见《数据库参考》中“GUC参数说明 \> 错误报告和日志 \> 记录日志的内容”章节中关于“log\_hostname”的描述。

- 数据库内核执行初始化语句较慢导致的性能问题。

此种情况定位较难，可以尝试使用Linux的跟踪命令：strace。

    ```
    strace gsql -U MyUserName -W xxxxxx -d postgres -h 127.0.0.1 -p 23508 -r -c '\q'
    ```

此时便会在屏幕上打印出数据库的连接过程。比如较长时间停留在下面的操作上：

    ```
    sendto(3, "Q\0\0\0\25SELECT VERSION()\0", 22, MSG_NOSIGNAL, NULL, 0) = 22
    poll([{fd=3, events=POLLIN|POLLERR}], 1, -1) = 1 ([{fd=3, revents=POLLIN}])
    ```

此时便可以确定是数据库执行“SELECT VERSION\(\)”语句较慢。

在连接上数据库后，便可以通过执行“explain performance select version\(\)”语句来确定初始化语句执行较慢的原因。更多信息，详见《性能调优指南》中“SQL调优指南 \> SQL执行计划介绍”章节。

另外还有一种场景不太常见：由于数据库主节点所在机器的磁盘满或故障，此时所查询等受影响，无法进行用户认证，导致连接过程挂起，表现为假死。解决此问题清理数据库主节点的数据盘空间便可。

- TCP连接创建较慢问题。

此问题可以参考上面的初始化语句较慢排查的做法，通过strace跟踪，如果长时间停留在：

    ```
    connect(3, {sa_family=AF_FILE, path="/home/test/tmp/gaussdb_llt1/.s.PGSQL.61052"}, 110) = 0
    ```

或者

    ```
    connect(3, {sa_family=AF_INET, sin_port=htons(61052), sin_addr=inet_addr("127.0.0.1")}, 16) = -1 EINPROGRESS (Operation now in progress)
    ```

那么说明客户端与数据库端建立物理连接过慢，此时应当检查网络是否存在不稳定、网络吞吐量太大的问题。

**创建连接故障**

- gsql: could not connect to server: No route to host

此问题一般是指定了不可达的地址或者端口导致的。请检查-h参数与-p参数是否添加正确。

- gsql: FATAL:  Invalid username/password,login denied.

此问题一般是输入了错误的用户名和密码导致的，请联系数据库管理员，确认用户名和密码的正确性。

- gsql: FATAL:  Forbid remote connection with trust method!

数据库由于安全问题，禁止远程登录时使用trust模式。这时需要修改pg\_hba.conf里的连接认证信息。具体的设置信息请参见[配置文件参考](../database_administration_guide/configuration_file_reference.md)章节。

>[!NOTE]说明
>
>请不要修改pg\_hba.conf中openGauss主机的相关设置，否则可能导致数据库功能故障。建议业务应用部署在openGauss之外，而非openGauss内部。

- 连接数据库，添加“-h 127.0.0.1”可以连接，去掉后无法连接问题。

通过执行SQL语句“show unix\_socket\_directory”检查数据库主节点使用的Unix套接字目录，是否与shell中的环境变量$PGHOST一致。

如果检查结果不一致，那么修改PGHOST环境变量到GUC参数unix\_socket\_directory指向的目录便可。

关于unix\_socket\_directory的更多信息，详见《数据库参考》中“GUC参数说明 \> 连接和认证 \> 连接设置”章节中的说明。

- The "libpq.so" loaded mismatch the version of gsql, please check it.

此问题是由于环境中使用的libpq.so的版本与gsql的版本不匹配导致的，请通过“ldd gsql”命令确认当前加载的libpq.so的版本，并通过修改LD\_LIBRARY\_PATH环境变量来加载正确的libpq.so。

- gsql: symbol lookup error: xxx/gsql: undefined symbol: libpqVersionString

此问题是由于环境中使用的libpq.so的版本与gsql的版本不匹配导致的（也有可能是环境中存在PostgreSQL的libpq.so），请通过“ldd gsql”命令确认当前加载的libpq.so的版本，并通过修改LD\_LIBRARY\_PATH环境变量来加载正确的libpq.so。

- gsql: connect to server failed: Connection timed out

Is the server running on host "xx.xxx.xxx.xxx" and accepting TCP/IP connections on port xxxx?

此问题是由于网络连接故障造成。请检查客户端与数据库服务器间的网络连接。如果发现从客户端无法PING到数据库服务器端，则说明网络连接出现故障。请联系网络管理人员排查解决。

    ```
    ping -c 4 10.10.10.1
    PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
    From 10.10.10.1: icmp_seq=2 Destination Host Unreachable
    From 10.10.10.1 icmp_seq=2 Destination Host Unreachable
    From 10.10.10.1 icmp_seq=3 Destination Host Unreachable
    From 10.10.10.1 icmp_seq=4 Destination Host Unreachable
    --- 10.10.10.1 ping statistics ---
    4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 2999ms
    ```

- gsql: FATAL:  permission denied for database "postgres"

DETAIL:  User does not have CONNECT privilege.

此问题是由于用户不具备访问该数据库的权限，可以使用如下方法解决。

  1. 使用管理员用户dbadmin连接数据库。

        ```
        gsql -d postgres -U dbadmin -p 15400
        ```

  2. 赋予该用户访问数据库的权限。

GRANT CONNECT ON DATABASE postgres TO user1;

>[!NOTE]说明
>实际上，常见的许多错误操作也可能产生用户无法连接上数据库的现象。如用户连接的数据库不存在，用户名或密码输入错误等。这些错误操作在客户端工具也有相应的提示信息。
>
>```
>gsql -d postgres -p 15400
>gsql: FATAL:  database "postgres" does not exist
>gsql -d postgres -U user1 -W gauss@789 -p 15400
>gsql: FATAL:  Invalid username/password,login denied.
>```

- gsql: FATAL:  sorry, too many clients already，active/non-active: 2/10/3.

此问题是由于系统连接数量超过了最大连接数量。请联系数据库DBA进行会话连接数管理，释放无用会话。

关于查看用户会话连接数的方法如[表23 查看会话连接数](#zh-cn_topic_0237152147_zh-cn_topic_0059779356_t8e166846f0204638bd83f2fd35f44585)。

会话状态可以在视图PG\_STAT\_ACTIVITY中查看。无用会话可以使用函数pg\_terminate\_backend进行释放。

    ```
    select datid,pid,state from pg_stat_activity;
    ```

    ```
     datid |       pid       | state
    -------+-----------------+--------
     13205 | 139834762094352 | active
     13205 | 139834759993104 | idle
    (2 rows)
    ```

其中pid的值即为该会话的线程ID。根据线程ID结束会话。

    ```
    SELECT PG_TERMINATE_BACKEND(139834759993104);
    ```

显示类似如下信息，表示结束会话成功。

    ```
    PG_TERMINATE_BACKEND
    ----------------------
     t
    (1 row)
    ```

**表 23**  查看会话连接数

查看指定用户的会话连接数上限。
执行如下命令查看连接到指定用户USER1的会话连接数上限。其中-1表示没有对用户user1设置连接数的限制。
SELECT ROLNAME,ROLCONNLIMIT FROM PG_ROLES WHERE ROLNAME='user1';
rolname | rolconnlimit
---------+--------------
user1    |           -1 (1 row) 查看指定数据库的会话连接数上限。
执行如下命令查看连接到指定数据库postgres的会话连接数上限。其中-1表示没有对数据库postgres设置连接数的限制。
SELECT DATNAME,DATCONNLIMIT FROM PG_DATABASE WHERE DATNAME='postgres';
datname  | datconnlimit
----------+--------------
postgres |           -1 (1 row) 查看指定数据库已使用的会话连接数。
执行如下命令查看指定数据库postgres上已使用的会话连接数。其中，1表示数据库postgres上已使用的会话连接数。
SELECT COUNT(*) FROM PG_STAT_ACTIVITY WHERE DATNAME='postgres';
count \--------- 1 (1 row)

- gsql: wait xxx.xxx.xxx.xxx:xxxx timeout expired

gsql在向数据库发起连接的时候，会有5分钟超时机制，如果在这个超时时间内，数据库未能正常的对客户端请求进行校验和身份认证，那么gsql会退出当前会话的连接过程，并报出如上错误。

一般来说，此问题是由于连接时使用的-h参数及-p参数指定的连接主机及端口有误（即错误信息中的xxx部分），导致通信故障；极少数情况是网络故障导致。要排除此问题，请检查数据库的主机名及端口是否正确。

- gsql: could not receive data from server: Connection reset by peer.

同时，检查数据库主节点日志中出现类似如下日志“ FATAL: cipher file "/data/dbnode/server.key.cipher" has group or world access”，一般是由于数据目录或部分关键文件的权限被误操作篡改导致。请参照其他正常实例下的相关文件权限，修改回来便可。

- gsql: FATAL:  GSS authentication method is not allowed because XXXX user password is not disabled.

目标数据库主节点的pg\_hba.conf里配置了当前客户端IP使用“gss”方式来做认证，该认证算法不支持用作客户端的身份认证，请修改到"sha256"后再试。配置方法见《数据库管理指南》中“管理数据库安全 \> 客户端接入认证 \> 配置文件参考”章节 。

>[!NOTE]说明
>
>- 请不要修改pg\_hba.conf中openGauss主机的相关设置，否则可能导致数据库功能故障。
>- 建议业务应用部署在openGauss之外，而非openGauss内部。

**其他故障**

- 出现因“总线错误”（Bus error）导致的core dump或异常退出

一般情况下出现此种问题，是进程运行过程中加载的共享动态库（在Linux为.so文件）出现变化；或者进程二进制文件本身出现变化，导致操作系统加载机器的执行码或者加载依赖库的入口发生变化，操作系统出于保护目的将进程杀死，产生core dump文件。

解决此问题，重试便可。同时请尽可能避免在升级等运维操作过程中，在openGauss内部运行业务程序，避免升级时因替换文件产生此问题。

>[!NOTE]说明
>
>此故障的core dump文件的可能堆栈是dl\_main及其子调用，它是操作系统用来初始化进程做共享动态库加载的。如果进程已经初始化，但是共享动态库还未加载完成，严格意义上来说，进程并未完全启动。
