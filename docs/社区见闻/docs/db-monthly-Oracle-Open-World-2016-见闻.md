# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/10/02/
> 分类: 社区见闻

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
	

  

    
数据库内核月报 － 2016 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        AliSQL · 社区动态 · 关于开源之后评论的评论
                      

                    

                    

                  
                      

                        MySQL · 社区见闻 · Oracle Open World 2016 见闻
                      

                    

                    

                  
                      

                        MySQL · 社区见闻 · Percona Live 2016 见闻
                      

                    

                    

                  
                      

                        MySQL · 社区见闻 · MariaDB Developer Meeting 2016
                      

                    

                    

                  
                      

                        MySQL · myrocks · data dictionary 分析
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 无法revoke单库或单表权限
                      

                    

                    

                  
                      

                        PgSQL · 代码浅析 · PostgreSQL 可靠性分析
                      

                    

                    

                  
                      

                        PgSQL · 代码浅析 · PostgreSQL 9.6 聚合OP复用的优化分析
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 直方图的实现与分析
                      

                    

                    

                  
                      

                        SQL Server · 最佳实践 · 参数嗅探问题
                      

                    

 
        

    

  

    
 MySQL · 社区见闻 · Oracle Open World 2016 见闻  

    
 Author: plinux  

  

  

  
高能预警：这不是一篇纯技术月报，这不是一篇纯技术月报！（不善拍照，外景图片有从朋友的FB和Twitter中截取）

申请主题

今年的OOW依然在旧金山召开，有了去年参会的经验，感觉以我们的工作水平，放在国际上也是可以出去讲一番的，因此在收到 Oracle ACE 主题邀请之后，就果断把我们去年最大的成果之一——《Double Sync Replication》提交上去了。

不过多久，收到会务组通知主题竟然通过了，第一次在国外用英文公开讲Topic，内心还是有点小激动和小紧张的，好好练了一番英语，当然现场最终还是Chinglish，这是后话了……

参会

9.16到会场Checkin，拿到了自己的小卡片，作为今年唯一来自国内的数据库Speaker，还是很自豪的。（忽略JavaOne，我也不知道为何工作人员给我贴一个JavaOne，我对Java只会写“Hello World” -_-|||）

今年OOW可以明显看到，Oracle未来的战略就是云，到处都体现出云的主题。Oracle也自称是 The fastest growing cloud company，当然这么说应该也没错。

另外有个小小的感觉就是，MySQL的场次真的非常少，去年MySQL还在主会场有Topic，今年所有的MySQL主题都被安排在 Park Central Hotel 这个地方。
但有一个好处就是，可以不用到处走动，就在这坐一天就能听各种MySQL的主题。

现场内容

Docker

首先有一位来自VMware的资深QA老爷子来分享 Docker（为什么有一种 VMware 混入了奸细的感觉）。

首先老爷子比较了用虚拟机和用 Docker 来运行 App 的差异，老爷子认为完整的虚拟机作为容器来运行简单的应用太重了，完全没必要，Dokcer 之类的容器来运行会轻量很多，也好维护。

当然，Docker 本身还是一个完整的系统，并且是一个完整的 Linux 系统。（很有幸今年的云栖大会，也见到了 Docker 的创始人）

然后给了几个示例，如何使用 Docker 来运行 MySQL，回头也可以照着试一下。

AirBnb

然后AirBnb的主题也算比较有意思《Scaling Airbnb: How to Unleash Database Headroom for Exponential Growth》，分享了他们如何应对快速增长的数据。

同一时间还在进行的有 Booking 的主题《MySQL Architecture Cookbook》，他们也是讲的他们如何使用 MySQL，那一场爆满我无法进入，但据入场的朋友告知，讲得其实非常非常基础，看来到哪都是讲最基础可以直接拿来用的东西最受欢迎。

不过AirBnb这场也还算不错，是两位华人演讲，而且大家还有共同的朋友，世界真小～（后来还去了趟AirBnb参观，华人真多……）

其实应对快速增长的数据，大家做法都差不多，AirBnb无非也是加入缓存减少数据库的直接压力，然后数据先拆分，只不过相对来说可能AirBnb业务比较简单，他们先按业务垂直拆分，搞出了很多独立的Node，尽量不分库，然后最主要库再进行水平拆分。

不过沟通下来，他们的数据库并不能支撑100%的压力，也就是说万一前面的缓存挂了，数据库可能瞬间就垮了，应用端也还没有做限流措施，要是整机房断电，后果有点不敢想……

他们使用了 MariaDB 的 MaxScale 作为 Proxy，利用到了MaxScale的连接池，白名单，扩展监控等功能。当然自动切换实际上是没开的，这玩意一般还是人工介入比较安全，万一误判……

相对来说其实我们 RDS 的 Proxy 要比这个功能强大的多，不过看起来美帝除了 Google/Facebook 这样的公司，大家都不爱造轮子，能用现成的就现成的。

