# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/09/04/
> 分类: 答疑解惑

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
	

  

    
数据库内核月报 － 2015 / 09

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 ·  InnoDB Adaptive hash index介绍
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 ·  clog异步提交一致性、原子操作与fsync
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · BUG 几例
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 诡异的函数返回值
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 建表过程中crash造成重建表失败
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 谈谈checkpoint的调度
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.6 并行复制恢复实现
                      

                    

                    

                  
                      

                        MySQL · 备库优化 ·  relay fetch 备库优化
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 5.6并行复制事件分发机制
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 文件目录谈
                      

                    

 
        

    

  

    
 PgSQL · 答疑解惑 · 诡异的函数返回值  

    
 Author: 康贤  

  

  

  
背景

修改PG源码时，在elog.c文件中准备调用timestamp.c中的
TimestampTz GetCurrentTimestamp(void)
，以获取当前时间，
TimestampTz
是个int64类型，但是返回值类型不是期望的（是个int32值），但是在另外一个文件postgres.c调用返回的是正常的，如下：

elog

.

c

:
 
GetCurrentTimestamp

()
 
=
 
3891376011

postgres

.

c

:
 
GetCurrentTimestamp

()
 
=
 
495621643471576

也就是说，同一个函数在不同文件返回值的长度完全不同！

原因调查

首先查看具体函数定义
GetCurrentTimestamp()
，怀疑是elog.c没有宏定义
HAVE_INT64_TIMESTAMP
，随后gdb调试查看，最终计算的结果result确实是int64的值，当这个函数返回之后得到的值却变成了int32的值。

TimestampTz

GetCurrentTimestamp

(

void

)

{

	
TimestampTz
 
result

;

	
struct
 
timeval
 
tp

;

	
gettimeofday

(

&

tp

,
 
NULL

);

	
result
 
=
 
(

TimestampTz

)
 
tp

.

tv_sec
 
-

		
((

POSTGRES_EPOCH_JDATE
 
-
 
UNIX_EPOCH_JDATE

)
 
*
 
SECS_PER_DAY

);

#ifdef HAVE_INT64_TIMESTAMP

	
result
 
=
 
(

result
 
*
 
USECS_PER_SEC

)
 
+
 
tp

.

tv_usec

;

#else

	
result
 
=
 
result
 
+
 
(

tp

.

tv_usec
 
/
 
1000000

.

0

);

#endif

	
return
 
result

;

}

难道elog.c调用的不是timestamp.c中这个函数？继续在源码中查找这个
GetCurrentTimestamp
函数定义，看是否有多个定义。但是查找的结果是除了这个文件有定义，其他文件都没有这个函数定义，并且在timestamp.c这个函数中添加debug信息也都打印出来了，现在可以确定是函数返回的时候将int64转成int32了。百思不得其解之际，最后在编译日志中发现一个warning：

elog.c:2245: warning: implicit declaration of function ‘GetCurrentTimestamp’

在网上搜了一下，这种警告是由于函数未声明引起的，但是
GetCurrentTimestamp()
在timestamp.h中声明了，通过对比postgres.c和elog.c include的头文件发现区别：postgres.c包含
#include "utils/timestamp.h"
，也就是在postgres.c 中含有
GetCurrentTimestamp
的函数声明，而在elog.c中却没有。在通过测试发现，C程序如果在函数调用前，没有对函数作声明，则编译系统会把第一次遇到的该函数形式（函数定义或函数调用）作为函数的声明，并将函数类型默认为int 型！

解决方法

在elog.c中添加
#include "utils/timestamp.h"
头文件，并查看编译日志看是否有其他这样的warning。重新配置编译选项，加上-Werror-implicit-function-declaration，将这种warning改成error，提前报错。

总结

对于这个warning需要重视，通过修改编译选项将其变成error，便于我们发现问题，错误发现的越早越好，避免在编译时忽略或者掩盖错误。如果不是这个函数返回值错误特别明显，它将有可能成为一个隐形的bug。

  

    

		

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
