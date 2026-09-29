# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/02/02/
> 分类: 

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
	

  

    
数据库内核月报 － 2023 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB MySQL · 功能特性 · 大表扫描优化
                      

                    

                    

                  
                      

                        PolarDB MySQL的INTERVAL分区如何让DBA解放双手
                      

                    

                    

                  
                      

                        Long-lived Transactions 产生的影响
                      

                    

 
        

    

  

    
 PolarDB MySQL的INTERVAL分区如何让DBA解放双手  

    
 Author: yuanyu  

  

  

  
作为大表的优化方案之一，分区表功能现在越来越受欢迎。PolarDB MySQL的分区表完全兼容MySQL官方的语法和功能，同时，PolarDB在功能和性能上做了很多的优化和增强（详情请参见
PolarDB MySQL分区表概述
）。

INTERVAL分区是什么

分区表是把一个逻辑的大表，按照分区策略分割成多个物理的小表，这个大表叫做分区表，这些物理的小表叫做分区。单表在管理超大数据量时是有瓶颈的，分区表把数据切分成小的分片独立管理，从而使得拥有大数据量的表仍然拥有高性能。
分区表的分区策略，包括 RANGE，LIST，HASH三种， 指定分区键以及分区策略， 可以根据分区键字段的值把数据划分到不同的分区。
INTERVAL分区按照分区策略划分属于RANGE分区，是对
RANGE分区
功能的扩展。两者的区别在于，向RANGE分区表插入数据时，如果插入的数据超出当前已存在分区的范围，将无法插入并且会返回错误；对于INTERVAL RANGE分区表，当插入的数据超过现有分区的范围时，PolarDB数据库会自动创建新分区，然后继续完成数据的插入。

INTERVAL分区表可以自动创建新的分区，由于RANGE分区表的所有分区是按分区范围有序排列的，所以INTERVAL分区也是按序向后追加新的分区。新分区的创建规则是由前一个分区的最大范围以及用户指定的分区范围决定的。
INTERVAL的分区范围由新增的INTERVAL语法来指定，如下所示。

INTERVAL

(

type

,
 
expr

)

这个语法包含两个参数，通过参数type可以指定时间类型，通过参数expr可以指定具体的分区范围。

如何创建INTERVAL分区

例如，创建一个INTERVAL分区表时，指定分区的范围是1天。

CREATE
 
TABLE
 
t

(

a
 
int

,
 
b
 
datetime

)

PARTITION
 
BY
 
RANGE
 
COLUMNS

(

b

)
 
INTERVAL

(

DAY

,
 
1

)
 
(

	
PARTITION
 
p20211101
 
VALUES
 
LESS
 
THAN

(

'2021-11-01 00:00:00'

)

);

这个INTERVAL分区表，自动创建的分区，每个分区的范围都是1天。
详情请参见
创建INTERVAL RANGE分区
。

已有分区表是否可以转成INTERVAL分区表

这个要区分原表的类型。

  
非RANGE分区表

这里包含两种场景，一种是原表是非分区表，另一种是原表是分区表但不是RANGE分区表。这两种情况，都需要通过ALTER TABLE table_name partition_options这样的语法来完成转换，这种转换通常是需要锁表的，锁表时间取决于表的数据量。
当然，考虑到用户业务的连续性，PolarDB也提供了非分区表到INTERVAL分区表快速转换的语法，详情请参考
普通表快速转RANGE分区表
。
文档里提供的示例是普通表转RANGE分区表，转换成INTERVAL分区表只需要加上INTERVAL语法即可，示例如下。

CREATE
 
TABLE
 
t
 
(

`id`
 
int
 
,

`gmt_create`
 
datetime

);

insert
 
into
 
t
 
values

(

1

,
 
NOW

()),
 
(

2

,
 
NOW

());

alter
 
table
 
t
 
partition
 
by
 
range
 
columns

(

gmt_create

)
 
interval

(

DAY

,
 
1

)
 
