# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/06/03/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2015 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 崩溃恢复过程
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 唯一键约束失效
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · ALTER IGNORE TABLE导致主备不一致
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL Sort 分页
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · binlog event 中的 error code
                      

                    

                    

                  
                      

                        PgSQL · 功能分析 · Listen/Notify 功能
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 任性的 normal shutdown
                      

                    

                    

                  
                      

                        PgSQL · 追根究底 · WAL日志空间的意外增长
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MariaDB Role 体系
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB数据文件大小计算
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态 · ALTER IGNORE TABLE导致主备不一致  

    
 Author: Plinux  

  

  

  
背景

我们知道当一张表的某个字段存在重复值时，这个字段没办法直接加UNIQUE KEY，但是MySQL提供了一个 ALTER IGNORE TABLE的方式，可以忽略修改表结构过程中出现的错误，但是要忽略UNIQUE重复值，就需要打开old_alter_table，也就是拷贝表的方式来ALTER TABLE。

例如这样：

CREATE
 
TABLE
 
t1

(

c1
 
int

)
 
ENGINE
 
=
 
InnoDB

;

INSERT
 
INTO
 
t1
 
VALUES
 
(

1

),
 
(

1

);

SET
 
old_alter_table

=

1

;

ALTER
 
IGNORE
 
TABLE
 
t1
 
ADD
 
UNIQUE
 
(

c1

);

但是如果你是 MySQL 5.5 主备环境，你会发现备库收到这个DDL后，SQL THREAD 会给你一个无情的报错：

'Error '

Duplicate
 
entry
 
'1'
 
for
 
key
 
'c1

''

 on query.
Default database: '

test

'. Query: '

ALTER
 
IGNORE
 
TABLE
 
t1
 
ADD
 
UNIQUE
 
(

c1

)

''

原因

这是为什么呢？

其实关键问题就是这个SQL要执行成功，必须保证 old_alter_table 打开，但是 MySQL 的 SET 语句并不参与复制，因此备库只收到了一个 ALTER IGNORE TABLE，而没有先打开 old_alter_table，因此备库用的不是整表拷贝的方法来重建表，因而无法执行成功。

解决

那我们怎么解决这个问题呢，也很简单，只要备库Slave线程也用 old_alter_table=1 来执行 ALTER IGNORE TABLE就好了。

本质上就是 
mysql_alter_table()
 中需要让
need_copy_table= ALTER_TABLE_DATA_CHANGED
（old_alter_table=1），而不是
need_copy_table= ALTER_TABLE_INDEX_CHANGED
（old_alter_table=0）。

因此我们只要在
mysql_alter_table()
函数中判断该用哪种算法的时候，给出一个可以干预的变量，让Slave线程在需要的时候可以按
need_copy_table= ALTER_TABLE_DATA_CHANGED
执行。

原来的代码：

   
if
 
((

thd

->

variables

.

old_alter_table

       
||
 
(

table

->

s

->

db_type

()
 
!=
 
create_info

->

db_type

)

 
#ifdef WITH_PARTITION_STORAGE_ENGINE

       
||
 
partition_changed

 
#endif

      
)

     
need_copy_table

=
 
ALTER_TABLE_DATA_CHANGED

;

我们加上判断 (‘是否启用Slave自动用 ALTER_TABLE_DATA_CHANGED 方式做ALTER IGNORE TABLE’ && 
thd->slave_thread
 && ignore)，就可以在我们打开控制变量的时候，强制让Slave线程用 old_alter_table=1 的方式来执行 ALTER IGNORE TABLE。

   
if
 
((

thd

->

variables

.

old_alter_table
 
||

        
(

'是否启用

Slave

自动用
 
ALTER_TABLE_DATA_CHANGED
 
方式做

ALTER
 
IGNORE
 
TABLE

'
 
&&

         
thd

->

slave_thread
 
&&
 
ignore

))

       
||
 
(

table

->

s

->

db_type

()
 
!=
 
create_info

->

db_type

)

 
#ifdef WITH_PARTITION_STORAGE_ENGINE

       
||
 
partition_changed

 
#endif

      
)

     
need_copy_table

=
 
ALTER_TABLE_DATA_CHANGED

;

  

    

		

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
