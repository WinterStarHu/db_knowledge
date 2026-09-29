# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/12/02/
> 分类: 特性介绍

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
	

  

    
数据库内核月报 － 2015 / 12

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB 事务子系统介绍
                      

                    

                    

                  
                      

                        PgSQL · 特性介绍 · 全文搜索介绍
                      

                    

                    

                  
                      

                        MongoDB · 捉虫动态 · Kill Hang问题排查记录
                      

                    

                    

                  
                      

                        MySQL · 参数优化 ·RDS MySQL参数调优最佳实践
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 备库激活过程分析
                      

                    

                    

                  
                      

                        MySQL · TokuDB · 让Hot Backup更完美
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 表膨胀
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · Index Condition Pushdown (ICP)
                      

                    

                    

                  
                      

                        MariaDB · 社区动态 · MariaDB on Power8
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · 企业版特性一览
                      

                    

 
        

    

  

    
 PgSQL · 特性介绍 · 全文搜索介绍  

    
 Author: 维度  

  

  

  
背景

在日常的数据处理中，我们经常会有这样的需求：从一个文本中寻找某个字符串（比如某个单词）。

对这个需求，我们可以用类似这样的SQL完成：
SELECT * FROM tbl WHERE text LIKE ‘%rds PostgreSQL%’;
（找到含有“rds PostgreSQL”的文本）。

现在我们考虑一些特殊的情形：

  

    
需要查找的文本特别多，特别大；

  

  

    
不做单纯的字符串匹配，而是考虑自然语言的一些特性，比如匹配某一类字符串（域名、人名）或者匹配单词的所有形式（不考虑它的词性及变化，比如have，has，had都匹配出来）；

  

  

    
对中文自然语言特性的支持。

  

那么此时再用以上的 “SELECT … LIKE …” 就不明智了，因为对数据库来说，这样的SQL必然走的是全表扫描，那么当文本特别多、特别大的时候，查找效率就会很低。

另外，这样的SQL也不会智能到可以处理自然语言的特性。

怎么办呢？PostgreSQL（以下简称PG）提供了强大的全文搜索功能可以满足这样的需求。

对文本的预处理

全文搜索首先需要对文本预处理，包括3步：

  

    

将文本分解成一个个token
，这些token可以是数字、单词、域名、人名、email的格式等等。在PG中可以定义一个parser来做这个工作。

  

  

    

将第一步分解成的token标准化
，所谓的标准化就是利用一些规则将token分好类（比如人名是一类、域名是一类等等）。标准化后的token我们称之为lexeme。在PG中是通过定义一个词典来做这个工作。PG里最简单的词典simple的标准化过程就是将大写字母转成小写字母。

  

  

    

对文本打分，优化查找过程
，比如对于待查找的词，文本1匹配的数量大于文本2匹配的数量，那么在这个查找过程，文本1的优先级大于文本2的优先级。

  

在PG中，以上对文本的预处理可以通过一个函数
to_tsvector
来完成，函数的返回值是tsvector这个数据类型。

另外，对于待查找的单词，我们也要用
to_tsquery
这个函数包装起来，函数的返回值是tsquery这个数据类型。

一个简单的例子见下面，
to_tsquery
里的参数可以使用运算符(&:与、|:或、!:非)：

SELECT to_tsvector('fat cats ate fat rats') @@ to_tsquery('fat & rat');
 ?column?
----------
 t

Quick Start

在了解了这些概念之后，我们用实际的例子来玩一玩PG的全文搜索。

我们在client端输入以下命令，\dFp显示的是所有的parser，这里只有一个默认parser(default)。

\dFp+ default 显示默认parser(default)的详细信息：parse的过程（5个函数），parse的Token类型（asciihword, asciiword…）。

sbtest

=#
 
\

dFp

        
List
 
of
 
text
 
search
 
parsers

   
Schema
   
|
  
Name
   
|
     
Description

------------+---------+---------------------

 
pg_catalog
 
|
 
default
 
|
 
default
 
