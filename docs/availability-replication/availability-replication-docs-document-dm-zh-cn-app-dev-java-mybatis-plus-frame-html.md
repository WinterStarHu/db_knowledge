# MyBatis-Plus 框架 | 达梦技术文档

> 来源: https://eco.dameng.com/document/dm/zh-cn/app-dev/java-MyBatis-Plus-frame.html

MyBatis-Plus 框架 | 达梦技术文档

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

MyBatis-Plus 框架

一、前言

MyBatis-Plus（简称 MP ）是一个 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。

二、数据库连接

2.1 MyBatis-Plus 增强工具的引入

mybatis-plus 依托于 mybatis，两者相辅相成，MyBatis-Plus 增强工具的引入不会对 mybatis 框架造成影响。

准备项目所需 jar 包：JAVA_Mybatis_Plus_lib.zip。

注意

mybatis-plus3.0 之后的版本才支持 DM 数据库，在选择使用 mybatisplus-jar 包版本时请注意版本号。

若选择的 mybatis-plus 版本不支持 DM 数据库则会报错，如下图所示：

新建项目 Java_Mybatis_Plus，并导入项目所需 jar 包，如下图所示：

注意

复制 jar 包到 lib 文件夹后，要选择所有 jar 包，点击鼠标右键，选择 Build path-->Add to Build path。

在 src 源码目录下创建如下包名，完整项目目录结构如下图所示：

书写 Mybatis 的主配置文件：mybatis-config.xml，存放在 src 目录下。mybatis-config.xml 文件如下所示：

<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd"> -->

添加 jdbc.properties 配置文件，(主要配置 driver、url、username、password 等)。修改数据库连接信息，只修改 jdbc.properties 里的字段即可。jdbc.properties 文件如下所示：

jdbc.driver=dm.jdbc.driver.DmDriver jdbc.url=jdbc:dm://localhost:5236 jdbc.username=SYSDBA jdbc.password=*****

三、开发示例

3.1 基本绑定变量操作示例

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

数据访问层接口。此处使用 mybatisplus 工具，接口继承 BaseMapper 规定泛型为 ProductCategory，无需自己手动添加增删改查接口。ProductCategoryMapper.java 文件如下所示：

package dameng.dao;
import org.apache.ibatis.annotations.Mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import dameng.pojo.ProductCategory;

@Mapper public interface ProductCategoryMapper extends BaseMapper{ }

数据访问层接口对应配置文件。由于此处使用 mybatisplus 工具，该工具自动映射与之前相应的 mapper 接口，无需再写基础增删改查方法的 xml。

<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

测试类。TestProduct.java 文件如下所示：

package dameng.test;
import java.io.InputStream;
import java.util.List;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import com.baomidou.mybatisplus.core.MybatisSqlSessionFactoryBuilder;
import dameng.dao.ProductCategoryMapper;
import dameng.pojo.ProductCategory;
public class TestProduct { SqlSession sqlSession = null;
ProductCategoryMapper productCategoryMapper = null;
public void init() { try { //1. 生成 sqlsession factory biulder 对象 MybatisSqlSessionFactoryBuilder builder = new MybatisSqlSessionFactoryBuilder();
//2. 加载配置文件作为一个输入流 InputStream resourceAsStream = Resources.getResourceAsStream("mybatis-config.xml");
SqlSessionFactory factory = builder.build(resourceAsStream);
//这里 Resources 使用的包是 ibatis 包 //3. 通过会话工厂构造器对象和配置文件流构建一个会话构造工厂 //4. 通过 SQL 会话工厂 //true 设置 mybatis 事务自动提交 sqlSession = factory.openSession(true);
productCategoryMapper = sqlSession.getMapper(ProductCategoryMapper.class);
}catch (Exception e){ e.printStackTrace();
} } //测试插入信息 @Test public void testInstert(){ productCategoryMapper.insert((new ProductCategory(null, "语文")));
} //测试修改信息 @Test public void testUpdate(){ ProductCategory productCategory = productCategoryMapper.selectById(4);
productCategory.setName("英语");
productCategoryMapper.updateById(productCategory);
} //测试根据 ID 查询指定人信息 @Test public void testSelectPersonById(){ ProductCategory productCategory = productCategoryMapper.selectById(1);
System.out.println(productCategory);
} //测试全查 @Test public void testSelectAll(){ List selectList = productCategoryMapper.selectList(null);
for(ProductCategory p: selectList){ System.out.println(p);
} } //测试删除 @Test public  void testDelete(){ productCategoryMapper.deleteById(5);
} //测试增删改查 public static void main(String[] args) { TestProduct test = new TestProduct();
test.init();
test.testInstert();
test.testSelectPersonById();
test.testUpdate();
test.testSelectAll();
test.testDelete();
} }

运行结果截图。运行后控制台输出结果如下图所示：

运行后数据库数据如下图所示：

3.2 大字段操作示例

创建需要操作的含大字段类型的数据表。

CREATE TABLE "PRODUCTION"."BIG_DATA" ( "ID" INT IDENTITY(1, 1) NOT NULL, "PHOTO" IMAGE, "DESCRIBE" BLOB, "TXT" CLOB, NOT CLUSTER PRIMARY KEY("ID")) STORAGE(ON "BOOKSHOP", CLUSTERBTR) ;

在 D 盘根目录下，创建 DM8 特点 .jpg、达梦产品简介.txt 两个文件，作为大字段存储，如下图所示：

操作数据库对应的实体类。TestBigData.java 文件如下所示：

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

数据访问层接口对应配置文件。

<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

测试类。TestBigData.java 文件如下所示：

package dameng.test;
import java.io.*;
import java.util.List;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.*;
import com.baomidou.mybatisplus.core.MybatisSqlSessionFactoryBuilder;
import dameng.dao.BigDataMapper;
import dameng.pojo.BigData;
public class TestBigData { SqlSession sqlSession = null;
BigDataMapper bigDataMapper = null;
public void init() { try { //1. 生成 sqlsession factory biulder 对象 MybatisSqlSessionFactoryBuilder sfb = new MybatisSqlSessionFactoryBuilder();
//2. 加载配置文件作为一个输入流 //这里 Resources 使用的包是 ibatis 包 InputStream resourceAsStream;
resourceAsStream = Resources.getResourceAsStream("mybatis-config.xml");
//3. 通过会话工厂构造器对象和配置文件流构建一个会话构造工厂 SqlSessionFactory factory = sfb.build(resourceAsStream);
//4. 通过 SQL 会话工厂 //true 设置 mybatis 事务自动提交 sqlSession = factory.openSession(true);
bigDataMapper = sqlSession.getMapper(BigDataMapper.class);
resourceAsStream.close();
} catch (IOException e) { e.printStackTrace();
} } public static void main(String[] args) { TestBigData test = new TestBigData();
test.init();
test.testInsert();
test.testSelect();
} //测试插入大字段表 private void testInsert() { try { String filePath = "D:\\DM8特点.jpg";
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
} } //测试查询大字段表 private void testSelect() { List list = bigDataMapper.selectList(null);
try { for(BigData big:list) { //打印出id System.out.println("id = "+big.getId());
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

示例代码下载：JAVA_Mybatis_Plus.zip

以上文档内容参考过程中遇到任何问题，可到 达梦技术社区 提问交流。

上次更新：2026-09-26 上一篇下一篇

MyBatis-Plus 框架

一、前言 二、数据库连接
2.1 MyBatis-Plus 增强工具的引入
三、开发示例
3.1 基本绑定变量操作示例
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