他们也想到了重放线上数据库流量来进行压测验证系统承受能力，但是相对来说其实还在比较初步的阶段，只是简单的重放多倍线上流量，并没有针对整个链路进行压测，相对于阿里的全链路压测来说，还处于压测比较初步的阶段。

整个听下来，AriBnb还在继续的高速增长，他们走过的路阿里都走过，基本上每个高速增长的公司，这些路都要走一趟。

其实国内很多公司走的都比这些硅谷创业公司走的前，完全也可以去OOW分享，希望明年见到更多来自国内的主题。

MySQL Team

最火的当然还是官方场，今年 MySQL Team 带来的主题主要都是关于 MySQL 8.0 这个版本的，在官网上已经可以下载8.0的实验室版，官方也介绍了未来的 Roadmap。

MySQL 8.0 完整支持 Unicode 9.0 了，默认字符集将修改为 UTF8MB4，做移动互联网的同学们有福了。

喜欢用UUID当主键的同学们，你们终于可以用UUID当主键而不那么影响性能了，新的UUID也能保证自增序列，不会再乱序了，而且新增了UUID转换函数，可以把UUID压缩到VARBINARY(16)里面存储，占用空间也少了一点。

以前有开发要用UUID当主键的话，我都会把UUID改成唯一索引，另加一个自增数字列当主键，现在一定程度上可以允许使用UUID当主键了。（当然UUID当主键体积还是有点大）

为分析操作提供了CTE，然而我个人依然不建议把数据库当计算器，语法是支持了，优化器呢……

自增值终于可以持久化了！

这个 #199 的无数年的古老 Bug 终于解决了，虽然我们也已经有了解决方案，但是官方能解决还是极好的！

索引定义中的 ASC/DESC 终于有实际的效果了，虽然一直有这个语法，但是 InnoDB 一直不支持用  DESC 方式组织索引。

虽然 InnoDB 的 B-Tree 是双向链表，但是为了避免死锁，在设计上，顺着索引读和逆着索引读效率还是不一样的，加锁规则就不一样。

因此现在能按递减序列组织索引，当大量需要 DESC 排序方式的时候，这样可以提升一定的效率，尤其是需要组合索引中每个列组织方式不一样时，这是很有效的，例如(a DESC, B ASC)。

Performance Schema 终于想起来要加索引了！

查PS里面的表，应该会快一些了。

MySQL 里用命令设置参数也可以持久化了，这个功能其实非常实用，我想DBA都体验过改了参数忘记修改 my.cnf 然后一重启就还原的经历吧……

参数现在可以看到底是编译的还是修改过的还是 my.cnf 里面配置的。

新的数据字典，所有源信息都会写入到 InnoDB 来保存。

实话实说，这样做可能以后 MySQL 支持其他引擎会越来越难了吧……跟 InnoDB 绑定太紧密了。

其他新功能，像 GIS，新的代价模型啦，很多~

最后是 MySQL Cluster 7.5 的提升，然而我们并没有用过。

我的主题

我的主题国内的一些同学都听过了——《Double Sync Replication》，只不过这次是英文版。

尽管努力练习了，但不是母语还是有点困难，刚开始几页老卡壳，讲到后面好一些，毕竟之前已经在Facebook内部给他们分享过一次，有一点点经验了。

给大家介绍 Double Sync 的流程图。

这种 Topic 虽然听众也坐满了，但基本都是熟人，要么是 Percona 的，要么是 MariaDB 的，要么是 MySQL Team 的，还剩几个 Booking 的 Geek，内核圈子还是太小啊～
很荣幸官方 Replication Team 的老大 Luis，Optimizor Team 的老大 Manyi， 还有原厂一票 Product Manager 等原厂小伙伴都全程听了这个 Topic，至少他们没有认为这个协议有什么Bug，哈哈~

这张图国内的小伙伴见过很多次吧~ 用Chinglish改了下注释~

关于开源问题，已经在FAQ写的很明白，一定会开源的！

后面会根据排期，直接放到AliSQL的开源分支里面，也会贡献给原厂和MariaDB。

用户组会议

最后，非常荣幸作为 CMUG（China MySQL User Group） 的社区领导人之一，参加 User Group 的会议。

MySQL的发展离不开整个社区的发展，可以看到MySQL社区的活跃度也在持续增加。

国内的社区也在逐步的壮大，渐渐的有一些国内社区成员到国外给大家分享国内的 MySQL 经验，也逐渐的有国外的小伙伴想来中国沟通，年底 Facebook 的 MySQL Team 就会组团来参加 CMUG 年终总结大会，给国内 CMUG 成员分享 RocksDB。

最后再说两句

其实，国外很多的技术会议，国内的同学们都应该积极的参加一下，其实在技术上我们并不落后，反而其实比很多名气很大的公司要更进步，国内的互联网用户基数很大，所碰到的问题其实更多更棘手，解决的经验并不比谁少，只是缺少信心。

希望以后在国际会议上，越来越多看到国人在上面分享。

  

    

		

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
