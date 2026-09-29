# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2016/03/08/
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
	

  

    
数据库内核月报 － 2016 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · TokuDB · 事务子系统和 MVCC 实现
                      

                    

                    

                  
                      

                        MongoDB · 特性分析 · MMAPv1 存储引擎原理
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · 优化器逻辑推理
                      

                    

                    

                  
                      

                        SQLServer · BUG分析 · Agent 链接泄露分析
                      

                    

                    

                  
                      

                        Redis · 特性分析 · AOF Rewrite 分析
                      

                    

                    

                  
                      

                        MySQL · BUG分析 · Rename table 死锁分析
                      

                    

                    

                  
                      

                        MySQL · 物理备份 · Percona XtraBackup 备份原理
                      

                    

                    

                  
                      

                        GPDB · 特性分析· GreenPlum FTS 机制
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · 备库Seconds_Behind_Master计算
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 锁问题最佳实践
                      

                    

 
        

    

  

    
 GPDB · 特性分析· GreenPlum FTS 机制  

    
 Author: 康贤  

  

  

  
前言

FTS(Fault Tolerance Serve)是GreenPlum中的故障检测服务，是保证GP高可用的核心功能。GreenPlum的Segment的健康检测及HA是由GP Master实现的，GP Master上面有个专门的进程–FTS进程，它可以快速检测到Primary或者Mirror是否挂掉，并及时作出Primary/Mirror 故障切换。如果FTS挂掉了，Master将会重新fork出来一个FTS进程。

FTS实现原理

GP Master上面的FTS进程每隔60s(时间可以配置)向Primary或者Mirror发送心跳包，Primary和Mirror收到心跳包后返回它们的当前状态，FTS进程心跳包的发送状态和Segment返回状态更新元信息和作出故障切换。因为Segment可能很多，为了加快检测速度，FTS是多线程的，默认16个线程。

实现检测方法的源码大致如下：

	while (!probeGetIpAddr(&probeInfo) ||
	       !probeOpenSocket(&probeInfo) ||
	       !probeMarkSocketNonBlocking(&probeInfo) ||
	       !probeConnect(&probeInfo) ||
	       !probeSend(&probeInfo) ||
	       !probeReceive(&probeInfo) ||
	       !probeProcessResponse(&probeInfo))
	{
		probeClose(&probeInfo);
		if (retryCnt == gp_fts_probe_retries)
		{
			write_log("FTS: failed to probe segment (content=%d, dbid=%d) after trying %d time(s), "
					  "maximum number of retries reached.",
					  probeInfo.segmentId,
					  probeInfo.dbId,
					  retryCnt);
			break;
		}

		/* sleep for 1 second to avoid tight loops */
		pg_usleep(USECS_PER_SEC);
		retryCnt++;
		//other code
	}

Segment检测及故障切换

GP Master首先会检测Primary状态，如果Primary不可连通，那么将会检测Mirror状态，Primary/Mirror状态总共有4种：

  
Primary活着，Mirror活着。GP Master探测Primary成功之后直接返回，进行下一个Segment检测；

  
Primary活着，Mirror挂了。GP Master探测Primary成功之后，通过Primary返回的状态得知Mirror挂掉了（Mirror挂掉之后，Primary将会探测到，将自己变成ChangeTracking模式），这时候更新Master元信息，进行下一个Segment检测；

  
Primary挂了，Mirror活着。GP Master探测Primary失败之后探测Mirror，发现Mirror是活着，这时候更新Master上面的元信息，同时使Mirror接管Primary（故障切换），进行下一个Segment检测；

  
Primary挂了，Mirror挂了。GP Master探测Primary失败之后探测Mirror，Mirror也是挂了，直到重试最大值，结束这个Segment的探测，也不更新Master元信息了，进行下一个Segment检测。

参数配置

gp_fts_probe_threadcount

用来故障检测的线程数量，默认为16。

gp_fts_probe_interval

两次检测的时间间隔，默认为60s。如果一次检测时间使用10s，那么剩余50s将会sleep;如果超过60s，将会直接进入下一次检测。

gp_fts_probe_timeout

检测Segment超时时间，默认值: 20。

gp_fts_probe_retries

检测Segment失败重试次数，如果超过这个次数，将会认为当前节点挂掉，默认值: 5。

gp_segment_connect_timeout

Prmary和Mirror文件同步允许连接Mirror最大超时时间，如果达到这个超时时间，Primary将会认为Mirror挂掉了，默认值: 180s。

总结

通过GreenPlum FTS机制学习，可以了解部分MPP架构高可用原理。同时根据自身的业务，合理地配置FTS参数，保障GP高可用。

  

    

		

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
