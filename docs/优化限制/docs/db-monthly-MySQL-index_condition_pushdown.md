# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/03/05/
> 分类: 优化限制

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
	

  

    
数据库内核月报 － 2015 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 答疑释惑· 并发Replace into导致的死锁分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 5.7.6 InnoDB page flush 优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· pid file丢失问题分析
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· using filesort VS using temporary
                      

                    

                    

                  
                      

                        MySQL · 优化限制· MySQL index_condition_pushdown
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· lower_case_table_names 使用问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Logical Decoding探索
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· jsonb类型解析
                      

                    

                    

                  
                      

                        TokuDB ·引擎机制· TokuDB线程池
                      

                    

 
        

    

  

    
 MySQL · 优化限制· MySQL index_condition_pushdown  

    
 Author:   

  

  

  

背景

MySQL 5.6 开始支持index_condition_pushdown特性，即server层把可以在index进行filter的谓词传递给引擎层完成过滤，然后结果返回到server。

工作方式

下面看一下InnoDB的处理方式:

通过设置set global optimizer_switch= "index_condition_pushdown=ON"来启用这个特性。

例如:

CREATE TABLE `t1` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`col1` int(11) DEFAULT NULL,
`col2` int(11) DEFAULT NULL,
PRIMARY KEY (`id`),
KEY `t1_cc` (`col1`,`col2`)
)  ENGINE=InnoDB;

mysql&gt; explain select * from t1 where col1&gt;= 1 and col1 &lt;= 4 and col2=11;
+----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+
| id | select_type | table | type  | possible_keys | key   | key_len | ref  | rows | Extra                 |
+----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+
|  1 | SIMPLE      | t1    | range | t1_cc         | t1_cc | 10      | NULL |    2 | Using index condition |
+----+-------------+-------+-------+---------------+-------+---------+------+------+-----------------------+

1. 评估

在执行计划评估阶段，通过push_index_cond函数把index filter谓词传递给引擎handler。

2. 执行

InnoDB通过row_search_for_mysql获取每行记录的时候，使用innobase_index_cond函数来check index filter谓词条件是否成立。通过这种方式来完成index上的filter，整个过程并不复杂。

收益和限制

下面来看一下index_condition_pushdown的收益和限制:

收益: index_condition_pushdown所带来的收益可以从三个方面来看:

1. 数据copy

减少了InnoDB层返回给server层的数据量，减少了数据copy。

2. 随机读取

对于二级索引的扫描和过滤，减少了回primary key上进行随机读取的次数

3. 记录锁

记录锁是在InnoDB层完成的，比如如果是select for update语句，就会发现index_condition_pushdown会大大减少记录锁的个数。

限制: 目前index_condition_pushdown还有诸多的限制:

1. 索引类型

如果索引类型是primary key，就不会采用，因为index_condition_pushdown最大的好处是减少回表的随机IO，所以如果使用的index是PK，那么收益就大大减少，不过MySQL官方也在从新评估是否采用，见WL#6061。

2. 性能衰减

如果在primary key上面使用， 或者index filter谓词并不能有效过滤记录的时候，会发现sysbench的测试性能相比较关闭ICP的方式略低。可以参考
http://s.petrunia.net/blog/?p=101的讨论。

3. SQL类型

1. 不支持多表update和delete语句，因为select和update会共用handler，而一个是一致性读，一个是当前读，同样的filter都apply的话，update会找不到记录。

2. 如果JOIN是CONST 或者 SYSTEM，不能使用。 因为CONST和SYSTEM做了特别优化，只执行一次，做了缓存，而应用filter的话，会产生数据一致性问题。

索引设计的原则

除了MySQL提供的这些新特性以外，DBA或者开发在设计index的时候，应该遵循的一些原则:

1. 查询谓词都能够通过index进行扫描

2. 排序谓词都能够利用index的有序性

3. index包含了查询所需要的所有字段

这就是传说中的Three-star index。

可以参考《Wiley,.Relational.Database.Index.Design.and.the.Optimizers》

MySQL的index_condition_pushdown，前进了一大步，不过相比较Oracle的index扫描方式，还有空间。比如oracle的index扫描支持的index skip scan方式。

  

    

		

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
