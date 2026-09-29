# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/05/07/
> 分类: 应用案例

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
	

  

    
数据库内核月报 － 2019 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MSSQL · 最佳实践 · 挑战云计算安全的存储过程
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 聚合函数（Aggregate Function）的实现过程
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · RDS for PostgreSQL 的逻辑订阅
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 通过 SQL 管理 UNDO TABLESPACE
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 通过Resource Group来控制线程计算资源
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Skip Scan Range
                      

                    

                    

                  
                      

                        MongoDB · 应用案例 · killOp 案例详解
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · LinkBuf设计与实现
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI分解，目标设定之 - 等比数列
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI 预测例子
                      

                    

 
        

    

  

    
 MongoDB · 应用案例 · killOp 案例详解  

    
 Author: linqing  

  

  

  
MongoDB 提供 
currentOp
 命令，列出当前正在执行的查询操作，并提供 
killOp
 命令，用于中止一些耗时比较长，影响线上业务的操作，作为一种应急手段。

下图是一个 currentOp 命令的输出项之一，用户在获取到 opid 后，调用 killOp() 并没有把这个请求干掉。

为什么 opid 是负数？

opid 在 mongod 里是一个 
uint32
 类型的整数，当你从 mongo shell 里看到 opid 为负数时，说明你的 mongod 已经成功执行超过21（INT32_MAX）次请求了，相当牛逼。

MongoDB 客户端与server是通过 BSON 来交换数据的，而在 
bson 标准
里，是没有 
uint32
 类型的，所以 opid 最终是以 
int32
 传递给客户端的，shell 拿到这个opid，当这个值超过 INT32_MAX 时，打印出来就是负数了。

负数的 opid 会 kill 会不掉么？

MongoDB 3.2.5 之前的确是有这个 bug，没有考虑到负数的情况，在 
SERVER-23066
 里已经修复了，阿里云上3.2、3.4、4.0 的最新版本均已修复这个问题。

修复的代码也很简单，就是接收到负数opid时，将其转换为 
uint32
 类型，详见 
SERVER-23066 Make killOp accept negative opid

mongod 既然已经修复了，负数 opid 还是 kill 不掉？

此时 killOp 不成功，已经跟 opid 是否是负数没有关系了，本来在 MongoDB 的设计里，也不是所有操作都能被 kill 的。

killOp 的原理，为什么 killOp 能干掉请求？

MongoDB 一个用户连接，后端对应一个线程，本身一个请求开始后，会有一个线程一直执行，直到技术。能被 killOp 杀掉的请求，是因为请求在执行过程中会检测，是否收到了 kill 信号，如果收到了，就走结束请求的逻辑。所以 killOp 的作用也只是给对应的操作一个 kill 信号标志而已。

SomeCommand::Run() 
{
   for (someCondition) {
       doSomeThing();
       if (killOpReceived) { // SomeCommand 主动检测了 killOp 的信号，才能被 kill 掉
         break;
       }
   }
}

什么样的操作需要被 kill 掉？

运行逻辑很简单、开销很低的命令无需捕获 killOp 信号，这种操作 kill 掉也没什么意义，解决不了根本问题。而复杂命令，比如 find、update、createIndex、aggregation 等操作，可能持续遍历很多条记录，才一定需要具备被 kill 的能力。MongoDB 会在执行这些命令的执行逻辑里加入检查是否收到 kill 命令的逻辑。

加了 killOp 检测逻辑的命令，就一定能立马被 kill？

不一定，一个操作比如 createIndex，会分为很多步骤，命令解析、加锁、执行具体命令逻辑、释放锁、回包等，只有命令执行到具体执行逻辑里时，killOp 才会生效，如果一个操作还没有成功加上锁，本身每占用什么资源，而且对应的现成也没有执行，killOp 是不会生效的。

query 操作为什么会加写锁？

正常只读的请求、如 find、listIndexes 都是不会加写锁，但当 MongoDB 开启 profiling 的时候，请求执行超过一定阈值(默认100ms）的请求，会记录到 
db.system.profile
 capped colleciton 里，写这个集合就需要加意向写锁（w），同时对于 capped collection 的写入，会有一个特殊的 METADATA 互斥写锁(W)，有兴趣的研究代码，关键字列在下面.

const ResourceId resourceCappedInFlightForOtherDb =
    ResourceId(RESOURCE_METADATA, ResourceId::SINGLETON_CAPPED_IN_FLIGHT_OTHER_DB);
    
Lock::ResourceLock cappedInsertLockForLocalDb(
    txn->lockState(), resourceCappedInFlightForLocalDb, MODE_X);

  

    

		

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
