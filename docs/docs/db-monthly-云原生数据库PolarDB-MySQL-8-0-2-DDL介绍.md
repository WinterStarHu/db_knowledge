# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/09/03/
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
	

  

    
数据库内核月报 － 2023 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 · store procedure记录了过多的slow_log的问题详解
                      

                    

                    

                  
                      

                        MySQL · 工具使用 · MySQL client pager/edit/tee 介绍
                      

                    

                    

                  
                      

                        云原生数据库PolarDB MySQL 8.0.2 DDL介绍
                      

                    

 
        

    

  

    
 云原生数据库PolarDB MySQL 8.0.2 DDL介绍  

    
 Author: yinggang  

  

  

  
引言

众所周知，在MySQL生态下，DDL是一类非常复杂的操作，涵盖了Index变更、Primary Key变更、Column列结构变更、Table表结构变更、Foreign Key操作、Generated Column列结构变更等多种不同类型的操作。DDL不仅持续时间久、消耗硬件资源多，而且其中涉及的锁表操作更成为了很多用户的梦魇，操作不慎就可能导致影响正常业务，造成灾难性的影响。
云原生数据库PolarDB MySQL在DDL方面经过多年的经验积累和持续的功能迭代，目前在性能和锁稳定性方面取得了长足的进步。本文将基于PolarDB MySQL 8.0.2版本，介绍不同类型DDL的执行方式，供用户查询了解，以期帮助用户了解DDL的行为，评估DDL操作风险，降低对业务的影响。对于DDL操作，本文主要从如下几个方面展开介绍。

  
是否锁表（允许并发DML）：非锁表的DDL（Online DDL）只在修改元数据步骤申请表互斥锁（持续时间一般不超过1秒），在表结构变更期间允许对目标表进行读写操作，提高了在生产环境中的响应速度和可用性。相反，非Online方式执行的 DDL 会全程锁表，不支持并发的写入操作，当DDL操作持续较长时间时，可能会对业务操作造成重大影响。

  
是否重建表（持续时间长短）：这类DDL，需要根据新的表结构，需要重新创建Primary Key以及所有二级索引，通常需要花费较长时间。值得注意的是，即使重建表，PolarDB内核的DDL性能也远优于gh-ost/pt-osc等第三方工具；

  
是否只修改元数据（秒级完成）：只修改元数据的操作，不修改表数据，即DDL不会随着表规模变大而影响性能，一般秒级即可完成

  
是否支持并行DDL（多线程加速）：对于大表创建索引/重建表等场景，PolarDB支持通过并行DDL，多线程加速DDL的完成，最高有15-20倍的性能提升，详情可以查询：
PolarDB的并行DDL功能

[1]

    

      
Note：对于锁表的DDL操作，用户可以考虑DMS无锁变更或者ght-ost等方式，尤其当这类DDL需要重建表（需要大量数据迁移导致DDL时间窗口较大，且无法通过Instant/Parallel DDL加速），并且业务无法留出足够的时间窗口时。这类第三方的工具主要的问题在于速度很慢，在大表或者高并发场景增量数据过多的情况下容易失败。
在使用三方工具时，需要留意，任何工具（例如gh-ost或者pt-osc或者DMS无锁变更）都至少会在切表（修改元数据步骤）时拿MDL-X锁，进而导致短暂的锁表，Online DDL也有同样的现象。所以用户在执行DDL时，依然需要确保DDL不会被大事务/大查询所堵塞。规避短暂锁表导致的连接打满等问题。幸运的是，云原生数据库PolarDB MySQL内核团队在全链路MDL锁治理方面也做了相当多的优化工作，关于这部分内容，可以参考文档：
深度解析PolarDB DDL锁的优化和演进

[2]

    

  

Index操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
创建二级索引

      
是

      
否

      
否

      
支持

    

    

      
删除二级索引

      
是

      
否

      
是

      
不需要

    

    

      
重命名二级索引

      
是

      
否

      
是

      
不需要

    

    

      
增加全文索引
（FULLTEXT）

      
否

      
否
1

      
否

      
不支持

    

    

      
增加空间索引 （SPATIAL）

      
否

      
否

      
否

      
不支持

    

    

      
修改索引类型

      
是

      
否

      
是

      
不需要

    

  

  

    
在添加表上第一个全文索引时，如果没有用户定义的FTS_DOC_ID列，会导致额外的重建表操作。

  