word
 
parser

(

1
 
row

)

sbtest

=#
 
\

dFp

+
 
default

    
Text
 
search
 
parser
 
"pg_catalog.default"

     
Method
      
|
    
Function
    
|
 
Description

-----------------+----------------+-------------

 
Start
 
parse
     
|
 
prsd_start
     
|
 
(

internal

)

 
Get
 
next
 
token
  
|
 
prsd_nexttoken
 
|
 
(

internal

)

 
End
 
parse
       
|
 
prsd_end
       
|
 
(

internal

)

 
Get
 
headline
    
|
 
prsd_headline
  
|
 
(

internal

)

 
Get
 
token
 
types
 
|
 
prsd_lextype
   
|
 
(

internal

)

        
Token
 
types
 
for
 
parser
 
"pg_catalog.default"

   
Token
 
name
    
|
               
Description

-----------------+------------------------------------------

 
asciihword
      
|
 
Hyphenated
 
word

,
 
all
 
ASCII

 
asciiword
       
|
 
Word

,
 
all
 
ASCII

 
blank
           
|
 
Space
 
symbols

 
email
           
|
 
Email
 
address

 
entity
          
|
 
XML
 
entity

 
file
            
|
 
File
 
or
 
path
 
name

 
float
           
|
 
Decimal
 
notation

 
host
            
|
 
Host

 
hword
           
|
 
Hyphenated
 
word

,
 
all
 
letters

 
hword_asciipart
 
|
 
Hyphenated
 
word
 
part

,
 
all
 
ASCII

 
hword_numpart
   
|
 
Hyphenated
 
word
 
part

,
 
letters
 
and
 
digits

 
hword_part
      
|
 
Hyphenated
 
word
 
part

,
 
all
 
letters

 
int
             
|
 
Signed
 
integer

 
numhword
        
|
 
Hyphenated
 
word

,
 
letters
 
and
 
digits

 
numword
         
|
 
Word

,
 
letters
 
and
 
digits

 
protocol
        
|
 
Protocol
 
head

 
sfloat
          
|
 
Scientific
 
notation

 
tag
             
|
 
XML
 
tag

 
uint
            
|
 
Unsigned
 
integer

 
url
             
|
 
URL

 
url_path
        
|
 
URL
 
path

 
version
         
|
 
Version
 
number

 
word
            
|
 
Word

,
 
all
 
letters

(

23
 
rows

)

输入\dF+ english，给出标准化各类英语token时所用到的dictionary：

sbtest

=#
 
\

dF

+
 
english

Text
 
search
 
configuration
 
"pg_catalog.english"

Parser

:
 
"pg_catalog.default"

      
Token
      
|
 
Dictionaries

-----------------+--------------

 
asciihword
      
|
 
english_stem

 
asciiword
       
|
 
english_stem

 
email
           
|
 
simple

 
file
            
|
 
simple

 
float
           
|
 
simple

 
host
            
|
 
simple

 
hword
           
|
 
english_stem

 
hword_asciipart
 
|
 
english_stem

 
hword_numpart
   
|
 
simple

 
hword_part
      
|
 
english_stem

 
int
             
|
 
simple

 
numhword
        
|
 
simple

 
numword
         
|
 
simple

 
sfloat
          
|
 
simple

 
uint
            
|
 
simple

 
url
             
|
 
simple

 
url_path
        
|
 
simple

 
version
         
|
 
simple

 
word
            
|
 
english_stem

创建以default为parser的配置defcfg，并增加token映射，这里我们只关心email, url, host：

sbtest

=#
 
CREATE
 
TEXT
 
SEARCH
 
CONFIGURATION
 
defcfg
 
(

PARSER
 
=
 
default

);

CREATE
 
TEXT
 
SEARCH
 
CONFIGURATION

sbtest

=#
 
ALTER
 
TEXT
 
SEARCH
 
CONFIGURATION
 
defcfg
 
ADD
 
MAPPING
 
FOR
 
email

,

url

,

host
 
