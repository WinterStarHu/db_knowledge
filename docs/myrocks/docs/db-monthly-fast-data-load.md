# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/05/09/
> 分类: myrocks

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
	

  

    
数据库内核月报 － 2017 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB Buffer Pool
                      

                    

                    

                  
                      

                        AliSQL · 特性介绍 · 动态加字段
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 数据库崩溃恢复（上）
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 的那些网络超时错误
                      

                    

                    

                  
                      

                        HybridDB · 最佳实践 · HybridDB 数据合并的方法与原理
                      

                    

                    

                  
                      

                        MSSQL · 应用案例 · 构建死锁自动收集系统
                      

                    

                    

                  
                      

                        PostgreSQL · 实现分析 · PostgreSQL 10.0 并行查询和外部表的结合
                      

                    

                    

                  
                      

                        RocksDB · 特性介绍 · HashLinkList 内存表
                      

                    

                    

                  
                      

                        MySQL · myrocks · fast data load
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · "写入、共享、存储、计算" 最佳实践
                      

                    

 
        

    

  

    
 MySQL · myrocks · fast data load  

    
 Author: 张远  

  

  

  
Fast data load

Load data相比普通insert效率更高，Load data批量插入数据有效减少了解析SQL的开销。MyRocks 同其他MySQL 引擎一样也支持Load data语法，同时MyRocks对data load也做了特殊优化。RocksDB引擎有一个规律是，
数据最终会存储在最底层SST文件中
，MyRocks通过参数rocksdb_bulk_load控制是否直接将数据存储在最底层SST文件中，而不走普通的insert流程。

先来看下普通insert流程(图片来自yoshinorim）

优化后的bulk load流程(图片来自yoshinorim）

由于SST文件中的数据必须是有序的，所以 bulk load特性有一个限制是插入的数据必须是按主键有序的。

Insert和Load data都支持bulk load特性，Load data文件中的数据容易保证有序，但对于非自增insert来说，要保证有序插入比较困难，因此bulk load特性对普通insert意义不大。

rocksdb_bulk_load设为1后，开启bulk load特性。值得注意的是，在 bulk load特性下，会默认忽略唯一性检查，同时rocksdb_commit_in_the_middle自动开启。

Bulk load 源码实现

  

    
step 1 第一次插入时会新建SST临时文件, 参见myrocks::Rdb_sst_info::open_new_sst_file

文件形如：test.t1
PRIMARY_0_0.bulk_load.tmp

db.tablename_indexname_count1_count2
.bulk_load.tmp

其中count1每次都会原子自增，防止并发load时出现重名的情况。

其中count2表示当前是第几个SST临时文件

  

  

    
step 2 随后插入都会直接插入到SST临时文件中，参见myrocks::Rdb_sst_info::put

  

  

    
step 3 SST临时文件写满或load结束，将SST临时文件copy或hard link为正式的SST文件，同时更新SST元数据信息，参考rocksdb::ExternalSstFileIngestionJob::Prepare/ExternalSstFileIngestionJob::Run

  

  

    
step 4 删除临时SST文件，参考ExternalSstFileIngestionJob::Cleanup

  

如果bulk load中途mysqld crash有可能残留SST临时文件，mysqld重启时会自动清理SST临时文件。参考Rdb_sst_info::init

Bulk load 相关测试

load data 测试

Bulk load下rocksdb load data比innodb快近3倍。

Bulk load下rocksdb load data比rocksdb 普通load data快近6倍。

perf top

可以看出bulk load模式下，插入流程要简洁很多。

  

    
rocksdb without bulk load

  

  

    
rocksdb with bulk load

  

insert 测试

由于SQL解析占比重较大，bulk load模式下的insert优势并不明细。

perf top

可以看出普通insert相比load data有更多的SQL解析操作（MySQLparse)，同时非bulk load下的insert比bulk load下insert有更多的排序操作(KeyComparator)。

  

    
insert without bulk load

  

  

    
insert with bulk load

  

  

    

		

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