Primary Key操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
增加Primary Key

      
是

      
是

      
否

      
支持

    

    

      
删除Primary Key

      
否

      
是

      
否

      
不支持

    

    

      
删除原来Primary Key，
增加新的Primary Key

      
是

      
是

      
否

      
支持

    

  

Column操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
增加列

      
是

      
否
1

      
是
1

      
支持
1

    

    

      
删除列

      
是

      
是

      
否

      
支持

    

    

      
重命名列

      
是

      
否

      
是

      
不需要

    

    

      
重排序列

      
是

      
是

      
否

      
支持

    

    

      
设置列的默认值

      
是

      
否

      
是

      
不需要

    

    

      
修改列类型

      
否

      
是

      
否

      
不支持

    

    

      
扩展VARCHAR长度

      
是
2

      
否

      
是

      
不需要

    

    

      
删除列默认值

      
是

      
否

      
是

      
不需要

    

    

      
修改auto-increment值

      
是

      
否

      
否

      
不需要

    

    

      
变更某列为NULL

      
是

      
是

      
否

      
支持

    

    

      
变更某列为非NULL

      
是

      
是

      
否

      
支持

    

    

      
修改ENUM/SET列的定义

      
是

      
否

      
是

      
不需要

    

  

  

    
秒级加列仅支持添加列到表的末尾，并且表需要已有主键（否则可能会因为最末尾的隐式主键导致Instant Add Column失败）。另外，Instant Add Column不支持压缩表（ROW_FORMAT=COMPRESSED），不支持全文索引的表，不支持临时表。如果不支持Instant Add Column，增加列默认走INPLACE DDL，需要全表重建。此时支持通过并行DDL加速，允许并发DML。

    
扩展VARCHAR长度：存储VARCHAR列长度所需的字节数需要保持一致，才能支持快速修改。具体来说，对于0-255Bytes的VARCHAR列，只需要一个Byte存储长度。而对于大于等于256Bytes的VARCHAR列，就需要两个Bytes存储长度。只有控制VARCHAR列长度的扩展范围，比如从0-255Bytes，或者从256Bytes到更大的范围，才能支持ALTER TABLE只修改元数据。也就是说，当修改VARCHAR列长度从小于256Bytes到大于256Bytes的长度时，PolarDB默认走Copy DDL类型，即全程都是锁表的，不支持DML写操作，仅支持读操作。当用户不确定自己修改VARCHAR列的范围是否满足上述条件时，可以手动执行DDL的执行方式为INPLACE。此时，如果不支持快速列扩展，会直接报错。如下给出了一个参考示例：

  

ALTER TABLE table_name ALGORITHM=INPLACE, CHANGE COLUMN c1 c1 VARCHAR(256);

ERROR 0A000: ALGORITHM=INPLACE is not supported. Reason: Cannot change
column type INPLACE. Try ALGORITHM=COPY.

  
varchar类型属于变长存储类型，磁盘仅存储实际长度，因此建议用户在使用varchar字段时，考虑将最大长度直接调整到256以上，避免扩展字段时可能需要走copy算法。

Table操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
修改ROW_FORMAT

      
是

      
是

      
否

      
支持

    

    

      
修改KEY_BLOCK_SIZE

      
是

      
是

      
否

      
支持

    

    

      
设置持久化统计信息

      
是

      
否

      
是

      
不需要

    

    

      
声明character set

      
是

      
是
1

      
否

      
支持

    

    

      
转换character set

      
否

      
是

      
否

      
不支持

    

    

      
Optimize表

      
是

      
是
2

      
否

      
支持

    

    

      
重建表

      
是

      
是

      
否

      
支持

    

    

      
重命名表

      
是

      
否

      
是

      
不需要

    

  

  

    
如果新的character发生变化，需要走COPY DDL重建表的方式

    
通过ALTER TABLE table_name ENGINE=InnoDB, ALGORITHM=INPLACE, LOCK=NONE，重新整理表中的碎片时，带全文索引的表不支持INPLACE。

  

