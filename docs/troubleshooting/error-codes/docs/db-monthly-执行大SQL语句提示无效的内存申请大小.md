# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/08/04/
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
                      

                    

 
        

    

  

    
 PgSQL · 捉虫动态 · 执行大SQL语句提示无效的内存申请大小  

    
 Author: 康贤  

  

  

  
背景

我们执行一个大SQL时（长度大于512M），会返回如下错误：

ERROR: invalid memory alloc request size 1073741824

复现

我们首先复现出来这个问题

  

    
创建表

    

 create table byteatable(id int, obj bytea);

    

  

  

    
插入512M大对象

    

 #!/bin/bash
 data='a'
 for ((i=1;i<=29;i++));
 do
 data=$data$data
 done
 echo 'build ok'
 psql -U postgres -d postgres << EOF
 insert into byteatable(id,obj) values (1,"$data");
 EOF
 echo 'OK'

    

  

执行脚本后就能复现出来了

ERROR: invalid memory alloc request size 1073741824

BUG分析

我们先找到出现这个错误的位置。

源码位置：

void *
MemoryContextAlloc(MemoryContext context, Size size)
{
    void *ret;
    AssertArg(MemoryContextIsValid(context));
    if (!AllocSizeIsValid(size))
      elog(ERROR, "invalid memory alloc request size %zu", size);
    context->isReset = false;
    ret = (*context->methods->alloc) (context, size);
    VALGRIND_MEMPOOL_ALLOC(context, ret, size);
    return ret;
}

#define AllocSizeIsValid(size) ((Size) (size) <= MaxAllocSize)

#define MaxAllocSize ((Size) 0x3fffffff) /* 1 gigabyte - 1 */

这里限制的内存是1G - 1，而我们插入的大SQL需要的内存没有1G，那么为什么还提示非法的申请内存大小呢？通过调试跟踪，我们发现是在词法分析的时刻出错的。主要问题是在词法分析的内存申请机制上，申请的内存肯定不能少于sql的长度，如果当前申请的内存不够用，那么将重新申请当前内存乘以2的内存大小。

int literallen; /* actual current string length */

int literalalloc; /* current allocated buffer size */
//当前申请内存初始化
yyext->literalalloc = 1024;

static
 
void

addlit

(

char
 
*

ytext

,
 
int
 
yleng

,
 
core_yyscan_t
 
yyscanner

)

{

    
/* enlarge buffer if needed */

    
if
 
((

yyextra

->

literallen
 
+
 
yleng

)
 
>=
 
yyextra

->

literalalloc

)

    
{

       
do
 
{

           
yyextra

->

literalalloc
 
*=
 
2

;

       
}
 
while
 
((

yyextra

->

literallen
 
+
 
yleng

)
 
>=
 
yyextra

->

literalalloc

);

       
yyextra

->

literalbuf
 
=
 
(

char
 
*

)
 
repalloc

(

yyextra

->

literalbuf

,

                              
yyextra

->

literalalloc

);

     
}

     
/* append new data */

     
memcpy

(

yyextra

->

literalbuf
 
+
 
yyextra

->

literallen

,
 
ytext

,
 
yleng

);

     
yyextra

->

literallen
 
+=
 
yleng

;

}

static
 
void

addlitchar

(

unsigned
 
char
 
ychar

,
 
core_yyscan_t
 
yyscanner

)

{

     
/* enlarge buffer if needed */

     
if
 
((

yyextra

->

literallen
 
+
 
1

)
 
>=
 
yyextra

->

literalalloc

)

     
{

          
yyextra

->

literalalloc
 
*=
 
2

;

          
yyextra

->

literalbuf
 
=
 
(

char
 
*

)
 
repalloc

(

yyextra

->

literalbuf

,

         
yyextra

->

literalalloc

);

     
}

}

从源码中可以看出，每次申请原申请内存的2倍，即yyextra->literalalloc *= 2; 而最大申请内存限制是

#define MaxAllocSize ((Size) 0x3fffffff) 

/* 1 gigabyte - 1 */

所以我们在词法分析能申请的最大内存是2^29 = 536870912，如果词法分析SQL语句需要的内存大于536870912，那么申请的内存需要再乘2，就会得到2^30 = 1073741824，超过MaxAllocSize＝0x3fffffff= 1073741823。所以会提示错误：

ERROR: invalid memory alloc request size 1073741824

当然不仅仅是插入一个大对象才会引起这个问题，只要是SQL语句长度大于512M都是出现这个错误,我们可以使用select复现：

do
 
language
 
plpgsql
 
$$

declare

  
v_text
 
text
 
:

=
 
'a'

;

begin

  
for
 
i
 
in
 
1

..

29
 
loop

    
v_text

:

=

v_text

||

v_text

;

  
end
 
loop

;

  
execute
 
$

_

$

select
 
'$_$||v_text||$_$'

$

_

$

;

  
raise
 
notice
 
'execute a sql large than 512MB success.'

;

exception
 
when
 
others
 
then

  
raise
 
notice
 
'execute a sql large than 512MB failed.'

;

end

;

$$

;

BUG修复

其实申请MaxAllocSize是可行的，通过修改源码实现，每当申请的内存大于MaxAllocSize并且SQL需要的长度小于MaxAllocSize时，我们就申请MaxAllocSize大小的内存。

static void
addlit(char *ytext, int yleng, core_yyscan_t yyscanner)
{
    /* enlarge buffer if needed */
    if ((yyextra->literallen + yleng) >= yyextra->literalalloc)
    {
        do {
                yyextra->literalalloc *= 2;
        } while ((yyextra->literallen + yleng) >= yyextra->literalalloc);
        /* we can not alloc more than MaxAllocSize */
        if (yyextra->literalalloc > MaxAllocSize && (yyextra->literallen + yleng) < MaxAllocSize)
                yyextra->literalalloc = MaxAllocSize;
        yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
                                                                                        yyextra->literalalloc);
    }
    /* append new data */
    memcpy(yyextra->literalbuf + yyextra->literallen, ytext, yleng);
    yyextra->literallen += yleng;
}

static void
addlitchar(unsigned char ychar, core_yyscan_t yyscanner)
{
    /* enlarge buffer if needed */
    if ((yyextra->literallen + 1) >= yyextra->literalalloc)
    {
        yyextra->literalalloc *= 2;
        /* we can not alloc more than MaxAllocSize */
        if (yyextra->literalalloc > MaxAllocSize && (yyextra->literallen + 1) < MaxAllocSize)
                yyextra->literalalloc = MaxAllocSize;
        yyextra->literalbuf = (char *) repalloc(yyextra->literalbuf,
                                                                                        yyextra->literalalloc);
    }
    /* append new data */
    yyextra->literalbuf[yyextra->literallen] = ychar;
    yyextra->literallen += 1;
}

修复之后可以正常插入了

$ 
sh pgtest.sh
build ok
INSERT 0 1
OK

  

    

		

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
