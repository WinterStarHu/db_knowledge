# MOT SQL覆盖和限制

MOT设计几乎能够覆盖SQL和未来特性集。例如，大多数支持标准的Postgres SQL，也支持常见的数据库特性，如存储过程、自定义函数等。

下面介绍各种SQL覆盖和限制。

## 不支持的特性

MOT不支持以下特性：

- 隔离性：不支持SERIALIZABLE隔离。
- 查询原生编译（JIT）：SQL覆盖范围有限。
- 本地内存限制为1GB。一个事务只能更改小于1GB的数据。
- 容量（数据+索引）受限于可用内存。
- 不支持全文检索索引。
- 不支持逻辑复制特性。
- 不支持保存点。
- 不支持Ustore存储引擎。
- 不支持列存表。

此外，下面详细列出了MOT、MOT索引、查询和DML语法的各种通用限制，以及查询原生编译的特点和限制。

## MOT限制

MOT功能限制：

- 分区
- AES加密、数据动态脱敏、行级访问控制
- 流操作
- 自定义类型
- 子事务：仅支持存储过程的语句块上下文，且有以下限制：MOT恢复支持仅包含SELECT操作的子事务，且仅允许只读回滚。在这种情况下，父事务将中止。
- DML触发器
- DDL触发器
- “C”或“POSIX”以外的排序规则

## 不支持的DDL操作

- CREATE FORIGN table LIKE：有限支持，LIKE可以用于任何表（MOT和堆表），但不带任何选项、数据或索引。
- 创建as select表
- 按范围分区
- 创建无日志记录子句（no-logging clause）的表
- 创建可延迟约束主键（DEFERRABLE）
- 重建索引
- 表空间
- 使用子命令创建架构

## 不支持的数据类型

- UUID
- User-Defined Type (UDF)
- Array data type
- NVARCHAR2(n)
- Clob
- Name
- Blob
- Raw
- Path
- Circle
- Reltime
- Bit varying(10)
- Tsvector
- Tsquery
- JSON
- Box
- Text
- Line
- Point
- LSEG
- POLYGON
- INET
- CIDR
- MACADDR
- Smalldatetime
- BYTEA
- Bit
- Varbit
- OID
- Money
- Any unlimited varchar/character varying
- HSTORE
- XML
- Int16
- Abstime
- Tsrange
- Tstzrange
- Int8range
- Int4range
- Numrange
- Daterange
- HLL

## 不支持的索引DDL和索引

- 在小数和数值类型上创建索引

- 在可空列上创建索引

- 单表创建索引总数\>9

- 在键大小\>256的表上创建索引

键大小包括以字节为单位的列大小+列附加大小，这是维护索引所需的开销。下表列出了不同列类型的列附加大小。

此外，如果索引不是唯一的，额外需要8字节。

下面是伪代码计算键大小：

    ```
    keySize =0;

    for each (column in index){
          keySize += (columnSize + columnAddSize);
    }
    if (index is non_unique) {
          keySize += 8;
    }
    ```

列类型 列大小 列附加大小 varchar tinyint smallint int longint float double

上表中未指定的类型，列附加大小为零（例如时间戳）。

## 不支持的DML

- Merge into
- Lock table
- Copy from table
- Upsert

## 不支持的JIT功能（原生编译和执行）

- 存储过程编译：仅访问MOT表的存储过程可用。
- 查询涉及两个以上的表
- 查询有以下任何一个情况：
  - 非原生类型的聚合
  - 窗口功能
  - 子查询子链接
  - Distinct-ON修饰语（distinct子句来自DISTINCT ON）
  - 递归（已指定WITH RECURSIVE）
  - 修改CTE（WITH中有INSERT/UPDATE/DELETE）

以下子句不支持轻量执行：

- Returning list
- Group By clause
- Grouping sets
- Having clause
- Windows clause
- Distinct clause
- Sort clause that does not conform to native index order：支持，但所有排序列都必须存在于SELECT中。
- Set operations
- Constraint dependencies
