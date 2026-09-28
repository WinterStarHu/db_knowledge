# 支持PL/Java

## 可获得性

本特性自openGauss 1.0.0版本开始引入。

## 特性简介

支持java UDF。

## 客户价值

提供多种函数的开发环境。

## 特性描述

使用openGauss数据库的PL/Java函数，用户可以使用自己喜欢的Java IDE编写Java方法，并将包含这些方法的jar文件安装到openGauss数据库中，然后使用该方法。openGauss PL/Java基于开源tada PL/Java 1.5.2开发，PL/Java所使用的JDK版本为Huawei JDK V100R001C00SPC190B003-b09。

## 特性增强

无。

## 特性约束

- Java UDF可以实现一些较为简单的java计算，强烈建议不要在Java UDF中封装业务。
- 强烈建议不要在Java函数中使用任何方式连接数据库，包括但不限于JDBC。
- 建议用户使用Huawei JDK V100R001C00SPC190B003-b09编译Java方法和jar文件。
- 暂不支持的数据类型：除[表1](#table10200627143416)提及之外的数据类型，包括自定义类型，复杂数据类型（Java Array类及派生类）。
- 暂不支持UDAF、UDTF。

**表 1**  PL/Java默认数据类型映射关系

openGauss Java BOOLEAN boolean "char" byte bytea byte[] SMALLINT short INTEGER int BIGINT long FLOAT4 float FLOAT8 double CHAR java.lang.String VARCHAR java.lang.String TEXT java.lang.String name java.lang.String DATE java.sql.Timestamp TIME java.sql.Time (stored value treated as local time) TIMETZ java.sql.Time TIMESTAMP java.sql.Timestamp TIMESTAMPTZ java.sql.Timestamp

## 依赖关系

PL/Java依赖JDK环境，目前openGauss中已包含JDK环境，无需用户安装。如果用户已安装（相同或不同版本的）JDK，也不会引起冲突，openGauss会使用Huawei JDK V100R001C00SPC190B003-b09来运行PL/Java。