(

  
partition
 
p20230101
 
values
 
less
 
than
 
(

'2023-01-01'

),

  
partition
 
p20230102
 
values
 
less
 
than
 
(

'2023-01-02'

)

)
 
WITHOUT
 
VALIDATION

;

需要注意的是，请务必保证普通表中的数据全部符合分区表第一个分区定义的范围，否则转成分区表后，不符合规则的数据可能会查询不到。

  
RANGE分区表

RANGE分区表转INTERVAL分区表，可以通过ALTER TABLE table_name SET INTERVAL(type, expr)的语法来完成，这个转换过程是不需要锁表的。
详情请参见
转换分区表
。

INTERVAL分区的命名规则

INTERVAL分区表自动生成的分区，有特定的命名规则，分区命名的前缀必须是_p，后面的名字是根据分区范围的上边界以及分区键的类型来确定。
例如，分区键是DATETIME类型，分区的范围是VALUES LESS THAN(‘2023-01-01’)，那么分区名是_p20230101000000；如果分区键是DATE类型，分区的范围是VALUES LESS THAN(‘2023-01-01’)，那么分区名是_p20230101。
用户也可以通过
ADD PARTITION
语法，给INTERVAL分区表创建新的分区，为了避免自动生成的分区和用户自定义分区名冲突，用户自定义分区的命名要么不以_p为前缀，要么按照自动生成分区的命名规则来定义分区。
避免用户难以理解自动生成分区的命名规则，当用户自定义分区的命名不符合命名规则时，会给用户提示正确的命名，如下图所示。

Interval分区如何解放DBA

数据库分区表特性，可以通过分区来提升大表的访问性能，同时可以灵活的管理分区数据，但是很多场景下分区需要定期来维护。
例如需要定期创建新的分区，定期删除旧的分区等，这些操作通常都需要DBA在凌晨的运维时间来执行。当INTERVAL分区结合定时任务就可以实现分区的自动化管理。

自动化分区管理解决方案

这套解决方案，适合以时间列为分区键的场景。
假设有业务表orders，以订单时间为分区键，需要每天有一个分区来保存当天的订单。

CREATE
 
TABLE
 
orders

(

  
id
 
int

,

  
ordertime
 
datetime

)

PARTITION
 
BY
 
RANGE
 
COLUMNS

(

ordertime

)
 
INTERVAL

(

DAY

,
 
1

)

(

  
PARTITION
 
_p20230101000000
 
VALUES
 
LESS
 
THAN

(

'2023-01-01'

),

  
PARTITION
 
_p20230102000000
 
VALUES
 
LESS
 
THAN

(

'2023-01-02'

)

  
PARTITION
 
_p20230103000000
 
VALUES
 
LESS
 
THAN

(

'2023-01-03'

)

  
PARTITION
 
_p20230104000000
 
VALUES
 
LESS
 
THAN

(

'2023-01-04'

)

);

使用INTERVAL分区可以自动新增每天的分区。如果用户订单信息只需要保存3天，那么就可以一个创建event来定期删除3天前的旧分区，不影响其他分区性能的同时可以节省存储空间。创建定时任务的示例如下。

DELIMITER
 
||

CREATE
 
EVENT
 
IF
 
NOT
 
EXISTS
 
drop_partition
 
ON
 
SCHEDULE

EVERY
 
1
 
DAY
 
STARTS
 
'2023-01-04 02:00:00'

ON
 
COMPLETION
 
PRESERVE

DO

BEGIN

set
 
@

pname
 
=
 
concat

(

'alter table orders drop partition _p'

,
 
date_format

(

date_add

(

curdate

(),
 
INTERVAL
 
-

3
 
DAY

),
 
'%Y%m%d000000'

));

prepare
 
stmt_drop_partition
 
from
 
@

pname

;

execute
 
stmt_drop_partition

;

deallocate
 
prepare
 
stmt_drop_partition

;

END
 
||

DELIMITER
 
;

详情请参见
自动化管理分区
。

小结

INTERVAL分区结合定时任务，可以实现类似于数据生命周期管理的功能。

  

    

		

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
