# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/02/05/
> 分类: 答疑释惑

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
	

  

    
数据库内核月报 － 2015 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 性能优化· InnoDB buffer pool flush策略漫谈
                      

                    

                    

                  
                      

                        MySQL · 社区动态· 5.6.23 InnoDB相关Bugfix
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Replication Slot
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· pg_prewarm
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· InnoDB丢失自增值
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· 5.5 和 5.6 时间类型兼容问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· 变量修改导致binlog错误
                      

                    

                    

                  
                      

                        MariaDB · 特性分析· 表/表空间加密
                      

                    

                    

                  
                      

                        MariaDB · 特性分析· Per-query variables
                      

                    

                    

                  
                      

                        TokuDB · 特性分析· 日志详解
                      

                    

 
        

    

  

    
 MySQL · 答疑释惑· InnoDB丢失自增值  

    
 Author:   

  

  

  

背景

在上一期的月报中，我们在
InnoDB自增列重复值问题
 中提到，InnoDB 自增列在重启后会丢失，因为MySQL没有持久化自增值，平时是存在内存表对象中的。如果实例重启的话，内存值丢失，其初始化过程是做了一个类似 select max(id) + 1 操作。实际上存在另外一种场景，实例即使不重启，也会导致自增值丢失。

问题说明

实例运行过种中，InnoDB表自增值是存储在表对象中的，表对象又是放在缓存中的，如果表太多而不能全部放在缓存中的话，老的表就会被置换出来，这种被置换出来的表下次再使用的时候，就要重新打开一遍，对自增列来说，这个过程就和实例重启类似，需要 select max(id) + 1 算一下自增值。

对InnoDB来说，其数据字典中表对象缓存大小由 
table_definition_cache
 系统变量控制，在5.6.8之后，其最小值是400。和表缓存相关的另一个系统变量是
table_open_cache
，这个控制的是所有线程打开表的缓存大小，这个缓存放在server层。

下面我们用testcase的方式来给出InnoDB表对象对置换出的场景：

##把 table_definition_cache 和 table_open_cache 都设为400
SET GLOBAL table_definition_cache = 400;
SET GLOBAL table_open_cache = 400;

## 创建500个InnoDB自增表，各插入一条数据，然后把自增改为100
let $i=0;
while($i &lt; 500)
{
--eval CREATE TABLE t$i(id INT NOT NULL AUTO_INCREMENT, name VARCHAR(30), PRIMARY KEY(id)) ENGINE=InnoDB;
--eval INSERT INTO t$i(name) VALUES(&quot;InnoDB&quot;);
--eval ALTER TABLE t$i AUTO_INCREMENT = 100;
--inc $i
}

## 最后400张表扫一遍
let $i=100;
while($i &lt; 500)
{
--eval SELECT * FROM t$i;
--inc $i
}

## 稍微sleep下，等mysqld把不用的表（t0..t99）换出
sleep 5;

## 查看t1表自增
SHOW CREATE TABLE t1;

Table   Create Table
t1      CREATE TABLE `t1` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(30) DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1
...

可以看到自增值确实和重启场景一样，本应是100，却变成了 2（select max(id) + 1）了。

问题分析

原因就是缓存不够，导致表对象被换出，下次再用就要重新打开，这里给出调用栈，对代码感兴趣的同学可以看下。

将老的table置换出：

#0  dict_table_remove_from_cache_low (table=0x2b81d054e278, lru_evict=1)
at /path/to/mysql/storage/innobase/dict/dict0dict.cc:1804
#1  0x00000000011cf246 in dict_make_room_in_cache (max_tables=400, pct_check=100)
at /path/to/mysql/storage/innobase/dict/dict0dict.cc:1261
#2  0x0000000001083564 in srv_master_evict_from_table_cache (pct_check=100)
at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2017
#3  0x0000000001084022 in srv_master_do_idle_tasks () at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2212
#4  0x000000000108484a in srv_master_thread (arg=0x0) at /path/to/mysql/storage/innobase/srv/srv0srv.cc:2360
#5  0x00000030cc007851 in start_thread () from /lib64/libpthread.so.0
#6  0x00000030cbce767d in clone () from /lib64/libc.so.6

