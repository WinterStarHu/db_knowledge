# iBatis 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/java-iBatis-frame.html

iBatis 框架 | 达梦技术文档

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

iBatis 框架

一、前言

iBatis 一词来源于“internet”和“abatis”的组合，是一个由 Clinton Begin 在  2001 年发起的开放源代码项目。于 2010 年 6 月 16 号被谷歌托管，改名为 MyBatis。iBatis 是一个基于 SQL 映射支持 JAVA 和 .NET 的持久层框架。

二、数据库连接

2.1 iBatis 框架引入

1.准备项目所需 jar 包：JAVA_iBatis_lib.zip 。

2.新建项目 JAVA_iBatis，并导入项目所需 jar 包，如下图所示：

注意

复制 jar 包到 lib 文件夹后，要选择所有 jar 包，点击鼠标右键，选择 Build path-->Add to Build path。

在 src 源码目录下创建如下包名，完整项目目录结构如下图所示：

4. 书写 iBatis 的主配置文件：SqlMapConfig.xml，存放 src 目录下。SqlMapConfig.xml 文件如下所示：

<!DOCTYPE sqlMapConfig PUBLIC "-//iBATIS.com//DTD SQL Map Config 2.0//EN" "http://www.ibatis.com/dtd/sql-map-config-2.dtd"> <settings cacheModelsEnabled="true" enhancementEnabled="true" lazyLoadingEnabled="true" errorTracingEnabled="true" maxRequests="32" maxSessions="10" maxTransactions="5" useStatementNamespaces="false" />

添加 jdbc.properties 配置文件（主要配置 driver、url、username、password 等）。修改数据库连接信息，只修改 jdbc.properties 里的字段即可。

jdbc.properties 文件如下所示：

jdbc.driver=dm.jdbc.driver.DmDriver jdbc.url=jdbc:dm://localhost:5236 jdbc.username=SYSDBA jdbc.password=*****

三、开发示例

3.1 基础绑定参数示例

基本操作使用的数据表为示例库中 Product 的 PRODUCT_CATEGORY 表，对应于数据库表添加实体类 PRODUCT_CATEGORY，其位置放 dameng.pojo 下。

操作数据库对应的实体类

PRODUCT_CATEGORY.java 文件如下所示：

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

集中管理 SQL 语句的配置文件 ProductCategory.xml

此配置文件由 SqlMapConfig.xml 配置文件映射。

<!DOCTYPE sqlMap PUBLIC "-//iBATIS.com//DTD SQL Map 2.0//EN" "http://www.ibatis.com/dtd/sql-map-2.dtd">

<select id="selectProductCategoryById" parameterClass="java.lang.Integer" resultMap="ProductCategory"> select * from PRODUCTION.PRODUCT_CATEGORY WHERE PRODUCT_CATEGORYID = #productCategoryId#;
elect count(*) from PRODUCTION.PRODUCT_CATEGORY;
select * from PRODUCTION.PRODUCT_CATEGORY;
INSERT into PRODUCTION.PRODUCT_CATEGORY(name)VALUES (
#name#
);
delete from PRODUCTION.PRODUCT_CATEGORY where PRODUCT_CATEGORYID = #productCategoryId#;
update PRODUCTION.PRODUCT_CATEGORY set NAME = #name# where PRODUCT_CATEGORYID = #productCategoryId#

测试类

TestProduct.java 文件如下所示：

package dameng.test;
import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import dameng.pojo.ProductCategory;
public class TestProduct { SqlMapClient sqlMap = null;
Reader reader = null;
@Before public void before() { try { //1. 读取 SqlMapConfig.xml 配置文件 reader = Resources.getResourceAsReader("SqlMapConfig.xml");
//2. 通过读取的配置文件构建 sqlMap 对象 sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
} catch (IOException e) { e.printStackTrace();
} } //测试插入信息 @Test public void testInstert(){ try { //注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 sqlMap.insert("insertProductCategory",new ProductCategory(null, "物理"));
} catch (SQLException e) { e.printStackTrace();
} } //测试修改信息 @Test public void testUpdate(){ ProductCategory productCategory;
try { productCategory = (ProductCategory) sqlMap.queryForObject("selectProductCategoryById",4);
productCategory.setName("英语2");
//注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 sqlMap.update("updateProductCategory", productCategory);
} catch (SQLException e) { e.printStackTrace();
} } //测试根据 ID 查询指定人信息 @Test public void testSelectPersonById(){ ProductCategory productCategory;
try { //注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 productCategory = (ProductCategory) sqlMap.queryForObject("selectProductCategoryById",4);
System.out.println(productCategory);
} catch (SQLException e) { e.printStackTrace();
} } //测试全查 @Test public void testSelectAll(){ List list;
try { //注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 list = sqlMap.queryForList("selectAll");
for(ProductCategory p: list){ System.out.println(p);
} } catch (SQLException e) { e.printStackTrace();
} } //测试删除 @Test public void testDelete(){ try { //注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 sqlMap.delete("deleteById",5);
} catch (SQLException e) { e.printStackTrace();
} }

