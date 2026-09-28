# 自适应压缩

## 可获得性

本特性自openGauss 1.0.0版本开始引入。

## 特性简介

数据压缩是当前数据库采用的主要技术。数据类型不同，适用于它的压缩算法不同。对于相同类型的数据，其数据特征不同，采用不同的压缩算法达到的效果也不相同。自适应压缩正是从数据类型和数据特征出发，采用相应的压缩算法，实现了良好的压缩比、快速的入库性能以及良好的查询性能。

## 客户价值

主要应用场景为数据入库和频繁的海量数据查询。 在数据入库场景中，自适应压缩可以大幅度地减少数据量，成倍提高IO操作效率，并将数据分类压缩以获得更快的入库性能。当用户进行数据查询时，少量的IO操作和快速的数据解压可以加快数据获取的速率，从而在更短的时间内得到查询结果。

## 特性描述

目前，数据库已实现了列存储上RLE、DELTA、BYTEPACK/BITPACK、LZ4、ZLIB、LOCAL DICTIONARY等多种压缩算法。数据库支持的数据类型与压缩算法的映射关系如下表所示。

RLE DELTA BITPACK/BYTEPACK LZ4 ZLIB LOCAL DICTIONARY smallint/int/bigint/oid decimal/real/double money/time/date/ timestamp tinterval/interval/time with time zone/ numeric/char/varchar/text/nvarchar2 以及其他支持数据类型

## 特性增强

支持对压缩算法进行不同压缩水平的调整。

## 特性约束

无。

## 依赖关系

开源压缩软件LZ4/ZLIB。

## 使用说明

自适应压缩是列存表的功能，在创建表时需要指定表数据存储方式为列式存储。

使用时可设置COMPRESSION参数，它决定了表数据的压缩比以及压缩时间。一般来讲，压缩级别越高，压缩比也越大，压缩时间也越长；反之亦然。实际压缩比取决于加载的表数据的分布特征。有效值为YES/NO/LOW/MIDDLE/HIGH，默认值为LOW。

## 使用指导

测试用例

```
-- 创建列存表。
openGauss=# CREATE TABLE COMPRESS_LOW
(
    ID            INT PRIMARY KEY     NOT NULL,
    NAME          TEXT                NOT NULL,
    AGE           INT                 NOT NULL,
    ADDRESS       CHAR(50)                    ,
    SALARY        REAL
) WITH (ORIENTATION=COLUMN);

openGauss=# INSERT INTO COMPRESS_LOW
openGauss-# SELECT GENERATE_SERIES(1, 10000) AS KEY,REPEAT( CHR(INT4(RANDOM()*26)+65),4),
openGauss-# (RANDOM()*(6^2))::INTEGER,NULL,(RANDOM()*(10^4))::INTEGER;

-- 创建列存表，并设置COMPRESSION为NO。
openGauss=# CREATE TABLE COMPRESS_NO
(
    ID            INT PRIMARY KEY     NOT NULL,
    NAME          TEXT                NOT NULL,
    AGE           INT                 NOT NULL,
    ADDRESS       CHAR(50)                    ,
    SALARY        REAL
) WITH (ORIENTATION=COLUMN, COMPRESSION=NO);

openGauss=# INSERT INTO COMPRESS_NO
openGauss-# SELECT GENERATE_SERIES(1, 10000) AS KEY,REPEAT( CHR(INT4(RANDOM()*26)+65),4),
openGauss-# (RANDOM()*(6^2))::INTEGER,NULL,(RANDOM()*(10^4))::INTEGER;

-- 创建列存表，并设置COMPRESSION为MIDDLE。
openGauss=# CREATE TABLE COMPRESS_MID
(
    ID            INT PRIMARY KEY     NOT NULL,
    NAME          TEXT                NOT NULL,
    AGE           INT                 NOT NULL,
    ADDRESS       CHAR(50)                    ,
    SALARY        REAL
) WITH (ORIENTATION=COLUMN, COMPRESSION=MIDDLE);

openGauss=# INSERT INTO COMPRESS_MID
openGauss-# SELECT GENERATE_SERIES(1, 10000) AS KEY,REPEAT( CHR(INT4(RANDOM()*26)+65),4),
openGauss-# (RANDOM()*(6^2))::INTEGER,NULL,(RANDOM()*(10^4))::INTEGER;

-- 创建列存表，并设置COMPRESSION为HIGH。
openGauss=# CREATE TABLE COMPRESS_HIGH
(
    ID            INT PRIMARY KEY     NOT NULL,
    NAME          TEXT                NOT NULL,
    AGE           INT                 NOT NULL,
    ADDRESS       CHAR(50)                    ,
    SALARY        REAL
) WITH (ORIENTATION=COLUMN, COMPRESSION=HIGH);

openGauss=# INSERT INTO COMPRESS_HIGH
openGauss-# SELECT GENERATE_SERIES(1, 10000) AS KEY,REPEAT( CHR(INT4(RANDOM()*26)+65),4),
openGauss-# (RANDOM()*(6^2))::INTEGER,NULL,(RANDOM()*(10^4))::INTEGER;

-- 查询表大小。
openGauss=# select pg_size_pretty(pg_relation_size('compress_low')) as size;
  size
--------
 152 kB
 (1 row)

openGauss=# select pg_size_pretty(pg_relation_size('compress_no')) as size;
  size
--------
 240 kB
 (1 row)

openGauss=# select pg_size_pretty(pg_relation_size('compress_mid')) as size;
  size
--------
 128 kB
 (1 row)

openGauss=# select pg_size_pretty(pg_relation_size('compress_high')) as size;
  size
--------
 112 kB
 (1 row)

```