Generated Column操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
增加STORED Column

      
否
1

      
是

      
否

      
不支持

    

    

      
修改STORED Column顺序

      
否

      
是

      
否

      
不支持

    

    

      
删除STORED Column

      
是

      
是

      
否

      
支持

    

    

      
增加VIRTUAL Column

      
是

      
否

      
是

      
不需要

    

    

      
修改VIRTUAL Column顺序

      
否

      
是

      
否

      
不支持

    

    

      
删除VIRTUAL Column

      
是

      
否

      
是

      
不需要

    

  

  

    
由于增加Stored Column表达式涉及SQL/Server层，因此不支持Online DDL。

  

Foreign Key操作

  

    

      
操作

      
允许并发DML

      
重建表

      
秒级完成

      
支持并行DDL

    

  

  

    

      
增加Foregin Key

      
是
1

      
否
1

      
是
1

      
不需要

    

    

      
删除Foregin Key

      
是
1

      
否
1

      
是
1

      
不需要

    

  

  

    
只有关闭了foreign_key_checks开关情况下，才支持INPLACE DDL，并且只修改元数据。否则只支持COPY DDL，全程锁表。

  

分区表操作

  

    

      
操作

      
允许并发DML

      
秒级完成

      
In Place

      
支持并行DDL

    

  

  

    

      
表转分区

      
否

      
否

      
否

      
不支持

    

    

      
增加分区(ADD)

      
是
1

      
否

      
是
2

      
不支持

    

    

      
删除分区(DROP)

      
是
1

      
否

      
是
2

      
不支持

    

    

      
删除分区表空间(DISCARD)

      
否

      
否

      
否

      
不支持

    

    

      
导入分区表空间(IMPORT)

      
否

      
否

      
否

      
不支持

    

    

      
截断分区(TRUNCATE)

      
是

      
否

      
是

      
不支持

    

    

      
合并分区（HASH/KEY分区）

      
否

      
否

      
是
3

      
不支持

    

    

      
重分布分区(REORGNIZATE

      
否
1

      
否

      
是
3

      
不支持

    

    

      
交换分区(EXCHANGE)

      
是
1

      
否

      
是

      
不支持

    

    

      
分析分区(ANALYZE)

      
是

      
否

      
是

      
不支持

    

    

      
检查分区(CHECK)

      
是

      
否

      
是

      
不支持

    

    

      
优化分区(OPTIMIZE)

      
否

      
否

      
否

      
不支持

    

    

      
重建分区(REBUILD)

      
否
1

      
否

      
是
3

      
不支持

    

    

      
修复分区(REPAIR)

      
是

      
否

      
是

      
不支持

    

    

      
分区转表

      
否

      
否

      
否

      
不支持

    

  

  

    
支持分区级元数据锁，开启loose_partition_level_mdl_enabled参数后，DDL不影响不涉及的分区上的DML。更多信息可以参考：
PolarDB的在线分区维护功能

[3]

  

  

    
只有RANGE/LIST分区支持。

    
只支持QUERY。

  

总结

由于篇幅原因，本文仅介绍了部分常见的DDL操作，希望能够帮助用户在执行DDL前，了解相关DDL在云原生数据库PolarDB MySQL 8.0.2版本上的行为特征。总的来说，经过多年的持续优化，借助于并行DDL、Instant DDL、DDL IO优化等方面的工作，PolarDB MySQL在DDL方面已经形成了较大的优势。未来，PolarDB内核团队将继续在DDL方面发力，进一步提升DDL的易用性，始终如一地为用户打造最佳的云原生数据库。

参考资料：

[1] PolarDB的并行DDL功能：
https://help.aliyun.com/zh/polardb/polardb-for-mysql/user-guide/parallel-ddl

[2] 深度解析PolarDB DDL锁的优化和演进：
https://mp.weixin.qq.com/s/icYkCqEPboIlx9UxPr5ZnQ

[3] PolarDB的在线分区维护功能：
https://help.aliyun.com/zh/polardb/polardb-for-mysql/user-guide/online-partition-maintenance

  

    

		

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
