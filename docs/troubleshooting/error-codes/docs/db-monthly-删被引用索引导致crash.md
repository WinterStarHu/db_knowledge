# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/04/09/
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
	

  

    
数据库内核月报 － 2015 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB undo log 漫游
                      

                    

                    

                  
                      

                        TokuDB · 产品新闻 · RDS TokuDB小手册
                      

                    

                    

                  
                      

                        TokuDB · 特性分析 · 行锁(row-lock)与区间锁(range-lock)
                      

                    

                    

                  
                      

                        PgSQL · 社区动态 · 说一说PgSQL 9.4.1中的那些安全补丁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 连接断开导致XA事务丢失
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · GTID下slave_net_timeout值太小问题
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · Relay log 中 GTID group 完整性检测
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · UPDATE交换列单表和多表的区别
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 删被引用索引导致crash
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑 · GTID下auto_position=0时数据不一致
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态 · 删被引用索引导致crash  

    
 Author: 济天  

  

  

  
bug描述

设置 foreign_key_checks=0 删除被引用的索引后，再设置foreign_key_checks=1，对引用表进行DML操作会导致 mysqld crash，以下是重现的测例：

drop
 
table
 
if
 
exists
 
t2

;

drop
 
table
 
if
 
exists
 
t1

;

create
 
table
 
t1
 
(

a
 
int

,
 
b
 
int

,
 
key
 
idx1

(

a

))
 
engine

=

innodb

;

insert
 
into
 
t1
 
values

(

1

,

1

);

insert
 
into
 
t1
 
values

(

2

,

2

);

create
 
table
 
t2
 
(

a
 
int

,
 
b
 
int

,
 
foreign
 
key
 
(

b

)
 
references
 
t1

(

a

))
 
engine

=

innodb

;

set
 
session
 
foreign_key_checks
 
=
 
0

;

alter
 
table
 
t1
 
drop
 
key
 
idx1

;

set
 
session
 
foreign_key_checks
 
=
 
1

;

insert
 
into
 
t2
 
values
 
(

1

,

1

);
 
//

此语句执行时

mysqld

会

crash

分析

对于引用约束，在mysql实现中引用表和被引用表都会记录表的引用关系。

以下链表记录该表引用了哪些表，链表中每个元素为 dict_foreign_t

table

->

foreign_list
      

以下链表记录该表被哪些表引用，链表中每个元素为 dict_foreign_t

table

->

referenced_list

dict_foreign_t 结构如下

dict_foreign_t

{

  
foreign_table
       
// t2

  
foreign_index
       
  
referenced_table
    
// t1

  
referenced_index
    
// idx1

  
......

}

对于上面的测例，t1为被引用表，t2为引用表。

  

    
对于t1
table->foreign_list 为null
table->referenced_list 则记录了引用关系

  

  

    
对于t2
table->foreign_list 记录了引用关系
table->referenced_list 则为null

  

对于删除索引操作，如果索引涉及到引用关系，那么对应引用关系中的索引也应该做相应调整。对于测例中的删索引操作 
alter table t1 drop key idx1;
 应该做如下调整

  

    
修改t1表的引用关系
table->referenced_list中dict_foreign_t->referenced_index 置为null

  

  

    
修改t2表的引用关系
table->foreign_list中dict_foreign_t->referenced_index 置为null

  

而此bug修复之前, 并没有修改t2表的引用关系, 从而导致后面对t2表进行DML操作时，如果访问了无效的dict_foreign_t->referenced_index就会导致crash。

修复方法

删除被引用的索引后,应修改引用表的引用关系，即应修改table->referenced_list。
详见
官方修复

附加说明

如果删除引用表对应的外键时，mysql如何处理的呢？同删除被引用表的索引一样，都需要调整引用表和被引用表的关系。

实际上，当删除引用表对应的外键时，如果存在和此外键相似（这里的相似是指索引列数和列顺序相同）的索引时，会用相似的索引代替删除的外键，从而保持原有的引用约束关系。

例如，在下面的例子中，原来t2存在有两个索引idx1和idx2，都可以作为外键，函数
dict_foreign_find_index
选择了idx1作为外键。当删除idx1后，同样通过dict_foreign_find_index选择了idx2做为了外键。

drop
 
table
 
if
 
exists
 
t2

;

drop
 
table
 
if
 
exists
 
t1

;

create
 
table
 
t1
 
(

a
 
int

,
 
b
 
int

,
 
key

(

a

))
 
engine

=

innodb

;

create
 
table
 
t2
 
(

a
 
int

,
 
b
 
int

,
 
foreign
 
key
 
(

b

)
 
references
 
t1

(

a

),

                 
key
 
idx1

(

b

),
 
key
 
idx2

(

b

))
 
engine

=

innodb

;

alter
 
table
 
t2
 
drop
 
key
 
idx1

;

同样，此bug修复后，删除被引用表的索引时，如果存在相似的索引会用相似的索引代替。
例如，在下面的例子中，原来t1存在有两个索引idx1和idx2，都可以作为被引用索引，函数dict_foreign_find_index选择了idx1作为被引用索引。当删除idx1后，同样通过dict_foreign_find_index选择了idx2做为了新的被引用索引。

drop
 
table
 
if
 
exists
  
t2

;

drop
 
table
 
if
 
exists
  
t1

;

create
 
table
 
t1
 
(

a
 
int

,
 
b
 
int

,
 
key
 
idx1

(

a

),
 
key

                 
idx2

(

a

))
 
engine

=

innodb

;

create
 
table
 
t2
 
(

a
 
int

,
 
b
 
int

,

                 
foreign
 
key
 
(

b

)
 
references
 
t1

(

a

))
 
engine

=

innodb

;

其实，相似索引的存在是完全没有必要的。如果禁止创建相似的索引，那么引用约束这块的处理也不会这么复杂了。

  

    

		

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
