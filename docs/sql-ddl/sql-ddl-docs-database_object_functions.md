# 数据库对象函数

## 数据库对象尺寸函数

数据库对象尺寸函数计算数据库对象使用的实际磁盘空间。

- pg\_column\_size\(any\)

描述：存储一个指定的数值需要的字节数（可能压缩过）。

返回值类型：int

备注：pg\_column\_size显示用于存储某个独立数据值的空间。

    ```
    openGauss=# SELECT pg_column_size(1);
     pg_column_size
    ----------------
                  4
    (1 row)
    ```

- pg\_database\_size\(oid\)

描述：指定OID代表的数据库使用的磁盘空间。

返回值类型：bigint

- pg\_database\_size\(name\)

描述：指定名称的数据库使用的磁盘空间。

返回值类型：bigint

备注：pg\_database\_size接受一个数据库的OID或者名称，然后返回该对象使用的全部磁盘空间。

示例：

    ```
    openGauss=# SELECT pg_database_size('postgres');
     pg_database_size
    ------------------
             51590112
    (1 row)
    ```

- pg\_relation\_size\(oid\)

描述：指定OID代表的表或者索引所使用的磁盘空间。

返回值类型：bigint

- get\_db\_source\_datasize\(\)

描述：估算当前数据库非压缩态的数据总容量。

返回值类型：bigint

备注：（1）调用该函数前需要做analyze；（2）通过估算列存的压缩率计算非压缩态的数据总容量。

示例：

    ```
    openGauss=# analyze;
    ANALYZE
    openGauss=# select get_db_source_datasize();
     get_db_source_datasize
    ------------------------
                35384925667
    (1 row)
    ```

- pg\_relation\_size\(text\)

描述：指定名称的表或者索引使用的磁盘空间。表名称可以用模式名修饰。

返回值类型：bigint

- pg\_relation\_size\(relation regclass, fork text\)

描述：指定表或索引的指定分叉树（'main'，'fsm'或'vm'）使用的磁盘空间。

返回值类型：bigint

- pg\_relation\_size\(relation regclass\)

描述：pg\_relation\_size\(..., 'main'\)的简写。

返回值类型：bigint

备注：pg\_relation\_size接受一个表、索引、压缩表的OID或者名称，然后返回它们的字节大小。

- pg\_partition\_size\(oid,oid\)

描述：指定OID代表的分区使用的磁盘空间。其中，第一个oid为表的OID，第二个oid为分区的OID。

返回值类型：bigint

- pg\_partition\_size\(text, text\)

描述：指定名称的分区使用的磁盘空间。其中，第一个text为表名，第二个text为分区名。

返回值类型：bigint

- pg\_partition\_indexes\_size\(oid,oid\)

描述：指定OID代表的分区的索引使用的磁盘空间。其中，第一个oid为表的OID，第二个oid为分区的OID。

返回值类型：bigint

- pg\_partition\_indexes\_size\(text,text\)

描述：指定名称的分区的索引使用的磁盘空间。其中，第一个text为表名，第二个text为分区名。

返回值类型：bigint

- pg\_indexes\_size\(regclass\)

描述：附加到指定表的索引使用的总磁盘空间。

返回值类型：bigint

- pg\_size\_pretty\(bigint\)

描述：将以64位整数表示的字节值转换为具有单位的易读格式。

返回值类型：text

- pg\_size\_pretty\(numeric\)

描述：将以数值表示的字节值转换为具有单位的易读格式。

返回值类型：text

备注：pg\_size\_pretty用于把其他函数的结果格式化成一种易读的格式，可以根据情况使用KB 、MB 、GB 、TB。

- pg\_table\_size\(regclass\)

描述：指定的表使用的磁盘空间，不计索引（但是包含TOAST，自由空间映射和可见性映射）。

返回值类型：bigint

- pg\_tablespace\_size\(oid\)

描述：指定OID代表的表空间使用的磁盘空间。

返回值类型：bigint

- pg\_tablespace\_size\(name\)

描述：指定名称的表空间使用的磁盘空间。

返回值类型：bigint

备注：

pg\_tablespace\_size接受一个数据库的OID或者名称，然后返回该对象使用的全部磁盘空间。

- pg\_total\_relation\_size\(oid\)

描述：指定OID代表的表使用的磁盘空间，包括索引和压缩数据。

返回值类型：bigint

- pg\_total\_relation\_size\(regclass\)

描述：指定的表使用的总磁盘空间，包括所有的索引和TOAST数据。

