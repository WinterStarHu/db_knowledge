# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/03/09/
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
	

  

    
数据库内核月报 － 2015 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 答疑释惑· 并发Replace into导致的死锁分析
                      

                    

                    

                  
                      

                        MySQL · 性能优化· 5.7.6 InnoDB page flush 优化
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态· pid file丢失问题分析
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· using filesort VS using temporary
                      

                    

                    

                  
                      

                        MySQL · 优化限制· MySQL index_condition_pushdown
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态·DROP DATABASE外键约束的GTID BUG
                      

                    

                    

                  
                      

                        MySQL · 答疑释惑· lower_case_table_names 使用问题
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· Logical Decoding探索
                      

                    

                    

                  
                      

                        PgSQL · 特性分析· jsonb类型解析
                      

                    

                    

                  
                      

                        TokuDB ·引擎机制· TokuDB线程池
                      

                    

 
        

    

  

    
 PgSQL · 特性分析· jsonb类型解析  

    
 Author:   

  

  

  
PG 9.4版本里面，增强了对json数据的支持，受到了很大关注。9.4之前，PG已经原生支持json数据类型了，但只是用字符串的形式存储和处理。这样做天然有性能上的缺点：每次对json字符串里面的数据进行查询，一般需要全表扫描加字符串匹配，效率很低。当然也可以在存储json的字符串字段上创建GIN索引，但需要对查询中用到的json的key或value创建单独索引，造成要被动维护很多索引。所以，这种json类型，只适用于把PG单纯作为数据存储，只读入读出数据，不对数据进行限定key或value查询的场景。

PG 9.4中引入了jsonb类型。其特点是，将json数据中的key和value进行解析，转换为PG的基本数据类型，包括数字，字符串和布尔类型等；同时，增加了对应的GIN处理函数，可以将json中的所有key和value转换为GIN索引的key。这样，只用一个GIN索引，即可实现对所有key或value的条件查询。下面我们分析一下jsonb的使用方法和内核实现。

使用

创建含jsonb类型的表方法如下所示：

=&gt; create table test_jsonb(col_jsonb jsonb);
CREATE TABLE
=&gt; insert into test_jsonb values(&#039;{&quot;product&quot;: &quot;PostgreSQL&quot;, &quot;version&quot;: 9.4, &quot;platform&quot;:[&quot;win&quot;, &quot;linux&quot;, &quot;unix&quot;]}&#039;::jsonb);
INSERT 0 1

创建GIN索引的方法如下：

--创建jsonb_ops索引：
=&gt; create index idx_jsonb on test_jsonb using gin (col_jsonb);
CREATE INDEX
--创建jsonb_ops_path索引：
=&gt; create index idx_jsonb_path on test_jsonb using gin (col_jsonb jsonb_path_ops);
CREATE INDEX

可以使用下面的查询得到含有键值对的行：

=&gt;select * from test_jsonb where col_jsonb @&gt; &#039;{&quot;product&quot; : &quot;PostgreSQL&quot;}&#039;;
col_jsonb
---------------------------------------------------------------------------------
{&quot;product&quot;: &quot;PostgreSQL&quot;, &quot;version&quot;: 9.4, &quot;platform&quot;: [&quot;win&quot;, &quot;linux&quot;, &quot;unix&quot;]}

内核实现

先分析一下jsonb是如何从字符串，变成特殊的二进制形式存入磁盘的。追踪一下jsonb插入的过程，可以看到PG所调用的函数流程如下。

jsonb_in-&gt;jsonb_from_cstring-&gt;pg_parse_json-&gt;JsonbValueToJsonb

其中，pg_parse_json先把用户输入的字符串，通过编译器转换为一个树形结构（每个节点的类型为JsonbValue）。然后JsonbValueToJsonb在这个结构基础上，转换为存入磁盘的格式。从convertJsonbObject函数可以看出，转换为磁盘格式的策略为：从树形结构的根部开始遍历，递归进行广度优先遍历。对于同一父亲下面的子键值，将所有键名（字符串）长度写入buffer中预留的头部，随后将键名依次写入buffer中。最后再以相似的方式写入键所对应的所有值（值如果是json对象，则递归调用）。这样，读入buffer的头部，就可以遍历出所有键名的位置，得到键名。再从读第一个键值开始，读入对应的值或子键，最终得到整个树（见JsonbIteratorNext）。

采用这种存储方式，jsonb所占用的存储空间比原来支持的json类型要多一些。其实，jsonb的核心优势在于快速和灵活的索引。从前面创建index的语句可以看到，jsonb支持两种特有的GIN索引jsonb_ops和jsonb_path_ops。我们知道，GIN索引建立时，会先通过内建函数从表中每行数据的索引字段的值中，抽取键（key），一个字段值一般可抽取多个key。然后，将每个key与含有此key的所有行的ID组成键值对，再将它们插入b树索引供查询。那么这两种GIN索引有什么区别呢？

它们的区别在于，生成GIN key的方式不同。jsonb_ops调用gin_extract_jsonb函数生成key，这样每个字段的json数据中的所有键和值都被转成GIN的key；而jsonb_path_ops使用函数gin_extract_jsonb_path抽取：如果将一个jsonb类型的字段值看做一颗树，叶子节点为具体的值，中间节点为键，则抽取的每个键值实际上时每个从根节点到叶子节点的路径对应的hash值。

不难推测，jsonb_path_ops索引的key的数目和jsonb的叶子节点数有关，用叶子节点的路径做查询条件时会比较快（这也是这种索引唯一支持的查询方式）；而jsonb_ops索引的key的数目与jsonb包含的键和值（即树形结构的所有节点）的总数有关，可以用于路径查询之外的其他查询。

  

    

		

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
