# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/08/05/
> 分类: migration/upgrade

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
	

  

    
数据库内核月报 － 2015 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 社区动态 · InnoDB Page Compression
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · RDS中的PostgreSQL备库延迟原因分析
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MySQL5.6.26 Release Note解读
                      

                    

                    

                  
                      

                        PgSQL · 捉虫动态 · 执行大SQL语句提示无效的内存申请大小
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MariaDB InnoDB表空间碎片整理
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 归档进程cp命令的core文件追查
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · open file limits
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 疯狂的 filenum++
                      

                    

                    

                  
                      

                        MySQL · 功能分析 · 5.6 并行复制实现分析
                      

                    

                    

                  
                      

                        MySQL · 功能分析 · MySQL表定义缓存
                      

                    

 
        

    

  

    
 MySQL · 社区动态 · MariaDB InnoDB表空间碎片整理  

    
 Author: Plinux  

  

  

  
介绍

当你对InnoDB进行修改操作时，例如删除一些行，这些行只是被标记为“已删除”，而不是真的从索引中物理删除了，因而空间也没有真的被释放回收。InnoDB的Purge线程会异步的来清理这些没用的索引键和行，但是依然没有把这些释放出来的空间还给操作系统重新使用，因而会导致页面中存在很多空洞。如果表结构中包含动态长度字段，那么这些空洞甚至可能不能被InnoDB重新用来存新的行，因为空间空间长度不足。
有些用户可能会使用 OPTIMIZE TABLE 或者 ALTER TABLE <table> ENGINE=InnoDB 来重建这些表，但是这样会导致表的拷贝，如果临时空间不足甚至不足以进行一次 OPTIMIZE TABLE 操作。并且如果你用的是共享表空间方式，OPTIMIZE TABLE 会导致你的共享表空间文件持续增大，因为整理的索引和数据都追加在数据文件的末尾。

新的碎片整理算法

从MariaDB 10.1开始，MariaDB把Facebook的碎片整理代码合并进来了，并且把所有代码都调整到InnoDB/XtraDB层去实现，因而只需要使用现成的 OPTIMIZE TABLE 命令就行。开启新的整理算法需要把下面的配置加到 my.cnf 配置文件中：

[mysqld]
innodb-defragment=1

这样配置以后新的碎片整理功能就会替代原有的 OPTIMIZE TABLE 算法，不会有新的表生成，也不需要把旧表的数据拷贝到新表。新的算法会载入 n 个页面尝试把上面的记录紧凑的合并到一起，从而让页面存满记录，然后释放掉完全空了的页面。

新的配置项

  

innodb_defragment
: 打开或关闭InnoDB碎片整理算法。当设置为FALSE时，所有正在做的整理操作会暂停。暂停的整理操作会在变量设置为TRUE时重新开始。默认值是FALSE。

  

innodb_defragment_n_pages
: 一次性读取多少个页面进行合并整理操作。取值范围是2~32，默认值是7。

  

innodb_defragment_stats_accuracy
: 统计信息写到持久化存储前可以有多少个整理统计信息的变更。设置为0表示不禁用整理统计追踪，默认值是0.

  

innodb_defragment_fill_factor_n_recs
: 在进行空间整理时在一个页面上留多少条记录的空间。这个变量和 innodb_defragment_fill_factor 一起可以让页面不至于被塞得太满，从而减少后面插入记录导致的页面分裂。取值范围是 1~100，默认值是20。

  

innodb_defragment_fill_factor
: 可以设置为[0.7~1]之间的值，让整理算法知道应该把一个页面填的多满。默认值是0.9. 设置为0.7以下没有什么意义。这个变量和 innodb_defragment_fill_factor_n_recs 一起可以让页面不至于被塞得太满，从而减少后面插入记录导致的页面分裂。上面这量个变量也是告诉我们，持续的整理操作可以让InnoDB更高效。

  

innodb_defragment_frequency
: 对单个索引每秒的整理操作不要超过这个数量。这个变量控制了整理线程在一段时间内请求索引的 X_LOCK 的次数。整理线程会检查是当前操作的索引离上次操作的时间否超过了1/defragment_frequency (s) ，如果还没过足够长的时间，则把索引重新放回队列中。实际的操作频率只会比这个值低。

