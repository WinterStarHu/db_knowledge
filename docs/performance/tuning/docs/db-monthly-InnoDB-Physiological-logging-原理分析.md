# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2022/05/01/
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
	

  

    
数据库内核月报 － 2022 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB Physiological logging 原理分析
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB unique check 的问题
                      

                    

                    

                  
                      

                        InnoDB · 引擎特性 · LOB 物理结构
                      

                    

                    

                  
                      

                        MySQL · undolog 的purge
                      

                    

 
        

    

  

    
 MySQL · 引擎特性 · InnoDB Physiological logging 原理分析  

    
 Author: baotiao  

  

  

  
为什么InnoDB 的redo log 是
Physiological logging
?

有一个存储的同学来问, 如果redo log 是纯physical log 的话, 那么就可以省去double write buffer 的开销, 保证每一次修改都是在4kb以内(由操作系统保证4kb以内的原子操作), 那么就不存在应用redo 到不新不旧的page 上的问题, 就不需要double write buffer.

目前主要有两种Logical logging and Physical logging.

Logical logging 像Binlog 这种, 记录的是操作, 跟物理格式无关, 所以通过binlog 可以对接不同的存储引擎.

Physical logging 是纯物理格式, byte for byte 的记录数据的改动, 比如 [start, end, ‘xxxxx’] 这样的格式内容改动.

Physical logging
 的优点是高效率, 并且可以直接修改物理格式, 任何操作都不需要重新遍历btree 到指定page.

但是缺点也很明显, 记录的内容非常冗余, 比如一次delete 操作, logical logging 只需要记录MLOG_COMP_REC_DELETE offset 就可以, 实际执行的过程中会修改prev record->next_record, next_record->prev_record, checksum, PAGE_DIR_SLOT_MIN_N_OWNED, 可能还需要更新dir slot 信息等等. 如果改成physical logging 那么这些信息涉及到的内容在page 不同位置, 那么需要记录的日志就非常多了.

另外在page reorgnize 或者 SMO 场景需要记录大量的无用日志, 比如当一个page 内部有过大量的删除, 有碎片需要整理的时候, 因为需要重新组织page结构, 如果physical logging 那么就需要一个一个record 重新insert 到当前page, offset 需要重新记录, 而logical logging 就只需要记录MLOG_PAGE_REORGANIZE 就可以了. 对比一下16kb 的page 只需要记录几个字节, 而physical logging 需要写差不多16kb 的内容了.

Logical logging
 的优点是记录非常高效, 如上面说的delete 操作, 只需要记录几个字节, 在SMO, page reorgnize 等场景更加明显.

但是最大的缺点也很明显, 因为记录的是record_id, 那么所有改动就需要重新遍历btree, 因为都需要对btree 进行修改, 那么就得走加index lock, 串行修改的逻辑. 而物理日志因为page 之前完全没有依赖, 那么就可以并行回放, 这样crash recovery 的效率最高的.

在
ARIES
 文章之后, 大部分的商业数据库选择的是”Physiological Logging”,  也就是”physical to a page, logical within a page.”, InnoDB 也是这样, 尽可能将Logocal logging 和 Physical logging 的优点结合在一起.

记录的redo log 的格式是操作类型, 有些操作类型需要修改record 的话会记录offset. 大量的操作是一些逻辑操作, 比如 MLOG_1BYTE/MLOG_2BYTE/MLOG_INIT_FILE_PAGE 等等.

对于insert/update/delete 等等操作可以保证到记录到page level, 那么在crash recovery 的时候, 就可以并行的回放日志不需要重新执行btree 遍历找到page逻辑, 从而加快crash recovery.

当然现在InnoDB 的日志还有一些冗余的地方, PolarDB 也做了一些改进, 比如增加了record 长度信息, 减少了连续mtr 里面page id 记录等等, MariaDB Marko 也一直在优化这块 
MDEV-12353
. 整体而言都是为了在page 内部的Logical redo 尽可能高效并且减少冗余.

Reference:

  
C. Mohan, Don Handerle
.
 ARIES: A Transaction Recovery Method Supporting Fine-Granularity Locking and Partial Rollbacks Using Write-Ahead Logging.

  
C. Mohan, Frank Levine. ARIES/lM: An Efficient and High Concurrency index Management Method Using Write-Ahead Logging.

  

    

		

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
