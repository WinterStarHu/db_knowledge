# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/09/03/
> 分类: migration/upgrade

数据库内核月报
 -->
  

  

  

  

  

  

  

  

  

  
 -->
  
hljs.initHighlightingOnLoad();

  

  

  

  

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-62056244-1', 'auto');
  ga('send', 'pageview');

 -->

  

  

  数据库内核月报
	

  

    
数据库内核月报 － 2016 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 社区贡献 · AliSQL那些事儿
                      

                    

                    

                  
                      

                        PetaData · 架构体系 · PetaData第二代低成本存储体系
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MariaDB 10.2 前瞻
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 执行计划缓存设计与实现
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · pg_rman源码浅析与使用
                      

                    

                    

                  
                      

                        MySQL · 捉虫状态 · bug分析两例
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PG优化器浅析
                      

                    

                    

                  
                      

                        MongoDB · 特性分析· Sharding原理与应用
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PG中的无锁算法和原子操作应用一则
                      

                    

                    

                  
                      

                        SQLServer · 最佳实践 · TEMPDB的设计
                      

                    

 
        

    

  

    
 MySQL · 社区动态 · MariaDB 10.2 前瞻  

    
 Author: plinux  

  

  

  
继 MariaDB 10.1 之后，对标 MySQL 5.7 的 MariaDB 10.2 版本也即将封板，那么我们就来看看新的版本有哪些新的功能吧。

之前的月报我们写过一篇
关于 Window Function 的介绍
，除此之外，10.2.2 又即将发布一些新的特性。

Virtual Columns 进一步加强

目前有两种类型的虚拟列：PERSISTENT/STORED 类型，这种类型的虚拟列的值是直接存在表中的；而 VIRTUAL 类型，其实只是一个定义，表结构中并不包括这个列，在需要用到的时候临时计算。默认值是 VIRTUAL。

虚拟列的语法

<type>  [GENERATED ALWAYS]  AS   ( <expression> )
[VIRTUAL | PERSISTENT | STORED]  [UNIQUE] [UNIQUE KEY] [COMMENT <text>]

限制

  
只有支持的引擎才能使用虚拟列，目前InnoDB, Aria, MyISAM 和 CONNECT 引擎都能支持。

  
有限的支持虚拟列索引。VIRTUAL 类型的虚拟列不能作为主键也不能建索引。

  
PERSISTENT 类型的虚拟列可以建索引，也可以作为外键，但是不支持 ON UPDATE CASCADE, ON UPDATE SET NULL, ON DELETE SET NULL。

  
不能用使用自定义函数来定义虚拟列，内置的函数可以。

  
不能定义虚拟列的虚拟列。

用例

表结构如下

USE TEST;

CREATE TABLE table1 (
     a INT NOT NULL,
     b VARCHAR(32),
     c INT AS (a mod 10) VIRTUAL,
     d VARCHAR(5) AS (left(b,5)) PERSISTENT);

用 DESCRIBE 语法来看表结构，在 Extra 列能看到相关的信息。

DESCRIBE table1;
+-------+-------------+------+-----+---------+------------+
| Field | Type        | Null | Key | Default | Extra      |
+-------+-------------+------+-----+---------+------------+
| a     | int(11)     | NO   |     | NULL    |            |
| b     | varchar(32) | YES  |     | NULL    |            |
| c     | int(11)     | YES  |     | NULL    | VIRTUAL    |
| d     | varchar(5)  | YES  |     | NULL    | PERSISTENT |
+-------+-------------+------+-----+---------+------------+

再来做一些操作看效果

INSERT INTO table1 VALUES (1, 'some text',default,default);
Query OK, 1 row affected (0.00 sec)

INSERT INTO table1 VALUES (2, 'more text',5,default);
Query OK, 1 row affected, 1 warning (0.00 sec)

Warning (Code 1645): The value specified for computed column 'c' in table 'table1' ignored.

INSERT INTO table1 VALUES (123, 'even more text',default,'something');
Query OK, 1 row affected, 2 warnings (0.00 sec)

Warning (Code 1645): The value specified for computed column 'd' in table 'table1' ignored.
Warning (Code 1265): Data truncated for column 'd' at row 1

SELECT * FROM table1;
+-----+----------------+------+-------+
| a   | b              | c    | d     |
+-----+----------------+------+-------+
|   1 | some text      |    1 | some  |
|   2 | more text      |    2 | more  |
| 123 | even more text |    3 | even  |
+-----+----------------+------+-------+
3 rows in set (0.00 sec)

可以看到虚拟列都起效果了。

DEFAULT 支持表达式

在当前的所有MySQL版本及分支中，都只能定义固定的 DEFAULT 值，或者特定的类型如 AUTO_INCREMENT， CURRENT_TIMESTAMP。
在 10.1 中能支持 DATETIME 类型也使用 CURRENT_TIMESTAMP 定义默认值。
然而 MariaDB 10.2 中已经可以使用表达式来定义固定值。

例如你可以这么定义：