返回值类型：bigint

- pg\_total\_relation\_size\(text\)

描述：指定名称的表所使用的全部磁盘空间，包括索引和压缩数据。表名称可以用模式名修饰。

返回值类型：bigint

备注：pg\_total\_relation\_size接受一个表或者一个压缩表的OID或者名称，然后返回以字节计的数据和所有相关的索引和压缩表的尺寸。

- datalength\(any\)

描述：计算一个指定的数据需要的字节数（不考虑数据的管理空间和数据压缩、数据类型转换等情况）。

返回值类型：int

备注：datalength用于计算某个独立数据值的空间。

示例：

    ```
    openGauss=# SELECT datalength(1);
    datalength
    ------------
    4
    (1 row)
    ```

目前支持的数据类型及计算方式见下表：

数据类型 存储空间 数值类型 整数类型 TINYINT SMALLINT INTEGER BINARY_INTEGER BIGINT 任意精度型 DECIMAL 每4位十进制数占两个字节，小数点前后数字分别计算 NUMERIC 每4位十进制数占两个字节，小数点前后数字分别计算 NUMBER 每4位十进制数占两个字节，小数点前后数字分别计算 序列整型 SMALLSERIAL SERIAL LARGESERIAL BIGSERIAL 每4位十进制数占两个字节，小数点前后数字分别计算 浮点类型 FLOAT4 DOUBLE PRECISION FLOAT8 BINARY_DOUBLE FLOAT[(p)] 4或者8(float_as_numeric参数未开启时)每4位十进制数占两个字节，小数点前后数字分别计算。(float_as_numeric参数开启时) DEC[(p[,s])] 每4位十进制数占两个字节，小数点前后数字分别计算 INTEGER[(p[,s])] 每4位十进制数占两个字节，小数点前后数字分别计算 布尔类型 布尔类型 BOOLEAN 字符类型 字符类型 CHAR CHAR(n) CHARACTER(n) NCHAR(n) VARCHAR(n) CHARACTER 字符实际字节数 VARYING(n) 字符实际字节数 VARCHAR2(n) 字符实际字节数

NVARCHAR(n) 字符实 际字节数 NVARCHAR2(n) 字符实际字节数 TEXT 字符实际字节数 CLOB 字符实际字节数 时间类型 时间类型 DATE TIME TIMEZ TIMESTAMP TIMESTAMPZ SMALLDATETIME INTERVAL DAY TO SECOND INTERVAL RELTIME ABSTIME TINTERVAL

## 数据库对象位置函数

- pg\_relation\_filenode\(relation regclass\)

描述：指定关系的文件节点数。

返回值类型：oid

备注：pg\_relation\_filenode接受一个表、索引、序列或压缩表的OID或者名称，并且返回当前分配给它的“filenode”数。文件节点是关系使用的文件名称的基本组件。对大多数表来说，结果和pg\_class.relfilenode相同，但对确定的系统目录来说，relfilenode为0而且这个函数必须用来获取正确的值。如果传递一个没有存储的关系，比如一个视图，那么这个函数返回NULL。

- pg\_relation\_filepath\(relation regclass\)

描述：指定关系的文件路径名。

返回值类型：text

备注：pg\_relation\_filepath类似于pg\_relation\_filenode，但是它返回关系的整个文件路径名（相对于openGauss的数据目录PGDATA）。当查询关系为段页式表时，本函数返回结果为关系的逻辑地址，并非实际存储该关系的文件路径。

- pg\_filenode\_relation\(tablespace oid, filenode oid\)

描述：获取对应的tablespace和relfilenode所对应的表名。

返回类型：regclass

- pg\_partition\_filenode\(partition\_oid\)

描述：获取到指定分区表的oid锁对应的filenode。

返回类型：oid

- pg\_partition\_filepath\(partition\_oid\)

描述：指定分区的文件路径名。

返回值类型：text

## 回收站对象函数

- gs\_is\_recycle\_object\(classid, objid, objname\)

描述：判断是否为回收站对象。

返回值类型：bool

备注： + classid：所依赖对象所在表系统的OID，可以通过PG_DEPEND视图来获得；objid：当前对象的oid objname：对象名，回收站的对象名都是以 'BIN$' 开头的字符串。
+ 该视图也可简写成 gs_is_recycle_obj 。

示例：

    ```sql
    openGauss=# select * from gs_is_recycle_object(1259, 24585, 'BIN$3DD94EB6009$6170E10==$0');
    ```
