# Sharding-JDBC 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/JAVA_ShardingJDBC.html

Sharding-JDBC 框架 | 达梦技术文档

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

Sharding-JDBC 框架

一、前言

1.1 概述

ShardingSphere 是一套由开源的分布式数据库中间件解决方案组成的生态圈，它由 Sharding-JDBC、Sharding-Proxy 和 Sharding-Sidecar（计划中）这 3 款相互独立的产品组成。它们均提供标准化的数据分片、分布式事务和数据库治理功能，可适用于如 Java 同构、异构语言、云原生等各种多样化的应用场景。

1.2 JAR 包

准备以下 jar 包：

spring-boot-starter spring-boot-starter-test lombok mybatis-plus-core sharding-jdbc-spring-boot-starter druid mybatis-plus-boot-starter DmJdbcDriver18.jar

二、准备工作

创建三个达梦实例，端口分别为 5236、5237、5238，分别创建以下表:

CREATE TABLE "SYSDBA"."GOODS_1" ( "GID" BIGINT, "GNAME" VARCHAR(50), "USER_ID" BIGINT, "GSTATUS" VARCHAR(50)) STORAGE(ON "MAIN", CLUSTERBTR) ;

CREATE TABLE "SYSDBA"."GOODS_2" ( "GID" BIGINT, "GNAME" VARCHAR(50), "USER_ID" BIGINT, "GSTATUS" VARCHAR(50)) STORAGE(ON "MAIN", CLUSTERBTR) ;

三、代码部分

3.1 对象部分

3.1.1 启动类代码

SharingJdbcTestApplication 代码:

package com.example.sharingjdbctest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication @MapperScan(basePackages = {"com.example.sharingjdbctest.mapper","com.example.sharingjdbctest.hash"})

public class SharingJdbcTestApplication { public static void main(String[] args) { SpringApplication.run(SharingJdbcTestApplication.class, args);
} }

3.1.2 Mapper 层代码

GoodsMapper 代码:

package com.example.sharingjdbctest.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.sharingjdbctest.pojo.Goods;
import org.springframework.stereotype.Repository;

@Repository public interface GoodsMapper extends BaseMapper { }

3.1.3 Pojo 层代码

Goods 代码:

package com.example.sharingjdbctest.pojo;
import lombok.Data;

@Data public class Goods { private Long gid;
private String gname;
private Long userId;
private String gstatus;
}

3.2 配置类和测试代码

3.2.1 测试项一

测试水平分表，通过生成的 gid 值进行分表。

applicagtion.properties 代码:

spring.shardingsphere.datasource.names=g1 spring.main.allow-bean-definition-overriding=true spring.shardingsphere.datasource.g1.type=com.alibaba.druid.pool.DruidDataSource spring.shardingsphere.datasource.g1.driver-class-name=dm.jdbc.driver.DmDriver spring.shardingsphere.datasource.g1.url=jdbc:dm://localhost:5236 spring.shardingsphere.datasource.g1.username=SYSDBA spring.shardingsphere.datasource.g1.password=***** spring.shardingsphere.sharding.tables.goods.actual-data-nodes=g1.goods_$->{1..2} spring.shardingsphere.sharding.tables.goods.key-generator.column=gid spring.shardingsphere.sharding.tables.goods.key-generator.type=SNOWFLAKE spring.shardingsphere.sharding.tables.goods.table-strategy.inline.sharding-column=gid spring.shardingsphere.sharding.tables.goods.table-strategy.inline.algorithm-expression=goods_$->{gid % 2 + 1} spring.shardingsphere.props.sql.show=true

SharingJdbcTestApplicationTests 代码:

package com.example.sharingjdbctest;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.sharingjdbctest.mapper.GoodsMapper;
import com.example.sharingjdbctest.pojo.Goods;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest class SharingJdbcTestApplicationTests {

@Autowired GoodsMapper goodsMapper;

@Test void addGoods() { Goods good = new Goods();
good.setGname("图书");
good.setUserId(100L);
good.setGstatus("已发布");
goodsMapper.insert(good);
Goods good2 = new Goods();
good2.setGname("手机");
good2.setUserId(99L);
good2.setGstatus("已发布");
goodsMapper.insert(good2);
}

@Test void addGoods2() { for (int i = 0; i < 10; i++){ Goods good = new Goods();
good.setGname("图书" + i);
good.setUserId(100L);
good.setGstatus("已发布");
goodsMapper.insert(good);
} }

@Test void getGood3(){ QueryWrapper queryWrapper = new QueryWrapper<>();
//此处根据实际gid值修改，还会查询goods表 queryWrapper.eq("gid",960919903190122497L);
Goods good = goodsMapper.selectOne(queryWrapper);
System.out.println(good.toString());
}

}

5236 库：

SELECT *FROM GOODS_1;

SELECT *FROM GOODS_2;

3.2.2 测试项二

测试分库分表，通过 user_id 分库，gid 分表。

applicagtion.properties 代码:

