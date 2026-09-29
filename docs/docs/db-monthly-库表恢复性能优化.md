# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/08/02/
> 分类: 

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
	

  

    
数据库内核月报 － 2023 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 源码分析 · 庖丁解 InnoDB 之 Buffer Pool
                      

                    

                    

                  
                      

                        PolarDB MySQL - 库表恢复性能优化
                      

                    

                    

                  
                      

                        PolarDB MySQL - InnoDB冷数据表OSS归档
                      

                    

 
        

    

  

    
 PolarDB MySQL - 库表恢复性能优化  

    
 Author: 李畅(巴卡)  

  

  

  
背景

用户在使用数据库时，可能会因为误操作导致数据被误修改，或者想要修复某个用户表的数据，PolarDB 提供了多种备份恢复方式，包括实例级别的备份与恢复、库表备份与恢复、表回收站以及Flashback 等。其中实例级别和库表的备份恢复均基于快照，用户可以将实例或者库表恢复为某个时间点的备份。因为备份需要使用额外的存储，默认频率不会很高，如果想要恢复的时间点没有备份，就需要使用这个时间点之前最近的备份集以及redo log恢复到指定的某个时间点；表回收站用于处理误删表的情况，开启表回收站功能后，删除的表不会被立即删除，而是rename 到 recycle bin 下；Flashback 使用undo 回溯到某个时间点，一般是比较近的时间点。用户在做恢复时，需要根据不同的场景选择合适的恢复方法。

云上数据库的库表恢复

MySQL 的 
Transportable Tablespace
 特性提供了备份以及恢复file_per_table 表的操作。目前各家云厂商提供的库表恢复功能大部分基于该特性实现。简单的备份与恢复流程如下：

  
执行
flush table ... for export
生成描述目标表的 
.cfg
文件;

  
将
.cfg
和
.ibd
文件保存在某个位置做备份；

  
恢复的时候首先
alter table ... discard tablespace
，将之前备份的 
.cfg
和 
.ibd
拷贝到目标表对应的目录下，再执行
alter table ... import tablespace
完成恢复

上述是使用该特性所做的简单的备份恢复操作，但是在数据量以及业务压力比较大的情况下存在下列问题：

  
当表很大的时候，拷贝数据文件比较耗时，并且import 还需要再次读取处理数据页，流程上有冗余；

  
恢复过程包含两个独立的操作，import 操作不是原子操作，无法回滚，如果中间操作失败需要做一些清理

对于第一个问题，PolarDB 底层存储使用PolarStore，可以设置备份策略定期生成备份集，使用ROW(Redirect on Write)，不会对同一份数据复制多次。可以直接使用备份集恢复，也可以基于某个备份集和redo log 恢复到指定的时间点。第二个问题是本文接下来部分介绍的优化要解决的。接下来以恢复到指定时间点为例介绍PolarDB 提供的库表恢复功能的流程。

库表恢复流程

恢复到指定时间点

以恢复库表到指定的时间点为例，用户在确定目标库表和要恢复到的时间点之后，恢复任务会拉起一个临时的实例，该实例使用的PolarStore 上的数据是某个备份集的，因为 lsn 和 时间之间存在映射关系，所以恢复到指定的时间点就是用这个临时的实例应用增量redo 直到某个lsn。恢复完成之后，执行
flush table ... for export
生成导入所需要的
.cfg
文件。至此，临时实例上的任务就已经完成了，这个临时的实例会在整个恢复任务完成之后释放掉。

原导入流程

通过以上步骤，在临时实例上就包含了目标时间点状态的库表数据，接下来的步骤就是：

  
在RW 上创建空表，调用
alter table ... discard tablespace
清理掉RW 下目标表的数据文件；

  
从临时实例挂载的存储上拷贝数据文件到RW上，调用
alter table ... import tablesapce
完成导入；

  
由于PolarDB 是一写多读架构，RO 和 Standby 依赖RW 的redo log 来更新自身的状态，但是原库表恢复逻辑没有记录redo log，所以RO 和 Standby 上还需要额外的操作。对于RO，因为和RW 是共享存储，所以只需要把内存中的table cache清理掉重新从存储上读取就可以了；而Standby 是独立的存储，所以还需要把数据文件再拷贝到Standby 的存储上，清理table cache 并重新从存储上读取。

优化后的导入流程

上述的原有库表恢复流程解决了最开始列出来的第一个问题，但是通过上述时间点恢复的例子可以发现新的问题：

  
一写多读架构RO 和Standby 的使用依赖于RW 的 redo log，但是整个导入流程没有对应的redo log，导致需要在RO 和Standby 上做额外的操作；

  
因为恢复操作没有redo log，所以如果下一次做按时间点库表恢复，无法使用redo log 恢复出这些数据

所以为了解决上面两个问题，以及最开始提到的第二个问题，优化后的流程分别通过对恢复流程记录redo log 以及新的load 数据方式解决。这种新的load 数据的特点包括：

  
使用外部的数据文件作为数据源；

  
具备原子性，数据load 失败，目标数据文件会恢复到之前的状态；

  
load 数据过程中阻止其他的数据修改操作

总结

新的恢复流程通过记录redo log 解决了RO 和 Standby的同步以及多次恢复的问题，通过引入DDL 使得整个恢复流程是一个原子操作。此外还通过省略多余的IO 操作，整体速度比原流程更快。

参考

如何按备份集恢复误操作的数据库/表_云原生关系型数据库 PolarDB-阿里云帮助中心

如何按时间点恢复的方式恢复库表_云原生关系型数据库 PolarDB-阿里云帮助中心

如何从备份集恢复指定的库或表_云原生关系型数据库 PolarDB-阿里云帮助中心

如何将指定的库或表恢复到过去时间点_云原生关系型数据库 PolarDB-阿里云帮助中心

http://mysql.taobao.org/monthly/2022/07/02/

  

    

		

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
