# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/09/09/
> 分类: performance/tuning

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
	

  

    
数据库内核月报 － 2019 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 临时表改进
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 初探 Clone Plugin
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 网络模块优化
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Multi-Valued Indexes 简述
                      

                    

                    

                  
                      

                        AliSQL · 引擎特性 · Statement Queue
                      

                    

                    

                  
                      

                        Database · 理论基础 · Palm Tree
                      

                    

                    

                  
                      

                        AliSQL · 引擎特性 · Returning
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · 回归测试探寻
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · 哈希分片为什么分布不均匀
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG有standby的情况下为什么停库可能变慢？
                      

                    

 
        

    

  

    
 MongoDB · 最佳实践 · 哈希分片为什么分布不均匀  

    
 Author: linqing  

  

  

  
今天接到一个用户反馈的问题，sharding集群，使用wiredtiger引擎，某个DB下集合全部用的hash分片，
show dbs
 发现其中一个shard里该DB的大小，跟其他的集合差别很大，其他基本在60G左右，而这个shard在200G左右？

由于这个DB下有大量的集合及索引，一眼也看不出问题，写了个脚本分析了一下，得到如下结论

  
somedb 下所有集合都是hash分片，并且chunk的分布是比较均匀的

  
show dbs 反应的是集合及索引对应的物理文件大小

  
集合的数据在各个shard上逻辑总大小是接近的，只有shard0占用的物理空间比其他大很多

从shard0上能找到大量 moveChunk 的记录，猜测应该是集合的数据在没有开启分片的情况下写到shard0了，然后开启分片后，从shard0迁移到其他shard了，跟用户确认的确有一批集合是最开始没有分片。

所以这个问题就转换成了，为什么复制集里集合的逻辑空间与物理空间不一致？即collection stat 里 
size
 与 
storageSize
 的区别。

mymongo:PRIMARY> db.coll.stats()
{
	"ns" : "test.coll",
	"size" : 30526664,
	"count" : 500808,
	"avgObjSize" : 33,
	"storageSize" : 19521536,
	"capped" : false,
	....
}

逻辑存储空间与物理存储空间有差距的主要原因

  
存储引擎存储时，需要记录一些额外的元数据信息，这会导致物理空间总和比逻辑空间略大

  
存储引擎可能支持数据压缩，逻辑的数据块存储到磁盘时，经过压缩可能比逻辑数据小很多了（具体要看数据的特性，极端情况下压缩后数据变大也是有可能的）

  
引擎对删除空间的处理，很多存储引擎在删除数据时，考虑到效率，都不会立即去挪动数据回收删除的存储空间，这样可能导致删除很多文档后，逻辑空间变小，但物理空间并没有变小。如下图所示，灰色的文档删除表示被删除。删除的空间产生很多存储碎片，这些碎片空间不会立即被回收，但有新文档写入时，可以立即被复用。

而上述case里，集合数据先分到一个shard，然后启用分片后，迁移一部分到其他shard，就是一个典型的产生大量存储碎片的例子。存储碎片对服务通常影响不大，但如果因为空间不够用了需要回收，如何去强制的回收这些碎片空间？

  
数据清理掉重新加入复制集同步数据，或者直接执行resync命令 （确保有还有其他的数据备份）

  
对集合调用 compact 命令

参考资料

  

resync命令

  

compact命令

  

    

		

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
