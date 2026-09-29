# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/10/10/
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
	

  

    
数据库内核月报 － 2015 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 全文索引简介
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 跟踪Metadata lock
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 索引过滤性太差引起CPU飙高分析
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · PG主备流复制机制
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · start slave crash 诊断分析
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 删除索引导致表无法打开
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · PostgreSQL Aurora方案与DEMO
                      

                    

                    

                  
                      

                        TokuDB · 捉虫动态 · CREATE DATABASE 导致crash问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · pg_receivexlog工具解析
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MySQL权限存储与管理
                      

                    

 
        

    

  

    
 MySQL · 特性分析 · MySQL权限存储与管理  

    
 Author: 济天  

  

  

  
权限相关的表

系统表

MySQL用户权限信息都存储在以下系统表中，用户权限的创建、修改和回收都会同步更新到系统表中。

mysql.user            //用户信息
mysql.db              //库上的权限信息
mysql.tables_priv     //表级别权限信息
mysql.columns_priv    //列级别权限信息
mysql.procs_priv      //存储过程和存储函数的权限信息
mysql.proxies_priv    //MySQL proxy权限信息，这里不讨论

  
mysql.db存储是库的权限信息，不是存储实例有哪些库。MySQL查看实例有哪些数据库是通过在数据目录下查找有哪些目录文件得到的。

information_schema表

information_schema下有以下权限相关的表可供查询:

USER_PRIVILEGES
SCHEMA_PRIVILEGES
TABLE_PRIVILEGES
COLUMN_PRIVILEGES

权限缓存

用户在连接数据库的过程中，为了加快权限的验证过程，系统表中的权限会缓存到内存中。
例如：
mysql.user缓存在数组acl_users中,
mysql.db缓存在数组acl_dbs中,
mysql.tables_priv和mysql.columns_priv缓存在hash表column_priv_hash中,
mysql.procs_priv缓存在hash表proc_priv_hash和func_priv_hash中。

另外acl_cache缓存db级别的权限信息。例如执行use db时，会尝试从acl_cache中查找并更新当前数据库权限（
thd->security_ctx->db_access
）。

权限更新过程

以grant select on test.t1为例:

  
更新系统表mysql.user，mysql.db，mysql.tables_priv；

  
更新缓存acl_users，acl_dbs，column_priv_hash；

  
清空acl_cache。

FLUSH PRIVILEGES

FLUSH PRIVILEGES会重新从系统表中加载权限信息来构建缓存。

当我们通过SQL语句直接修改权限系统表来修改权限时，权限缓存是没有更新的，这样会导致权限缓存和系统表不一致。因此通过这种方式修改权限后，应执行FLUSH PRIVILEGES来刷新缓存，从而使更新的权限生效。

通过GRANT/REVOKE/CREATE USER/DROP USER来更新权限是不需要FLUSH PRIVILEGES的。

  
当前连接修改了权限信息时，现存的其他客户连接是不受影响的，权限在客户的下一次请求时生效。

  

    

		

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
