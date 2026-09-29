# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/07/03/
> 分类: 特性介绍

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
	

  

    
数据库内核月报 － 2017 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB崩溃恢复
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 阿里云RDS金融数据库(三节点版) - 背景篇
                      

                    

                    

                  
                      

                        AliSQL · 特性介绍 · 支持 Invisible Indexes
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · HybridDB for MySQL高压缩引擎TokuDB 揭秘
                      

                    

                    

                  
                      

                        MySQL · myrocks · myrocks写入分析
                      

                    

                    

                  
                      

                        MSSQL · 实现分析 · Extend Event实现审计日志对SQL Server性能影响
                      

                    

                    

                  
                      

                        HybridDB · 源码分析 · MemoryContext 内存管理和内存异常分析
                      

                    

                    

                  
                      

                        MySQL · 实现分析 · HybridDB for MySQL 数据压缩
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · CPU满问题处理
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · InnoDB 异步IO工作流程
                      

                    

 
        

    

  

    
 AliSQL · 特性介绍 · 支持 Invisible Indexes  

    
 Author: fungo  

  

  

  
前言

MySQL 8.0 引入了 Invisible Indexes 这一个特性，对于 DBA 同学来说是一大福音，索引生命周期管理除了有和无外，又多了一种形态–可见和不可见，进而对业务SQL的调优又多了一种手段。

关于 Invisible Indexes，不管是官方还是第三方，都有非常多的介绍文档，这里推荐大家可以先看下：

  

官方文档: Invisible Indexes

  

官方 server 层团队博客: MySQL 8.0: Invisible Indexes

  

官方 worklog: WL#8697: Support for INVISIBLE indexes

  

Percona blog: Thoughts on MySQL 8.0 Invisible Indexes

  

我们的 weixiang 同学的文章：MySQL · 8.0新特性· Invisible Index

简单来说，Invisible Indexes 的特点是：对优化器来说是不可见的，但是引擎内部还是会维护这个索引，并且不可见属性的修改操只改了元数据，所以可以非常快。
当我们发现某个索引不需要，想要去掉的话，可以先把索引设置为不可见，观察下业务的反应，如果一切正常，就可以 drop 掉；如果业务有受影响，那么说明这个索引删掉会有问题，就可以快速改回来。所以相对于 DROP/ADD 索引这种比较重的操作，Invisible Indexes 就会显得非常灵活方便。

Invisible Indexes 是 server 层的特性，和引擎无关，因此所有引擎（InnoDB, TokuDB, MyISAM, etc.）都可以使用。

MySQL 官方只在 8.0 版本中支持了这一特性，考虑到 8.0 的普及还比较遥远，为了让大家能早日用上这么好的功能，我们将 Invisible Indexes 这一特性 backport 到 
AliSQL
 分支，目前开源分支已经支持，大家可以下载使用。

用法介绍

虽然官方文档里有详细的使用介绍，本文为了完整性，也简单介绍下使用方法。

  

    
CREATE TABLE： 我们可以在建表时指定索引的不可见属性，默认是可见的。

    

 CREATE TABLE `t1` (
   `id` int(11) DEFAULT NULL,
   `tid` int(11) DEFAULT NULL,
   KEY `idx_tid` (`tid`) INVISIBLE
 ) ENGINE=InnoDB;

    

  

  

    
ADD INDEX: 我们可以在后续加索引时，指定加的索引是否可见

    

 CREATE TABLE `t1` (
   `id` int(11) DEFAULT NULL,
   `tid` int(11) DEFAULT NULL
   ) ENGINE=InnoDB;
 CREATE INDEX idx_tid ON t1(tid) INVISIBLE;
 ALTER TABLE t1 ADD INDEX idx_tid(tid) INVISIBLE;

    

  

  

    
ALTER INDEX: 我们可以在后续使用时，更改已有索引的可见性

    

 CREATE TABLE `t1` (
   `id` int(11) DEFAULT NULL,
   `tid` int(11) DEFAULT NULL,
   KEY `idx_tid` (`tid`) INVISIBLE
 ) ENGINE=InnoDB;
 ALTER TABLE t1 ALTER INDEX idx_tid VISIBLE;

    

  

  

    
展示信息增加：
INFORMATION_SCHEMA.STATISTICS
 内存表和 
SHOW INDEX
 结果里，分别多了一个 Visible/IS_VISIBLE 字段，表示索引是否可见：

    

 mysql> SHOW INDEX FROM t1\G
 *************************** 1. row ***************************
 Table: t1
 Non_unique: 1
 Key_name: idx_tid
 Seq_in_index: 1
 Column_name: tid
 Collation: A
 Cardinality: 0
 Sub_part: NULL
 Packed: NULL
 Null: YES
 Index_type: BTREE
 Comment:
 Index_comment:
 Visible: NO

 mysql> SELECT * FROM INFORMATION_SCHEMA.STATISTICS where table_name='t1' AND index_name='idx_tid'\G
 *************************** 1. row ***************************
 TABLE_CATALOG: def
 TABLE_SCHEMA: test
 TABLE_NAME: t1
 NON_UNIQUE: 1
 INDEX_SCHEMA: test
 INDEX_NAME: idx_tid
 SEQ_IN_INDEX: 1
 COLUMN_NAME: tid
 COLLATION: A
 CARDINALITY: 0
 SUB_PART: NULL
 PACKED: NULL
 NULLABLE: YES
 INDEX_TYPE: BTREE
 COMMENT:
 INDEX_COMMENT:
 IS_VISIBLE: NO
 1 row in set (0.00 sec)

    

  

