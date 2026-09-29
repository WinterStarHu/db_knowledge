# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/12/07/
> 分类: 原理介绍

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
	

  

    
数据库内核月报 － 2018 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        Database · 原理介绍 · 数据库的事务与复制
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · PostgreSQL Hint Bits 简介
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 行级别安全解决方案
                      

                    

                    

                  
                      

                        MySQL · 原理介绍 · 再议MySQL的故障恢复
                      

                    

                    

                  
                      

                        POLARDB · 引擎特性 · 物理复制解读
                      

                    

                    

                  
                      

                        Redis · 原理介绍 · 利用管道优化aofrewrite
                      

                    

                    

                  
                      

                        PgSQL · 原理介绍 · PostgreSQL行锁实现
                      

                    

                    

                  
                      

                        MySQL · RocksDB · 数据的读取(二)
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 11 并行计算算法，参数，强制并行度设置
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL IoT，车联网 - 实时轨迹、行程实践
                      

                    

 
        

    

  

    
 PgSQL · 原理介绍 · PostgreSQL行锁实现  

    
 Author: kangxian  

  

  

  
锁是数据库很重要的机制，PostgreSQL支持表锁，行锁，了解PostgreSQL行锁机制有助于我们在应用中分析和解决行锁的问题。

锁模式

当前PG支持4种行锁模式: FOR KEY SHARE, FOR SHARE, FOR NO KEY UPDATE, FOR UPDATE，我们常见的delete场景获取的均为FOR UPDATE锁，而update场景会获取FOR NO KEY UPDATE或者FOR UPDATE，要看有没有唯一索引了。
下面表格记录了4种锁模式的兼容情况。

加锁流程

  

    
首先加事务Exclusive锁
行锁等到事务提交才会释放，其他事物如果等待这个行锁，必须等待这个事务锁释放。以Update为例，首先分配一个事务xid，这个时候会对事务xid加锁，AssignTransactionId->AssignTransactionId->LockAcquire，这个锁是个内存锁

  

  

    
判断是否需要锁等待
  如果一个tuple被修改或者删除后，会记录xmax和t_infomask，ExecUpdate->heap_update->HeapTupleSatisfiesUpdate会返回tuple状态，只有当前Tuple上的Xmax或者MultiXactId还在活跃事务列表，会进行锁等待

  

  

    
加tuple锁
tuple锁可以保证多个修改事务加锁的顺序问题，原则是先来先拿锁，修改完tuple后，tuple锁会立即释放，而事务锁不会释放。假设有3个事务，A、B、C依次对同一行修改，均未提交，这个时候，A处于idle in transaction状态，B持有tuple锁但是等待A的事务锁，C等待B持有的tupe锁。调用函数为ExecUpdate->heap_update->heap_acquire_tuplock

  

  

    
等待Xmax事务Share锁
  等待事务锁之前，需要释放page锁，这样不会阻塞当前page上其他tuple的访问。调用函数ExecUpdate->heap_update->XactLockTableWait，其他事务commit或者abort后，等待事务会被唤醒，这个时候需要重新检查tuple上的xmax是否发生变化，如果发生变化，需要等待新的xmax事务提交。

  

MultiXact

对于FOR UPDATE和FOR NO KEY UPDATE锁，可以方便通过Tuple上的xmax判断谁持有锁，而对于FOR SHARE和FOR KEY SHARE，一个Tuple上面可能会被多个事务加锁，Tuple上动态维护这些事务代价很高，为了便于维护这些事务状态，PG引入了MultiXact机制，把多事务记录到独立buffer和文件中，如图所示。当触发多事务机制时，会生成一个新的MultiXactId，把当前Tuple对应的所有锁成员放在MultiXactMemberPage中，并把新的MultiXactId保存在xmax中。

总结

PostgreSQL行锁相对于Oracle和MySQL的实现还是有区别的，Oracle记录在ITL中，但是不支持select for share，MySQL记录在bitmap中，但是当更新特别多的时候，产生大量的行锁，bitmap会占用大量内存。

  

    

		

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
