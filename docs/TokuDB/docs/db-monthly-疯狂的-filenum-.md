# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/08/08/
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
                      

                    

 
        

    

  

    
 MySQL · TokuDB · 疯狂的 filenum++  

    
 Author: 一工  

  

  

  
问题描述

收到一枚RDS TokuDB实例crash导致HA切换的报警，上去一看错误如下：

tokudb/ft-index/ft/cachetable/cachetable.cc toku_cachetable_openfd_with_filenum: Assertion `filenum.fileid != FILENUM_NONE.fileid' failed
/bin/mysqld(_Z19db_env_do_backtraceP8_IO_FILE+0x1b)[0xc57ddb]
/bin/mysqld(_Z35toku_cachetable_openfd_with_filenumPP9cachefileP10cachetableiPKc7FILENUMPb+0x223)[0xbb49b3]
/bin/mysqld(_Z19toku_ft_handle_openP9ft_handlePKciiP10cachetableP7tokutxn+0x135)[0xbf3c05]
/bin/mysqld(_Z20toku_ft_handle_clonePP9ft_handleS0_P7tokutxn+0xb5)[0xbf42f5]
/bin/mysqld(_Z29toku_db_lt_on_create_callbackPN4toku8locktreeEPv+0x2a)[0xb801ba]
/bin/mysqld(_Z18toku_db_open_inameP9__toku_dbP13__toku_db_txnPKcji+0x276)[0xb805b6]
/bin/mysqld(_ZN9ha_tokudb20open_main_dictionaryEPKcbP13__toku_db_txn+0x1ab)[0xb50a0b]
/bin/mysqld(_ZN9ha_tokudb16initialize_shareEPKci+0x2c8)[0xb70848]
/bin/mysqld(_ZN9ha_tokudb4openEPKcij+0x5e9)[0xb71349]
/bin/mysqld(_ZN7handler7ha_openEP5TABLEPKcii+0x33)[0x5e74b3]

这个错误信息在RDS上第一次碰到，隐隐感到这是一个“可遇不可求”的bug导致，开始捉虫。

问题分析

每个表(索引)文件被打开后，TokuDB都会为这个文件赋予一个唯一id，即filenum。

filenum有什么作用？
TokuDB在写redo log的时候，每个事务里会带一个filenum属性，用来标示该事务属于哪个表文件，在崩溃恢复的时候，会根据这个filenum回放到相应的表里。

filenum在什么时候被分配？
表(索引)文件被打开的时候会被分配。

filenum如何分配？
为了保证唯一性，TokuDB维护了一个filenum数据结构(类似binary tree) : m_active_filenum，分配算法：

uint32_t m_next_filenum_to_use;  //全局变量，用来标识已分配的最大filenum
lock();
retry:
int ret = m_active_filenum.find(m_next_filenum_to_use);
if (ret == 0) {
  //m_next_filenum_to_use被占用
  m_next_filenum_to_use++;
  goto retry;
}
filenum = m_next_filenum_to_use; //得到我们想要的filenum
m_next_filenum_to_use++;
unlock();

这样问题就来了，如果用户有非常多的表(索引)文件，不停的被打开和关闭，m_next_filenum_to_use会一直递增下去，由于是uint32_t类型，小宇宙终于爆发了，filenum 递增到4294967295(UINT_MAX)，从而导致assert失败。

问题修复

当一些表(索引)文件被close后，这些filenum可以被回收再利用，所以当filenum递增到UINT_MAX后，重置到0即可:

uint32_t m_next_filenum_to_use;  //全局变量，用来标识已分配的最大filenum
lock();
retry:
int ret = m_active_filenum.find(m_next_filenum_to_use);
if (ret == 0) {
  //m_next_filenum_to_use被占用
  m_next_filenum_to_use++;
  goto retry;
}
// 从0开始重新获取未被使用的filenum
if (m_next_filenum_to_use == UINT_MAX) {
  m_next_filenum_to_use = 0;
  goto retry;
}
filenum = m_next_filenum_to_use; //得到我们想要的filenum
m_next_filenum_to_use++;
unlock();

RDS版本已修复此问题，官方patch戳
这里
。

  

    

		

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
