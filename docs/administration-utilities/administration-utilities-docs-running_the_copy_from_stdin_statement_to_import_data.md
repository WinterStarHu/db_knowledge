# 使用COPY FROM STDIN导入数据

## 概述

用户可以使用以下方式通过COPY FROM STDIN语句直接向openGauss写入数据。

- 通过键盘输入向openGauss数据库写入数据。详细请参见[COPY](../sql_reference/copy.md)。
- 通过JDBC驱动的CopyManager接口从文件或者数据库向openGauss写入数据。此方法支持COPY语法中copy option的所有参数。

## CopyManager类简介

CopyManager是 openGauss JDBC驱动中提供的一个API接口类，用于批量向openGauss数据库中导入数据。

### CopyManager的继承关系

CopyManager类位于org.opengauss.copy Package中，继承自java.lang.Object类，该类的声明如下：

```
public class CopyManager
extends Object
```

### 构造方法

public CopyManager\(BaseConnection connection\)

throws SQLException

### 常用方法

**表 1**  CopyManager常用方法

返回值 throws CopyIn copyIn(String sql) SQLException long copyIn(String sql, InputStream from) 使用COPY FROM STDIN从InputStream中快速向数据库中的表导入数据。
SQLException,IOException long copyIn(String sql, InputStream from, int bufferSize) 使用COPY FROM STDIN从InputStream中快速向数据库中的表导入数据。
SQLException,IOException long copyIn(String sql, Reader from) 使用COPY FROM STDIN从Reader中快速向数据库中的表导入数据。
SQLException,IOException long copyIn(String sql, Reader from, int bufferSize) 使用COPY FROM STDIN从Reader中快速向数据库中的表导入数据。
SQLException,IOException CopyOut copyOut(String sql) SQLException long copyOut(String sql, OutputStream to) 将一个COPY TO STDOUT的结果集从数据库发送到OutputStream类中。
SQLException,IOException long copyOut(String sql, Writer to) 将一个COPY TO STDOUT的结果集从数据库发送到Writer类中。
SQLException,IOException

## 处理错误表

### 操作场景

当数据导入发生错误时，请根据本文指引信息进行处理。

### 查询错误信息

数据导入过程中发生的错误，一般分为数据格式错误和非数据格式错误。

- 数据格式错误

在创建外表时，通过设置参数“LOG INTO error\_table\_name”，将数据导入过程中出现的数据格式错误信息写入指定的错误信息表error\_table\_name中。您可以通过以下SQL，查询详细错误信息。

    ```
    openGauss=# SELECT * FROM error_table_name;
    ```

