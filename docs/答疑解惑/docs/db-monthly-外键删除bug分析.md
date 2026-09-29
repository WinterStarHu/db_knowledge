# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/07/07/
> 分类: 答疑解惑

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
	

  

    
数据库内核月报 － 2015 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb change buffer介绍
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB Checkpoint机制
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 时间线解析
                      

                    

                    

                  
                      

                        PgSQL · 功能分析 · PostGIS 在 O2O应用中的优势
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB index lock前世今生
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MySQL内存分配支持NUMA
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 外键删除bug分析
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · MySQL logical read-ahead
                      

                    

                    

                  
                      

                        MySQL · 功能介绍 · binlog拉取速度的控制
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 浮点型的显示问题
                      

                    

 
        

    

  

    
 MySQL · 答疑解惑 · 外键删除bug分析  

    
 Author: 济天  

  

  

  
背景

你是否曾为
Error on rename of './test/#sql-78fd_780371' to './test/t2' (errno: 150)
这样的错误而不解，如stackoverflow上的这个
问题
？

下面我们来复现下：

drop
 
table
 
t2

;

drop
 
table
 
t1

;

create
 
table
 
t1

(

c1
 
int
 
primary
 
key

,
 
c2
 
int

);

create
 
table
 
t2

(

c1
 
int
 
primary
 
key

,
 
c2
 
int
 
,
 
constraint
 
fk
 
foreign
 
key
 
(

c2

)
 
references
 
t1

(

c1

))
 
engine

=

innodb

;

//

删外键所引用的列

alter
 
table
 
t2
 
drop
 
c2

;

//

删不存在的外键

alter
 
table
 
t2
 
drop
 
foreign
 
key
 
idx1

;

5.5的表现

mysql

>
  
alter
 
table
 
t2
 
drop
 
c2

;

ERROR
 
1025
 
(

HY000

):
 
Error
 
on
 
rename
 
of
 
'./test/#sql-78fd_780371'
 
to
 
'./test/t2'
 
(

errno

:
 
150

)

mysql

>
 
alter
 
table
 
t2
 
drop
 
foreign
 
key
  
idx1

;

ERROR
 
1025
 
(

HY000

):
 
Error
 
on
 
rename
 
of
 
'./test/t2'
 
to
 
'./test/#sql2-78fd-780371'
 
(

errno

:
 
152

)

5.6的表现

mysql

>
  
alter
 
table
 
t2
 
drop
 
c2

;

ERROR
 
1553
 
(

HY000

):
 
Cannot
 
drop
 
index
 
'fk'

:
 
needed
 
in
 
a
 
foreign
 
key
 
constraint

mysql

>
 
alter
 
table
 
t2
 
drop
 
foreign
 
key
  
idx1

;

ERROR
 
1091
 
(

42000

):
 
Can

't DROP '

idx1

'; check that column/key exists

很明显5.6的报错信息更精确些，5.5的报错太不人性化了，容易造成误解。

它们差别在于5.6的报错处理在语义分析阶段，精准的定位了错误信息。

 mysql_alter_table
    |=>mysql_inplace_alter_table
    |==>ha_innobase::prepare_inplace_alter_table
    |===>innobase_check_foreign_key_index

而5.5的报错处理在执行阶段。

我们先来看看5.5的执行流程：

 mysql_alter_table
    |=>mysql_create_table_no_lock //创建临时表tmp_table1,其结构和原表类似,但不包括外键信息
    |==>rea_create_table
    |=>copy_data_between_tables //将原表数据copy到tmp_table1
    |=>mysql_rename_table //将原表重命名tmp_table2,但不重命名外键涉及的表信息
    |==> row_rename_table_for_mysql //修改字典表
    |=>mysql_rename_table //将临时表tmp_table1重命名回原表
    |==>row_rename_table_for_mysql //修改字典表
    |===>dict_load_foreigns //这里通过从数据字段加载外键信息来检查外键索引是否存在,外键索引列是否一致.

dict_load_foreigns
：这个函数由于承担的责任太多，只要发现错误，就笼统的抛出
Error on rename of 'xxxx' to 'xxxx' (errno: xxx)
的错误.

外键bug

我们来看一个外键相关的
bug77467
。

Alter
 
table
 
reply

    
change
 
blogId
 
topicId
 
int

(

11

)
 
NOT
 
NULL

,

    
drop
 
index
 
userId

,

    
drop
 
foreign
 
key
 
reply_ibfk_2

;

bug中这个DDL虽然执行失败了，但实际上foreign key reply_ibfk_2被删除了。这个bug在单机环境下影响不大，但在主备环境下由于DDL执行失败并没有记binlog，从而导致主备表结构不一致。这个bug只出现在5.6以前的版本中，5.6是OK的

bug分析

我们来看看5.5的流程：

mysql_alter_table

    
|=>

mysql_create_table_no_lock
 
//创建临时表tmp_table1,其结构和原表类似,但不包括外键信息

    
|==>

rea_create_table

    
|=>

copy_data_between_tables
 
//将原表数据copy到tmp_table1

    
|=>

mysql_rename_table
 
//将原表重命名tmp_table2,但不重命名外键涉及的表信息,同时删除原表的外键reply_ibfk_2

    
|==>
 
row_rename_table_for_mysql
 
//修改字典表

    
|=>

mysql_rename_table
 
//将临时表tmp_table1重命名回原表

    
|==>

row_rename_table_for_mysql
 
//修改字典表

    
|===>

dict_load_foreigns
 
//这里通过从数据字段加载外键信息来检查外键索引是否存在,外键索引列是否一致.检查发现index userId不存在,出现错误

    
|===>

trx_rollback_to_savepoint
 
//出现错误回滚之前的修改

出错回滚之前的修改，预期是回滚删除外键reply_ibfk_2，但是删除外键reply_ibfk_2操作在第一次
mysql_rename_table
中，属于一个事务，而回滚操作在第二次
mysql_rename_table
中，属于另一个事务，因此回滚没有成功。

那么5.6为什么没有出现这种错误呢？5.6在语义分析的时候就发现错误，还没来得及删外键就已经报错返回了。

bug修复

5.5修复方法，将删外键的操作放到第二次
mysql_rename_table
中进行，如果出现错误就可以顺利的回滚了。当然，还是5.6的做法比较好。

  

    

		

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
