# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/02/04/
> 分类: 会议见闻

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
	

  

    
数据库内核月报 － 2016 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 文件系统之文件物理结构
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 文件系统之IO系统和内存管理
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · InnoDB transaction history
                      

                    

                    

                  
                      

                        PgSQL · 会议见闻 · PgConf.Russia 2016 大会总结
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · PostgreSQL 9.6 并行查询实现分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB之黑科技工具
                      

                    

                    

                  
                      

                        PgSQL · 性能优化 · PostgreSQL TPC-C极限优化玩法
                      

                    

                    

                  
                      

                        MariaDB · 版本特性 · MariaDB 的 GTID 介绍
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 线程池
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · mysqldump tips 两则
                      

                    

 
        

    

  

    
 PgSQL · 会议见闻 · PgConf.Russia 2016 大会总结  

    
 Author: 明虚  

  

  

  
大会概况

2月3号到5号，受邀去莫斯科参加了PgConf.Russia大会，这里介绍一下大会的一些见闻。

此次大会的新闻报道见
此链接
。此次会议有多达600多人参加，聚集了俄罗斯地区的PG相关厂商、DBA和开发者。大会邀请了20多位来自俄罗斯之外的国际演讲者，包括PG核心开发团队的大佬Bruce Momjian和Heikki Linnakangas。大会的议程见
此链接
。PG内核开发者Oleg Bartunov（及其创建的Postgres Professional公司）是本次会议的主要组织者。总体来看，PG目前在俄罗斯的发展阶段和中国非常相似，由于信息安全方面和成本的考虑，大量Oracle的用户正在转向PG，PG受到越来越多的关注。

主要演讲

在这次会议我主要关注了国际演讲者的会场。其中，Bruce主要介绍了PG 9.5的新特性和一些未来的方向，大概也都是大家在官网文档能看到的内容；Andreas Freund介绍了如何避免checkpoint时的IO突增对系统稳定性的影响，思路是在写脏页时调用
sync_file_range
以及checkpoint时对脏页先排序再落盘，对
sync_file_range
的使用与我们RDS for PG使用的策略有些相似（我们是在做checkpoint的调用
sync_file_range
来减少fsync时的脏页数量，增强系统稳定性）；李元佳介绍了PG在中国发展的情况；Alexander Korotkov介绍了创建Pluggable Access Method的新方法，例如创建新的索引的访问方法，来增加新的索引类型，新的存储引擎等；Fabio Telles Rodriguez介绍了PG在巴西银行中的应用，涉及成千上万的遍布巴西各地的银行分支机构，围绕PG他们建立了一个复杂、大数据量、高并发的业务系统；内核开发者Michael Paquier的演讲
《PostgreSQL and backups》
介绍了PG的备份工具，其中对pg_arman（有点类似Oracle的RMAN工具）做了实际的演示。

Peter van Hardenberg介绍了Heroku如何运营百万级的PG数据库，这是我觉得印象最深的一个演讲（可能因为他也是做“云上PG”的），他演讲的题目是《Megascale PostgreSQL-as-a-Service: Operating 106 databases》。Heroku是一个后端云服务平台（即提供了应用服务器到数据库的整体云服务），他们理念是努力做到帮应用开发者省去尽量多的在架构和运维方面花的时间，让他们集中于用代码实现业务逻辑，他们采用了PG作为唯一的数据库（还支持Redis缓存服务）。Peter介绍了团队的发展历程，目前他们用10个人左右的团队，开发和运维了百万级的数据库（数据库个数，非实例个数）。使用Heroku的API，可以实现一个命令就可以创建好一个实例。其丰富的API提供了从创建实例，到监控等各种功能。他们有一个很有意思的功能，叫dataclips，即可以为某条SQL生成一个URL，访问这个URL即可得到相应的数据（SQL查询结果），可以用于数据分享。近期他们还实现了慢SQL的诊断分析及其可视化。对于管理团队，他非常强调一点是，开发人员要同时兼职运维，这样能迫使开发人员努力自动化运维工作，这和我们阿里云的思路真是不谋而合。与Peter同行的另一位Heroku工程师Will Leinweber介绍了Heroku的具体开发工作。

大会请来了日本Pivotal团队的Andreas Scherbaum，演讲题目是
《How We Made Greenplum Open Source》
，介绍了Greenplum的开源历程，解释了为什么GP从公告开源到实际放出代码为什么经历了近一年之久：代码清理、License问题、专利问题、与内部测试系统的解耦等等，耗费了大量的时间。Andreas还揭秘了GP在Pivotal十几年的开发历程。

来自EDB的Kevin Grittner大篇幅的介绍了PG实现隔离级别的实现；而Vladimir Sitnikov 的演讲《PostgreSQL and JDBC: striving for high performance》很有意思，对比了“无数”个JDBC for PG的Driver，对需要选择JDBC Driver的人来说非常有参考价值。最后参加了内核开发者Heikki Linnakangas的《Index Internals》，其中介绍GIST、GIN等各种索引的架构非常透彻。

另外，我也以《Alibaba and Postgres》为题介绍了我们的“云上PG”的情况，主要是我们如何解决上云过程中遇到的问题，包括处理OOM、闪断、连接池、权限管理等等，大家有兴趣可以参看
这里
。

上面是对本次大会演讲的一个粗略介绍，详细的演讲资料请大家关注
大会网站
，这些资料会后续公布。

题外的话

最后说些题外的话，本次会议会址基本上是在莫斯科市中心了，很多漂亮的剧院；会议的几天并不太冷（0度左右），算是赶上了好天气（往年一般零下20度）。现在是去莫斯科游玩的好时候：因为货币贬值，宾馆酒店的价格实际大幅下降。不过去市中心的咖啡馆、餐馆还是要谨慎，价格还是相当“感人”的。

总结一下此次俄罗斯之行，感触最深的是俄罗斯PG爱好者的热情，和PG在俄罗斯发展的巨大机遇。美中不足的是，俄罗斯目前还没有公有云的提供商（或数据中心），期待AWS或阿里云尽快在俄罗斯建立数据中心，早日让俄罗斯的PG爱好者也能开启云上PG之旅。

  

    

		

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
