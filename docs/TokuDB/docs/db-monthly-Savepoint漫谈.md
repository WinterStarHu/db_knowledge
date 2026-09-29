# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/04/10/
> 分类: TokuDB

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
	

  

    
数据库内核月报 － 2016 / 04

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 参数故事 · innodb_additional_mem_pool_size
                      

                    

                    

                  
                      

                        GPDB · 特性分析 · Segment事务一致性与异常处理
                      

                    

                    

                  
                      

                        GPDB · 特性分析 · Segment 修复指南
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 并行复制外键约束问题二
                      

                    

                    

                  
                      

                        PgSQL · 性能优化 · 如何潇洒的处理每天上百TB的数据增量
                      

                    

                    

                  
                      

                        Memcached · 最佳实践 · 热点 Key 问题解决方案
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · 短连接Auth性能优化
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · RDS 只读实例延迟分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB索引结构--Fractal Tree
                      

                    

                    

                  
                      

                        MySQL · TokuDB · Savepoint漫谈
                      

                    

 
        

    

  

    
 MySQL · TokuDB · Savepoint漫谈  

    
 Author: yigong  

  

  

  
问题描述

某TokuDB实例备库发生复制中断,报错信息甚是诡异：

  Error executing row event: "Can't lock file (errno: 22 - Invalid argument)"

经过gdb core后，大体知道了发生错误的原因：

TokuDB在创建子事务的时候，由于嵌套事务过多，FT-index直接返回了错误（TokuDB的嵌套事务最多允许256个，嵌套事务数目的类型为uint8_t）导致。

比较诡异的是主库一切正常，无任何错误。

经过沟通，发现用户使用了大量的savepoint，这是一个突破点。

Savepoint机制

在TokuDB里savepoint的机制是个啥样子呢？

这里我们分两种情况来处理，先来看第一种，
SQL1
：

set autocommit=0;
savepoint s0;
insert into tb1 values(0);
release savepoint s0;
savepoint s1;
insert into tb1 values(1);
release savepoint s1;
...
commit;

TokuDB将会这样处理：

a) savepoint s0：
创建s0子事务
b) release savepoint s0的时候：
commit当前s0事务
c) savepoint s1：
创建s1子事务(此时s0子事务已不存在，已提交)
d) release savepoint s1的时候：
commit当前s1事务

savepoint 间的事务并非嵌套，而是用完就释放，然后再重新创建，这样不会导致事务栈溢出。

再来看另外一种情况，
SQL2
：

set autocommit=0;
savepoint s0;
insert into tb1 values(0);
savepoint s1;
insert into tb1 values(1);
savepoint s2;
insert into tb1 values(2);
...
commit;

这种SQL TokuDB的处理方式是：

a) savepoint的时候：
s1是s0的子事务，s2是s1的子事务，就这样嵌套下去直到事务栈溢出...

b) commit的时候：
会先提交s2，然后提交s1，然后提交s0，最后整个事务提交

问题解决

针对开始时的问题，TokuDB内核君进行了大胆猜测：

在主库执行的是SQL1，一切正常；
在备库执行的是SQL2，事务栈溢出了；

通过翻看 binlog 代码印证了我们的猜测，在 sql/binlog.cc 里只实现了 
binlog_savepoint_set
 方法，只记录savepoint event到binlog，而未记录release savepoint event！

由于savepoint实现机制不同，对InnoDB引擎来说是没有问题的，但对 TokuDB 来说就是灾难了。解决办法就是实现
binlog_savepoint_release
方法，记录release savepoint event到binlog。

ApsaraDB MySQL 5.6 最新版已修复这个问题，对savepoint有需求的TokuDB用户(InnoDB不受影响)做下升级即可。

本篇小文从一个用户引发的问题出发，讨论了TokuDB的savepoint机制，当然TokuDB内核组的同学每天都会处理很多类似的问题，从发现问题到解决问题，以及持续的优化，为的就是给大家提供一种“飞”的感觉。有大数据量存储的同学不妨试试我们的 TokuDB 引擎，存储成本大大降低，顺便体验一把下一代存储引擎带来的“优越感”（注意，这不是广告）。

最后广告还是来了：
我们的PB级云数据库 

PetaData已开始公测

，底层采用TokuDB引擎，存储介质是普通的SATA盘，有兴趣的同学可以去围观下。

  

    

		

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
