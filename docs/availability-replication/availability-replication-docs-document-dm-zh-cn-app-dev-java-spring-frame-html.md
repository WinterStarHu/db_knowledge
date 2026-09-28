# Spring 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/java-spring-frame.html

Spring 框架 | 达梦技术文档

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

Spring 框架

一、前言

Spring 为简化企业级开发而生，使用 Spring 开发可以将 Bean 对象，Dao 组件对象，Service 组件对象等交给 Spring 容器来管理，这样使得很多复杂的代码在 Spring 中开发却变得非常的优雅和简洁，有效的降低代码的耦合度，极大的方便项目的后期维护、升级和扩展。

Spring 通常与 Mybtais 等数据操作层框架结合使用，本示例是 Spring+Mybatis 框架整合使用。

二、数据库连接

2.1 Spring 的引入

准备项目所需 jar 包：JAVA_Spring_lib.zip。

新建项目 JAVA_Spring，并导入项目所需 jar 包，如下图所示：

注意

复制 jar 包到 lib 文件夹后，要选择所有 jar 包，鼠标右键，Build path-->Add to Build path。

在 src 源码目录下创建如下包名，完整项目目录结构如下图所示：

书写 Spring 的核心配置文件：spring-dao.xml，存放在 src 目录下。此处将原本 mybatis 的相关配置全部集中到 spring 配置文件中，可以省略 mybatis 配置文件。spring-dao.xml.xml 文件如下所示：

<beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p" xmlns:aop="http://www.springframework.org/schema/aop" xmlns:context="http://www.springframework.org/schema/context" xmlns:jee="http://www.springframework.org/schema/jee" xmlns:tx="http://www.springframework.org/schema/tx" xsi:schemaLocation=" http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee-4.0.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.0.xsd">

添加 jdbc.properties 配置文件，(主要配置 driver、url、username、password 等)。修改数据库连接信息，只修改 jdbc.properties 里的字段即可。jdbc.properties 文件如下所示：

jdbc.driver=dm.jdbc.driver.DmDriver jdbc.url=jdbc:dm://localhost:5236 jdbc.username=SYSDBA jdbc.password=*****

三、开发示例

3.1 基础绑定参数示例

基本操作使用的数据表为示例库中 Product 的 PRODUCT_CATEGORY 表，对应于数据库表添加实体类 PRODUCT_CATEGORY，其位置放于 dameng.pojo 下。

操作数据库对应的实体类。PRODUCT_CATEGORY.java 文件如下所示：

package dameng.pojo;
public class PRODUCT_CATEGORY { private int PRODUCT_CATEGORYID;
private String NAME;
public int getPRODUCT_CATEGORYID() { return PRODUCT_CATEGORYID;
} public void setPRODUCT_CATEGORYID(int pRODUCT_CATEGORYID) { PRODUCT_CATEGORYID = pRODUCT_CATEGORYID;
} public String getNAME() { return NAME;
} public void setNAME(String nAME) { NAME = nAME;
} public PRODUCT_CATEGORY(int pRODUCT_CATEGORYID, String nAME) { super();
PRODUCT_CATEGORYID = pRODUCT_CATEGORYID;
NAME = nAME;
} public PRODUCT_CATEGORY() { super();
} }

数据访问层接口。ProductCategoryMapper.java 文件如下所示：

package dameng.dao;

import org.apache.ibatis.annotations.Mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import dameng.pojo.ProductCategory;

@Mapper public interface ProductCategoryMapper extends BaseMapper{

}

测试类。TestProduct.java 文件如下所示：

package dameng.test;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import dameng.dao.ProductCategoryMapper;
import dameng.pojo.ProductCategory;

@RunWith(SpringJUnit4ClassRunner.class) @ContextConfiguration({"classpath:spring-dao.xml"}) public class TestProduct { @Autowired ProductCategoryMapper productCategoryMapper = null;
//测试插入信息 @Test public void testInstert(){ productCategoryMapper.insert((new ProductCategory(null, "语文")));
} //测试修改信息 @Test public void testUpdate(){ ProductCategory productCategory = productCategoryMapper.selectById(4);
productCategory.setName("英语");
productCategoryMapper.updateById(productCategory);
} //测试根据 id 查询指定人信息 @Test public void testSelectPersonById(){ ProductCategory productCategory = productCategoryMapper.selectById(1);
System.out.println(productCategory);
} //测试全查 @Test public void testSelectAll(){ List selectList = productCategoryMapper.selectList(null);
for(ProductCategory p: selectList){ System.out.println(p);
} } //测试删除 @Test public  void testDelete(){ productCategoryMapper.deleteById(5);
} }