新的状态变量

  

Innodb_defragment_compression_failures
: 整理碎片时重新压缩页面失败的次数。

  

Innodb_defragment_failures
: 整理操作失败的次数（例如没有可压缩的页面）。

  

Innodb_defragment_count
: 整理操作的次数。

举例

set @@global.innodb_file_per_table = 1;
set @@global.innodb_defragment_n_pages = 32;
set @@global.innodb_defragment_fill_factor = 0.95;
CREATE TABLE tb_defragment (
pk1 bigint(20) NOT NULL,
pk2 bigint(20) NOT NULL,
fd4 text,
fd5 varchar(50) DEFAULT NULL,
PRIMARY KEY (pk1),
KEY ix1 (pk2)
) ENGINE=InnoDB;

delimiter //;
create procedure innodb_insert_proc (repeat_count int)
begin
  declare current_num int;
  set current_num = 0;
  while current_num &lt; repeat_count do
    INSERT INTO tb_defragment VALUES (current_num, 1, REPEAT('Abcdefg', 20), REPEAT('12345',5));
    INSERT INTO tb_defragment VALUES (current_num+1, 2, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    INSERT INTO tb_defragment VALUES (current_num+2, 3, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    INSERT INTO tb_defragment VALUES (current_num+3, 4, REPEAT('HIJKLM', 20), REPEAT('67890',5));
    set current_num = current_num + 4;
  end while;
end//
delimiter ;//
commit;
 
set autocommit=0;
call innodb_insert_proc(50000);
commit;
set autocommit=1;

在建表和插入操作之后，我们可以在 INFORMATION_SCHEMA 中看到如下信息：

select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'PRIMARY';
Value
313
 
select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'ix1';
Value
72
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_pages_freed');
count(stat_value)
0
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_page_split');
count(stat_value)
0
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_leaf_pages_defrag');
count(stat_value)
0
 
SELECT table_name, data_free/1024/1024 AS data_free_MB, table_rows FROM information_schema.tables WHERE engine LIKE 'InnoDB' and table_name like '%tb_defragment%';
table_name data_free_MB table_rows
tb_defragment 4.00000000 50051
 
SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'PRIMARY';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` PRIMARY 25873 4739939
 
SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'ix1';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` ix1 50071 1051775

现在如果我们删掉 3/4 的记录就会在页面中留下很多空洞，然后我们通过 OTPTIMIZE TABLE 执行整理操作：

delete from tb_defragment where pk2 between 2 and 4;
 
optimize table tb_defragment;
Table	Op	Msg_type	Msg_text
test.tb_defragment	optimize	status	OK
show status like '%innodb_def%';
Variable_name	Value
Innodb_defragment_compression_failures	0
Innodb_defragment_failures	1
Innodb_defragment_count	4

执行完之后我们可以看到有些页面被释放掉了，有些页面被合并了：

select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'PRIMARY';
Value
0
 
select count(*) as Value from information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name = 'ix1';
Value
0
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_pages_freed');
count(stat_value)
2
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_page_split');
count(stat_value)
2
 
select count(stat_value) from mysql.innodb_index_stats where table_name like '%tb_defragment%' and stat_name in ('n_leaf_pages_defrag');
count(stat_value)
2
 
SELECT table_name, data_free/1024/1024 AS data_free_MB, table_rows FROM information_schema.tables WHERE engine LIKE 'InnoDB';
table_name data_free_MB table_rows
innodb_index_stats 0.00000000 8
innodb_table_stats 0.00000000 0
tb_defragment 4.00000000 12431
 
SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'PRIMARY';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` PRIMARY 690 102145
 
SELECT table_name, index_name, sum(number_records), sum(data_size) FROM information_schema.innodb_buffer_page where table_name like '%tb_defragment%' and index_name like 'ix1';
table_name index_name sum(number_records) sum(data_size)
`test`.`tb_defragment` ix1 5295 111263

  

    

		

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
