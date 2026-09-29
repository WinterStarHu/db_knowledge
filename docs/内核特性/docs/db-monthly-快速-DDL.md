# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2020/07/03/
> 分类: 内核特性

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
	

  

    
数据库内核月报 － 2020 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 内核特性 · 8.0 新的火山模型执行器
                      

                    

                    

                  
                      

                        MongoDB · 内核特性 · wiredtiger page逐出
                      

                    

                    

                  
                      

                        AliSQL · 内核特性 · 快速 DDL
                      

                    

                    

                  
                      

                        MySQL · 内核特性 · semi-join四个执行strategy
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB redo log thread cpu usage
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · SQL防火墙使用说明与内核浅析
                      

                    

 
        

    

  

    
 AliSQL · 内核特性 · 快速 DDL  

    
 Author: 思勉  

  

  

  
优化背景

DDL是数据库运行期间不可避免的操作，MySQL用户经常会遇到DDL相关的问题包括:

  
为什么加个索引会造成实例的抖动，影响正常的业务读写？

  
为什么一个不到 1G 的表执行 DDL 有时需要十几分钟？

  
为什么使用了 temp table 的连接退出会造成实例抖动？

针对这些问题，RDS内核团队进行分析后发现 MySQL 在 DDL 运行期间的缓存维护逻辑存在性能缺陷。在AliSQL上对这个问题进行了深入分析后，引入了针对性的buffer pool页面管理策略的优化，大大降底DDL操作带来的相关锁争用，解决或有效地缓解了上述问题，让AliSQL在正常业务压力下可以安心地做DDL操作。

启用快速 DDL功能，只需在 RDS 实例上打开 innodb_rds_faster_ddl 参数即可。

测试验证

这里针对 inplace类型DDL 执行时间， 以及临时表清理两个场景进行压测验证。

DDL场景

选取 RDS8.0 支持的两种 inplace online ddl 操作进行验证， 其中 create index 操作不需要重建表，optimize teble 操作需要重建表。 

  

    

      
操作

      
Instant

      
In Place

      
重建表

      
可并发执行DML

      
只修改元数据

    

  

  

    

      
create index

      
否

      
是

      
否

      
是

      
否

    

    

      
opitmize table

      
否

      
是

      
是

      
是

      
否

    

  

测试过程：

测试使用 8c 64g 的 8.0.18 实例进行，执行DDL操作的表大小600M 用sysbench 发起压测请求模拟线上业务，在 sysbench 压测期间执行 DDL 操作，进行反复对比测试。

结果对比:

  

    

      
 

      
关闭优化

      
启用优化

      
提升倍数

    

  

  

    

      
create index

      
56s

      
4.9s

      
11.4

    

    

      
optimize table

      
220s

      
17s

      
12.9

    

  

在该场景下，优化后的AliSQL相比8.0社区版本 DDL 执行时间缩短了90%以上.

临时表场景

MySQL 在很多情况下会使用临时表：查询 information_schema 库下面的表， SQL 中执行 create temporary table 保存中间结果，优化器为了加速某些复杂SQL的执行也会自动创建和删除临时表。在线程退出时会集中清理用到过的临时表，基实是属于一种特殊类型的DDL，同样会导致实例的性能抖动。 更详细的背景有兴趣可以参考这个bug: 
Temp ibt tablespace truncation at disconnection stuck InnoDB under large BP

测试过程：

使用 8c 64g 的 8.0.18 实例正常 tpcc 压测，先提前预热，将 bp 基本用满，并发起单线程短连接的 temp table 请求。

结果对比:

原生MySQL在每次 temp table 线程退出时出现剧烈的抖动，tps 下降超过70%，开启优化之后性能影响降低至5%。

  

    

      
 

      
无DDL操作

      
开启优化

      
关闭优化

    

  

  

    

      
tps

      
42k

      
40k

      
<10k

    

  

压测过程中的秒级性能数据如下图所示（红线处开始关闭DDL加速功能）：

优化效果

DDL加速功能覆盖 RDS 线上的5.6/5.7/8.0 三个版本，不同版本的性能收益见下表。

  

    

      
分类

      
DDL

      
RDS 56

      
RDS 57

      
RDS 80

    

  

  

    

      
Inplace DDL

      
InplaceDdl 范围 
5.7 

8.0

      
否

      
是

      
是

    

    

      
Tablespace 管理

      
alter tablespace encryption

      
否

      
是

      
是

    

    

      
 

      
truncate/drop tablespace

      
否

      
是

      
是

    

    

      
 

      
discard tablespace

      
是

      
是

      
是

    

    

      
Drop Table 

      
drop/truncate table 

      
是

      
是

      
是

    

    

      
Undo 操作

      
truncate/drop undo

      
否

      
否

      
是

    

    

      
Flush table

      
flush table for export

      
是

      
是

      
是

    

  

DDL加速功能可以缩短表中 DDL 的执行时间，降低 DDL操作对实例运行的影响。

Temp缺陷

  

DDL using bulk load is very slow under long flush_list

  

Temp ibt tablespace truncation at disconnection stuck InnoDB under large BP

  

BUF_REMOVE_ALL_NO_WRITE is not needed for undo tablespace

  

InnoDB temp table could hurt InnoDB perf badly

AliSQL的快速DDL特性（RC_20200630版本）完美地解决了以上MySQL Temp缺陷。

  

    

		

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