CREATE TABLE t1 (a int DEFAULT (1+1), b int DEFAULT (a+1));
CREATE TABLE t2 (a bigint primary key DEFAULT UUID_SHORT());

但是表达式不支持存储函数和子查询，而且表达式中如果包含另外的列，那么那个列必须在当前列之前定义了。

并且 BLOB 和 TEXT 类型也支持DEFAULT值定义了。

但是必须注意，在 DEFAULT 使用表达式，必须使用ROW格式才能保证复制的数据安全，当然，任何时候我们都建议使用ROW_FORMAT。

外键定义支持表达式CHECK

CHECK的语法

InnoDB是支持外键约束的，基本语法如下：

[CONSTRAINT [symbol]] FOREIGN KEY
    [index_name] (index_col_name, ...)
    REFERENCES tbl_name (index_col_name,...)
    [ON DELETE reference_option]
    [ON UPDATE reference_option]

reference_option:
    RESTRICT | CASCADE | SET NULL | NO ACTION

可以看到只能支持基本的索引列约束，相对来说是比较简单的。
MariaDB 10.2 将其扩充增加了 CHECK 语法，可以使用表达式来做约束：

CHECK(expression) # 用于检查列的值，在列定义的时候使用
CONSTRAINT [constraint_name] CHECK (expression)

用例

比如我们可以定义一张这样的表。

CREATE TABLE t1 (a INT CHECK (a>2), b INT CHECK (b>2), CONSTRAINT a_greater CHECK (a>b));

比如做一些最简单的数值检查

CREATE TABLE t1 (a INT CHECK (a>2), b INT CHECK (b>2), CONSTRAINT a_greater CHECK (a>b));

INSERT INTO t1(a) VALUES (1);
ERROR 4022 (23000): CONSTRAINT `a` failed for `test`.`t1`

INSERT INTO t1(a,b) VALUES (3,4);
ERROR 4022 (23000): CONSTRAINT `a_greater` failed for `test`.`t1`

INSERT INTO t1(a,b) VALUES (4,3);
Query OK, 1 row affected (0.04 sec)

可以看到 CHECK 检查的条件生效了。

当然更复杂一点还能引入一些内置函数，包括UDF来做检查：

CREATE TABLE t2 (name VARCHAR(30) CHECK (CHAR_LENGTH(name)>2), start_date DATE, 
  end_date DATE CHECK (start_date IS NULL OR end_date IS NULL OR start_date<end_date));

INSERT INTO t2(name, start_date, end_date) VALUES('Ione', '2003-12-15', '2014-11-09');
Query OK, 1 row affected (0.04 sec)

INSERT INTO t2(name, start_date, end_date) VALUES('Io', '2003-12-15', '2014-11-09');
ERROR 4022 (23000): CONSTRAINT `name` failed for `test`.`t2`

INSERT INTO t2(name, start_date, end_date) VALUES('Ione', NULL, '2014-11-09');
Query OK, 1 row affected (0.04 sec)

INSERT INTO t2(name, start_date, end_date) VALUES('Ione', '2015-12-15', '2014-11-09');
ERROR 4022 (23000): CONSTRAINT `end_date` failed for `test`.`t2`

这样在某些情况下可以把一些简单的逻辑检查放到数据库做，大大简化程序的设计。

总结

MariaDB 10.2 是 MariaDB 一个较大的里程碑版本，很多社区呼声很大的功能都被扩充进去，对用户来说是个福音。MariaDB和MySQL相互竞争，对整个MySQL及其兼容分支的发展都是一个很好的现象，有竞争就有动力，无论是MySQL还是MariaDB，在强大的竞争压力下，进度都快起来了，新功能不断的加入，代码不断的优化，最终受益的都是我们这些用户。

  

    

		

 -->
  

  
阿里云PolarDB-数据库内核组
 -->
  
 -->
  
社招/校招 欢迎投递简历 直达招聘信息
 -->
  
 -->
  
直连月报小编
 -->
  
 -->
  
欢迎在github上star AliSQL
 -->
  

  阅读：
 - 

  

本作品采用
知识共享署名-非商业性使用-相同方式共享 3.0 未本地化版本许可协议
进行许可。

  jQuery(document).ready(function($){
    // browser window scroll (in pixels) after which the "back to top" link is shown
    var offset = 300,
      //browser window scroll (in pixels) after which the "back to top" link opacity is reduced
      offset_opacity = 1200,
      //duration of the top scrolling animation (in ms)
      scroll_top_duration = 700,
      //grab the "back to top" link
      $back_to_top = $('.cd-top');

    //hide or show the "back to top" link
    $(window).scroll(function(){
      ( $(this).scrollTop() > offset ) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible cd-fade-out');
      if( $(this).scrollTop() > offset_opacity ) {
        $back_to_top.addClass('cd-fade-out');
      }
    });

    //smooth scroll to top
    $back_to_top.on('click', function(event){
      event.preventDefault();
      $('body,html').animate({
        scrollTop: 0 ,
        }, scroll_top_duration
      );
    });

  });
