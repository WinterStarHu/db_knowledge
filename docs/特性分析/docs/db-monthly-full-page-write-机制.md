# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/11/05/
> 分类: 特性分析

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
	

  

    
数据库内核月报 － 2015 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 社区见闻 · OOW 2015 总结 MySQL 篇
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · Statement Digest
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · PostgreSQL 用户组权限管理
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MDL 实现分析
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · full page write 机制
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · MySQL 外键异常分析
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 优化器 range 的代价计算
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · ORDER/GROUP BY 导致 mysqld crash
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB 中的行锁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · order by limit 造成优化器选择索引错误
                      

                    

 
        

    

  

    
 PgSQL · 特性分析 · full page write 机制  

    
 Author: 康贤  

  

  

  
PG默认每个page的大小为8K，PG数据页写入是以page为单位，但是在断电等情况下，操作系统往往不能保证单个page原子地写入磁盘，这样就极有可能导致部分数据块只写到4K(操作系统是一般以4K为单位)，这些“部分写”的页面包含新旧数据的混合。在崩溃后的恢复期间，xlog 里面存储的记录变化信息不够完整，无法完全恢复该页。PG为了解决这类问题，full_page_write机制孕育而生。

什么是full_page_write？

PostgreSQL 在 checkpoint 之后在对数据页面的第一次写的时候会将整个数据页面写到 xlog 里面。当出现主机断电或者OS崩溃时，redo操作时通过checksum发现“部分写”的数据页，并将xlog中保存的这个完整数据页覆盖当前损坏的数据页，然后再继续redo就可以恢复整个数据库了。
除了能够解决断电等带来坏数据页问题外，full_page_write 还应用在在线备份功能上。PG进行全量备份数据库一般通过pg_basebackup工具实现，pg_basebackup类似于copy操作，在此期间，也会出现部分数据页写到一半时文件被copy走了，正是因为full_page_write存在，备份出来的数据库才可以成功恢复启动。所以即便full_page_write=off，在备份时也会被强制自动打开，保证备份成功。

实现原理

full_page_write主要在XLogInsert(插入一条xlog记录)时发挥作用，通过full_page_writer开关状态以及是否是checkpoint后对数据页面的第一次修改(lsn<RedoRecPtr)判断是否需要备份数据页。如果需要备份，那么则把数据页存放在这条记录的末尾，最终写入到xlog中。

doPageWrites = Insert->fullPageWrites || Insert->forcePageWrites;
/* Find info for buffer */
for (i = 0; i < XLR_MAX_BKP_BLOCKS; i++)
{
    if (dtbuf[i] == InvalidBuffer)
    {
    	/* OK, put it in this slot */
    	dtbuf[i] = rdt->buffer;
    	if (doPageWrites && XLogCheckBuffer(rdt, true,&(dtbuf_lsn[i]), &(dtbuf_xlg[i])))
    	{
    		dtbuf_bkp[i] = true;
    		rdt->data = NULL;
    		rdt->len = 0;
    	}
    	break;
    }
    ......
}

在redo恢复的时候只要数据块有备份，那么就是用备份的数据。

/* If we have a full-page image, restore it and we're done */
if (record->xl_info & XLR_BKP_BLOCK(0))
{
	(void) RestoreBackupBlock(lsn, record, 0, false, false);
	return;
}

full_page_write不足之处

因为full_page_write需要在xlog中记录数据页，会写更多xlog文件，不仅有数据变化信息，还有数据页本身信息，这样会增加额外的IO和磁盘消耗，同时也会引起主备延迟变大。
为了优化full_page_write，社区提供了一个patch，它的主要设计是创建两个共享内存块队列，checkpoint专用buffer队列和非checkpoint专用buffer队列，同时关闭full_page_write。当用户DML产生的数据buffer需要刷盘时，并不是立即刷到磁盘，而是先进入double write的buffer队列，当buffer队列满时，则将buffer队列里面的数据首先刷到特别的double write文件，然后再将数据刷到数据库文件。通过这种设计就不需要在checkpoint 之后在对数据页面的第一次写的时候会将整个数据页面写到 xlog 里面。当数据库需要恢复的时候，遍历所有double write文件里面的记录块，找到每个记录块对应的数据库page，然后对这个page进行checksum，如果page损坏，那么直接把记录块里面的内容覆盖到buffer数据。最后把double write文件删除，重新初始化buffer队列。

总结

把full_page_write这个选项关闭会提高数据库执行速度以及减少xlog数量，但是可能导致系统崩溃或者掉电之后的数据库损坏。如果有减小部分页面写入风险的硬件支持（比如电池供电的磁盘控制器），或者文件系统支持(能够保证page写入原子性)，可以把风险降低到一个可以接受的范围，那么可以考虑关闭这个选项，其他情况下建议打开这个选择。

  

    

		

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