WITH
 
simple

;

ALTER
 
TEXT
 
SEARCH
 
CONFIGURATION

建好配置defcfg后，我们看看利用defcfg对文本进行处理的结果。这里使用
to_tsvector
函数，可以看到email，url，host都被识别出来了：

sbtest

=#
 
select
 
to_tsvector

(

'defcfg'

,

'xxx yyy xxx@taobao.com yyy@sina.com http://google.com/123 12345 '

);

                              
to_tsvector

-----------------------------------------------------------------------

 
'google.com'

:

4
 
'google.com/123'

:

3
 
'xxx@taobao.com'

:

1
 
'yyy@sina.com'

:

2

(

1
 
row

)

在实际对表内的文本做全文搜索时，一般对目标列建立gin索引（也就是倒排索引，详情见
官方文档
），这样可以加快查询效率，具体操作如下：

sbtest

=#
 
CREATE
 
TABLE
 
t1

(

c1
 
text

);

CREATE
 
TABLE

sbtest

=#
 
CREATE
 
INDEX
 
c1_idx
 
ON
 
t1
 
USING
 
gin

(

to_tsvector

(

'defcfg'

,
 
c1

));

CREATE
 
INDEX

sbtest

=#
 
\

d
 
t1

     
Table
 
"public.t1"

 
Column
 
|
 
Type
 
|
 
Modifiers

--------+------+-----------

 
c1
     
|
 
text
 
|

Indexes

:

    
"c1_idx"
 
gin
 
(

to_tsvector

(

'defcfg'

::

regconfig

,
 
c1

))

这里我们插入2条文本，并做一些匹配：

sbtest

=#
 
INSERT
 
INTO
 
t1
 
VALUES

(

'xxx yyy xxx@taobao.com yyy@sina.com http://google.com 12345'

);

INSERT
 
0
 
1

sbtest

=#
 
INSERT
 
INTO
 
t1
 
VALUES

(

'xxx yyy xxx@gmail.com yyy@sina.com http://google.com 12345'

);

INSERT
 
0
 
1

sbtest

=#
 
select
 
*
 
from
 
t1

;

                             
c1

-------------------------------------------------------------

 
xxx
 
yyy
 
xxx

@

taobao

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

 
xxx
 
yyy
 
xxx

@

gmail

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

(

2
 
rows

)

sbtest

=#
 
select
 
*
 
from
 
t1
 
where
 
to_tsvector

(

'defcfg'

,

c1

)
 
@@
 
'google.com'

;

                             
c1

-------------------------------------------------------------

 
xxx
 
yyy
 
xxx

@

taobao

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

 
xxx
 
yyy
 
xxx

@

gmail

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

(

2
 
rows

)

sbtest

=#
 
select
 
*
 
from
 
t1
 
where
 
to_tsvector

(

'defcfg'

,

c1

)
 
@@
 
to_tsquery

(

'google.com & yyy@sina.com'

);

                             
c1

-------------------------------------------------------------

 
xxx
 
yyy
 
xxx

@

taobao

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

 
xxx
 
yyy
 
xxx

@

gmail

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

(

2
 
rows

)

sbtest

=#
 
select
 
*
 
from
 
t1
 
where
 
to_tsvector

(

'defcfg'

,

c1

)
 
@@
 
to_tsquery

(

'google.com & xxx@gmail.com'

);

                             
c1

------------------------------------------------------------

 
xxx
 
yyy
 
xxx

@

gmail

.

com
 
yyy

@

sina

.

com
 
http

:

//

google

.

com
 
12345

(

1
 
row

)

以上的操作都是针对英文，实际上对中文也是支持的，不过会稍微麻烦点，因为中文的token必须通过分词才能产生，所以需要先装分词的组件scws和zhparser，具体可以参考
这篇博文
。

结语

本文对PG的全文搜索做了一个入门级的介绍，方便用户快速上手，如果需要对全文搜索作更深入的研究，建议阅读
官方文档第12章
。

  

    

		

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
