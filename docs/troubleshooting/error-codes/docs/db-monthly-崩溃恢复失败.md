# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/05/
> 分类: troubleshooting/error-codes

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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 MySQL · 捉虫动态 · 崩溃恢复失败  

    
 Author:   

  

  

  

现象

5.6版本，在创建InnoDB表过程中，若发生crash，会导致服务无法启动。

背景

每个InnoDB表A创建成功后有两个文件A.frm和A.ibd。建表流程如下：

  

    
创建A.frm

  

  

    
创建A.ibd

  

  

    
初始化A.ibd

  

  

    
将表A加入InnoDB字典

  

若crash发生在步骤2之后，则只保留一个完整的A.frm和一个空文件A.idb。

崩溃恢复

　　在上述的crash发生后，下一次启动则需要做崩溃恢复。崩溃恢复的一个逻辑是需要遍历数据目录下的所有.ibd文件，验证文件与字典的一致性。

　　对于长度为0的.ibd 文件，报错并跳过，继续检测下一个表。

　　以上是5.5和5.6共有的逻辑。但5.6的一个新特性破坏了这个规则。

远程目录

　　5.6支持create table的时候指定其他目录。语法是create table 里新增参数DATA DIRECTORY.这样一个表就可能存在多个表空间。每个表空间对应一个数据结构(fsp_open_info).

　　这意味着在崩溃恢复过程中，需要验证哪一个表空间是可用的(fil_validate_single_table_tablespace)，

　　验证的方法是尝试读取该表空间的第一个page，若可用则将对应的fsp_open_info::success设置为TRUE。

　　而在读取本地默认表空间的第一个页时，若碰到读取失败，直接exit(1)，导致程序直接退出。“若文件小于4个page就报错”的逻辑，是在这个exit之后。

分析改进

　　其实在这个场景下，多出来的A.frm和A.ibd并不会导致系统严重问题。由于表A还没有记录入系统字典，实际上只需要将这两个文件直接删掉即可。

　　因此5.6的这个新增要求过于苛刻。改进方法是将文件大小的判断提前，若发现小于4个page，则直接报错跳过这个表。

  

    

		

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
