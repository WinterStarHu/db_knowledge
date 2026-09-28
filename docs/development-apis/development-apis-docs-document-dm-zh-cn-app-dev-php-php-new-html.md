# PHP 数据库接口 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/php_php_new.html

PHP 数据库接口 | 达梦技术文档

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

案例 问答 一体机 专栏

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

PHP 数据库接口

一、前言

1.1 概述

PHP 是一种服务器端的 HTML 脚本/编程语言，是一种简单的、面向对象的、解释型的、健壮的、安全的、性能非常之高的、独立于架构的、可移植的、动态的脚本语言。是一种广泛用于 Open Source（开放源代码）尤其适合 Web 开发并可以嵌入 HTML 的多用途脚本语言。它的语法接近 C，Java 和 Perl，而且容易学习。该语言让 Web 开发人员可以快速地书写动态生成的网页。

1.2 PHP 版本介绍

1.2.1 TS 版和 NTS 版

在 PHP 开发和生产环境搭建过程中，需要安装 PHP 语言解析器。官方提供了两种类型的版本，线程安全版（TS）和非线程安全版（NTS），有时候我们开发环境和实际生产的环境有所不同，因此也需要选择安装对应的 PHP 版本。

TS (Thread-Safety）即线程安全，多线程访问时，采用加锁机制，当一个线程访问该类的某个数据时进行数据加锁保护，其他线程不能同时进行访问该数据，直到该线程读取完毕，其他线程才可访问使用该数据。

优点：不会出现数据不一致或者数据污染的情况；

缺点：但耗费的时间要比 NTS 长。

NTS (None-Thread Safe）即非线程安全，不提供数据访问保护。

优点：一般操作的执行时间要比 TS 短；

缺点：可能出现多个线程先后或同时操作同一数据的情况，容易造成数据错乱（即脏数据）。

1.2.2 PHP 版本选择

以 ISAPI 方式运行就用 TS 线程安全版；以 FAST-CGI 或 PHP-FPM 方式运行就用 NTS 非线程安全版。

通常 Windows 下 Apache + PHP 选 TS ，IIS（fast-cgi）+ PHP 选 NTS 。

通常 Linux 下 Apache + PHP 选 TS，Nginx + PHP 选 NTS 。

1.2.3 PHP 版本检查

查看 PHP 版本。

[root@localhostphp7]# php -v PHP 7.4.33 (cli) (built: Nov  4 2022 11:47:15) ( ZTS ) Copyright (c) The PHP Group Zend Engine v3.4.0, Copyright (c) Zend Technologies

查看 PHP 是 NTS 版还是 TS 版，通过 phpinfo() 配置信息中的 Thread Safety 项，这个项目就是查看是否是线程安全，如果显示结果是 enabled，一般来说应该是 TS 版，否则是 NTS 版。

[root@localhostphp_pdo]# cat phpinfo.php <?php phpinfo();
?> [root@localhost htdocs]# php test.php | grep Thread Thread Safety => enabled Thread API => POSIX Threads

接口版本查询，进入到驱动所在的目录后通过以下命令进行查询，并根据上面查到的 PHP 版本获取对应连接数据库的驱动。

[root@localhostphp_pdo]# pwd /dm8/drivers/php_pdo [root@localhostphp_pdo]# strings libphp74ts_dm.so |grep API API20190902,TS [root@localhostphp_pdo]# strings libphp74_dm.so |grep API API20190902,NTS [root@localhostphp_pdo]# strings php74ts_pdo_dm.so |grep API API20190902,TS [root@localhostphp_pdo]# strings php74_pdo_dm.so |grep API API20190902,NTS [root@localhostphp_pdo]#

查询 PHP 扩展。

[root@localhostphp_pdo]# php -m [PHP Modules] Core ctype date DM dom ...................

二、 Linux 环境下 php 连接达梦数据库

2.1 开发环境准备

名称 版本

DM 数据库 DM 8.0 及以上版本

PHP PHP 7.4 及以上版本

由于应用需要通过对应的数据库驱动来连接数据库对数据库的数据进行操作，达梦数据库的驱动主要存放在数据库安装服务器的数据库软件目录下，例如：

数据库软件安装的 home 目录为：/dm8，则数据库存放对的 PHP 驱动目录为：/dm8/drivers/php_pdo 。

同时由于 PHP 版本不同，我们需要使用不同版本的驱动，例如本次示例中使用的 PHP TS 版本为 7.4，那么就需要用到 libphp74ts_dm.so 和 php74ts_pdo_dm.so 的驱动，同理如果 PHP TS 版本为 8.1 就需要从 DM 数据库的对应驱动目录下找到 libphp81ts_dm.so 和 php81ts_pdo_dm.so 的驱动。如果使用的是 PHP 的 NTS 版本则需要使用对应的 libphp74_dm.so 和 php74_pdo_dm.so，根据开发需求将对应驱动后拷贝到 PHP 所在应用服务器对应的目录即可。

2.1.1 达梦数据库安装

可访问达梦云适配中心下载试用，下载 DM8 数据库试用版并安装，安装步骤请参考数据库环境准备。

2.1.2 安装 PHP 开发工具包

准备安装包，下载链接：https://www.php.net/distributions/php-7.4.33.tar.gz 。

安装依赖包。

yum -y install libxml2 yum -y install libxml2-devel

找到 apxs2 位置，建议使用 Apache 自带的 apxs 进行解析。

locate apxs

解压安装包进行安装，安装步骤简单，点击【下一步】安装即可。具体安装步骤如下：

./configure --prefix=/usr/local/php/  --with-config-file-path=/usr/local/php --enable-maintainer-zts --with-apxs2=/usr/local/Apache2/bin/apxs make && make install ln -s /usr/local/php/bin/php /usr/bin/php cp php.ini-production /usr/local/php/php.ini./configure --prefix=/usr/local/php/  --with-config-file-path=/usr/local/php make && make install ln -s /usr/local/php/bin/php /usr/bin/php cp php.ini-production /usr/local/php/php.ini

查看版本。

php -v

注意

本次安装因为要使用 Apache，而 Apache 需要线程安全版 php，因此通过配置参数来指定： --enable-maintainer-zts，指定安装安全版，--with-apxs2 指定 apxs 所在路径用于解析 php。若使用 Apache 运行 PHP，需要先安装 Apache 。

2.2 数据库连接

PHP 配置 DM 驱动，在 /usr/local/php/php.ini 中增加以下内容：

[PHP_DM] extension_dir ="/opt/dmdbms/drivers/php_pdo" extension=libphp74_dm.so extension=php74_pdo_dm.so [dm] dm.port=5236 ; ; 是否允许持久性连接 dm.allow_persistent = 1 ; ; 允许建立持久性连接的最大数. -1 为没有限制.
dm.max_persistent = -1 ; ; 允许建立连接的最大数(包括持久性连接). -1 为没有限制.
dm.max_links = -1 ; ; 默认的主机地址 dm.default_host = localhost ; ; 默认登录的数据库 dm.default_db = SYSTEM ; ; 默认的连接用户名 dm.default_user = SYSDBA ; ; 默认的连接口令.
dm.default_pw = ***** ; ;连接超时，这个参数未实际的用到，等待服务器支持 dm.connect_timeout = 10 ; ;对于各种变长数据类型，每列最大读取的字节数。如果它设置为 0 或是小于 0,那么，读取变长字段时，将显示 NULL 值 dm.defaultlrl = 4096 ; ; 是否读取二进制类型数据，如果它设置为 0，那么二进制将被 NULL 值代替 dm.defaultbinmode = 1 ; ;是否允许检察持久性连接的有效性，如果设置为 ON，那么当重用一个持久性连接时，会检察该连接是否还有效 dm.check_persistent = ON

配置完成后将动态库文件进行复制：

cp /opt/dmdbms/drivers/php_pdo/php74* /usr/local/php7/lib cp /opt/dmdbms/drivers/php_pdo/libphp74* /usr/local/php7/lib

注意

PHP7.4 对应的是 php74_dm.so、libphp74ts_dm.so、php74_pdo_dm.so、php74ts_pdo_dm.so，PHP7.2 则对应的是 php72_dm.so 等，以此类推，请根据开发环境选择合适的 DM PHP 驱动包。

操作完成后通过 php -m 命令检查 PHP 扩展是否都安装成功，如图所示则代表成功。

2.3 使用 Apache 编译 PHP

2.3.1 安装 Apache

准备 httpd 软件包，下载地址：https://mirrors.aliyun.com/apache/httpd/ 。

安装依赖包，首先配置本地 yum 源（省略），yum 安装 apr、apr-util 、 pcre 、 expat 、openssl 。

yum -y install apr* apr-util* pcre* expat* openssl*

开始解压安装。

[root@localhost local]# tar -xvf httpd-2.4.52.tar.gz [root@localhost httpd-2.4.54]#pwd /usr/local/httpd-2.4.54 [root@localhost httpd-2.4.54]# ./configure --prefix=/usr/local/apache2 [root@localhost httpd-2.4.54]# make && make install

2.3.2 测试是否安装成功

编写示例。

[root@localhost httpd-2.4.54]# cd /usr/local/apache2/htdocs [root@localhost httpd-2.4.54]# cat test.php <?php phpinfo();
?>

配置 Apache 。

[root@localhost httpd-2.4.54]# cd /usr/local/apache2/conf/ [root@localhostconf]# vim httpd.conf
#修改地址为ip（未配置域名DNS）
ServerName 192.168.3.11:1000
#修改端口（默认为80）
Listen 1001
#加入如下代码,以支持Apache对PHP的解析
LoadModule php7_module modules/libphp7.so AddType application/x-httpd-php .php 找到如下代码，在index.html末尾加上index.php DirectoryIndex index.html

运行 Apache 。

[root@localhost httpd-2.4.52]# cd /usr/local/apache2/bin [root@localhostbin]# ./apachectl start

根据实际地址，使用浏览器登录地址查看 Apache 是否安装成功，本次用于测试虚拟机地址为 192.168.218.147 。

http://192.168.218.147:3001/test.php

2.4 开发示例

2.4.1 数据库连接

连接数据库示例代码：php_conn.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");

//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
print "php: Connected successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

运行示例截图，运行后终端输出如下图所示：

2.4.2 基础操作示例

基础增删改查示例代码：php_dml.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
print "php: Connected successfully"."\n";
//清空表，初始化测试环境 $result = dm_exec($link, 'delete from PRODUCTION.PRODUCT_CATEGORY') or die("Query failed : " . dm_error()."\n");
//插入数据 $result = dm_exec($link, "insert into PRODUCTION.PRODUCT_CATEGORY(NAME) values('语文'), ('数学'), ('英语'), ('体育')") or die("Query failed : " . dm_error()."\n");
print "php: insert success"."\n";

//删除数据 $result = dm_exec($link, "delete from PRODUCTION.PRODUCT_CATEGORY where name='数学'") or die("Query failed : " . dm_error()."\n");
print "php: delete success"."\n";

//更新数据 $result = dm_exec($link, 'update PRODUCTION.PRODUCT_CATEGORY set name = \'英语-新课标\' where name=\'英语\'') or die("Query failed : " . dm_error()."\n");
print "php: update success"."\n";

//查询数据 $result = dm_exec($link, "select * from PRODUCTION.PRODUCT_CATEGORY") or die("Query failed : " . dm_error()."\n");
print "\n";
while ($line = dm_fetch_array($result)) { print "\t\n";
foreach ($line as $col_value) { print "\t\t$col_value\n";
} print "\t\n";
} print "\n";

/*释放资源*/ dm_free_result($result);
print "php: select success"."\n";
/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

运行示例截图，运行后终端输出如下图所示：

2.4.3 绑定变量示例

绑定参数示例代码： php_bind.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");

//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
print "php: Connected successfully"."\n";

//清空表，初始化测试环境 $result = dm_exec($link, 'delete from PRODUCTION.PRODUCT_CATEGORY') or die("Query failed : " . dm_error()."\n");

//绑定参数方式插入数据 $a = '物理';
$stmt = dm_prepare($link, 'insert into PRODUCTION.PRODUCT_CATEGORY(name) values(?)');
$result = dm_execute($stmt, array($a)) or die("Query failed : " . dm_error()."\n"); ;
print "php: insert with bind successfully"."\n";

//查询数据 $result = dm_exec($link, "select * from PRODUCTION.PRODUCT_CATEGORY") or die("Query failed : " . dm_error()."\n");
print "\n";
while ($line = dm_fetch_array($result)) { print "\t\n";
foreach ($line as $col_value) { print "\t\t$col_value\n";
} print "\t\n";

} print "\n";
print "php: select successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

运行后终端输出如下图所示：

2.4.4 运行 php 文件操作示例

建表示例代码：php_create.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236","SYSDBA","*****") or die("Couldn't connect:".dm_error()."\n");

$result = dm_exec($link, 'create table "SYSDBA"."S1"("ID" INTEGER,"NAME" VARCHAR(50),"AGE" INTEGER);') or die("Query failed : " . dm_error()."\n");
print "php: create success"."\n";
dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

基础增删改查示例代码：php_dml.php 。

[root@localhost htdocs]# gedit php_dml.php <?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236","SYSDBA","*****") or die("Couldn't connect:".dm_error()."\n");
print "php: Connected successfully"."\n";
//插入数据 $result = dm_exec($link, "insert into SYSDBA.S1 VALUES(3,'杨',13),(4,'钱',15),(3,'宋',22)") or die("Query failed : " . dm_error()."\n");
print "php: insert success"."\n";
//更新数据 $result = dm_exec($link, 'update SYSDBA.S1 set name = \'杨\' where name=\'姚\'') or die("Query failed : " . dm_error()."\n");
print "php: update success"."\n";

//查询数据 $result = dm_exec($link, "select * from SYSDBA.S1") or die("Query failed : " . dm_error()."\n");
print "\n";
while ($line = dm_fetch_array($result)) { print "\t\n";
foreach ($line as $col_value) { print "\t\t$col_value\n";
} print "\t\n";

} print "\n";

/*释放资源*/ dm_free_result($result);
print "php: select success"."\n";
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

运行后终端输出如下图所示：

2.4.5 Trace 跟踪

在 /etc/dm_svc.conf 文件中配置打开 dpi trace 跟踪开关，设置 DPI_TRACE=(1)  如图所示：

设置生效后再执行 PHP 脚本时，就会在执行位置生成 trace 日志文件。

dpi_trace.log 记录的信息，内容如图（只截取部分）：

三、Windows 环境下 PHP 连接达梦数据库

3.1 php 环境准备

3.1.1 php 7.3 版本

php7.3 版本下载安装包为 php-7.3.9-Win32-VC15-x64.zip，下载地址为：https://windows.php.net/downloads/releases/archives/ 。

3.1.2 php 7.4 版本

若要选择安装 php7.4 版本安装包 php-7.4.30-Win32-vc15-x64.zip，下载地址为：https://windows.php.net/download/ 。

3.2 数据库连接

3.2.1 确定 DM 路径驱动

在达梦的安装包目录下找到 pdo73_dm.dll 和 php73_dm.dll（注意查看 phpinfo ，如果 Thread Safet 为 enabled，则选择该文件，否则选择 pdo73nts_dm.dll ）。

3.2.2 编译/修改 php.ini 文件

php 安装包解压以后，默认没有 php.ini 文件（将 php.ini-development 重命名为 php.ini 文件）。

在 php.ini 的 945 行左右添加如下内容：

将路径替换为自己对应驱动包的绝对路径。

extension="D:\dmdbms\drivers\php_pdo\pdo73_dm.dll" extension="D:\dmdbms\drivers\php_pdo\php73_dm.dll"

3.2.3 添加 PHP 环境变量

3.2.4 添加达梦的依赖库

打开 cmd 命令行，输入 php -m ，如果提示： “PHP Fatal error: Unable to start DM module in Unknown on line 0 错误”。

尝试将数据库安装目录 bin 下的以下 dll 文件拷贝至 C:\Windows\SysWOW64 和 C:\Windows\System32 (替换时会提示是否替换原有文件，这里选择“否”)。

dmdpi.dll dmcalc.dll dmelog.dll dmmem.dll dmos.dll dmcomm.dll dmcpr.dll dmcyt.dll dmstrt.dll dmclientlex.dll dmdta.dll dmcfg.dll dmdcr.dll dmmout.dll dmcvt.dll dmmsg.dll

注意

如果上述方法不成功，则尝试把数据库 bin 下面的所有的 dll 文件拷贝过去。

3.2.5 检查驱动

./php.exe -m

3.2.6 测试连接

编写 demo.php 文件。

<?php try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");

//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
print "php: Connected successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

将测试的 php 代码放到指定目录下，直接使用 php 连接。

./php.exe D:\phpstudy_pro\demo.php

3.3 使用 Apache 编译 PHP

进入 Apache 官网 下载适合版本的 Apache 和 VC_redist。

解压缩后添加环境变量，把 Apache 的 bin 目录加入环境变量 path 。

进入 conf 目录修改 httpd.conf 配置文件。

#根据 php 地址添加参数
LoadModule php7_module "C:/php/php/php-7.4.33-Win32-vc15-x86/php7apache2_4.dll" PHPIniDir  "C:/php/php/php-7.4.33-Win32-vc15-x86/php.ini" AddType application/x-httpd-php .php AddType application/x-httpd-php .html AddType application/pdf .pdf

在 htdocs 目录下添加测试代码。

phpinfo.php 代码如下：

进入 bin 目录下，点击 ApacheMonitor.exe 启动 Apache 。

网址处输入 http://localhost/phpinfo.php，进行查看。

3.4 开发示例

3.4.1 创建表

建表示例代码：php_win_create.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
$sql = 'create table "SYSDBA"."USER1" ( "ID" INTEGER identity(1, 1) not null, "USER_NAME" VARCHAR(20), "CREATE_AT" DATETIME(0), "UPDATE_AT" TIMESTAMP(0) DEFAULT sysdate, primary key("ID") )';
$result = dm_exec($link,$sql);
print "php: Create table successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

3.4.2 插入数据

插入数据示例代码：php_win_insert.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
$sql = "INSERT INTO SYSDBA.USER1 (USER_NAME, CREATE_AT, UPDATE_AT) VALUES ('ZHANS', '2020-07-17 10:06:00', TO_DATE('2028-11-01 15:20:10','YYYY-MM-DD HH24:MI:SS'));";
$result = dm_exec($link,$sql);
print "php: Insert table successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

3.4.3 查询数据

查询数据示例代码：php_win_select.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
$sql = "select * from SYSDBA.USER1 limit 10";
$result = dm_exec($link,$sql);

print " 查询结果:";
while ($line = dm_fetch_array($result)){ print_r($line);
echo ' ';
} $result = dm_exec($link,$sql);
print "php: select table successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

3.3.4 更新数据

更新数据示例代码：php_win_update.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
$sql = "update SYSDBA.USER1 set USER_NAME = '李四' where ID = 1";
$result = dm_exec($link,$sql);
print "php: update table successfully"."\n";
/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

3.4.5 删除数据

删除数据示例代码：php_win_delete.php 。

<?php header("Content-type:text/html;charset=utf-8"); //防止页面乱码 try { $link = dm_connect("localhost:5236", "SYSDBA", "*****") or die("Could not connect : " . dm_error()."\n");
//使用 dm_error 会显示 dm 的 php 接口返回的错误，执行成功，则继续往下执行。
$sql = "delete from SYSDBA.USER1 where id = 1";
$result = dm_exec($link,$sql);

print "php: delete table successfully"."\n";

/*断开连接*/ dm_close($link);
} catch(Exception $e) { $e->getMessage() . " ";
} ?>

3.4.6 设置默认模式

通常情况下，在 sql 语句中的表名前需要指定模式名，例如上面例子中的 test.users ，其中 test 就是模式名，users 是表名。

可以通过 SET SCHEMA 设置当前模式。设置后，执行 sql 语句时，就可以省略模式名。

语法格式：SET SCHEMA ;

四、常见问题

PHP 相关的常见问题请参考：

https://eco.dameng.com/document/dm/zh-cn/faq/faq-php.html 。

五、参考

Linux 环境下示例代码下载位于下方，名称为  PHP_Linux.zip 。

Windows 环境下示例代码下载位于下方，名称为 PHP_Window.zip 。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

PHP 数据库接口

一、前言
1.1 概述
1.2 PHP 版本介绍
1.2.1 TS 版和 NTS 版
1.2.2 PHP 版本选择
1.2.3 PHP 版本检查
二、 Linux 环境下 php 连接达梦数据库
2.1 开发环境准备
2.1.1 达梦数据库安装
2.1.2 安装 PHP 开发工具包
2.2 数据库连接
2.3 使用 Apache 编译 PHP
2.3.1 安装 Apache
2.3.2 测试是否安装成功
2.4 开发示例
2.4.1 数据库连接
2.4.2 基础操作示例
2.4.3 绑定变量示例
2.4.4 运行 php 文件操作示例
2.4.5 Trace 跟踪
三、Windows 环境下 PHP 连接达梦数据库
3.1 php 环境准备
3.1.1 php 7.3 版本
3.1.2 php 7.4 版本
3.2 数据库连接
3.2.1 确定 DM 路径驱动
3.2.2 编译/修改 php.ini 文件
3.2.3 添加 PHP 环境变量
3.2.4 添加达梦的依赖库
3.2.5 检查驱动
3.2.6 测试连接
3.3 使用 Apache 编译 PHP
3.4 开发示例
3.4.1 创建表
3.4.2 插入数据
3.4.3 查询数据
3.3.4 更新数据
3.4.5 删除数据
3.4.6 设置默认模式
四、常见问题 五、参考

微信扫码 分享文档

扫一扫 联系客服

关于我们

合作伙伴

招贤纳士

英文站

达梦官网

达梦技术

蜀天梦图

微信公众号

24小时热线

400 991 6599

商务咨询转 1 号线

技术咨询转 2 号线

技术支持

dmtech@dameng.com

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

鄂Copyright © 2026 达梦国产化应用创新实验室 鄂ICP备18017926号-1

快速上手运维指南应用开发指南SQL 开发指南常见问题产品手册

JAVA 语言

JAVA 开发环境准备 JDBC 接口 Hibernate 框架 iBatis 框架 Mybatis 框架 MyBatis-Plus 框架 Spring 框架 MyCat 框架 Sharding-JDBC 框架 Querydsl连接达梦

C/C++ 语言

ODBC 接口

QT 接口

QODBC 编译 QDM 编译

Pro*C 接口 DPI 接口 lua接口

.NET 语言

.Net Data Provider Dapper 框架

PHP 语言

WSL2-Ubuntun 下使用 PHP PHP 数据库接口

Python 语言

Python 数据库接口 Django 框架 SQLAlchemy 框架 Python 开发环境准备 Flask 框架

GO 语言

ODBC接口 GORM 框架 DM 接口

JavaScript 语言

Node.js 框架

简体中文

简体中文
