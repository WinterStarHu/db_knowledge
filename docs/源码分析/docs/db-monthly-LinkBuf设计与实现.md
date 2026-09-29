# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/05/08/
> 分类: 源码分析

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
	

  

    
数据库内核月报 － 2019 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MSSQL · 最佳实践 · 挑战云计算安全的存储过程
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 聚合函数（Aggregate Function）的实现过程
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · RDS for PostgreSQL 的逻辑订阅
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 通过 SQL 管理 UNDO TABLESPACE
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 通过Resource Group来控制线程计算资源
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Skip Scan Range
                      

                    

                    

                  
                      

                        MongoDB · 应用案例 · killOp 案例详解
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · LinkBuf设计与实现
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI分解，目标设定之 - 等比数列
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI 预测例子
                      

                    

 
        

    

  

    
 MySQL · 源码分析 · LinkBuf设计与实现  

    
 Author: 雕梁  

  

  

  
简介

在MySQL8.0中增加了一个新的数据结构叫做Link_buf，它是一个无锁的数据结构，这个数据结构主要用于redolog以及buffer pool的flush list.

这个数据结构简单来看就是一个拥有固定大小的数组，而对于InnoDB使用来说里面保存的就是写入log buffer或者加入到flush list的数据的大小.数组的每个元素可以被原子的更新.

由于在8.0种写入log buffer会有空洞的产生，因此这个数据结构就用来track当前log buffer的写入情况,也就是说每次写入的数据大小都会保存在linkbuffer中，而每次写入的位置通过start lsn来得到(hash),  假设有空洞(某些lsn还没有写入)，那么它对应在linkbuffer中的值就是0,这样就能很简单的track空洞.

最后要注意的是这个数据结构的前提就是LSN是一直增长且不会重复的.因此在InnoDB中只在redolog中使用.

之后在分析redolog的时候，我们可以详细的看到这个数据结构的使用.

源码分析

核心字段

我们先来看这个数据结构的核心字段.

  
Distance 这个累心表示了我们的Link_buf所包含的内容的类型(一般是lsn_t).

  
m_capacity 表示Link_buf的大小.

  
m_links所有的内容都是保存在这里(也就是一个动态数组).

  
m_tail表示当前buffer的结尾(这里的结尾的意思是第一个空洞的位置,也就是可以保证m_tail之前都是连续的).

template
 
<

typename
 
Position
 
=
 
uint64_t

>

class
 
Link_buf
 
{

 
public:

  
typedef
 
Position
 
Distance

;

.....................................

  
*/

**
 
Capacity
 
of
 
the
 
buffer

.
 
*/

*

  
size_t
 
m_capacity

;

  
*/

**
 
Pointer
 
to
 
the
 
ring
 
buffer
 
(

unaligned

).
 
*/

*

  
std

::

atomic

<

Distance

>
 
*

m_links

;

  
*/

**
 
Tail
 
pointer
 
in
 
the
 
buffer
 
(

expressed
 
in
 
original
 
unit

).
 
*/

*

  
alignas

(

INNOBASE_CACHE_LINE_SIZE

)
 
std

::

atomic

<

Position

>
 
m_tail

;

};

￼ ￼

构造函数

这里构造函数就是根据传递进来的capacity,创建对应大小的数组(m_links),然后初始化数组的内容.

template
 
<

typename
 
Position

>

Link_buf

<

Position

>::

Link_buf

(

size_t
 
capacity

)

    
:
 
m_capacity

(

capacity

),
 
m_tail

(

0

)
 
{

  
if
 
(

capacity
 
==
 
0

)
 
{

    
m_links
 
=
 
nullptr

;

    
return

;

  
}

  
ut_a

((

capacity
 
&
 
(

capacity
 
-
 
1

))
 
==
 
0

);

  
m_links
 
=
 
UT_NEW_ARRAY_NOKEY

(

std

::

atomic

<

Distance

>

,
 
capacity

);

  
for
 
(

size_t
 
i
 
=
 
0

;
 
i
 
<
 
capacity

;
 
++

i

)
 
{

    
m_links

[

i

].

store

(

0

);

  
}

}

￼ ￼ ￼

添加内容

add_link函数主要是用来将将要写入的数据的在lsn中的起始以及结束位置进行保存.流程如下。

  
首先根据from计算当前的写入lsn应该在数组的那个位置.

  
然后保存写入的大小到当前的slot.

template
 
<

typename
 
Position

>

inline
 
void
 
Link_buf

<

Position

>::

add_link

(

Position
 
from

,
 
Position
 
to

)
 
{

  
ut_ad

(

to
 
>
 
from

);

  
ut_ad

(

to
 
-
 
from
 
<=
 
std

::

numeric_limits

<

Distance

>::

max

());

  
const
 
auto
 
index
 
=
 
slot_index

(

from

);

  
auto
 
&

slot
 
=
 
m_links

[

index

];

  
ut_ad

(

slot

.

load

()
 
==
 
0

);

  
slot

.

store

(

to
 
-
 
from

);

}

slot_index函数就是用来计算slot，计算方式很简单，和数组的大小取模，这里或许有疑问了，如果当前的slot已经被其他的lsn占据了应该怎么办？这里的解决方式就是通过has_space进行判断.

template
 
<

typename
 
Position

>

inline
 
size_t
 
Link_buf

<

Position

>::

slot_index

(

Position
 
position

)
 
const
 
{

  
return
 
position
 
&
 
(

m_capacity
 
-
 
1

);

}

判断空间

has_space函数就是用来判断对应的position是否已经被占据.

template
 
<

typename
 
Position

>

inline
 
bool
 
Link_buf

<

Position

>::

has_space

(

Position
 
position

)
 
const
 
{

  
return
 
tail

()
 
+
 
m_capacity
 
>
 
position

;

}

advance_tail_until

这个函数用来更新m_tail字段，m_tail字段之前解释过，主要是为了保证它之前的slot都是连续的.

template
 
<

typename
 
Position

>

template
 
<

typename
 
Stop_condition

>

bool
 
Link_buf

<

Position

>::

advance_tail_until

(

Stop_condition
 
stop_condition

)
 
{

  
auto
 
position
 
=
 
m_tail

.

load

();

  
while
 
(

true

)
 
{

    
Position
 
next

;

    
bool
 
stop
 
=
 
next_position

(

position

,
 
next

);

    
if
 
(

stop
 
||
 
stop_condition

(

position

,
 
next

))
 
{

      
break

;

    
}

    
*/

*
 
Reclaim
 
the
 
slot

.
 
*/

*

    
claim_position

(

position

);

    
position
 
=
 
next

;

  
}

  
if
 
(

position
 
>
 
m_tail

.

load

())
 
{

    
m_tail

.

store

(

position

);

    
return
 
true

;

  
}
 
else
 
{

    
return
 
false

;

  
}

}

而上面的代码可以看到每次都会读取next_position,这个函数用来返回下一个slot是否为0,如果是0则返回true，也就是说已经到达空洞.

template
 
<

typename
 
Position

>

bool
 
Link_buf

<

Position

>::

next_position

(

Position
 
*

position

*

,
 
Position
 
&*

next

*

)
 
{

  
const
 
auto
 
index
 
=
 
slot_index

(

position

);

  
auto
 
&

slot
 
=
 
m_links

[

index

];

  
const
 
auto
 
distance
 
=
 
slot

.

load

();

  
ut_ad

(

position
 
<
 
std

::

numeric_limits

<

Position

>::

max

()
 
-
 
distance

);

  
next
 
=
 
position
 
+
 
distance

;

  
return
 
distance
 
==
 
0

;

}

  

    

		

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
