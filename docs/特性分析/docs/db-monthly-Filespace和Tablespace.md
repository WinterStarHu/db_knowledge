# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/06/04/
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
	

  

    
数据库内核月报 － 2016 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 特性分析 · innodb 锁分裂继承与迁移
                      

                    

                    

                  
                      

                        MySQL · 特性分析 ·MySQL 5.7新特性系列二
                      

                    

                    

                  
                      

                        PgSQL · 实战经验 · 如何预测Freeze IO风暴
                      

                    

                    

                  
                      

                        GPDB · 特性分析· Filespace和Tablespace
                      

                    

                    

                  
                      

                        MariaDB · 新特性 · 窗口函数
                      

                    

                    

                  
                      

                        MySQL · TokuDB  · checkpoint过程
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 内部临时表
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 空间优化
                      

                    

                    

                  
                      

                        SQLServer · 最佳实践 · 数据库实现大容量插入的几种方式
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB COUNT(*) 优化(?)
                      

                    

 
        

    

  

    
 GPDB · 特性分析· Filespace和Tablespace  

    
 Author: 康贤  

  

  

  
Filespace和Tablespace

Tablespace允许每个节点使用多种文件目录或者文件系统，当前所有数据都是存储在默认base目录下。我们可以根据需要制定最优的物理存储方式。使用表空间有下面几个优点：

  
根据数据使用频率来选择不同的存储类型

  
控制一些数据库对象的IO性能

比如历史数据表我们存放在SATA盘，频繁使用的表存放在SSD盘。

filespace指的是所有的存储文件系统位置的集合。
1个filespace可以被1个或多个tablespace使用，可以通过

select * from pg_filespace_entry,pg_tablespace,pg_filespace where pg_filespace.oid=pg_filespace_entry.fsefsoid and pg_filespace.oid=pg_tablespace.spcfsoid

SQL命令查看filespace和tablespace对应关系。

创建Filespace

GP有个默认的Filespace是pg_system

postgres=# select * from pg_filespace;
  fsname   | fsowner
-----------+---------
 pg_system |      10
(1 rows)

如果需要创建新的Filespace，那么需要通过gpfilespace工具创建，步骤如下：

  
创建config文件

文件每行内容格式为：
<hostname>:<dbid>:/<filesystem_dir>/<seg_datadir_name>
，每一个节点都需要配置，包括Master、Slave以及Segment
gpfilespace_config文件(文件名任意)内容如下：

filespace:test
localhost:1:/data1/test/demoDataDir-1
localhost:2:/data1/test/demoDataDir0
localhost:3:/data1/test/demoDataDir1
localhost:4:/data1/test/demoDataDir2

  
执行gpfilespace命令

gpfilespace -c gpfilespace_config

一旦集群中创建了新的Filespace，那么再创建备库、创建Mirror等都需要指定Filespace

  
使用gpfilespace创建filespace过程中会重启整个集群，而关闭集群的命令是gpstop -M fast，这样如果存在备库连接，那么会一直等待，所以我们需要手动杀掉备库连接，这样才能快速完成整个过程。

创建备库时创建Filespace

参数格式为：
filespace1_name:fs1_location,filespace2_name:fs2_location

gpinitstandby -s localhost -P 15433 -F test:/data1/test/demoDataDir0-stand,pg_system:/data1/tmp_datadir_for_gpdb_bld/qddir_stand -a

创建Mirror时创建Filespace

文件格式为：

   filespaceOrder=[<filespace1_fsname>[:<filespace2_fsname>:...]
   mirror<content>=<content>:<address>:<port>:<mir_replication_port>:<pri_replication_port>:<fselocation>[:<fselocation>:...]

内如如下：

filespaceOrder=test
mirror0=0:localhost:21000:22000:23000:/data1/test/mirror/demoDataDir0:/data1/test/mirror_file/demoDataDir0
mirror1=1:localhost:21001:22001:23001:/data1/test/mirror/demoDataDir1:/data1/test/mirror_file/demoDataDir1
mirror2=2:localhost:21002:22002:23002:/data1/test/mirror/demoDataDir2:/data1/test/mirror_file/demoDataDir2

创建Tablespace

语法：
CREATE TABLESPACE tablespace_name [OWNER username] FILESPACE filespace_name

这点和PG不同，PG可以在创建tablespace的时候直接指定文件系统位置，PG语法如下：

CREATE TABLESPACE tablespace_name
    [ OWNER user_name ]
    LOCATION 'directory'
    [ WITH ( tablespace_option = value [, ... ] ) ]

GP有两个默认的tablepace，pg_default和pg_global

postgres=# select spcname,spcfsoid from pg_tablespace ;
  spcname   | spcfsoid
------------+----------
 pg_default |     3052
 pg_global  |     3052
(2 rows)

临时文件空间

Greenplum在执行SQL的过程中可能产生大量的workfile和temporary file，为了单独隔离这些文件(避免数据磁盘满或者放到SSD盘提高性能等)，可以将这些临时文件空间可以单独放到一个文件系统中

  
查看当前的临时文件filespace

gpfilespace --showtempfilespace

  
将临时文件目录移到指定的filespace

gpfilespace --movetempfilespace test

执行成功之后将会在每个节点的数据目录(包括Master、Slave、Segment)下生产一个gp_temporary_files_filespace文件，内容如下:

17511
5 /data1/test/demoDataDir0-stand
1 /data1/test/demoDataDir-1

总结

Filespace和Tablespace不仅能够方便我们管理数据存储位置，而且合理搭配SSD和SATA盘能够显著提升IO性能。当然，我们需要熟悉gpfilespace命令，filespace创建之后是不能够删除的，同时在创建备库、创建Mirror需要指定filespace。

  

    

		

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
