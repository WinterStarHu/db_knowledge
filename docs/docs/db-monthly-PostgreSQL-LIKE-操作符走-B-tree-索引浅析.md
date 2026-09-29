# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/11/01/
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
	

  

    
数据库内核月报 － 2024 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PostgreSQL LIKE 操作符走 B-tree 索引浅析
                      

                    

                    

                  
                      

                        MySQL · 功能特性 · 谓词下推增强
                      

                    

 
        

    

  

    
 PostgreSQL LIKE 操作符走 B-tree 索引浅析  

    
 Author: 李海洋（陌痕）  

  

  

  
背景

LIKE 操作符是 PostgreSQL 支持的三种模式匹配方法之一。一般情况下，如果 SQL 中有模式匹配的过滤条件期望走索引，我们更推荐使用 GIN 或者 GIST 索引，同时配合创建一些插件，比如 pg_trgm，来达到更理想的效果。
如果模式匹配字符串的模式以常量前缀开头，即满足前缀匹配，那么 B-tree 索引也可能被使用。能走 B-tree 索引的理论基础是因为前缀匹配可以被转换成一个范围查询。
本文将对 LIKE 操作符前缀匹配走 B-tree 索引的原理作简要分析。

后面将会涉及到索引访问方法的 opclass（操作符类）和 opfamily（操作符族）的概念，可以参考
另一篇文章
。

分析

创建一张表 test，具体的创建语句为：

create table test(id int, c2 varchar(20));
insert into test select i, i from generate_series(1,100000)i;
create index idx_test_id_1 on test(id);
create index idx_test_c2_1 on test(c2);
analyze test;

一般场景

如果我们执行
explain select * from test where id > 1 and id < 10;
（SQL 1）将会得到下面的执行计划：

可以看执行计划中走了索引。

那如果我们稍微更改下 SQL，改为
explain select * from test where id > 1::numeric and id < 10::numeric;
（SQL 2）将会得到另一个执行计划：

可以看到执行计划中没有走索引。

如果对 PostgreSQL 稍微熟悉的同学，可能会为 SQL 2 再创建一个表达式索引
create index idx_test_id_2 on test((id::numeric));
，然后再次执行 SQL，就会看到已经走了索引：

这里判断是否能走索引的底层原理是什么呢？正常情况下，PostgreSQL 中过滤条件能够走索引需要满足：

  

过滤条件转换成index_key OP right_arg的形式；

  

OP
在索引对应的 opfamily 中。

条件 1 一般默认满足，或者通过操作符的 commutator 交换左右位置也能满足，这里重点介绍下条件 2。

查看 
create index
 的语法可以看到，在创建索引时可以指定对应的 opclass：

如果没有指定，
就会根据每个 index_key 的类型，选择对应的默认 opclass。
每种索引可以为一种类型定义多个 opclass，但是默认的 opclass 有且只有一个。每个 opclass 又属于一个 opfamily，可以通过 pg_opclass 查看对应关系，比如 SQL 1 中用到的索引，是 B-tree 的 int 类型，系统表中的内容为：

可以看到 B-tree 的 int 类型只有一个默认的 int4_ops。通过查看 pg_index ，我们可以进一步确认对应关系:

我们找到了对应的 opfamily，然后通过查询看到 SQL 1 过滤条件的操作符都在其中：

因此条件 2 也满足，能够走索引。

SQL 2 在没有创建表达式索引之前，不能够走索引，也是因为过滤条件最终的操作符为
OP(numeric, numeric)
，不在对应的 opfamily 中。创建表达时索引之后，SQL 2 就能够走表达式索引的关键因素就是上面所说的，opcalss 是根据 index_key 的类型来选择。这个例子中表达式索引的 index_key 是 numeric 类型，所以会默认选择 numeric 类型的 opclass，而
OP(numeric, numeric)
操作符在相应 opfamily 中，因此能够走索引。

LIKE 前缀匹配场景

如果我们执行
explain select * from test where c2 like '111%';
（SQL 3）将会看到执行计划也没有走索引：

从执行计划中还可以得到另一个信息，PostgrSQL 会将 LIKE 转换成
~~
操作符。这个操作是在语法解析的时候完成的：

类似的行为还有 NOT LIKE 被替换成
!~~
，ILIKE 被替换成
~~*
，NOT ILIKE 被替换成
!~~*
。

依照前面的分析，发现
~~
确实不在 B-tree varchar 类型默认 opclass 所在的 opfamily 中：

那这里是不是不符合一般场景的条件，才没有走索引的呢？其实并不是，
官方文档
给出了这样的示例：

我们查看测试库的字符排序规则以及字符分类信息，确实不是标准的“C” 区：

因此，执行
create index idx_test_c2_2 on test(c2 varchar_pattern_ops);
创建索引，再次执行 SQL 3，可以看到已经走了索引：

但是这里走索引的操作符并不是
~~
，并且
~~
也同样不在对应的 opfamily 中：

出现这种现象的原因是对于 LIKE 这类前缀匹配查询是否能够走 B-tree 索引，PostgreSQL 在进行索引匹配时会进行特殊处理：

  

检测模式匹配字符串是否以常量开头，如果是就表示可能可以走索引；

  

检测索引的 opfammily 是否为 xxx_pattern_ops 对应的 opfamily，如果是则能够生成索引路径；

  

2 不满足，则会检测字符的排序规则是否为标准“C” 区，如果满足要求也能够生成索引路径；

  

如果能够生成索引路径，则会在真正生成索引路径时，将过滤条件转换为范围条件，用于 index cond。

这里有两个值得注意的点：

  
如果 database 的字符排序规则和字符分类（两者需要绑定）都是标准“C”区。LIKE 前缀匹配也能使用默认 opclass 的 B-tree 索引（这种情况下默认操作符排序与字符排序的结果一致）：

当然，指定 xxx_pattern_ops 的方式也完全可以使用，并且从总体代价上看，示例 SQL 会优先使用后者：

  
如果我们手动将 SQL 改写成范围查询
explain select * from test where c2 >= '111' and c2 < '112';
，则是否走索引的判断规则就变成了一般场景。如果列上只有指定 xxx_pattern_ops 的索引，是不能被利用的，必须要再创建一个默认 opclass 的索引。

  

    

		

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