错误信息表结构如[表1](#zh-cn_topic_0117407722_taed071c5571f4f9a834bdacaf251bac5)所示。

**表 1**  错误信息表

列名称 nodeid integer 报错节点编号。
begintime timestamp with time zone 出现数据格式错误的时间。
filename character varying 出现数据格式错误的数据源文件名。
rownum numeric 在数据源文件中，出现数据格式错误的行号。
rawrecord text 在数据源文件中，出现数据格式错误的原始记录。
detail text 详细错误信息。

- 非数据格式错误

对于非数据格式错误，一旦发生将导致整个数据导入失败。您可以根据执行数据导入过程中，界面提示的错误信息，帮助定位问题，处理错误表。

### 处理数据导入错误

根据获取的错误信息，请对照下表，处理数据导入错误。

**表 2**  处理数据导入错误

错误信息 解决办法 missing data for column "r_reason_desc" 数据源文件中的列数比外表定义的列数少。对于TEXT格式的数据源文件，由于转义字符（\）导致delimiter（分隔符）错位或者quote（引号字符）错位造成的错误。示例：目标表存在3列字段，导入的数据如下所示。由于存在转义字符“\”，分隔符“|”被转义为第二个字段的字段值，导致第三个字段值缺失。
BE|Belgium\|1 由于列数少导致的报错，选择下列办法解决：在数据源文件中，增加列“r_reason_desc”的字段值。在创建外表时，将参数“fill_missing_fields”设置为“on”。即当导入过程中，若数据源文件中一行数据的最后一个字段缺失，则把最后一个字段的值设置为NULL，不报错。
对由于转义字符导致的错误，需检查报错的行中是否含有转义字符（\）。若存在，建议在创建外表时，将参数“noescaping”（是否不对'\'和后面的字符进行转义）设置为true。
extra data after last expected column 数据源文件中的列数比外表定义的列数多。
在数据源文件中，删除多余的字段值。在创建外表时，将参数“ignore_extra_data”设置为“on”。即在导入过程中，若数据源文件比外表定义的列数多，则忽略行尾多出来的列。
invalid input syntax for type numeric: "a" 数据类型错误。
在数据源文件中，修改输入字段的数据类型。根据此错误信息，请将输入的数据类型修改为numeric。
null value in column "staff_id" violates not-null constraint 非空约束。
在数据源文件中，增加非空字段信息。根据此错误信息，请增加“staff_id”列的值。
duplicate key value violates unique constraint "reg_id_pk" 唯一约束。
删除数据源文件中重复的行。通过设置关键字“DISTINCT”，从SELECT结果集中删除重复的行，保证导入的每一行都是唯一的。openGauss=# INSERT INTO reasons SELECT DISTINCT * FROM foreign_tpcds_reasons;
value too long for type character varying(16) 字段值长度超过限制。
在数据源文件中，修改字段值长度。根据此错误信息，字段值长度限制为VARCHAR2(16)。

## 示例1：通过本地文件导入导出数据

在使用JAVA语言基于openGauss进行二次开发时，可以使用CopyManager接口，通过流方式，将数据库中的数据导出到本地文件或者将本地文件导入数据库中，文件格式支持CSV、TEXT等格式。

样例程序如下，执行时需要加载openGauss的JDBC驱动。

```
import java.sql.Connection;
import java.sql.DriverManager;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.SQLException;
import org.opengauss.copy.CopyManager;
import org.opengauss.core.BaseConnection;

public class Copy{

     public static void main(String[] args)
     {
      String urls = new String("jdbc:opengauss://localhost:8000/postgres"); //数据库URL
      String username = new String("username");            //用户名
      String password = new String("passwd");             //密码
      String tablename = new String("migration_table"); //定义表信息
      String tablename1 = new String("migration_table_1"); //定义表信息
      String driver = "org.opengauss.Driver";
      Connection conn = null;

      try {
          Class.forName(driver);
          conn = DriverManager.getConnection(urls, username, password);
      } catch (ClassNotFoundException e) {
           e.printStackTrace(System.out);
      } catch (SQLException e) {
           e.printStackTrace(System.out);
      }

      // 将表migration_table中数据导出到本地文件d:/data.txt
      try {
          copyToFile(conn, "d:/data.txt", "(SELECT * FROM migration_table)");
      } catch (SQLException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      } catch (IOException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      }
      //将d:/data.txt中的数据导入到migration_table_1中。
      try {
          copyFromFile(conn, "d:/data.txt", tablename1);
      } catch (SQLException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      } catch (IOException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      }

      // 将表migration_table_1中的数据导出到本地文件d:/data1.txt
      try {
          copyToFile(conn, "d:/data1.txt", tablename1);
      } catch (SQLException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      } catch (IOException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
      }
  }

  public static void copyFromFile(Connection connection, String filePath, String tableName)
         throws SQLException, IOException {

     FileInputStream fileInputStream = null;

     try {
         CopyManager copyManager = new CopyManager((BaseConnection)connection);
         fileInputStream = new FileInputStream(filePath);
         copyManager.copyIn("COPY " + tableName + " FROM STDIN ", fileInputStream);
     } finally {
         if (fileInputStream != null) {
             try {
                 fileInputStream.close();
             } catch (IOException e) {
                 e.printStackTrace();
             }
         }
     }
 }
     public static void copyToFile(Connection connection, String filePath, String tableOrQuery)
          throws SQLException, IOException {

      FileOutputStream fileOutputStream = null;

      try {
          CopyManager copyManager = new CopyManager((BaseConnection)connection);
          fileOutputStream = new FileOutputStream(filePath);
          copyManager.copyOut("COPY " + tableOrQuery + " TO STDOUT", fileOutputStream);
      } finally {
          if (fileOutputStream != null) {
              try {
                  fileOutputStream.close();
              } catch (IOException e) {
                  e.printStackTrace();
              }
          }
      }
  }
}
```

## 示例2：从MY向openGauss数据库进行数据迁移

下面示例演示如何通过CopyManager从MY向openGauss数据库进行数据迁移的过程。

```
import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.opengauss.copy.CopyManager;
import org.opengauss.core.BaseConnection;

public class Migration{

    public static void main(String[] args) {
        String url = new String("jdbc:opengauss://localhost:8000/postgres"); //数据库URL
        String user = new String("username");            //openGauss数据库用户名
        String pass = new String("passwd");             //openGauss数据库密码
        String tablename = new String("migration_table_1"); //定义表信息
        String delimiter = new String("|");              //定义分隔符
        String encoding = new String("UTF8");            //定义字符集
        String driver = "org.opengauss.Driver";
        StringBuffer buffer = new StringBuffer();       //定义存放格式化数据的缓存

        try {
            //获取源数据库查询结果集
            ResultSet rs = getDataSet();

            //遍历结果集，逐行获取记录
            //将每条记录中各字段值，按指定分隔符分割，由换行符结束，拼成一个字符串
            //把拼成的字符串，添加到缓存buffer
            while (rs.next()) {
                buffer.append(rs.getString(1) + delimiter
                        + rs.getString(2) + delimiter
                        + rs.getString(3) + delimiter
                        + rs.getString(4)
                        + "\n");
            }
            rs.close();

            try {
                //建立目标数据库连接
                Class.forName(driver);
                Connection conn = DriverManager.getConnection(url, user, pass);
                BaseConnection baseConn = (BaseConnection) conn;
                baseConn.setAutoCommit(false);

                //初始化表信息
                String sql = "Copy " + tablename + " from STDIN with (DELIMITER " + "'" + delimiter + "'" +","+ " ENCODING " + "'" + encoding + "')";

                //提交缓存buffer中的数据
                CopyManager cp = new CopyManager(baseConn);
                StringReader reader = new StringReader(buffer.toString());
                cp.copyIn(sql, reader);
                baseConn.commit();
                reader.close();
                baseConn.close();
            } catch (ClassNotFoundException e) {
                e.printStackTrace(System.out);
            } catch (SQLException e) {
                e.printStackTrace(System.out);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //********************************
    // 从源数据库返回查询结果集
    //*********************************
    private static ResultSet getDataSet() {
        ResultSet rs = null;
        try {
            Class.forName("com.MY.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection("jdbc:MY://10.119.179.227:3306/jack?useSSL=false&allowPublicKeyRetrieval=true", "jack", "******");
            Statement stmt = conn.createStatement();
            rs = stmt.executeQuery("select * from migration_table");
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rs;
    }
}
```
