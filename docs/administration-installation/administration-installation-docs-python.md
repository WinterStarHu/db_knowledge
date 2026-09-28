# Python

Psycopg是一种用于执行SQL语句的PythonAPI，可以为PostgreSQL、openGauss数据库提供统一访问接口，应用程序可基于它进行数据操作。Psycopg2对libpq进行封装，部分代码使用C语言实现，既高效又安全。它具有客户端游标和服务器端游标、异步通信和通知、支持“COPY TO/COPY FROM”功能。支持多种类型Python开箱即用，适配PostgreSQL数据类型；通过灵活的对象适配系统，可以扩展和定制适配。Psycopg2兼容Unicode和Python 3。

openGauss数据库提供了对Psycopg2特性的支持，并且支持psycopg2通过SSL模式链接。

**表 1**  Psycopg支持平台

操作系统 EulerOS 2.5 x86_64位 EulerOS 2.8 ARM64位

## 加载驱动

- 在使用驱动之前，需要做如下操作：
  1. 从[openGauss官网](https://opengauss.org/zh/download/)上下载编译好的psycopg2压缩包。

>[!NOTE]说明
>openGauss官网上下载的psycopg2适配的版本为Python3.6，如果使用其他版本的Python, 需要自行编译psycopg2。需要修改一下编译时的setup.py版本号校验部分的代码，可通过如下命令实现：
>
>```
>sed -i "s/(pgmajor, pgminor, pgpatch)/(9, 2, 4)/g" setup.py
>```

  2. 解压版本对应的驱动包，将psycopg2拷贝到python安装目录的第三方包文件夹（即site-packages目录）下。
  3. 确保psycopg2目录权限至少为755，以免调用时提示文件由于权限问题无法访问。
  4. 对于非数据库用户，需要将解压后的lib目录，配置在LD\_LIBRARY\_PATH环境变量中。

- 在创建数据库连接之前，需要先加载如下数据库驱动程序：

    ```
    import  psycopg2
    ```

## 连接数据库

以下Python代码显示了如何连接到现有的数据库。 如果数据库不存在，那么它将自动创建，最后将返回一个数据库对象。

```
#!/usr/bin/python
import psycopg2
conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")
```

上述代码中，加粗字体请根据具体情况替换。在这里指定使用testdb作为数据库名称。

## 创建表

以下Python程序将用于在先前创建的数据库（testdb）中创建一个表：

```
#!/usr/bin/python

import psycopg2

conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")

cur = conn.cursor()
cur.execute('''CREATE TABLE COMPANY
       (ID INT PRIMARY KEY     NOT NULL,
       NAME           TEXT    NOT NULL,
       AGE            INT     NOT NULL,
       ADDRESS        CHAR(50),
       SALARY         REAL);''')

conn.commit()
conn.close()
```

当执行上述程序时，它将在数据库testdb中创建COMPANY表。

## 插入操作

以下Python程序显示了如何在上述示例中创建的COMPANY表中创建记录：

```
#!/usr/bin/python

import psycopg2

conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")

cur = conn.cursor()

cur.execute("INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) \
      VALUES (1, 'Paul', 32, 'California', 20000.00 )");

cur.execute("INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) \
      VALUES (2, 'Allen', 25, 'Texas', 15000.00 )");

cur.execute("INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) \
      VALUES (3, 'Teddy', 23, 'Norway', 20000.00 )");

cur.execute("INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) \
      VALUES (4, 'Mark', 25, 'Rich-Mond ', 65000.00 )");

conn.commit()
conn.close()
```

当执行上述程序时，它将在COMPANY表中创建/插入给定的记录。

## SELECT操作

以下Python程序显示了如何从上述示例中创建的COMPANY表中获取和显示记录：

```
#!/usr/bin/python

import psycopg2

conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")

cur = conn.cursor()

cur.execute("SELECT id, name, address, salary  from COMPANY")
rows = cur.fetchall()
for row in rows:
   print("ID = ", row[0])
   print("NAME = ", row[1])
   print("ADDRESS = ", row[2])
   print("SALARY = ", row[3])

conn.close()
```

执行上述程序时，会返回以下结果：

```
ID =,  1
NAME =,  Paul
ADDRESS =,  California
SALARY =,  20000.0

ID =,  2
NAME =,  Allen
ADDRESS =,  Texas
SALARY =,  15000.0

ID =,  3
NAME =,  Teddy
ADDRESS =,  Norway
SALARY =,  20000.0

ID =,  4
NAME =,  Mark
ADDRESS =,  Rich-Mond
SALARY =,  65000.0
```

## 更新操作

以下Python代码显示了如何使用UPDATE语句来更新任何记录，然后从COMPANY表中获取并显示更新的记录：

```
#!/usr/bin/python

import psycopg2

conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")

cur = conn.cursor()

cur.execute("UPDATE COMPANY set SALARY = 25000.00 where ID=1")
conn.commit

cur.execute("SELECT id, name, address, salary  from COMPANY")
rows = cur.fetchall()
for row in rows:
   print("ID = ", row[0])
   print("NAME = ", row[1])
   print("ADDRESS = ", row[2])
   print("SALARY = ", row[3])

conn.close()
```

执行上述程序时，会产生以下结果：

```
ID =,  1
NAME =,  Paul
ADDRESS =,  California
SALARY =,  25000.0

ID =,  2
NAME =,  Allen
ADDRESS =,  Texas
SALARY =,  15000.0

ID =,  3
NAME =,  Teddy
ADDRESS =,  Norway
SALARY =,  20000.0

ID =,  4
NAME =,  Mark
ADDRESS =,  Rich-Mond
SALARY =,  65000.0

```

## 删除操作

以下Python代码显示了如何使用DELETE语句来删除记录，然后从COMPANY表中获取并显示剩余的记录：

```
#!/usr/bin/python

import psycopg2

conn = psycopg2.connect(database="testdb", user="openGauss", password="xxxxxxxx", host="127.0.0.1", port="26000")

cur = conn.cursor()

cur.execute("DELETE from COMPANY where ID=2;")
conn.commit

cur.execute("SELECT id, name, address, salary  from COMPANY")
rows = cur.fetchall()
for row in rows:
   print("ID = ", row[0])
   print("NAME = ", row[1])
   print("ADDRESS = ", row[2])
   print("SALARY = ", row[3])

conn.close()
```

执行上述程序时，会产生以下结果：

```
ID =,  1
NAME =,  Paul
ADDRESS =,  California
SALARY =,  20000.0

ID =,  3
NAME =,  Teddy
ADDRESS =,  Norway
SALARY =,  20000.0

ID =,  4
NAME =,  Mark
ADDRESS =,  Rich-Mond
SALARY =,  65000.0
```