运行结果截图。运行后控制台输出结果如下图所示：

运行后数据库数据如下图所示：

3.2 大字段操作示例

创建需要操作的含大字段类型的数据表。

CREATE TABLE "PRODUCTION"."BIG_DATA" ( "ID" INT IDENTITY(1, 1) NOT NULL, "PHOTO" IMAGE, "DESCRIBE" BLOB, "TXT" CLOB, NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "BOOKSHOP", CLUSTERBTR) ;

在 D 盘根目录下，创建 DM8 特点.jpg、达梦产品简介.txt 两个文件，作为大字段存储，如下图所示：

操作数据库对应的实体类。BigData.java 文件如下所示：

package dameng.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
@TableName(value="PRODUCTION.BIG_DATA") public class BigData { @TableId(value = "id",type = IdType.AUTO) private Long id;
private byte[] photo; //mybatis 将 Image 和 Blob 映射成 byte[] private byte[] describe;
private String txt; //mybatis 将 Clob 映射成 String public Long getId() { return id;
} public void setId(Long id) { this.id = id;
} public byte[] getPhoto() { return photo;
} public void setPhoto(byte[] photo) { this.photo = photo;
} public byte[] getDescribe() { return describe;
} public void setDescribe(byte[] describe) { this.describe = describe;
} public String getTxt() { return txt;
} public void setTxt(String txt) { this.txt = txt;
} @Override public String toString() { return "TestBigData [id=" + id + ", txt=" + txt + "]";
} public BigData(Long id, byte[] photo, byte[] describe, String txt) { super();
this.id = id;
this.photo = photo;
this.describe = describe;
this.txt = txt;
} public BigData() { super();
} }

数据访问层接口。TestBigDataMapper.java 文件如下所示：

package dameng.dao;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import dameng.pojo.BigData;
public interface BigDataMapper extends BaseMapper{ }

测试类。TestBigData.java 文件如下所示：

package dameng.test;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import dameng.dao.BigDataMapper;
import dameng.pojo.BigData;

@RunWith(SpringJUnit4ClassRunner.class) @ContextConfiguration({"classpath:spring-dao.xml"}) public class TestBigData { @Autowired BigDataMapper bigDataMapper= null;
//测试插入大字段表 @Test public void testInsert() { try { String filePath = "D:\\DM8 特点.jpg";
File file = new File(filePath);
String filePath2 = "D:\\达梦产品简介.txt";
File file2 = new File(filePath2);
InputStream in;
in = new BufferedInputStream(new FileInputStream(file));
byte[] bytes1 = new byte[102400];
byte[] bytes2 = new byte[102400];
in.read(bytes1);
InputStream in2 = new BufferedInputStream(new FileInputStream(file));
in2.read(bytes2);
BufferedReader reader = new BufferedReader(new InputStreamReader (new FileInputStream(file2),"UTF-8"));
StringBuffer stringBuffer = new StringBuffer("");
String str = null;
while((str = reader.readLine())!=null) { stringBuffer.append(str);
stringBuffer.append("\n");
} BigData bigData = new BigData(null,bytes1,bytes2,stringBuffer.toString());

bigDataMapper.insert(bigData);
in.close();
in2.close();
reader.close();
} catch (FileNotFoundException e) { e.printStackTrace();
} catch (UnsupportedEncodingException e) { e.printStackTrace();
} catch (IOException e) { e.printStackTrace();
} } //测试查询大字段表 @Test public void testSelect() { List list = bigDataMapper.selectList(null);
try { for(BigData big:list) { //打印出 id System.out.println("id = "+big.getId());
//将 photo 列信息输出到指定路径 FileOutputStream fos = new FileOutputStream("D:/"+big.getId()+"_DM8特点.jpg");
fos.write(big.getPhoto());
//将 describe 列信息输出到指定路径 FileOutputStream fos2 = new FileOutputStream("D:/"+big.getId()+"_Blob_DM8特点.jpg");
fos2.write(big.getDescribe());
//将 photo 列信息输出到控制台 System.out.println("txt="+big.getTxt());
fos.close();
fos2.close();
} } catch (FileNotFoundException e) { e.printStackTrace();
} catch (IOException e) { e.printStackTrace();
} } }

运行结果截图。运行前如下图所示：

运行后控制台输出 Clob 里保存的大字段文本信息，如下图所示：

运行后读取处理 Image 大字段和 Blob 大字段后的信息，如下图所示：

运行后数据库数据信息如下图所示：

四、参考

示例代码下载：JAVA_Spring.zip。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

Spring 框架

一、前言 二、数据库连接
2.1 Spring 的引入
三、开发示例
3.1 基础绑定参数示例
3.2 大字段操作示例
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
