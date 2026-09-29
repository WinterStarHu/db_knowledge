# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/06/10/
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
	

  

    
数据库内核月报 － 2015 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 崩溃恢复过程
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 唯一键约束失效
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · ALTER IGNORE TABLE导致主备不一致
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL Sort 分页
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · binlog event 中的 error code
                      

                    

                    

                  
                      

                        PgSQL · 功能分析 · Listen/Notify 功能
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 任性的 normal shutdown
                      

                    

                    

                  
                      

                        PgSQL · 追根究底 · WAL日志空间的意外增长
                      

                    

                    

                  
                      

                        MySQL · 社区动态 · MariaDB Role 体系
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB数据文件大小计算
                      

                    

 
        

    

  

    
 MySQL · TokuDB · TokuDB数据文件大小计算  

    
 Author: 一工  

  

  

  
想要查看TokuDB某个表占了多少磁盘空间，目前还没有太好的方法。
如果你使用’show table status’命令，得到的结果只会让你更迷茫:

           Name: toku
         Engine: TokuDB
        Version: 10
     Row_format: tokudb_zlib
           Rows: 28874059
 Avg_row_length: 30
    Data_length: 868159449
Max_data_length: 9223372036854775807
   Index_length: 2099497463
      Data_free: 0

我们来看看test_toku表磁盘文件大小：

$du -b _test_toku*
124427776       _test_toku_A_B.tokudb  --KEY(A,B)索引数据文件
215959552       _test_toku_B_C.tokudb  --KEY(B,C)索引数据文件
149504000       _test_toku_main.tokudb --主数据文件

Data_length和Index_length都对不上，而且差的还不是一点，真头疼，总不能每次都要去服务器上du吧？其实，我们可以通过
information_schema.TokuDB_fractal_tree_info
得到：

mysql

>
 
select
 
*
 
from
 
TokuDB_fractal_tree_info
 
where
 
table_name

=

'test_toku'

\

G

;

***************************
 
1

.
 
row
 
***************************

        
dictionary_name

:
 
.

/

test

/

test_toku_A_B

     
internal_file_name

:
 
_test_toku_A_B

.

tokudb

bt_num_blocks_allocated

:
 
449

   
bt_num_blocks_in_use

:
 
449

      
bt_size_allocated

:
 
124416093

         
bt_size_in_use

:
 
123563101

           
table_schema

:
 
test

             
table_name

:
 
toku

  
table_dictionary_name

:
 
key

-

test_toku_A_B

***************************
 
2

.
 
row
 
***************************

        
dictionary_name

:
 
.

/

test

/

test_toku_B_C

     
internal_file_name

:
 
.

/

_test_toku_B_C

.

tokudb

bt_num_blocks_allocated

:
 
612

   
bt_num_blocks_in_use

:
 
612

      
bt_size_allocated

:
 
215945353

         
bt_size_in_use

:
 
214784137

           
table_schema

:
 
test

             
table_name

:
 
toku

  
table_dictionary_name

:
 
key

-

test_toku_B_C

***************************
 
3

.
 
row
 
***************************

        
dictionary_name

:
 
.

/

test

/

test_toku

-

main

     
internal_file_name

:
 
.

/

_test_toku_main

.

tokudb

bt_num_blocks_allocated

:
 
486

   
bt_num_blocks_in_use

:
 
486

      
bt_size_allocated

:
 
149491745

         
bt_size_in_use

:
 
148580897

           
table_schema

:
 
test

             
table_name

:
 
toku

  
table_dictionary_name

:
 
main

bt_size_allocated
字段是TokuDB内部维护当前数据文件最后分配的offset，跟数据文件磁盘大小基本一致。

再回到刚才的问题：
show table status
里Data_length和Index_length为什么跟实际大小出入这么大呢？

在
ha_tokudb::info()
里:

stats.data_file_length = dict_stats.bt_dsize;

bt_dsize的值来自toku_ft_stat64:

bt_dsize = ft->in_memory_stats.numbytes;

in_memory_stats.numbytes
是TokuDB在内存中维护的一个变量，用于记录变更数据的增量大小，每次checkpoint的时候持久化到数据文件(包括索引文件)的header里，所以是个出入比较大的参考变量(无压缩)，已不能通过此变量来反应表文件的真实大小。

这么不爽的地方，我们(RDS MySQL)已准备好patch把它修掉，让
show table status
可以拿到TokuDB表文件的真实大小。

  

    

		

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