@After public void after() { try { reader.close();
} catch (IOException e) { e.printStackTrace();
} } public static void main(String[] args) { TestProduct test = new TestProduct();
test.before();
test.testInstert();
test.testUpdate();
test.testSelectPersonById();
test.testSelectAll();
test.testDelete();
} }

运行结果截图。运行后控制台输出结果如下图所示：

运行后数据库数据如下图所示：

3.2 大字段操作示例

创建需要操作的含大字段类型的数据表。

CREATE TABLE "PRODUCTION"."BIG_DATA" ( "ID" INT IDENTITY(1, 1) NOT NULL, "PHOTO" IMAGE, "DESCRIBE" BLOB, "TXT" CLOB, NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "BOOKSHOP", CLUSTERBTR) ;

在 D 盘根目录下，创建 DM8 特点 .jpg、达梦产品简介 .txt 两个文件，作为大字段存储，如下图所示：

操作数据库对应的实体类。BigData.java 文件如下所示：

package dameng.pojo;

public class BigData { private Long id;
private byte[] photo; //iBatis 将 Image 和 Blob 映射成 byte[] private byte[] describe;
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

集中管理 SQL 语句的配置文件 BigData.xml。此配置文件由 SqlMapConfig.xml 配置文件映射。

<!DOCTYPE sqlMap PUBLIC "-//iBATIS.com//DTD SQL Map 2.0//EN" "http://www.ibatis.com/dtd/sql-map-2.dtd">

--> select * from PRODUCTION.BIG_DATA;
INSERT into PRODUCTION.BIG_DATA(photo,describe,txt)VALUES (
#photo#,#describe#,#txt#
);

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
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import dameng.pojo.BigData;
import dameng.pojo.ProductCategory;
public class TestBigData { SqlMapClient sqlMap = null;
Reader reader = null;
@Before public void before() { try { //1. 读取 SqlMapConfig.xml 配置文件 reader = Resources.getResourceAsReader("SqlMapConfig.xml");
//2. 通过读取的配置文件构建 sqlMap 对象 sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
} catch (IOException e) { e.printStackTrace();
} } //测试插入大字段表 @Test public void testInstert(){ try { String filePath = "D:\\DM8特点.jpg";
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
//注意此处 sqlmap 调用传递的字符串参数与对应 xml 文件里 SQL 语句的 ID 相对应 sqlMap.insert("insertBigData",bigData);
} catch (SQLException e) { e.printStackTrace();
} catch (FileNotFoundException e) { e.printStackTrace();
} catch (UnsupportedEncodingException e) { e.printStackTrace();
} catch (IOException e) { e.printStackTrace();
} } //测试查询大字段表 @Test public void testSelectAll(){ try { List list = sqlMap.queryForList("selectAllBigData");
for(BigData big:list) { //打印出 id System.out.println("id = "+big.getId());
//将 photo 列信息输出到指定路径 FileOutputStream fos = new FileOutputStream("D:/"+big.getId()+"_DM8特点.jpg");
fos.write(big.getPhoto());
//将 describe 列信息输出到指定路径 FileOutputStream fos2 = new FileOutputStream("D:/"+big.getId()+"_Blob_DM8特点.jpg");
fos2.write(big.getDescribe());
//将 photo 列信息输出到控制台 System.out.println("txt="+big.getTxt());
fos.close();
fos2.close();
} } catch (FileNotFoundException e) { e.printStackTrace();
} catch (IOException e) { e.printStackTrace();
} catch (SQLException e) { e.printStackTrace();
} } @After public void after() { try { reader.close();
} catch (IOException e) { e.printStackTrace();
} } public static void main(String[] args) { TestBigData test = new TestBigData();
test.before();
test.testInstert();
test.testSelectAll();
test.after();
} }

运行结果截图。运行前如下图所示：

运行后控制台输出 Clob 里保存的大字段文本信息，如下图所示：

运行后读取处理 Image 大字段和 Blob 大字段后的信息，如下图所示：

运行后数据库数据信息如下图所示：

四、参考

示例代码下载：JAVA_iBatis.zip。

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

iBatis 框架

一、前言 二、数据库连接
2.1 iBatis 框架引入
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