spring.shardingsphere.datasource.names=g1,g2,u0

spring.main.allow-bean-definition-overriding=true

spring.shardingsphere.datasource.g1.type=com.alibaba.druid.pool.DruidDataSource spring.shardingsphere.datasource.g1.driver-class-name=dm.jdbc.driver.DmDriver spring.shardingsphere.datasource.g1.url=jdbc:dm://localhost:5236 spring.shardingsphere.datasource.g1.username=SYSDBA spring.shardingsphere.datasource.g1.password=*****

spring.shardingsphere.datasource.g2.type=com.alibaba.druid.pool.DruidDataSource spring.shardingsphere.datasource.g2.driver-class-name=dm.jdbc.driver.DmDriver spring.shardingsphere.datasource.g2.url=jdbc:dm://localhost:5237 spring.shardingsphere.datasource.g2.username=SYSDBA spring.shardingsphere.datasource.g2.password=*****

spring.shardingsphere.datasource.u0.type=com.alibaba.druid.pool.DruidDataSource spring.shardingsphere.datasource.u0.driver-class-name=dm.jdbc.driver.DmDriver spring.shardingsphere.datasource.u0.url=jdbc:dm://localhost:5238 spring.shardingsphere.datasource.u0.username=SYSDBA spring.shardingsphere.datasource.u0.password=*****

spring.shardingsphere.sharding.tables.goods.actual-data-nodes=g$->{1..2}.goods_$->{1..2}

# 指定 goods 表 主键 gid 生成策略为 SNOWFLAKE
spring.shardingsphere.sharding.tables.goods.key-generator.column=gid spring.shardingsphere.sharding.tables.goods.key-generator.type=SNOWFLAKE

# 指定数据库分片策略 约定 user_id 值是偶数添加到 goods_db_1 中，奇数添加到 goods_db_2 中
spring.shardingsphere.sharding.tables.goods.database-strategy.inline.sharding-column=user_id spring.shardingsphere.sharding.tables.goods.database-strategy.inline.algorithm-expression=g$->{user_id % 2 + 1}

# 指定表分片策略 约定 gid 值是偶数添加到 goods_1 表，如果 gid 是奇数添加到 goods_2 表
spring.shardingsphere.sharding.tables.goods.table-strategy.inline.sharding-column=gid spring.shardingsphere.sharding.tables.goods.table-strategy.inline.algorithm-expression=goods_$->{gid % 2 + 1}

# 打开 sql 输出日志
spring.shardingsphere.props.sql.show=true

SharingJdbcTestApplicationTests 代码:

package com.example.sharingjdbctest;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.example.sharingjdbctest.mapper.GoodsMapper;
import com.example.sharingjdbctest.pojo.Goods;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest class SharingJdbcTestApplicationTests2 {

@Autowired GoodsMapper goodsMapper;

@Test void addGoods() { Goods good = new Goods();
good.setGname("图书1");
good.setUserId(100L);
good.setGstatus("已发布");
goodsMapper.insert(good);
Goods good2 = new Goods();
good2.setGname("手机1");
good2.setUserId(99L);
good2.setGstatus("已发布");
goodsMapper.insert(good2);
Goods good3 = new Goods();
good3.setGname("图书2");
good3.setGid(99L);
good3.setGstatus("已发布");
goodsMapper.insert(good3);
Goods good4 = new Goods();
good4.setGname("手机2");
good3.setGid(100L);
good4.setGstatus("已发布");
goodsMapper.insert(good4);
}

@Test void addGoods2() { for (int i = 0; i < 10; i++){ for(int j = 0; j <10 ; j++) { Goods good = new Goods();
good.setGname("图书" + i);
long a = (long)i;
good.setUserId(a);
long b = (long)j;
good.setGid(b);
good.setGstatus("已发布"+j);
goodsMapper.insert(good);
} } }

@Test void getGood3(){ QueryWrapper queryWrapper = new QueryWrapper<>();
//此处根据实际gid值修改，还会查询goods表 queryWrapper.eq("gid",960920931885121537L);
Goods good = goodsMapper.selectOne(queryWrapper);
System.out.println(good.toString());
}

}

5236 库：

SELECT *FROM GOODS_1;

SELECT *FROM GOODS_2;

5237 库：

SELECT *FROM GOODS_1;

SELECT *FROM GOODS_2;

查到 5237 库里的数据。

四、参考

1．示例代码下载：参考 Sharding-JDBC.zip 文件。

2．以上文档内容参考过程中遇到任何问题，可到达梦技术社区提问交流。

上次更新：2026-09-26 上一篇下一篇

Sharding-JDBC 框架

一、前言
1.1 概述
1.2 JAR 包
二、准备工作 三、代码部分
3.1 对象部分
3.1.1 启动类代码
3.1.2 Mapper 层代码
3.1.3 Pojo 层代码
3.2 配置类和测试代码
3.2.1 测试项一
3.2.2 测试项二
四、参考

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