尝试从缓存加载表对象：

#0  dict_table_check_if_in_cache_low (table_name=0x2adef847db20 &quot;test/t1&quot;)
at /path/to/mysql/storage/innobase/include/dict0priv.ic:114
#1  0x00000000011cd51a in dict_table_open_on_name (table_name=0x2adef847db20 &quot;test/t1&quot;, dict_locked=0, try_drop=1,
ignore_err=DICT_ERR_IGNORE_NONE) at /path/to/mysql/storage/innobase/dict/dict0dict.cc:947
#2  0x0000000000e58d8a in ha_innobase::open (this=0x2adef9747010, name=0x2adef7460780 &quot;./test/t1&quot;, mode=2, test_if_locked=2)
at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:4776
#3  0x000000000068668b in handler::ha_open (this=0x2adef9747010, table_arg=0x2adef742bc00, name=0x2adef7460780 &quot;./test/t1&quot;, mode=2,
test_if_locked=2) at /path/to/mysql/sql/handler.cc:2525
...
#9  0x00000000009c2a84 in mysqld_show_create (thd=0x2adef47aa000, table_list=0x2adef74200f0)
at /path/to/mysql/sql/sql_show.cc:867
#10 0x00000000009553b1 in mysql_execute_command (thd=0x2adef47aa000) at /path/to/mysql/sql/sql_parse.cc:3507
#11 0x0000000000963bbe in mysql_parse (thd=0x2adef47aa000, rawbuf=0x2adef7420010 &quot;show create table t1&quot;, length=20,
parser_state=0x2adef8480630) at /path/to/mysql/sql/sql_parse.cc:6623
...

缓存加载不到表对象，用select maxt 逻辑初始化自增：

#0  row_search_max_autoinc (index=0x2b241d8f50f8, col_name=0x2b241d855519 &quot;id&quot;, value=0x2b241e87d8a8)
at /path/to/mysql/storage/innobase/row/row0sel.cc:5361
#1  0x0000000000e58998 in ha_innobase::innobase_initialize_autoinc (this=0x2b241fbd9010)
at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:4663
#2  0x0000000000e59bd9 in ha_innobase::open (this=0x2b241fbd9010, name=0x2b241d853780 &quot;./test/t1&quot;, mode=2, test_if_locked=2)
at /path/to/mysql/storage/innobase/handler/ha_innodb.cc:5089
#3  0x000000000068668b in handler::ha_open (this=0x2b241fbd9010, table_arg=0x2b241e422000, name=0x2b241d853780 &quot;./test/t1&quot;, mode=2,
test_if_locked=2) at /path/to/mysql/sql/handler.cc:2525
...
#9  0x00000000009c2a84 in mysqld_show_create (thd=0x2b241abaa000, table_list=0x2b241d8200f0)
at /path/to/mysql/sql/sql_show.cc:867
#10 0x00000000009553b1 in mysql_execute_command (thd=0x2b241abaa000) at /path/to/mysql/sql/sql_parse.cc:3507
#11 0x0000000000963bbe in mysql_parse (thd=0x2b241abaa000, rawbuf=0x2b241d820010 &quot;show create table t1&quot;, length=20,
parser_state=0x2b241e880630) at /path/to/mysql/sql/sql_parse.cc:6623
...

处理建议

对于这个问题，一种解决方法是从源码改进，将自增值持久化，可以参考
上期的月报
给出的思路；如果不想改代码的话，可以这样绕过：在设定auto_increment值后，主动插入一行记录，这样不论在重启还是缓存淘汰的情况下，重新打开表仍能得到预期的值。

  

    

		

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
