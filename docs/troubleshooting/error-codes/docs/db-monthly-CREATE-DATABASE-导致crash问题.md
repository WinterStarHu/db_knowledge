# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/10/08/
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
                      

                    

 
        

    

  

    
 TokuDB · 捉虫动态 · CREATE DATABASE 导致crash问题  

    
 Author: 一工  

  

  

  
背景

TokuDB在启动的时候，会对datadir目录下的文件（和文件夹）进行遍历，根据规则找到所有的redo log文件，然后进行recover操作。
redo文件的命名规则是:log[index].toku[version]，比如log000000000002.tokulog27。

问题

这个bug说起来有点“谜之”，因为它还跟编译器的版本有关。

如果使用gcc 4.8.2编译出一个TokuDB（加-O3编译参数），进行如下操作：

CREATE DATABASE log0002;

然后重启，整个TokuDB就可能凌乱了，出现如下crash信息：

storage/tokudb/ft-index/ft/logger/logfilemgr.cc:159 toku_logfilemgr_init: Assertion 'r==2' failed (errno=2)
Backtrace: (Note: toku_do_assert=0x0xcd50d0)
mysqld(_Z20toku_logfilemgr_initP15toku_logfilemgrPKcPm+0x26c)[0xc40cdc]
mysqld(_Z30toku_logger_open_with_last_xidPKcP10tokuloggerm+0x51)[0xc10ba1]
mysqld(_Z14tokuft_recover)

原因

先来看下TokuDB判断一个文件是否为redo log的代码：

static bool is_a_logfile_any_version (const char *name, uint64_t *number_result, uint32_t *version_of_log) {
	bool rval = true;
	uint64_t result;
	int n;
	int r;
	uint32_t version;
	r = sscanf(name, "log%" SCNu64 ".tokulog%" SCNu32 "%n", &result, &version, &n);
	if (r!=2 || name[n]!='\0' || version <= TOKU_LOG_VERSION_1) {
		//Version 1 does NOT append 'version' to end of '.tokulog'
		version = TOKU_LOG_VERSION_1;
		r = sscanf(name, "log%" SCNu64 ".tokulog%n", &result, &n);
		if (r!=1 || name[n]!='\0') {
			rval = false;
		}
	}
	if (rval) {
		*number_result  = result;
		*version_of_log = version;
	}

	return rval;
}

这段代码的逻辑很简单，调用sscanf函数获取相关参数, 高能区域为：

r = sscanf(name, "log%" SCNu64 ".tokulog%" SCNu32 "%n", &result, &version, &n);

如果name为log0002，调用完sscanf函数后，n和version的值是不确定的（因为函数内变量未被初始化），就可能导致函数 
is_a_logfile_any_version
 把log0002文件夹误认为是一个redo log。
当
toku_logfilemgr_init
函数加载名称“log0002”时做二次校验，获取version值失败从而触发assert。

修复

大体思路是：

  
由于redo log不可能是文件夹，所以增加只对文件进行判断的逻辑，遇到文件夹直接跳过；

  
对
is_a_logfile_any_version
函数内变量进行初始化。

阿里云RDS TokuDB最新版本已经修复此问题，使用TokuDB的用户可以进行下小版本升级，以避免此问题影响业务。

  

    

		

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