下面我们用一例子来看下:

CREATE TABLE `t1` (
  `id` int(11) DEFAULT NULL,
  `tid` int(11) DEFAULT NULL,
  KEY `idx_tid` (`tid`) /*!50616 INVISIBLE */
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO t1 VALUES(1, 2), (3, 4), (5, 6), (7, 8), (9, 10);

可以看到下面的 EXPLAIN 结果，用的是全表扫描：

mysql> EXPLAIN SELECT * FROM t1 WHERE tid=4;
+----+-------------+-------+------+---------------+------+---------+------+------+-------------+
| id | select_type | table | type | possible_keys | key  | key_len | ref  | rows | Extra       |
+----+-------------+-------+------+---------------+------+---------+------+------+-------------+
|  1 | SIMPLE      | t1    | ALL  | NULL          | NULL | NULL    | NULL |    5 | Using where |
+----+-------------+-------+------+---------------+------+---------+------+------+-------------+
1 row in set (0.00 sec)

如果用 FORCE INDEX 强制指定的话，会报索引不存在的错（这个官方早期版本是不会报错的，最新新版本已经fix）：

mysql> EXPLAIN SELECT * FROM t1 FORCE INDEX(idx_tid) WHERE tid=4;
ERROR 1176 (42000): Key 'idx_tid' doesn't exist in table 't1'

索引改为可见之后，优化器就可以用了：

mysql> ALTER TABLE t1 ALTER INDEX idx_tid VISIBLE;
mysql> EXPLAIN SELECT * FROM t1 WHERE tid=4;
+----+-------------+-------+------+---------------+---------+---------+-------+------+-------+
| id | select_type | table | type | possible_keys | key     | key_len | ref   | rows | Extra |
+----+-------------+-------+------+---------------+---------+---------+-------+------+-------+
|  1 | SIMPLE      | t1    | ref  | idx_tid       | idx_tid | 5       | const |    1 | NULL  |
+----+-------------+-------+------+---------------+---------+---------+-------+------+-------+
1 row in set (0.00 sec)

虽然索引对优化器不可见，但是 MySQL 内部还是会维护索引的，包括约束条件，可以看下面这个例子：

CREATE TABLE `t2` (
`id` int(11) NOT NULL DEFAULT '0',
`tid` int(11) DEFAULT NULL,
PRIMARY KEY (`id`),
UNIQUE KEY `idx_tid` (`tid`) INVISIBLE
) ENGINE=InnoDB;

mysql> INSERT INTO t2 VALUES (1, 2), (3, 4);
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO t2 VALUES (5, 2);
ERROR 1062 (23000): Duplicate entry '2' for key 'idx_tid'

可以看到虽然 
idx_tid
 索引不可见，但是 UNIQUE 约束还是被遵守的。

使用注意和实现区别

使用注意：

  
PK 不能设置为不可见，这里的 PK 包括显示的PK，或者因为PK不存在，被提升为 PK 的 UK；

  
虽然设置索引的不可见属性不需要重建表，但是改变了表定义（frm），需要重新打开表，因此会请求 MDL 排它锁，如果有大事务或者长SQL，会被 block，这点使用时需要注意；

  
INFORMATION_SCHEMA.STATISTICS 内存表和 SHOW INDEX 结果里多一个字段，如果有用到的话，需要做好兼容。

另外 AliSQL 支持索引使用统计(
INFORMATION_SCHEMA.INDEX_STATISTICS
)，和 Invisible Indexes 配合使用效果更佳，比如我们可以根据索引使用找出使用频率低的索引，然后快速设置为不可见，如果业务没有影响的话，就可以进一步 DROP 掉索引。

实现上区别：

官方的 INVISIBLE INDEX 是实现在 8.0 里的，而在 8.0 其中一个重大改变，就是引入了 Data Dictionary，把原来在 Server 层放的元文件（.frm, .par, etc.）里的信息，全放在 InnoDB 里了。AliSQL 是 5.6 版本的，因此在元信息还是存储在 frm 文件里。这里有一个问题是，其中索引标志位占2个字节，目前16个 bit 已经全部被定义，如果扩展标志位的话，会造成不兼容，因为这里用了一个原先不会存在 frm 里flag 
HA_SORT_ALLOWS_SAME
 来存储在 frm 表示索引不可见，这是为了保证兼容性，实现上比较 trick 的地方。

  

    

		

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
